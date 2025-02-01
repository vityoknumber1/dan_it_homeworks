import os

from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://{}:{}@{}:{}/{}'.format(
    os.getenv('DB_USER', 'root'),
    os.getenv('DB_PASSWORD', 'password'),
    os.getenv('DB_HOST', 'localhost'),
    os.getenv('DB_PORT', '3306'),
    os.getenv('DB_NAME', 'testdb')
)
db = SQLAlchemy(app)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

    def __init__(self, name, email):
        self.name = name
        self.email = email

    def __repr__(self):
        return '<User %r>' % self.name


with app.app_context():
    db.create_all()
    db.session.add(User('admin', 'admin@example.com'))
    db.session.add(User('guest', 'guest@example.com'))
    db.session.commit()


@app.route('/')
def hello():
    return jsonify({"message": "Hello from Python Flask!"})


@app.route('/users')
def get_users():
    users = User.query.all()
    return jsonify([{"id": user.id, "name": user.name, "email": user.email} for user in users])


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)