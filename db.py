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

def db_error_message(err):
    errno = getattr(err, 'errno', None)
    msg = str(err)

    if errno == 1062:
        if "email" in msg.lower():
            return "That email is already in use."
        if "PRIMARY" in msg:
            return "That record already exists."
        return "A record with the same unique value already exists."

    if errno == 1451:
        return "This record cannot be deleted because other records still reference it."

    if errno == 1452:
        return "A referenced value (e.g. sport or country) is invalid or no longer exists."

    if errno == 3819:
        if "check_height" in msg:
            return "Height must be greater than 0 and less than 300."
        if "check_weight" in msg:
            return "Weight must be greater than 0 and less than 300."
        if "check_players" in msg:
            return "A team must have more than 1 player."
        if "check_size" in msg:
            return "Team size must be greater than 1."
        if "capacity_nonnegative" in msg:
            return "Capacity must be 0 or greater."
        return "A database rule was violated."

    if errno == 1048:
        return "A required field is missing."

    if errno == 1406:
        return "A value is too long for its field."

    return getattr(err, 'msg', str(err))