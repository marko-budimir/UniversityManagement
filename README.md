# University Management System

A Node.js and PostgreSQL-based web application for managing students and faculties in a university.

## Overview

The University Management System is a web application built with Node.js and PostgreSQL. It provides a platform for managing students, faculties, and their associations within a university. This README serves as a guide for setting up and using the system.

## Features

- CRUD operations for students and faculties
- Student-faculty associations
- Fetching and saving data from an external API

## Getting Started

### Prerequisites

Before running the application, ensure you have the following installed:

- [Node.js](https://nodejs.org/)
- [PostgreSQL](https://www.postgresql.org/)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/university-management.git
   cd university-management
2. Install dependencies:
   ```bash
    npm install
   
### Configuration
Set up your PostgreSQL database and update the configuration in .env:
    
    DB_USER=your_database_user
    DB_PASSWORD=your_database_password
    DB_HOST=your_database_host
    DB_PORT=your_database_port
    DB_NAME=university_management


### Database Schema
The database schema is defined in the schema.sql file.

Ensure the database exists before proceeding.


## Usage
Start the server:
    
    npm start
Access the application at http://localhost:3000.

## API Endpoints
    /students: CRUD operations for students
    /faculties: CRUD operations for faculties
    /data: Fetch and save data from an external API
