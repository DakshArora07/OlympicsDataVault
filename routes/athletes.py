from flask import Blueprint, render_template, request, redirect, url_for
import mysql.connector
from db import get_connection, db_error_message

athletes_bp = Blueprint('athletes', __name__)

@athletes_bp.route("/athletes")
def athletes():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    search_query = request.args.get('search', '').strip()
    sport_filter = request.args.get('sport', '')
    gender_filter = request.args.get('gender', '')

    query = """
        SELECT a.*, c.name AS country_name, c.flag AS flag
        FROM athlete a
        LEFT JOIN country c ON a.country_code = c.country_code
        WHERE 1=1
    """
    params = []

    if search_query:
        query += """ AND (
            a.first_name LIKE %s OR 
            a.last_name LIKE %s OR 
            a.email LIKE %s OR
            CONCAT(a.first_name, ' ', a.last_name) LIKE %s
        )"""
        params += [
            search_query + '%',
            search_query + '%',
            search_query + '%',
            '%' + search_query + '%'
        ]

    if sport_filter:
        query += " AND a.sport = %s"
        params.append(sport_filter)

    if gender_filter:
        query += " AND a.gender = %s"
        params.append(gender_filter)

    query += " ORDER BY a.registration_number"

    cursor.execute(query, tuple(params))
    athlete_list = cursor.fetchall()

    cursor.execute("SELECT DISTINCT sport FROM athlete ORDER BY sport")
    sports = [row['sport'] for row in cursor.fetchall()]

    conn.close()

    return render_template('athletes.html',
                           athletes=athlete_list,
                           sports=sports,
                           search=search_query,
                           sport_filter=sport_filter,
                           gender_filter=gender_filter
                           )

@athletes_bp.route("/athletes/<int:reg_num>")
def athlete_detail(reg_num):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT a.*, c.name AS country_name, c.flag AS flag
        FROM athlete a
        LEFT JOIN country c ON a.country_code = c.country_code
        WHERE a.registration_number = %s
    """, (reg_num,))
    athlete = cursor.fetchone()

    if not athlete:
        conn.close()
        return redirect(url_for("athletes.athletes"))


    cursor.execute("""
        SELECT ap.*, g.date, e.sport, v.name as venue_name
        FROM athlete_participation ap
        JOIN game g ON ap.sport = g.sport AND ap.format = g.format AND ap.gender_category = g.gender_category AND ap.game_number = g.game_number
        JOIN event e ON ap.sport = e.sport AND ap.format = e.format AND ap.gender_category = e.gender_category
        JOIN venue v ON e.venue_id = v.venue_id
        WHERE ap.athlete_registration_number = %s
    """, (reg_num,))
    participations = cursor.fetchall()

    athlete_medals = {'Gold' : 0, 'Silver' : 0, 'Bronze' : 0}
    for p in participations:
        if p['medal'] in athlete_medals:
            athlete_medals[p['medal']] += 1

    conn.close()
    return render_template('athlete_detail.html',
                           athlete=athlete,
                           medals=athlete_medals,
                           participations=participations
                           )

@athletes_bp.route("/register_athlete", methods=['GET', 'POST'])
def register_athlete():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT country_code, name
        FROM country
        ORDER BY name
    """)
    countries = cursor.fetchall()

    cursor.execute("""
        SELECT name
        FROM sport
        ORDER BY name
    """)
    sports = [row['name'] for row in cursor.fetchall()]

    if request.method == 'POST':
        registration_number = request.form.get('registration_number')
        first_name = request.form.get('first_name')
        middle_name = request.form.get('middle_name') or None
        last_name = request.form.get('last_name')
        date_of_birth = request.form.get('date_of_birth')
        gender = request.form.get('gender')
        email = request.form.get('email') or None
        height = request.form.get('height')
        weight = request.form.get('weight')
        country_code = request.form.get('country_code') or None
        sport = request.form.get('sport')

        try:
            cursor.execute("""
                INSERT INTO athlete
                (registration_number, first_name, middle_name, last_name,
                 date_of_birth, gender, email, height, weight, country_code, sport)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                registration_number, first_name, middle_name, last_name,
                date_of_birth, gender, email, height, weight, country_code, sport
            ))

            conn.commit()
            conn.close()
            return redirect(url_for('athletes.athletes'))

        except (mysql.connector.IntegrityError, mysql.connector.DatabaseError) as err:
            conn.rollback()
            error = db_error_message(err)
            conn.close()
            return render_template(
                'register_athlete.html',
                countries=countries,
                sports=sports,
                error=error,
                form=request.form
            )

    conn.close()
    return render_template(
        'register_athlete.html',
        countries=countries,
        sports=sports
    )

@athletes_bp.route("/athletes/<int:reg_num>/edit", methods=['GET', 'POST'])
def edit_athlete(reg_num):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM athlete
        WHERE registration_number = %s
    """, (reg_num,))
    selected_athlete = cursor.fetchone()

    if not selected_athlete:
        conn.close()
        return redirect(url_for("athletes.athletes"))

    cursor.execute("""
        SELECT country_code, name
        FROM country
        ORDER BY name
    """)
    countries = cursor.fetchall()

    cursor.execute("""
        SELECT name
        FROM sport
        ORDER BY name
    """)
    sports = [row['name'] for row in cursor.fetchall()]
    athlete = dict(selected_athlete)

    if request.method == 'POST':
        # Get form data
        first_name = request.form.get('first_name')
        middle_name = request.form.get('middle_name') or None
        last_name = request.form.get('last_name')
        date_of_birth = request.form.get('date_of_birth')
        gender = request.form.get('gender')
        email = request.form.get('email') or None
        height = request.form.get('height')
        weight = request.form.get('weight')
        country_code = request.form.get('country_code') or None
        sport = request.form.get('sport')

        try:
            cursor.execute("""
                UPDATE athlete
                SET first_name = %s,
                    middle_name = %s,
                    last_name = %s,
                    date_of_birth = %s,
                    gender = %s,
                    email = %s,
                    height = %s,
                    weight = %s,
                    country_code = %s,
                    sport = %s
                WHERE registration_number = %s
            """, (
                first_name, middle_name, last_name, date_of_birth,
                gender, email, height, weight, country_code, sport, reg_num
            ))

            conn.commit()
            conn.close()

            return redirect(url_for("athletes.athlete_detail", reg_num=reg_num))

        except (mysql.connector.IntegrityError, mysql.connector.DatabaseError) as err:
            conn.rollback()
            error = db_error_message(err)
            athlete.update({
                "first_name": first_name,
                "middle_name": middle_name,
                "last_name": last_name,
                "date_of_birth": date_of_birth,
                "gender": gender,
                "email": email,
                "height": height,
                "weight": weight,
                "country_code": country_code,
                "sport": sport
            })

            conn.close()

            return render_template(
                "edit_athlete.html",
                athlete=athlete,
                countries=countries,
                sports=sports,
                error=error
            )

    conn.close()
    return render_template(
        "edit_athlete.html",
        athlete=athlete,
        countries=countries,
        sports=sports
    )

@athletes_bp.route("/athletes/<int:reg_num>/delete", methods=["POST"])
def delete_athlete(reg_num):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
        DELETE
        FROM athlete
        WHERE registration_number = %s
        """, (reg_num,))

        cursor.execute("""
        DELETE FROM team
        WHERE (team_id, country_code) IN (
        SELECT team_id, country_code
        FROM (
        SELECT t.team_id, t.country_code
        FROM team t
        LEFT JOIN member_of mo
        ON t.team_id = mo.team_id
        AND t.country_code = mo.country_code
        GROUP BY t.team_id, t.country_code, t.number_of_players
        HAVING COUNT(mo.athlete_registration_number) < t.number_of_players
        ) AS invalid_teams
        )
        """)

        conn.commit()
        conn.close()
        return redirect(url_for('athletes.athletes'))

    except mysql.connector.IntegrityError as err:
        conn.rollback()
        return redirect(url_for('athletes.athlete_detail', reg_num=reg_num, error=db_error_message(err)))

    finally:
        conn.close()

@athletes_bp.route("/api/athletes_by_country/<country_code>")
def athletes_by_country(country_code):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT registration_number, first_name, last_name, sport
        FROM athlete
        WHERE country_code = %s
        ORDER BY last_name, first_name
    """, (country_code,))

    athlete_list = cursor.fetchall()
    conn.close()

    from flask import jsonify
    return jsonify(athlete_list)