FROM python:3.10-alpine
ENV APP_DIRR='/mnt/c/Users/vikto/homework_13/src'
ENV USER='viktor'
ENV GROUPNAME="${USER}"

# Create a group and user for Linux alpine
RUN addgroup -S "${GROUPNAME}" && adduser -S "${USER}" -G "${GROUPNAME}"

WORKDIR "${APP_DIRR}"

COPY requirements.txt app/requirements.txt


RUN export PATH=$PATH:/usr/local/python3/bin && pip install --no-cache-dir pipenv

RUN pipenv install -r app/requirements.txt

COPY --chown="${USER}":"${USER}" bootstrap.sh gunicorn_config.py ./
COPY --chown="${USER}":"${USER}" app ./app

#RUN pipenv install --system --deploy

USER "${USER}"


#COPY --chown="${USER}":"${USER}" Pipfile Pipfile.lock bootstrap.sh gunicorn_config.py ./

COPY --chown=="${USER}":"${USER}" . . 

## Start app
EXPOSE 8000
ENTRYPOINT ["/mnt/c/Users/vikto/homework_13/src/bootstrap.sh"]
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app", "--workers=4", "--threads=1"]
