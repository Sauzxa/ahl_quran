# Ahl Al-Quran Project Overview

## Introduction
This document provides an overview of the **Ahl Al-Quran** project based on an analysis of the codebase. The project is a comprehensive school management system designed for Quranic education, featuring a cross-platform frontend and a RESTful backend.

> **Note**: While the initial description mentioned a FastAPI backend, the actual codebase utilizes a **PHP** backend.

## Project Structure
The project is divided into two main directories:

- **`ahlQuran_Front`**: The Flutter-based frontend application.
- **`ahlQuran_back`**: The PHP-based backend API.

---

## Backend (`ahlQuran_back`)

The backend is built using **Vanilla PHP** with a custom routing system. It serves as the central data hub, managing students, teachers, classes, and attendance.

### Key Technologies
- **Language**: PHP (Vanilla)
- **Database**: MySQL
- **Dependencies**: `vlucas/phpdotenv` (for environment variables)
- **Architecture**: MVC (Model-View-Controller) pattern with a custom router.

### API Structure
- **Base URL**: `/api/v1`
- **Authentication**: Basic login/signup endpoints.
- **Resources**: Standard RESTful endpoints (CRUD) for:
    - `students`, `teachers`, `guardians`, `supervisors`
    - `lectures`, `weeklyschedules`, `attendance`
    - `exams`, `examlevels`, `examrecords`
- **Special Endpoints**: Aggregated endpoints (e.g., `/special/students/submit`) for handling complex data submissions in a single request.

### Security
- **Current Status**: The backend documentation notes critical security vulnerabilities (e.g., unhashed passwords, lack of strict API authorization) that need addressing for production use.

---

## Frontend (`ahlQuran_Front`)

The frontend is a **Flutter** application designed to run on both **Web** and **Mobile** platforms from a single codebase.

### Key Technologies
- **Framework**: Flutter
- **State Management**: GetX
- **Networking**: `http` package
- **Routing**: GetX Named Routes (`GetPage`)

### Architecture
- **Entry Point**: `lib/main.dart` initializes the app, loads environment variables, and sets up the theme.
- **Routing**: Defined in `lib/routes/app_screens.dart` and `lib/routes/app_routes.dart`.
    - **Web Routes**: Specific routes for web pages like `/home`, `/features`, `/pricing`.
    - **App Routes**: Core application routes for dashboard, management, and reporting.
- **Controllers**: Located in `lib/controllers`, extending `GetxController`.
    - `GenericController`: Handles common CRUD operations.
    - `submitForm`: Helper for form submissions.
- **Data Layer**:
    - **Models**: Located in `lib/system/new_models`.
    - **API Service**: `lib/system/services/api_client.dart` handles HTTP requests (GET, POST, PUT, DELETE) and error handling.
    - **Endpoints**: Configured in `lib/system/services/network/api_endpoints.dart`.

### Features
- **Dashboard**: Central hub for management.
- **Management**: dedicated screens for Students, Guardians, Teachers, Lectures, and Exams.
- **Reporting**: Various report screens (`Report1` to `Report4`) and statistical charts.
- **Attendance**: Tracking system for students and supervisors.

---

## Discrepancies & Observations

- **Backend Technology**: The project uses PHP instead of the FastAPI backend mentioned in the initial description.
- **Platform Integration**: The Flutter app appears to be a unified codebase handling both web and mobile views, with responsive design considerations and specific web routes.

## Getting Started

### Backend Setup
1.  Navigate to `ahlQuran_back`.
2.  Run `composer install`.
3.  Import `db.sql` into your MySQL database.
4.  Configure `.env` with database credentials.
5.  Serve via Apache/Nginx pointing to `api/v1/index.php`.

### Frontend Setup
1.  Navigate to `ahlQuran_Front`.
2.  Run `flutter pub get`.
3.  Configure `.env` if necessary.
4.  Run `flutter run` (select Chrome for Web or an Emulator for Mobile).
