#!/bin/sh

pipenv run gunicorn --config gunicorn_config.py app.app:app
