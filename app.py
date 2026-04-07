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
    return render_template('index.html', title='Index')


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
        FROM athelete a
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

    cursor.execute("SELECT DISTINCT sport FROM athelete ORDER BY sport")
    sports = [row['sport'] for row in cursor.fetchall()]

    conn.close()

    return render_template('athletes.html',
                           athletes=athlete_list,
                           sports=sports,
                           search=search_query,
                           sport_filter=sport_filter,
                           gender_filter=gender_filter
                           )


@app.route("/athletes/<int:reg_num>")
def athlete_detail(reg_num):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT a.*, c.name AS country_name, c.flag AS flag
        FROM athelete a
        LEFT JOIN country c ON a.country_code = c.country_code
        WHERE a.registration_number = %s
    """, (reg_num,))
    athlete = cursor.fetchone()

    if not athlete:
        conn.close()
        return redirect(url_for("athletes"))

    # TODO: Query for all athlete participations
    # TODO: Query for all athlete medals

    conn.close()
    return render_template('athlete_detail.html',
                           athlete=athlete,
                           medals={},
                           participations=[]
                           )


@app.route("/events")
def events():
    return render_template('events.html', title='Events')


@app.route("/venues")
def venues():
    return render_template('venues.html', title='Venues')


@app.route("/search")
def search():
    return render_template('search.html', title='Search')


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
                INSERT INTO athelete 
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


@app.route("/athletes/<int:reg_num>/edit", methods=['GET', 'POST'])
def edit_athlete(reg_num):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM athelete
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
            UPDATE athelete
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
        FROM athelete_participation
        WHERE athelete_registration_number = %s
    """, (reg_num,))

    cursor.execute("""
        DELETE
        FROM member_of
        WHERE athelete_registration_number = %s
    """, (reg_num,))

    cursor.execute("""
        DELETE 
        FROM athelete
        WHERE registration_number = %s
    """, (reg_num,))

    conn.commit()
    conn.close()
    return redirect(url_for('athletes'))


if __name__ == '__main__':
    app.run(debug=True)
