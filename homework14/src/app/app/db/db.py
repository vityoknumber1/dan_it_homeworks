import csv
from typing import List

from model.model import Student, StudentSchema

students_db: List[Student] = []


def loadData() -> None:
    with open('db/students.csv', 'r') as students:
        csv_reader = csv.DictReader(students, delimiter=',')

        schema = StudentSchema()
        for student in csv_reader:
            result = schema.load({
                # "id": student['id']
                "first_name": student['first_name'],
                "last_name": student['last_name'],
                "age": student['age'],
            })
            students_db.append(result)
