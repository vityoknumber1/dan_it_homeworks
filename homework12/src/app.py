from flask import Flask, jsonify, request
from marshmallow import ValidationError

from db.db import loadData, students_db
from model.model import StudentSchema

app = Flask(__name__)

loadData()

NOT_FOUND_BY_ID_ERROR = "Entity with ID: {}, not found"
SUCCESSFULLY_REMOVED_MESSAGE = "Entity with ID: {}, deleted successfully"
NOT_FOUND_BY_LAST_NAME_ERROR = "Entity(ies) with last name: {}, not found"


@app.get("/")
def index():
    return (jsonify(
        {'payload': {
            'endpoints': {
                'Retrieve a list of all students': 'GET /students',
                'Retrieve information about a specific student': 'GET /students/{id}',
                'Create a new student.': 'POST /students/{id}',
                'Update student information by their ID.': 'PUT /students/{id}',
                'Update a student\'s age by their ID': 'PATCH /students/{id}',
                'Delete a student from the CSV file by their ID': 'DELETE /students/{id}',
            }
        }}
    ))


@app.get("/students")
def students():
    last_name = request.args.get('last_name')
    if last_name:
        students_list = list(filter(lambda st: st.last_name.lower() == last_name.lower(), students_db))
        if students_list:
            schema = StudentSchema()
            return jsonify({'payload': schema.dump(students_list, many=True)})
        return {
            'error': NOT_FOUND_BY_LAST_NAME_ERROR.format(last_name)
        }, 404
    else:
        schema = StudentSchema()
        return jsonify({'payload': schema.dump(students_db, many=True)})


@app.get("/students/<int:student_id>")
def students_show(student_id: int):
    student = next((st for st in students_db if st.id == student_id), None)
    if student is not None:
        schema = StudentSchema()
        return jsonify({'payload': schema.dump(student)})
    return {'error': NOT_FOUND_BY_ID_ERROR.format(student_id)}, 404


@app.post("/students")
def students_create():
    try:
        new_student = StudentSchema().load(request.get_json())
        students_db.append(new_student)
        return jsonify({'payload': StudentSchema().dump(new_student)}), 201
    except ValidationError as err:
        print(err.messages)
        return {'error': err.messages}, 422
    except TypeError as typeError:
        error_message = str(typeError)
        message = error_message.find('missing')
        print(message)
        return {'error': f"{error_message[message].upper()}{error_message[message + 1:]}"}, 422


@app.put("/students/<int:student_id>")
def students_update_all_fields(student_id: int):
    student = next((st for st in students_db if st.id == student_id), None)
    if student is None:
        return {'error': NOT_FOUND_BY_ID_ERROR.format(student_id)}, 404

    required_fields = {'first_name', 'last_name', 'age'}
    data = request.get_json()

    non_existing_fields = set(data.keys()) - required_fields

    if non_existing_fields:
        return jsonify({
            'error': 'Invalid fields in request',
            'invalid_fields': list(non_existing_fields)
        }), 400

    missing_fields = [field for field in required_fields if field not in data]

    if missing_fields:
        return jsonify({
            'error': 'Missing required fields',
            'missing_fields': missing_fields
        }), 400

    update_student = StudentSchema().validate({
        "age": data['age'],
        "first_name": data['first_name'],
        "last_name": data['last_name']
    })

    if update_student:
        return jsonify({
            'error': 'Validation failed',
            'validation': update_student
        }), 400

    student.last_name = data['last_name']
    student.first_name = data['first_name']
    student.age = data['age']

    return jsonify({'payload': StudentSchema().dump(student)}), 201


@app.patch("/students/<int:student_id>")
def students_update_age(student_id: int):
    student = next((st for st in students_db if st.id == student_id), None)
    if student is None:
        return {'error': NOT_FOUND_BY_ID_ERROR.format(student_id)}, 404

    required_fields = {'age'}
    data = request.get_json()

    non_existing_fields = set(data.keys()) - required_fields

    if non_existing_fields:
        return jsonify({
            'error': 'Invalid fields in request',
            'invalid_fields': list(non_existing_fields)
        }), 400

    missing_fields = [field for field in required_fields if field not in data]

    if missing_fields:
        return jsonify({
            'error': 'Missing required fields',
            'missing_fields': missing_fields
        }), 400

    update_student = StudentSchema().validate({
        "age": data['age'],
    })

    if update_student:
        return jsonify({
            'error': 'Validation failed',
            'validation': update_student
        }), 400

    student.age = data['age']

    return jsonify({'payload': StudentSchema().dump(student)}), 201


@app.delete("/students/<int:student_id>")
def students_remove(student_id: int):
    student = next((st for st in students_db if st.id == student_id), None)
    if student is None:
        return {'error': NOT_FOUND_BY_ID_ERROR.format(student_id)}, 404
    students_db.remove(student)

    return {'payload': SUCCESSFULLY_REMOVED_MESSAGE.format(student_id)}, 201


if __name__ == '__main__':
    app.run(debug=True)