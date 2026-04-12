from flask import Blueprint, render_template
from db import get_connection

misc_bp = Blueprint('misc', __name__)

@misc_bp.route('/')
@misc_bp.route("/index")

@misc_bp.route('/')
@misc_bp.route("/index")
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

    cursor.execute("""
        SELECT c.name AS country, c.flag,
               SUM(medals.medal = 'Gold')   AS gold,
               SUM(medals.medal = 'Silver') AS silver,
               SUM(medals.medal = 'Bronze') AS bronze,
               COUNT(medals.medal)          AS total
        FROM (
            SELECT a.country_code, ap.medal
            FROM athlete_participation ap
            JOIN athlete a ON ap.athlete_registration_number = a.registration_number
            WHERE ap.medal IS NOT NULL

            UNION ALL

            SELECT tp.country_code, tp.medal
            FROM team_participation tp
            WHERE tp.medal IS NOT NULL
        ) AS medals
        JOIN country c ON medals.country_code = c.country_code
        GROUP BY c.country_code, c.name, c.flag
        ORDER BY gold DESC, silver DESC, bronze DESC
    """)
    medal_tally = cursor.fetchall()

    conn.close()
    return render_template('index.html',
                           athlete_count=athlete_count,
                           country_count=country_count,
                           sport_count=sport_count,
                           medal_tally=medal_tally,
                           venue_count=venue_count
                           )

@misc_bp.route("/medals")
def medals():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT c.name AS country, c.flag, c.continent,
               SUM(medals.medal = 'Gold')   AS gold,
               SUM(medals.medal = 'Silver') AS silver,
               SUM(medals.medal = 'Bronze') AS bronze,
               COUNT(medals.medal)          AS total
        FROM (
            SELECT a.country_code, ap.medal
            FROM athlete_participation ap
            JOIN athlete a ON ap.athlete_registration_number = a.registration_number
            WHERE ap.medal IS NOT NULL

            UNION ALL

            SELECT tp.country_code, tp.medal
            FROM team_participation tp
            WHERE tp.medal IS NOT NULL
        ) AS medals
        JOIN country c ON medals.country_code = c.country_code
        GROUP BY c.country_code, c.name, c.flag, c.continent
        ORDER BY gold DESC, silver DESC, bronze DESC
    """)
    individual_tally = cursor.fetchall()

    cursor.execute("""
        SELECT sport,
               SUM(medal = 'Gold')   AS gold,
               SUM(medal = 'Silver') AS silver,
               SUM(medal = 'Bronze') AS bronze
        FROM (
            SELECT ap.sport, ap.medal
            FROM athlete_participation ap
            WHERE ap.medal IS NOT NULL

            UNION ALL

            SELECT tp.sport, tp.medal
            FROM team_participation tp
            WHERE tp.medal IS NOT NULL
        ) AS all_medals
        GROUP BY sport
        ORDER BY gold DESC, silver DESC, bronze DESC
    """)
    sport_medals = cursor.fetchall()

    cursor.execute("""
        SELECT a.first_name, a.last_name, c.name AS country, c.flag,
               ap.sport, ap.format, ap.gender_category, g.date
        FROM athlete_participation ap
        JOIN athlete a ON ap.athlete_registration_number = a.registration_number
        LEFT JOIN country c ON a.country_code = c.country_code
        JOIN game g ON ap.sport = g.sport
            AND ap.format = g.format
            AND ap.gender_category = g.gender_category
            AND ap.game_number = g.game_number
        WHERE ap.medal = 'Gold'
        ORDER BY g.date DESC
    """)
    gold_medalists = cursor.fetchall()

    conn.close()
    return render_template('medals.html',
                           individual_tally=individual_tally,
                           sport_medals=sport_medals,
                           gold_medalists=gold_medalists)

@misc_bp.route("/countries")
def countries():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT c.*, COUNT(a.registration_number) AS athlete_count
        FROM country c
        LEFT JOIN athlete a ON c.country_code = a.country_code
        GROUP BY c.country_code
    """)
    country_list = cursor.fetchall()

    conn.close()
    return render_template('countries.html', countries=country_list)

@misc_bp.route("/sports")
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