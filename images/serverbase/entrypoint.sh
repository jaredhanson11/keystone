#!/bin/sh
exec gunicorn server:app -w 2 -b 0.0.0.0:${PORT} --log-config /app/logging.conf ${EXTRA_GUNICORN_ARGS}