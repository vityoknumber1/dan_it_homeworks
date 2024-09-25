FROM python:3.10-slim


WORKDIR /mnt/c/Users/vikto/homework_13/src/app/app


COPY requirements.txt .


RUN pip install --no-cache-dir -r requirements.txt


COPY app.py .

COPY students.csv .



EXPOSE 8000



CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
