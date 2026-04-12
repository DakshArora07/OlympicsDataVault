from flask import Flask
from routes.misc import misc_bp
from routes.athletes import athletes_bp
from routes.teams import teams_bp
from routes.events import events_bp
from routes.venues import venues_bp

app = Flask(__name__)

app.register_blueprint(misc_bp)
app.register_blueprint(athletes_bp)
app.register_blueprint(teams_bp)
app.register_blueprint(events_bp)
app.register_blueprint(venues_bp)

if __name__ == '__main__':
    app.run(debug=True)