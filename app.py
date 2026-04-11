import os
from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME")
}

def get_connection():
    return mysql.connector.connect(**DB_CONFIG)

@app.route('/')
@app.route("/index")
def index():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT COUNT(*) as count
        FROM athlete
    """)
    athlete_count = cursor.fetchone()['count']

    cursor.execute("""
        SELECT COUNT(*) as count
        FROM sport
    """)
    sport_count = cursor.fetchone()['count']

    cursor.execute("""
        SELECT COUNT(*) as count
        FROM country
    """)
    country_count = cursor.fetchone()['count']

    cursor.execute("""
        SELECT COUNT(*) as count
        FROM venue
    """)
    venue_count = cursor.fetchone()['count']

    #TODO: Medal Tally Query

    conn.close()

    return render_template('index.html',
                           athlete_count=athlete_count,
                           country_count=country_count,
                           sport_count=sport_count,
                           venue_count=venue_count
                           )
@app.route("/medals")
def medals():
    return render_template('medals.html', title='Medals')

@app.route("/queries")
def queries():
    return render_template('queries.html', title='Queries')

@app.route("/athletes")
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

    query += " ORDER BY a.last_name, a.first_name"

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

@app.route("/register_athlete", methods=['GET', 'POST'])
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

        cursor.execute(
            """
                INSERT INTO athlete 
                (registration_number, first_name, middle_name, last_name, 
                 date_of_birth, gender, email, height, weight, country_code, sport)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (registration_number, first_name, middle_name, last_name,
                  date_of_birth, gender, email, height, weight, country_code, sport))

        conn.commit()
        conn.close()
        return redirect(url_for('athletes'))

    conn.close()
    return render_template('register_athlete.html',
                           countries=countries,
                           sports=sports
                           )

@app.route("/athletes/<int:reg_num>")
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
        return redirect(url_for("athletes"))


    cursor.execute("""
        SELECT ap.*, g.date, e.sport, v.name as venue_name
        FROM athlete_participation ap
        JOIN game g ON ap.format = g.format
            AND ap.gender_category = g.gender_category
            AND ap.game_number = g.game_number
        JOIN event e ON ap.format = e.format 
               AND ap.gender_category = e.gender_category
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

@app.route("/athletes/<int:reg_num>/edit", methods=['GET', 'POST'])
def edit_athlete(reg_num):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM athlete
        WHERE registration_number = %s
    """, (reg_num,))
    selected_athlete = cursor.fetchone()

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

    if not selected_athlete:
        conn.close()
        return redirect(url_for("athletes"))

    athlete = {
        "registration_number": selected_athlete["registration_number"],
        "first_name": selected_athlete["first_name"],
        "middle_name": selected_athlete["middle_name"],
        "last_name": selected_athlete["last_name"],
        "date_of_birth": selected_athlete["date_of_birth"],
        "gender": selected_athlete["gender"],
        "email": selected_athlete["email"],
        "height": selected_athlete["height"],
        "weight": selected_athlete["weight"],
        "country_code": selected_athlete["country_code"],
        "sport": selected_athlete["sport"]
    }

    if request.method == 'POST':
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
        """, (first_name, middle_name, last_name, date_of_birth,
              gender, email, height, weight, country_code, sport, reg_num))

        conn.commit()
        conn.close()
        return redirect(url_for("athlete_detail", reg_num=reg_num))

    return render_template(
        "edit_athlete.html",
        athlete=athlete,
        countries=countries,
        sports=sports
    )

@app.route("/athletes/<int:reg_num>/delete", methods=["POST"])
def delete_athlete(reg_num):

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        DELETE 
        FROM athlete
        WHERE registration_number = %s
    """, (reg_num,))

    conn.commit()
    conn.close()
    return redirect(url_for('athletes'))

@app.route("/api/athletes_by_country/<country_code>")
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

@app.route("/teams")
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

@app.route("/register_team", methods=["GET", "POST"])
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
        return redirect(url_for("teams"))

    conn.close()
    return render_template("register_team.html", countries=countries)

@app.route("/events")
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
            LEFT JOIN game g ON e.format = g.format AND e.gender_category = g.gender_category
            LEFT JOIN team_event te ON e.format = te.format AND e.gender_category = te.gender_category
            GROUP BY e.format, e.gender_category, e.sport, v.name, v.city, v.capacity, te.format, te.team_size
            ORDER BY e.sport, e.format
        """)
    event_list = cursor.fetchall()

    conn.close()
    return render_template('events.html', events=event_list)

@app.route("/events/<sport>/<format>/<gender>")
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
            LEFT JOIN team_event te ON e.format = te.format AND e.gender_category = te.gender_category
            WHERE e.sport = %s AND e.format = %s AND e.gender_category = %s
        """, (sport, format, gender))
    event = cursor.fetchone()

    if not event:
        conn.close()
        return redirect(url_for('events'))

    cursor.execute("""
            SELECT g.game_number, g.date,
                   COUNT(ap.athlete_registration_number) AS participants
            FROM game g
            LEFT JOIN athlete_participation ap
                ON g.format = ap.format
                AND g.gender_category = ap.gender_category
                AND g.sport = ap.sport
                AND g.game_number = ap.game_number
            WHERE g.sport = %s AND g.format = %s AND g.gender_category = %s
            GROUP BY g.game_number, g.date
            ORDER BY g.date
        """, (sport, format, gender))
    games = cursor.fetchall()

    # TODO: Leaderboard Query(s)

    conn.close()
    return render_template('event_detail.html',
                           event=event,
                           games=games,
                           leaderboard=[])

@app.route("/register_event", methods=["GET", "POST"])
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
        return redirect(url_for("events"))

    return render_template("register_event.html", sports=sports_list, venues=venue_list)

@app.route("/events/<sport>/<format>/<gender>/delete", methods=["POST"])
def delete_event(sport, format, gender):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        DELETE FROM event
        WHERE sport = %s AND format = %s AND gender_category = %s
    """, (sport, format, gender))

    conn.commit()
    conn.close()
    return redirect(url_for('events'))

@app.route("/venues")
def venues():

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT v.*, COUNT(e.format) as event_count
        FROM venue v
        LEFT JOIN event e ON v.venue_id = e.venue_id
        GROUP BY v.venue_id
        ORDER BY v.venue_id
    """)

    venue_list = cursor.fetchall()
    conn.close()
    return render_template('venues.html', venues=venue_list)

@app.route("/register_venue", methods=["GET", "POST"])
def register_venue():

    if request.method == "POST":
        venue_id = request.form.get("venue_id")
        name = request.form.get("name")
        city = request.form.get("city")
        country = request.form.get("country")
        capacity = request.form.get("capacity")

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            INSERT INTO venue (venue_id, name, city, country, capacity)
            VALUES (%s, %s, %s, %s, %s)
        """, (venue_id, name, city, country, capacity))

        conn.commit()
        conn.close()
        return redirect(url_for("venues"))

    return render_template("register_venue.html")

@app.route("/sports")
def sports():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT s.*, COUNT(e.sport) AS event_count
        FROM sport s
        LEFT JOIN event e ON e.sport = s.name
        GROUP BY s.name, s.type
        ORDER BY s.name
    """)
    sport_list = cursor.fetchall()

    conn.close()
    return render_template('sports.html', sports=sport_list)

if __name__ == '__main__':
    app.run(debug=True)
