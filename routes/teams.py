from flask import Blueprint, render_template, request, redirect, url_for
from db import get_connection, db_error_message
import mysql.connector

teams_bp = Blueprint('teams', __name__)

@teams_bp.route("/teams")
def teams():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT t.*, c.name as country_name, c.flag as country_flag
        FROM team t
        JOIN country c ON t.country_code = c.country_code
        GROUP BY t.team_id, t.country_code, t.number_of_players, country_flag, country_name
        ORDER BY t.team_id
    """)

    team_list = cursor.fetchall()
    return render_template('teams.html', teams=team_list)

@teams_bp.route("/teams/<int:team_id>/<country_code>")
def team_detail(team_id, country_code):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT t.*, c.name as country_name, c.flag as country_flag
        FROM team t
        JOIN country c ON t.country_code = c.country_code
        WHERE t.team_id = %s AND t.country_code = %s
    """, (team_id, country_code))
    team = cursor.fetchone()

    if not team:
        conn.close()
        return redirect(url_for('teams.teams'))

    cursor.execute("""
        SELECT mo.athlete_registration_number, a.first_name, a.last_name, a.sport 
        FROM member_of mo
        JOIN athlete a ON mo.athlete_registration_number = a.registration_number
        WHERE mo.team_id = %s AND mo.country_code = %s
        ORDER BY a.last_name, a.first_name
    """, (team_id, country_code))
    members = cursor.fetchall()

    cursor.execute("""
            SELECT tp.*, g.date
            FROM team_participation tp
            JOIN game g ON tp.sport = g.sport
                AND tp.format = g.format
                AND tp.gender_category = g.gender_category
                AND tp.game_number = g.game_number
            WHERE tp.team_id = %s AND tp.country_code = %s
            ORDER BY g.date
        """, (team_id, country_code))
    participation = cursor.fetchall()

    conn.close()
    return render_template('team_detail.html',
                           team=team,
                           members=members,
                           participations=participation)

@teams_bp.route("/register_team", methods=["GET", "POST"])
def register_team():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT country_code, name 
        FROM country 
        ORDER BY name
    """)
    countries = cursor.fetchall()

    if request.method == "POST":
        team_id = request.form.get("team_id")
        country_code = request.form.get("country_code")
        number_of_players = request.form.get("number_of_players")
        athlete_ids = request.form.getlist("athlete_ids")

        try:
            cursor.execute("""
                        INSERT INTO team (country_code, team_id, number_of_players)
                        VALUES (%s, %s, %s)
                    """, (country_code, team_id, number_of_players))

            for athlete_id in athlete_ids:
                cursor.execute("""
                            INSERT INTO member_of (athlete_registration_number, country_code, team_id)
                            VALUES (%s, %s, %s)
                        """, (athlete_id, country_code, team_id))

            conn.commit()
            conn.close()
            return redirect(url_for("teams.teams"))

        except (mysql.connector.IntegrityError, mysql.connector.DatabaseError) as err:
            conn.rollback()
            error = db_error_message(err)

            conn.close()
            return render_template(
                "register_team.html",
                countries=countries,
                error=error,
                form=request.form
            )

    conn.close()
    return render_template("register_team.html", countries=countries)

@teams_bp.route("/teams/<int:team_id>/<country_code>/edit", methods=["GET", "POST"])
def edit_team_page(team_id, country_code):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT t.*, c.name as country_name, c.flag as country_flag
        FROM team t
        JOIN country c ON t.country_code = c.country_code
        WHERE t.team_id = %s AND t.country_code = %s
    """, (team_id, country_code))
    team = cursor.fetchone()

    if not team:
        conn.close()
        return redirect(url_for('teams.teams'))

    def get_members():
        cursor.execute("""
            SELECT mo.athlete_registration_number AS registration_number,
                   a.first_name, a.last_name, a.sport
            FROM member_of mo
            JOIN athlete a ON mo.athlete_registration_number = a.registration_number
            WHERE mo.team_id = %s AND mo.country_code = %s
        """, (team_id, country_code))
        return cursor.fetchall()

    def get_available():
        cursor.execute("""
            SELECT a.registration_number, a.first_name, a.last_name, a.sport
            FROM athlete a
            WHERE a.country_code = %s
            AND a.registration_number NOT IN (
                SELECT athlete_registration_number FROM member_of
                WHERE team_id = %s AND country_code = %s
            )
            ORDER BY a.last_name, a.first_name
        """, (country_code, team_id, country_code))
        return cursor.fetchall()

    current_members = get_members()
    available_athletes = get_available()

    if request.method == "POST":
        selected_ids = set(request.form.getlist("athlete_ids"))
        current_ids = set(str(m['registration_number']) for m in current_members)

        try:
            to_add = selected_ids - current_ids
            to_remove = current_ids - selected_ids

            for athlete_id in to_remove:
                cursor.execute("""
                    DELETE FROM member_of
                    WHERE athlete_registration_number = %s
                    AND team_id = %s AND country_code = %s
                """, (athlete_id, team_id, country_code))

            for athlete_id in to_add:
                cursor.execute("""
                    INSERT INTO member_of (athlete_registration_number, country_code, team_id)
                    VALUES (%s, %s, %s)
                """, (athlete_id, country_code, team_id))

            cursor.execute("""
                UPDATE team SET number_of_players = %s
                WHERE team_id = %s AND country_code = %s
            """, (len(selected_ids), team_id, country_code))

            conn.commit()
            conn.close()
            return redirect(url_for('teams.team_detail', team_id=team_id, country_code=country_code))

        except (mysql.connector.IntegrityError, mysql.connector.DatabaseError) as err:
            conn.rollback()
            error = db_error_message(err)

            selected_ids_int = set(int(x) for x in selected_ids)
            all_athletes = current_members + available_athletes

            new_current = [a for a in all_athletes if a['registration_number'] in selected_ids_int]
            new_available = [a for a in all_athletes if a['registration_number'] not in selected_ids_int]

            conn.close()
            return render_template(
                'edit_team.html',
                team=team,
                current_members=new_current,
                available_athletes=new_available,
                error=error
            )

    conn.close()
    return render_template(
        'edit_team.html',
        team=team,
        current_members=current_members,
        available_athletes=available_athletes
    )

@teams_bp.route("/teams/<int:team_id>/<country_code>/delete", methods=["POST"])
def delete_team(team_id, country_code):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        DELETE FROM team
        WHERE team_id = %s AND country_code = %s
    """, (team_id, country_code))

    conn.commit()
    conn.close()
    return redirect(url_for('teams.teams'))
