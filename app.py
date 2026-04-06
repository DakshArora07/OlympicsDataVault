from flask import Flask, render_template

app = Flask(__name__)


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
    return render_template('athletes.html', title='Athletes')

@app.route("/events")
def events():
    return render_template('events.html', title='Events')

@app.route("/venues")
def venues():
    return render_template('venues.html', title='Venues')

@app.route("/search")
def search():
    return render_template('search.html', title='Search')

@app.route("/register_athlete")
def register_athlete():
    return render_template('register_athlete.html', title='RegisterAthlete')

if __name__ == '__main__':
    app.run(debug=True)
