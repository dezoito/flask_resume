#!/bin/bash
# /usr/local/bin/gunicorn config.wsgi -w 4 -b 0.0.0.0:5000 --chdir=/app
gunicorn app:app -b 0.0.0.0:81
