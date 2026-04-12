from flask import Blueprint, render_template, request, redirect, url_for
from db import get_connection

venues_bp = Blueprint('venues', __name__)

@venues_bp.route("/venues")
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

@venues_bp.route("/register_venue", methods=["GET", "POST"])
def register_venue():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT name, country_code
        FROM country
        ORDER BY name
    """)
    country_list = cursor.fetchall()

    if request.method == "POST":
        venue_id = request.form.get("venue_id")
        name = request.form.get("name")
        city = request.form.get("city")
        country = request.form.get("country")
        capacity = request.form.get("capacity")

        cursor.execute("""
            INSERT INTO venue (venue_id, name, city, country, capacity)
            VALUES (%s, %s, %s, %s, %s)
        """, (venue_id, name, city, country, capacity))


        conn.commit()
        conn.close()
        return redirect(url_for("venues.venues"))

    return render_template("register_venue.html", countries=country_list)

@venues_bp.route("/venues/<int:venue_id>")
def venue_detail(venue_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM venue
        WHERE venue_id = %s
    """, (venue_id,))
    venue = cursor.fetchone()

    if not venue:
        conn.close()
        return redirect(url_for('venues.venues'))

    cursor.execute("""
        SELECT e.sport, e.format, e.gender_category,
               IF(te.format IS NOT NULL, 'Team', 'Individual') AS event_type
        FROM event e
        LEFT JOIN team_event te ON e.sport = te.sport
            AND e.format = te.format
            AND e.gender_category = te.gender_category
        WHERE e.venue_id = %s
        ORDER BY e.sport, e.format
    """, (venue_id,))
    event_list = cursor.fetchall()

    conn.close()
    return render_template('venue_detail.html', venue=venue, events=event_list)

@venues_bp.route("/venues/<int:venue_id>/edit", methods=["GET", "POST"])
def edit_venue_page(venue_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM venue WHERE venue_id = %s", (venue_id,))
    venue = cursor.fetchone()

    if not venue:
        conn.close()
        return redirect(url_for('venues.venues'))

    cursor.execute("SELECT name, country_code FROM country ORDER BY name")
    countries = cursor.fetchall()

    if request.method == "POST":
        name     = request.form.get("name")
        city     = request.form.get("city")
        country  = request.form.get("country")
        capacity = request.form.get("capacity")

        cursor.execute("""
            UPDATE venue
            SET name = %s, city = %s, country = %s, capacity = %s
            WHERE venue_id = %s
        """, (name, city, country, capacity, venue_id))

        conn.commit()
        conn.close()
        return redirect(url_for('venues.venue_detail', venue_id=venue_id))

    conn.close()
    return render_template('edit_venue.html', venue=venue, countries=countries)

@venues_bp.route("/venues/<int:venue_id>/delete", methods=["POST"])
def delete_venue(venue_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("DELETE FROM venue WHERE venue_id = %s", (venue_id,))

    conn.commit()
    conn.close()
    return redirect(url_for('venues.venues'))