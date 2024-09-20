from marshmallow import Schema, fields, validate, post_load


class Student:
    id = 1

    def __init__(self, first_name: str, last_name: str, age: int):
        self.id = Student.id
        self.first_name = first_name
        self.last_name = last_name
        self.age = age
        Student.id += 1

    def __repr__(self):
        return "<Student(id={self.id}, first_name={self.first_name!r}, last_name={self.last_name!r}, age={self.age})>".format(
            self=self)
    

class StudentSchema(Schema):
    id = fields.Int(required=False)
    first_name = fields.Str(validate=validate.Length(min=1))
    last_name = fields.Str(validate=validate.Length(min=1))
    age = fields.Int(validate=validate.Range(min=1))

    @post_load
    def make_student(self, data, **kwargs):
        return Student(**data)