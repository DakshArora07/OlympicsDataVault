from flask import Blueprint, render_template, request, redirect, url_for
from db import get_connection

events_bp = Blueprint('events', __name__)

@events_bp.route("/events")
def events():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
            SELECT e.format, e.gender_category, e.sport,
                   v.name AS venue_name, v.city, v.capacity,
                   COUNT(DISTINCT g.game_number) AS game_count,
                   IF(te.format IS NOT NULL, 'Team', 'Individual') AS event_type,
                   te.team_size
            FROM event e
            JOIN venue v ON e.venue_id = v.venue_id
            LEFT JOIN game g ON e.sport = g.sport AND e.format = g.format AND e.gender_category = g.gender_category
            LEFT JOIN team_event te ON e.sport = te.sport AND e.format = te.format AND e.gender_category = te.gender_category            GROUP BY e.format, e.gender_category, e.sport, v.name, v.city, v.capacity, te.format, te.team_size
            ORDER BY e.sport, e.format
        """)
    event_list = cursor.fetchall()

    conn.close()
    return render_template('events.html', events=event_list)

@events_bp.route("/events/<sport>/<format>/<gender>")
def event_detail(sport, format, gender):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT e.format, e.gender_category, e.sport,
               v.name AS venue_name, v.city, v.country AS venue_country, v.capacity,
               IF(te.format IS NOT NULL, 'Team', 'Individual') AS event_type,
               te.team_size
        FROM event e
        JOIN venue v ON e.venue_id = v.venue_id
        LEFT JOIN team_event te ON e.sport = te.sport AND e.format = te.format AND e.gender_category = te.gender_category
        WHERE e.sport = %s AND e.format = %s AND e.gender_category = %s
    """, (sport, format, gender))
    event = cursor.fetchone()

    if not event:
        conn.close()
        return redirect(url_for('events.events'))

    is_team_event = event['event_type'] == 'Team'

    if is_team_event:
        games_query = """
            SELECT g.game_number, g.date,
                   COUNT(DISTINCT CONCAT(tp.team_id, '-', tp.country_code)) AS participants
            FROM game g
            LEFT JOIN team_participation tp
                ON tp.sport = g.sport
               AND tp.format = g.format
               AND tp.gender_category = g.gender_category
               AND tp.game_number = g.game_number
            WHERE g.sport = %s AND g.format = %s AND g.gender_category = %s
            GROUP BY g.game_number, g.date
            ORDER BY g.date
        """

        participants_query = """
            SELECT tp.game_number, tp.score, tp.medal,
                   tp.team_id, tp.country_code,
                   c.name AS country
            FROM team_participation tp
            JOIN country c ON tp.country_code = c.country_code
            WHERE tp.sport = %s AND tp.format = %s AND tp.gender_category = %s
            ORDER BY tp.game_number, tp.score DESC
        """

        leaderboard_query = """
            SELECT tp.team_id,
                   tp.country_code,
                   c.name AS country,
                   COUNT(*) AS games_played,
                   MAX(tp.score) AS best_score,
                   AVG(tp.score) AS avg_score,
                   SUM(tp.medal = 'Gold') AS gold_medals,
                   SUM(tp.medal = 'Silver') AS silver_medals,
                   SUM(tp.medal = 'Bronze') AS bronze_medals
            FROM team_participation tp
            JOIN country c ON tp.country_code = c.country_code
            WHERE tp.sport = %s AND tp.format = %s AND tp.gender_category = %s
            GROUP BY tp.team_id, tp.country_code, c.name
            ORDER BY best_score DESC, avg_score DESC, tp.team_id
        """
    else:
        games_query = """
            SELECT g.game_number, g.date,
                   COUNT(DISTINCT ap.athlete_registration_number) AS participants
            FROM game g
            LEFT JOIN athlete_participation ap
                ON ap.sport = g.sport
               AND ap.format = g.format
               AND ap.gender_category = g.gender_category
               AND ap.game_number = g.game_number
            WHERE g.sport = %s AND g.format = %s AND g.gender_category = %s
            GROUP BY g.game_number, g.date
            ORDER BY g.date
        """

        participants_query = """
            SELECT ap.game_number, ap.score, ap.medal,
                   a.registration_number, a.first_name, a.last_name,
                   c.name AS country
            FROM athlete_participation ap
            JOIN athlete a ON ap.athlete_registration_number = a.registration_number
            LEFT JOIN country c ON a.country_code = c.country_code
            WHERE ap.sport = %s AND ap.format = %s AND ap.gender_category = %s
            ORDER BY ap.game_number, ap.score DESC
        """

        leaderboard_query = """
            SELECT a.registration_number,
                   a.first_name,
                   a.last_name,
                   c.name AS country,
                   COUNT(*) AS games_played,
                   MAX(ap.score) AS best_score,
                   AVG(ap.score) AS avg_score,
                   SUM(ap.medal = 'Gold') AS gold_medals,
                   SUM(ap.medal = 'Silver') AS silver_medals,
                   SUM(ap.medal = 'Bronze') AS bronze_medals
            FROM athlete_participation ap
            JOIN athlete a ON ap.athlete_registration_number = a.registration_number
            LEFT JOIN country c ON a.country_code = c.country_code
            WHERE ap.sport = %s AND ap.format = %s AND ap.gender_category = %s
            GROUP BY a.registration_number, a.first_name, a.last_name, c.name
            ORDER BY best_score DESC, avg_score DESC, a.last_name, a.first_name
        """

    cursor.execute(games_query, (sport, format, gender))
    games = cursor.fetchall()

    cursor.execute(participants_query, (sport, format, gender))
    participant_rows = cursor.fetchall()

    game_participants_map = {}
    for row in participant_rows:
        gn = row['game_number']
        if gn not in game_participants_map:
            game_participants_map[gn] = []
        game_participants_map[gn].append(row)

    cursor.execute(leaderboard_query, (sport, format, gender))
    leaderboard = cursor.fetchall()

    for row in leaderboard:
        row['medals'] = (
            f"🥇 {row['gold_medals']} "
            f"🥈 {row['silver_medals']} "
            f"🥉 {row['bronze_medals']}"
        )

    if gender == 'Mixed':
        cursor.execute("""
            SELECT registration_number, first_name, last_name, gender
            FROM athlete
            WHERE sport = %s
            ORDER BY last_name, first_name
        """, (sport,))
    else:
        cursor.execute("""
            SELECT registration_number, first_name, last_name, gender
            FROM athlete
            WHERE sport = %s AND gender = %s
            ORDER BY last_name, first_name
        """, (sport, gender))
    eligible_athletes = cursor.fetchall()

    if gender == 'Mixed':
        cursor.execute("""
            SELECT t.team_id, t.country_code, c.name as country_name
            FROM team t
            JOIN country c ON t.country_code = c.country_code
            WHERE NOT EXISTS (
                SELECT 1
                FROM member_of mo
                JOIN athlete a ON mo.athlete_registration_number = a.registration_number
                WHERE mo.team_id = t.team_id
                  AND mo.country_code = t.country_code
                  AND a.sport != %s
            )
            ORDER BY c.name, t.team_id
        """, (sport,))
    else:
        cursor.execute("""
            SELECT t.team_id, t.country_code, c.name as country_name
            FROM team t
            JOIN country c ON t.country_code = c.country_code
            WHERE NOT EXISTS (
                SELECT 1
                FROM member_of mo
                JOIN athlete a ON mo.athlete_registration_number = a.registration_number
                WHERE mo.team_id = t.team_id
                  AND mo.country_code = t.country_code
                  AND (a.sport != %s OR a.gender != %s)
            )
            ORDER BY c.name, t.team_id
        """, (sport, gender))
    eligible_teams = cursor.fetchall()

    conn.close()
    return render_template(
        'event_detail.html',
        event=event,
        games=games,
        leaderboard=leaderboard,
        eligible_athletes=eligible_athletes,
        eligible_teams=eligible_teams,
        game_participants_map=game_participants_map
    )

@events_bp.route("/register_event", methods=["GET", "POST"])
def register_event():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT name
        FROM sport
        ORDER BY name
    """)
    sports_list = [row['name'] for row in cursor.fetchall()]

    cursor.execute("""
        SELECT venue_id, name
        FROM venue
        ORDER BY name
    """)
    venue_list = cursor.fetchall()

    if request.method == "POST":
        sport = request.form.get("sport")
        format = request.form.get("format")
        gender_category = request.form.get("gender_category")
        venue_id = request.form.get("venue_id") or None
        event_type = request.form.get("event_type")
        team_size = request.form.get("team_size") or None

        if gender_category == 'Mixed' and event_type == 'Individual':
            return render_template("register_event.html",
                                   sports=sports_list,
                                   venues=venue_list,
                                   error="Individual events cannot have Mixed gender category.")

        cursor.execute("""
            INSERT INTO event (sport, format, gender_category, venue_id)
            VALUES (%s, %s, %s, %s)     
        """, (sport, format, gender_category, venue_id))

        if event_type == 'Individual':
            cursor.execute("""
                INSERT INTO individual_event (sport, format, gender_category)
                VALUES (%s, %s, %s)
            """, (sport, format, gender_category))
        else:
            cursor.execute("""
                INSERT INTO team_event (sport, format, gender_category, team_size)
                VALUES (%s, %s, %s, %s)
            """, (sport, format, gender_category, team_size))

        conn.commit()
        conn.close()
        return redirect(url_for("events.events"))

    return render_template("register_event.html", sports=sports_list, venues=venue_list)

@events_bp.route("/events/<sport>/<format>/<gender>/edit", methods=["GET"])
def edit_event_page(sport, format, gender):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT e.*, v.venue_id
        FROM event e
        JOIN venue v ON e.venue_id = v.venue_id
        WHERE e.sport = %s AND e.format = %s AND e.gender_category = %s
    """, (sport, format, gender))
    event = cursor.fetchone()
    cursor.execute("SELECT venue_id, name, city FROM venue ORDER BY name")
    venue_list = cursor.fetchall()
    conn.close()
    if not event:
        return redirect(url_for('events.events'))
    return render_template('edit_event.html', event=event, venues=venue_list)

@events_bp.route("/events/<sport>/<format>/<gender>/edit/save", methods=["POST"])
def edit_event(sport, format, gender):
    venue_id = request.form.get("venue_id")
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        UPDATE event SET venue_id = %s
        WHERE sport = %s AND format = %s AND gender_category = %s
    """, (venue_id, sport, format, gender))
    conn.commit()
    conn.close()
    return redirect(url_for('events.event_detail', sport=sport, format=format, gender=gender))

@events_bp.route("/events/<sport>/<format>/<gender>/delete", methods=["POST"])
def delete_event(sport, format, gender):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        DELETE FROM event
        WHERE sport = %s AND format = %s AND gender_category = %s
    """, (sport, format, gender))

    conn.commit()
    conn.close()
    return redirect(url_for('events.events'))

@events_bp.route("/events/<sport>/<format>/<gender>/add_game", methods=["POST"])
def add_game(sport, format, gender):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    game_number = request.form.get("game_number")
    date = request.form.get("date")

    cursor.execute("""
        INSERT INTO game (sport, format, gender_category, game_number, date)
        VALUES (%s, %s, %s, %s, %s)
    """, (sport, format, gender, game_number, date))

    conn.commit()
    conn.close()

    return redirect(url_for('events.event_detail', sport=sport, format=format, gender=gender))

@events_bp.route("/events/<sport>/<format>/<gender>/<game_number>/delete", methods=["POST"])
def delete_game(sport, format, gender, game_number):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        DELETE FROM game
        WHERE sport = %s
          AND format = %s
          AND gender_category = %s
          AND game_number = %s
    """, (sport, format, gender, game_number))

    conn.commit()
    conn.close()

    return redirect(url_for('events.event_detail', sport=sport, format=format, gender=gender))

@events_bp.route("/events/<sport>/<format>/<gender>/<game_number>/add_participation",
                 methods=["POST"])
def add_participation (sport, format, gender, game_number):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    score = request.form.get("score")
    medal = request.form.get("medal") or None
    athlete_id = request.form.get("athlete_id")
    team = request.form.get("team_id")

    if athlete_id:
        cursor.execute("""
                    INSERT INTO athlete_participation
                    (athlete_registration_number, sport, format, gender_category, game_number, score, medal)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (athlete_id, sport, format, gender, game_number, score, medal))
    elif team:
        team_id, country_code = team.split("|")
        cursor.execute("""
                    INSERT INTO team_participation
                    (country_code, team_id, sport, format, gender_category, game_number, score, medal)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """, (country_code, team_id, sport, format, gender, game_number, score, medal))
    conn.commit()
    conn.close()

    return redirect(url_for('events.event_detail', sport=sport, format=format, gender=gender))