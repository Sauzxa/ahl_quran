# API Documentation

## Base URL

`/api/v1`
---

## General

- **GET `/api/v1/`**  
  Returns the API version.

---

## Resources

For each resource below, the following RESTful endpoints are available unless otherwise noted.  
**All endpoints are prefixed with `/api/v1`.**  
**Use the specified HTTP method to call each endpoint.**

| Method | Endpoint               | Description                  |
| ------ | ---------------------- | ---------------------------- |
| GET    | `/api/v1/resource`     | Get all items                |
| GET    | `/api/v1/resource/:id` | Get a single item by ID      |
| POST   | `/api/v1/resource`     | Create a new item            |
| PATCH  | `/api/v1/resource/:id` | Update part of an item by ID |
| DELETE | `/api/v1/resource/:id` | Delete an item by ID         |

---

### AccountInfo [[examples](#accountinfo-ex)]

- **GET** `/api/v1/accountinfos` [[example](#get-apiv1accountinfos)]
- **GET** `/api/v1/accountinfos/:id` [[example](#get-apiv1accountinfos7)]
- **POST** `/api/v1/accountinfos` [[example](#post-apiv1accountinfos)]
- **PATCH** `/api/v1/accountinfos/:id` [[example](#patch-apiv1accountinfosid)]
- **DELETE** `/api/v1/accountinfos/:id` [[example](#delete-apiv1accountinfosid)]

### Appreciation

- **GET** `/api/v1/appreciations`
- **GET** `/api/v1/appreciations/:id`
- **POST** `/api/v1/appreciations`
- **PATCH** `/api/v1/appreciations/:id`
- **DELETE** `/api/v1/appreciations/:id`

### ContactInfo

- **GET** `/api/v1/contactinfos`
- **GET** `/api/v1/contactinfos/:id`
- **POST** `/api/v1/contactinfos`
- **PATCH** `/api/v1/contactinfos/:id`
- **DELETE** `/api/v1/contactinfos/:id`

### Exam

- **GET** `/api/v1/exams`
- **GET** `/api/v1/exams/:id`
- **POST** `/api/v1/exams`
- **PATCH** `/api/v1/exams/:id`
- **DELETE** `/api/v1/exams/:id`

### ExamLevel

- **GET** `/api/v1/examlevels`
- **GET** `/api/v1/examlevels/:id`
- **POST** `/api/v1/examlevels`
- **PATCH** `/api/v1/examlevels/:id`
- **DELETE** `/api/v1/examlevels/:id`

### ExamStudent

- **GET** `/api/v1/examstudents`
- **GET** `/api/v1/examstudents/exams/:id/students/:id`
- **POST** `/api/v1/examstudents`
- **PATCH** `/api/v1/examstudents/exams/:idExam/students/:idStudent`
- **DELETE** `/api/v1/examstudents/exams/:idExam/students/:idStudent`

### ExamTeacher

- **GET** `/api/v1/examteachers`
- **GET** `/api/v1/examteachers/exams/:idExam/teachers/:id`
- **POST** `/api/v1/examteachers`
- **PATCH** `/api/v1/examteachers/exams/:id/teachers/:id`
- **DELETE** `/api/v1/examteachers/exams/:id/teachers/:id`

### FormalEducationInfo

- **GET** `/api/v1/formaleducationinfos`
- **GET** `/api/v1/formaleducationinfos/:id`
- **POST** `/api/v1/formaleducationinfos`
- **PATCH** `/api/v1/formaleducationinfos/:id`
- **DELETE** `/api/v1/formaleducationinfos/:id`

### GoldenRecord

- **GET** `/api/v1/goldenrecords`
- **GET** `/api/v1/goldenrecords/:id`
- **POST** `/api/v1/goldenrecords`
- **PATCH** `/api/v1/goldenrecords/:id`
- **DELETE** `/api/v1/goldenrecords/:id`

### Guardian

- **GET** `/api/v1/guardians`
- **GET** `/api/v1/guardians/:id`
- **POST** `/api/v1/guardians`
- **PATCH** `/api/v1/guardians/:id`
- **DELETE** `/api/v1/guardians/:id`

### LectureContent

- **GET** `/api/v1/lecturecontents`
- **GET** `/api/v1/lecturecontents/:id`
- **POST** `/api/v1/lecturecontents`
- **PATCH** `/api/v1/lecturecontents/:id`
- **DELETE** `/api/v1/lecturecontents/:id`

### Lecture

- **GET** `/api/v1/lectures`
- **GET** `/api/v1/lectures/:id`
- **POST** `/api/v1/lectures`
- **PATCH** `/api/v1/lectures/:id`
- **DELETE** `/api/v1/lectures/:id`

### LectureStudent

- **GET** `/api/v1/lecturestudents`
- **GET** `/api/v1/lecturestudents/lectures/:id/students/:id`
- **POST** `/api/v1/lecturestudents`
- **PATCH** `/api/v1/lecturestudents/lectures/:id/students/:id`
- **DELETE** `/api/v1/lecturestudents/lectures/:id/students/:id`

### LectureTeacher

- **GET** `/api/v1/lectureteachers`
- **GET** `/api/v1/lectureteachers/lectures/:id/teachers/:id`
- **POST** `/api/v1/lectureteachers`
- **PATCH** `/api/v1/lectureteachers/lectures/:id/teachers/:id`
- **DELETE** `/api/v1/lectureteachers/lectures/:id/teachers/:id`

### MedicalInfo

- **GET** `/api/v1/medicalinfos`
- **GET** `/api/v1/medicalinfos/:id`
- **POST** `/api/v1/medicalinfos`
- **PATCH** `/api/v1/medicalinfos/:id`
- **DELETE** `/api/v1/medicalinfos/:id`

### PersonalInfo

- **GET** `/api/v1/personalinfos`
- **GET** `/api/v1/personalinfos/:id`
- **POST** `/api/v1/personalinfos`
- **PATCH** `/api/v1/personalinfos/:id`
- **DELETE** `/api/v1/personalinfos/:id`

### RequestCopy

- **GET** `/api/v1/requestcopys`
- **GET** `/api/v1/requestcopys/:id`
- **POST** `/api/v1/requestcopys`
- **PATCH** `/api/v1/requestcopys/:id`
- **DELETE** `/api/v1/requestcopys/:id`

### Student

- **GET** `/api/v1/students`
- **GET** `/api/v1/students/:id`
- **POST** `/api/v1/students`
- **PATCH** `/api/v1/students/:id`
- **DELETE** `/api/v1/students/:id`

### SubscriptionInfo

- **GET** `/api/v1/subscriptioninfos`
- **GET** `/api/v1/subscriptioninfos/:id`
- **POST** `/api/v1/subscriptioninfos`
- **PATCH** `/api/v1/subscriptioninfos/:id`
- **DELETE** `/api/v1/subscriptioninfos/:id`

### Supervisor

- **GET** `/api/v1/supervisors`
- **GET** `/api/v1/supervisors/:id`
- **POST** `/api/v1/supervisors`
- **PATCH** `/api/v1/supervisors/:id`
- **DELETE** `/api/v1/supervisors/:id`

### Teacher

- **GET** `/api/v1/teachers`
- **GET** `/api/v1/teachers/:id`
- **POST** `/api/v1/teachers`
- **PATCH** `/api/v1/teachers/:id`
- **DELETE** `/api/v1/teachers/:id`

### TeamAccomplishment

- **GET** `/api/v1/teamaccomplishments`
- **GET** `/api/v1/teamaccomplishments/:id`
- **POST** `/api/v1/teamaccomplishments`
- **PATCH** `/api/v1/teamaccomplishments/:id`
- **DELETE** `/api/v1/teamaccomplishments/:id`

### TeamAccomplishmentStudent

- **GET** `/api/v1/teamaccomplishmentstudents`
- **GET** `/api/v1/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id`
- **POST** `/api/v1/teamaccomplishmentstudents`
- **PATCH** `/api/v1/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id`
- **DELETE** `/api/v1/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id`

### WeeklySchedule

- **GET** `/api/v1/weeklyschedules`
- **GET** `/api/v1/weeklyschedules/:id`
- **POST** `/api/v1/weeklyschedules`
- **PATCH** `/api/v1/weeklyschedules/:id`
- **DELETE** `/api/v1/weeklyschedules/:id`

### Attendance

- **GET** `/api/v1/attendances`
- **GET** `/api/v1/attendances/user/:userId`
- **GET** `/api/v1/attendances/date/:date`
- **GET** `/api/v1/attendances/from/:date`
- **GET** `/api/v1/attendances/user/:userId/date/:date`
- **POST** `/api/v1/attendances`
- **POST** `/api/v1/attendances/bulk`
- **PATCH** `/api/v1/attendances/:id`

---

## Notes

- All endpoints return JSON.
- Use appropriate HTTP methods for each action.
- For details on request/response bodies, refer to the controller/model for each resource.

## Examples

### AccountInfo ex

#### **GET** `/api/v1/accountinfos`

```json
{
  "example": "get all accounts",
  "request": {},
  "response": [
    {
      "account_id": 1,
      "username": "user",
      "passcode": "123",
      "account_type": "teacher"
    },
    {
      "account_id": 7,
      "username": "user2",
      "passcode": "123",
      "account_type": "teacher"
    }
  ]
}
```

#### **GET** `/api/v1/accountinfos/7`

```json
{
  "example": "get specific account",
  "request": {},
  "response": {
    "account_id": 7,
    "username": "user2",
    "passcode": "123",
    "account_type": "teacher"
  }
}
```

_Error response:_

```json
{
  "example": "get specific account (not found)",
  "request": {},
  "response": {
    "error": "Not found"
  }
}
```

#### **POST** `/api/v1/accountinfos`

```json
{
  "example": "Add account",
  "request": {
    "username": "user2",
    "passcode": "123",
    "account_type": "teacher"
  },
  "response": {
    "account_id": 7,
    "username": "user2",
    "passcode": "123",
    "account_type": "teacher"
  }
}
```

#### **PATCH** `/api/v1/accountinfos/:id`

_Request:_

```json
{
  "passcode": "789"
}
```

_Response:_

```json
{
  "account_id": 7,
  "username": "user2",
  "passcode": "789",
  "account_type": "teacher"
}
```

#### **DELETE** `/api/v1/accountinfos/:id`

_Response:_

```json
{
  "message": "Account deleted successfully"
}
```

---

### WeeklySchedule ex

#### **GET** `/api/v1/weeklyschedules`

```json
[
  {
    "id": 1,
    "student_id": 12,
    "day": "Monday",
    "start_time": "08:00",
    "end_time": "10:00"
  },
  {
    "id": 2,
    "student_id": 13,
    "day": "Tuesday",
    "start_time": "09:00",
    "end_time": "11:00"
  }
]
```

#### **GET** `/api/v1/weeklyschedules/1`

```json
{
  "id": 1,
  "student_id": 12,
  "day": "Monday",
  "start_time": "08:00",
  "end_time": "10:00"
}
```

#### **POST** `/api/v1/weeklyschedules`

_Request:_

```json
{
  "student_id": 12,
  "day": "Wednesday",
  "start_time": "10:00",
  "end_time": "12:00"
}
```

_Response:_

```json
{
  "id": 3,
  "student_id": 12,
  "day": "Wednesday",
  "start_time": "10:00",
  "end_time": "12:00"
}
```

#### **PATCH** `/api/v1/weeklyschedules/3`

_Request:_

```json
{
  "end_time": "13:00"
}
```

_Response:_

```json
{
  "id": 3,
  "student_id": 12,
  "day": "Wednesday",
  "start_time": "10:00",
  "end_time": "13:00"
}
```

#### **DELETE** `/api/v1/weeklyschedules/3`

_Response:_

```json
{
  "message": "Deleted"
}
```
### Attendance ex

### GET `/api/v1/attendances`  
Get all attendance records.

**Response:**
```json
[
  {
    "id": 1,
    "user_id": 101,
    "attendance_date": "2025-05-20",
    "status": "present"
  },
  {
    "id": 2,
    "user_id": 102,
    "attendance_date": "2025-05-20",
    "status": "absent"
  }
]
