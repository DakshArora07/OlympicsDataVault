# Olympics Data Vault

A Flask-based Olympic data management system built for SFU CMPT 354: Database Systems. The project stores and manages structured Olympic-style data across athletes, teams, sports, venues, events, games, and medal results using a MySQL database backend.

## Overview

Olympics Data Vault is designed to demonstrate relational database concepts through a practical sports information system. It supports browsing, searching, creating, updating, and deleting records for core Olympic entities, while enforcing integrity through foreign keys, constraints, and relationships in the database schema.

The application includes pages for athlete profiles, team rosters, event details, medal standings, and summary dashboards. It also provides sample data from Paris 2024 Olympics through a MySQL dump so the project can be run and explored immediately after setup.

## Features

- Browse and search athletes by name, sport, and gender.
- View detailed athlete profiles with participation history and medal counts.
- Register, edit, and delete athlete records.
- Browse teams and inspect team members and participation history.
- Register and edit teams by selecting athletes from the same country.
- Browse events with venue, schedule, participant, and leaderboard information.
- Register new individual or team events.
- Add games and participation results for each event.
- View medal tallies by country and by sport.
- Explore summary statistics for athletes, countries, sports, and venues.

## Tech Stack

- Python
- Flask
- MySQL
- mysql-connector-python
- HTML templates
- CSS/JavaScript for static assets

## Project Structure

```bash
OlympicsDataVault/
├── routes/
│   ├── athletes.py
│   ├── venues.py
│   ├── events.py
│   ├── teams.py
│   └── misc.py
├── static/
│   ├── css/
│   │   └── main.css
│   └──  js/
│       └── main.js
├── templates/
│   ├── athlete_detail.html
│   ├── athletes.html
│   ├── countries.html
│   ├── edit_athlete.html
│   ├── edit_event.html
│   ├── edit_team.html
│   ├── edit_venue.html
│   ├── event_detail.html
│   ├── events.html
│   ├── index.html
│   ├── layout.html
│   ├── medals.html
│   ├── register_athlete.html
│   ├── register_event.html
│   ├── register_team.html
│   ├── register_venue.html
│   ├── sports.html
│   ├── team_detail.html
│   ├── teams.html
│   ├── venue_detail.html
│   └── venue.html
├── app.py
├── db.py
├── mysql_dump.sql
├── requirements.txt
└── README.md
```

## Database Design

The project is backed by a relational schema that models Olympic data using entities such as:

- `athlete`
- `country`
- `sport`
- `venue`
- `event`
- `game`
- `team`
- `memberof`
- `athleteparticipation`
- `teamparticipation`
- `individualevent`
- `teamevent`

The database uses primary keys, foreign keys, composite keys, and check constraints to preserve consistency across tables. It also stores seed data for athletes, countries, sports, venues, events, and results from the Paris 2024 Olympics.

## Pages and Functionality

### Home
The home page displays key summary statistics and medal tables.

### Athletes
Athlete pages allow users to:
- view all athletes,
- search and filter athletes,
- open an athlete detail page,
- register a new athlete,
- edit athlete information,
- delete athletes.

### Teams
Team pages allow users to:
- view all teams,
- inspect members of each team,
- see team participation history,
- create new teams,
- edit team membership,
- delete teams.

### Events
Event pages allow users to:
- view event listings,
- inspect event details,
- see games scheduled under each event,
- add or remove games,
- record athlete or team participation,
- assign scores and medals,
- manage event venue information.

### Medal Analytics
Medal pages provide:
- medal tallies by country,
- medal totals by sport,
- a list of gold medalists,
- continent-based medal breakdowns.

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/DakshArora07/OlympicsDataVault.git
cd OlympicsDataVault
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Set up MySQL
Create a MySQL database and import the provided dump:

```bash
mysql -u your_username -p your_database < mysql_dump.sql
```

### 4. Configure database connection
Update `db.py` with your local MySQL credentials and database name.

### 5. Run the application
```bash
python app.py
```

Then open the local Flask URL shown in your terminal.

## Sample 2024 Paris Olympics Data

The provided SQL dump includes sample 2024 Paris Olympics records for multiple countries, athletes, sports, teams, venues, and event results. This makes it easy to test the application immediately after import.

## Course Information

This project was developed as part of **CMPT 354: Database Systems** at **Simon Fraser University**.

## Team Members

- Daksh Arora
- Ayush Arora
- Meyer Kaur Sarna
- Mishika Bhandari

## License

This project was created for academic purposes.
