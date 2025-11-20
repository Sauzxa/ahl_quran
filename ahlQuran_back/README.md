# Ahl Al-Quran Backend API

**Base URL:** `/api/v1`

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/login` | User login |
| `POST` | `/auth/signup` | Create new user account |

### Standard Resource Endpoints

All standard resources follow RESTful conventions:

#### Account Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/accountinfos` | Get all account infos |
| `GET` | `/accountinfos/:id` | Get account info by ID |
| `POST` | `/accountinfos` | Create new account info |
| `PATCH` | `/accountinfos/:id` | Update account info |
| `DELETE` | `/accountinfos/:id` | Delete account info |

#### Appreciations
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/appreciations` | Get all appreciations |
| `GET` | `/appreciations/:id` | Get appreciation by ID |
| `POST` | `/appreciations` | Create new appreciation |
| `PATCH` | `/appreciations/:id` | Update appreciation |
| `DELETE` | `/appreciations/:id` | Delete appreciation |

#### Contact Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/contactinfos` | Get all contact infos |
| `GET` | `/contactinfos/:id` | Get contact info by ID |
| `POST` | `/contactinfos` | Create new contact info |
| `PATCH` | `/contactinfos/:id` | Update contact info |
| `DELETE` | `/contactinfos/:id` | Delete contact info |

#### Exams
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/exams` | Get all exams |
| `GET` | `/exams/:id` | Get exam by ID |
| `POST` | `/exams` | Create new exam |
| `PATCH` | `/exams/:id` | Update exam |
| `DELETE` | `/exams/:id` | Delete exam |

#### Exam Levels
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/examlevels` | Get all exam levels |
| `GET` | `/examlevels/:id` | Get exam level by ID |
| `POST` | `/examlevels` | Create new exam level |
| `PATCH` | `/examlevels/:id` | Update exam level |
| `DELETE` | `/examlevels/:id` | Delete exam level |

#### Exam Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/examstudents` | Get all exam-student records |
| `GET` | `/examstudents/exams/:id/students/:id` | Get specific exam-student record |
| `POST` | `/examstudents` | Create new exam-student record |
| `PATCH` | `/examstudents/exams/:idExam/students/:idStudent` | Update exam-student record |
| `DELETE` | `/examstudents/exams/:idExam/students/:idStudent` | Delete exam-student record |

#### Exam Teachers
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/examteachers` | Get all exam-teacher records |
| `GET` | `/examteachers/exams/:idExam/teachers/:id` | Get specific exam-teacher record |
| `POST` | `/examteachers` | Create new exam-teacher record |
| `PATCH` | `/examteachers/exams/:id/teachers/:id` | Update exam-teacher record |
| `DELETE` | `/examteachers/exams/:id/teachers/:id` | Delete exam-teacher record |

#### Formal Education Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/formaleducationinfos` | Get all formal education infos |
| `GET` | `/formaleducationinfos/:id` | Get formal education info by ID |
| `POST` | `/formaleducationinfos` | Create new formal education info |
| `PATCH` | `/formaleducationinfos/:id` | Update formal education info |
| `DELETE` | `/formaleducationinfos/:id` | Delete formal education info |

#### Golden Records
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/goldenrecords` | Get all golden records |
| `GET` | `/goldenrecords/:id` | Get golden record by ID |
| `POST` | `/goldenrecords` | Create new golden record |
| `PATCH` | `/goldenrecords/:id` | Update golden record |
| `DELETE` | `/goldenrecords/:id` | Delete golden record |

#### Guardians
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/guardians` | Get all guardians |
| `GET` | `/guardians/:id` | Get guardian by ID |
| `POST` | `/guardians` | Create new guardian |
| `PATCH` | `/guardians/:id` | Update guardian |
| `DELETE` | `/guardians/:id` | Delete guardian |

#### Lecture Contents
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/lecturecontents` | Get all lecture contents |
| `GET` | `/lecturecontents/:id` | Get lecture content by ID |
| `POST` | `/lecturecontents` | Create new lecture content |
| `PATCH` | `/lecturecontents/:id` | Update lecture content |
| `DELETE` | `/lecturecontents/:id` | Delete lecture content |

#### Lectures
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/lectures` | Get all lectures |
| `GET` | `/lectures/ar_name-and-id` | Get Arabic names and IDs only |
| `GET` | `/lectures/:id` | Get lecture by ID |
| `POST` | `/lectures` | Create new lecture |
| `PATCH` | `/lectures/:id` | Update lecture |
| `DELETE` | `/lectures/:id` | Delete lecture |

#### Lecture Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/lecturestudents` | Get all lecture-student records |
| `GET` | `/lecturestudents/lectures/:id/students/:id` | Get specific lecture-student record |
| `GET` | `/lecturestudents/lectures/students/:id` | Get all lectures for a student |
| `GET` | `/lecturestudents/lectures/:id/students` | Get all students for a lecture |
| `POST` | `/lecturestudents` | Create new lecture-student record |
| `PATCH` | `/lecturestudents/lectures/:id/students/:id` | Update lecture-student record |
| `DELETE` | `/lecturestudents/lectures/:id/students/:id` | Delete lecture-student record |

#### Lecture Teachers
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/lectureteachers` | Get all lecture-teacher records |
| `GET` | `/lectureteachers/lectures/:id/teachers/:id` | Get specific lecture-teacher record |
| `POST` | `/lectureteachers` | Create new lecture-teacher record |
| `PATCH` | `/lectureteachers/lectures/:id/teachers/:id` | Update lecture-teacher record |
| `DELETE` | `/lectureteachers/lectures/:id/teachers/:id` | Delete lecture-teacher record |

#### Medical Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/medicalinfos` | Get all medical infos |
| `GET` | `/medicalinfos/:id` | Get medical info by ID |
| `POST` | `/medicalinfos` | Create new medical info |
| `PATCH` | `/medicalinfos/:id` | Update medical info |
| `DELETE` | `/medicalinfos/:id` | Delete medical info |

#### Personal Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/personalinfos` | Get all personal infos |
| `GET` | `/personalinfos/:id` | Get personal info by ID |
| `POST` | `/personalinfos` | Create new personal info |
| `PATCH` | `/personalinfos/:id` | Update personal info |
| `DELETE` | `/personalinfos/:id` | Delete personal info |

#### Request Copies
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/requestcopys` | Get all request copies |
| `GET` | `/requestcopys/:id` | Get request copy by ID |
| `POST` | `/requestcopys` | Create new request copy |
| `PATCH` | `/requestcopys/:id` | Update request copy |
| `DELETE` | `/requestcopys/:id` | Delete request copy |

#### Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/students` | Get all students |
| `GET` | `/students/:id` | Get student by ID |
| `POST` | `/students` | Create new student |
| `PATCH` | `/students/:id` | Update student |
| `DELETE` | `/students/:id` | Delete student |

#### Subscription Info
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/subscriptioninfos` | Get all subscription infos |
| `GET` | `/subscriptioninfos/:id` | Get subscription info by ID |
| `POST` | `/subscriptioninfos` | Create new subscription info |
| `PATCH` | `/subscriptioninfos/:id` | Update subscription info |
| `DELETE` | `/subscriptioninfos/:id` | Delete subscription info |

#### Supervisors
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/supervisors` | Get all supervisors |
| `GET` | `/supervisors/:id` | Get supervisor by ID |
| `POST` | `/supervisors` | Create new supervisor |
| `PATCH` | `/supervisors/:id` | Update supervisor |
| `DELETE` | `/supervisors/:id` | Delete supervisor |

#### Teachers
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/teachers` | Get all teachers |
| `GET` | `/teachers/:id` | Get teacher by ID |
| `POST` | `/teachers` | Create new teacher |
| `PATCH` | `/teachers/:id` | Update teacher |
| `DELETE` | `/teachers/:id` | Delete teacher |

#### Team Accomplishments
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/teamaccomplishments` | Get all team accomplishments |
| `GET` | `/teamaccomplishments/:id` | Get team accomplishment by ID |
| `POST` | `/teamaccomplishments` | Create new team accomplishment |
| `PATCH` | `/teamaccomplishments/:id` | Update team accomplishment |
| `DELETE` | `/teamaccomplishments/:id` | Delete team accomplishment |

#### Team Accomplishment Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/teamaccomplishmentstudents` | Get all team accomplishment-student records |
| `GET` | `/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id` | Get specific record |
| `POST` | `/teamaccomplishmentstudents` | Create new record |
| `PATCH` | `/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id` | Update record |
| `DELETE` | `/teamaccomplishmentstudents/teamaccomplishments/:id/students/:id` | Delete record |

#### Weekly Schedules
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/weeklyschedules` | Get all weekly schedules |
| `GET` | `/weeklyschedules/:id` | Get weekly schedule by ID |
| `POST` | `/weeklyschedules` | Create new weekly schedule |
| `PATCH` | `/weeklyschedules/:id` | Update weekly schedule |
| `DELETE` | `/weeklyschedules/:id` | Delete weekly schedule |

#### Student Lecture Achievements
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/achievements` | Get all achievements |
| `GET` | `/achievements/latest` | Get latest achievements |
| `GET` | `/achievements/lectures/:id/students/:id` | Get specific achievement |
| `POST` | `/achievements` | Create new achievement |
| `PATCH` | `/achievements/lectures/:id/students/:id` | Update achievement |
| `DELETE` | `/achievements/lectures/:id/students/:id` | Delete achievement |

#### Supervisor Attendance
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/attendances` | Get all attendance records |
| `GET` | `/attendances/date/:date/supervisor/:supervisorId` | Get by supervisor and date |
| `GET` | `/attendances/supervisor/:supervisorId` | Get all for supervisor |
| `GET` | `/attendances/date/:date` | Get all for date |
| `POST` | `/attendances` | Create attendance record |
| `PATCH` | `/attendances/:supervisorId/:date` | Update attendance record |
| `DELETE` | `/attendances/:supervisorId/:date` | Delete attendance record |

---

## Special Endpoints (Aggregated Data)

### Students
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/special/students` | Get all students with complete data |
| `POST` | `/special/students/submit` | Create student with all related data |
| `PUT` | `/special/students/:id` | Update student with all related data |

### Guardians
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/special/guardians` | Get all guardians with children |
| `POST` | `/special/guardians/submit` | Create guardian with account and contact |
| `PUT` | `/special/guardians/:id` | Update guardian with account and contact |

### Lectures
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/special/lectures` | Get all lectures with teachers and schedules |
| `POST` | `/special/lectures/submit` | Create lecture with teachers and schedules |
| `PUT` | `/special/lectures/:id` | Update lecture with teachers and schedules |

### Exam Records
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/special/exams-records` | Get all exam records with student details |
| `POST` | `/special/exams-records/submit` | Create exam record |
| `PUT` | `/special/exams-records/:id` | Update exam record |

### Exam Teachers
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/special/exams-teachers` | Get all teachers with assigned exams |
| `POST` | `/special/exams-teachers/submit` | Create exam-teacher assignment |
| `PUT` | `/special/exams-teachers/:id` | Update exam-teacher assignment |

-----

# Ahl Al-Quran - Backend API

## Overview

This project is the backend API for Ahl Al-Quran, a school management system designed to handle the operational needs of a Quranic educational institution. It provides a RESTful interface to manage students, teachers, guardians, lectures, exams, attendance, and more.

The application is built with vanilla PHP and uses a custom router to handle API requests. It is designed to be a central data hub for various client applications (e.g., a web front-end or mobile apps).

## Features

  - **RESTful API:** Provides standard CRUD (Create, Read, Update, Delete) operations for all major resources.
  - **Resource Management:** Endpoints to manage:
      - Students, Guardians, Teachers, and Supervisors
      - Lectures, Weekly Schedules, and Attendance
      - Exams, Exam Levels, and Student Records
      - Personal, Contact, and Medical Information
  - **Authentication:** Basic endpoints for user signup and login.
  - **Environment Configuration:** Uses `.env` files for easy and secure configuration management.

## Technical Stack

  - **Backend:** PHP
  - **Database:** MySQL
  - **Dependencies:**
      - `vlucas/phpdotenv`: For loading environment variables from a `.env` file.

-----

## Getting Started

Follow these instructions to get the project up and running on your local machine for development and testing purposes.

### Prerequisites

  - PHP 7.2.5 or higher
  - Composer
  - A MySQL database server

### Installation Steps

1.  **Clone the repository:**

    ```bash
    git clone <your-repository-url>
    cd ahl_quran_backend
    ```

2.  **Install PHP dependencies:**
    Run Composer to install the required packages.

    ```bash
    composer install
    ```

3.  **Setup the Database:**

      - Create a new database in MySQL for this project (e.g., `quran`).
      - Import the database schema and initial data using the provided SQL file:
        ```bash
        mysql -u your_username -p your_database_name < db.sql
        ```
        This will create all the necessary tables and populate them with sample data.

4.  **Configure Environment Variables:**

      - The project uses a `.env` file to manage sensitive configurations like database credentials. The main entry point `api/v1/index.php` loads these variables.
      - Create a `.env` file in the project's root directory (`v0idseeker/ahl_quran_backend/V0idSeeker-ahl_quran_backend-9a2caf0e7c6944d8d5b7e521253ddd4f4e226f5e/`).
      - Add the following configuration to your `.env` file, replacing the values with your local database credentials:

    <!-- end list -->

    ```env
    BASE_URL=/your/project/subdirectory # e.g., /ahl_quran_backend

    DB_HOST=localhost
    DB_USER=root
    DB_PASS=
    DB_NAME=quran
    ```

    *Note: The `DB` connection is initialized in `api/v1/index.php` with hardcoded values as a fallback, but using the `.env` file is the recommended approach.*

5.  **Configure Your Web Server:**

      - Configure your web server (e.g., Apache or Nginx) to route all requests for the API to `api/v1/index.php`.
      - Ensure that your server configuration allows for URL rewriting so the router can handle clean URLs (e.g., `/api/v1/students/1`).

-----

## API Documentation

The API provides a set of RESTful endpoints for interacting with the application's resources. The base URL for all endpoints is `/api/v1`.

### General Resources

The API follows a standard REST pattern for most resources.

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/resource` | Get all items for a resource. |
| `GET` | `/resource/:id` | Get a single item by its ID. |
| `POST` | `/resource` | Create a new item. |
| `PATCH` | `/resource/:id` | Update an existing item. |
| `DELETE` | `/resource/:id` | Delete an item. |

### Available Resources

A comprehensive list of all available resources, endpoints, and example request/response payloads can be found in the API documentation file:

  - **[API Documentation](https://www.google.com/search?q=./api/v1/API_DOCS.md)**

Key resources include: `students`, `teachers`, `guardians`, `supervisors`, `lectures`, `exams`, `attendance`, and more.

### Special Endpoints

The API also includes specialized endpoints under the `/api/v1/special/` path for more complex data retrieval, such as fetching a student with all their related information in a single call.

-----

## 🚨 Security Warning

This project contains **critical security vulnerabilities** and should **NOT** be used in a production environment without addressing them.

1.  **Password Storage:** Passwords are currently stored in the database without being securely hashed. This is a major risk.

      - **Recommendation:** Implement `password_hash()` when creating or updating user passwords and `password_verify()` for checking passwords during login.

2.  **API Authorization:** Most endpoints are public and lack authorization checks. Once a user logs in, there is no mechanism to ensure they are authorized to access or modify other resources.

      - **Recommendation:** Implement an authentication mechanism like JWT (JSON Web Tokens) or session-based tokens. Each protected endpoint should verify the user's token and check their permissions before processing the request.

## Project Structure

The project is organized into the following main directories:

  - `/`: Contains project configuration files like `composer.json` and the database schema `db.sql`.
  - `/api/v1/`: The public-facing entry point for the API, containing the main `index.php` and the router.
  - `/controllers/`: Contains the controller classes that handle the logic for each API resource.
  - `/models/`: Contains the data model classes that interact with the database tables.
  - `/special_controllers/`: Contains controllers for more complex, aggregated data queries.
  - `/vendor/`: Contains third-party dependencies managed by Composer.




before start : 

This will add the `vlucas/phpdotenv` package, which helps you manage environment variables in your PHP project.

```
composer require vlucas/phpdotenv
```
