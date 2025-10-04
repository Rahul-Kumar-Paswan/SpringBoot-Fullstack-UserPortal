# 🚀 SpringBoot-Fullstack-UserPortal

![Java](https://img.shields.io/badge/Java-17-blue)
![Spring Boot](https://img.shields.io/badge/SpringBoot-3.x-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Ready-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

SpringBoot-Fullstack-UserPortal is a full-stack user management application built with Spring Boot, Thymeleaf, and MySQL, designed to be containerized with Docker for easy deployment and scalability.

![output](screenshots/maven-home-page.png)  
_For more UI pages, check the [`/screenshots`](./screenshots) folder._

---

## 🖥️ Project Overview

A full-stack web app built with:

- **Backend:** Spring Boot (Java), MySQL
- **Frontend:** Thymeleaf templates (server-side rendered)
- **Authentication:** Simple login/register with session management
- **Database:** MySQL for persistence
- **Containerization:** Docker & Docker Compose for local development and deployment

---

## 🧰 Technologies Used

| Layer    | Tech Stack                       |
| -------- | --------------------------------|
| Backend  | Spring Boot, Java, JPA, MySQL   |
| Frontend | Thymeleaf, HTML, CSS            |
| Database | MySQL                          |
| DevOps   | Docker, Docker Compose          |

---

## ⚙️ Prerequisites

Make sure you have the following installed:

- Docker (v20+)
- Docker Compose (v1.29+)
- (Optional for local dev) Java 17+, Maven 3.8+, MySQL Server

---

## 🔐 Environment Variables

Create a `.env` file at the root of the project folder (where `docker-compose.yml` and `pom.xml` reside):

```bash
SERVER_PORT=8089
DB_HOST=mysql
DB_PORT=3306
DB_NAME=your_db_name
DB_USER=root
DB_PASSWORD=your_rootpassword
```
💡 For manual local setup without Docker, set DB_HOST=localhost.

## 🏁 Running the Application with Docker Compose
Step 1: Build and start containers

From the project root, run:
```bash
docker-compose up --build -d
```
This will:

Build the Spring Boot app Docker image

Start a MySQL container with persistent storage

Start the Spring Boot app container, linked to the MySQL service

Step 2: Verify containers are running
```bash
docker ps
```

You should see containers named springboot-mysql and springboot-userportal-app running.

Step 3: Access the application

Open your browser and visit:

http://localhost:8089

## 🧹 Cleanup

To stop and remove containers, networks, and volumes:
```bash
docker-compose down -v
```

## 🛠️ Manual Local Development (without Docker)

If you prefer running locally without Docker:

Ensure MySQL is running locally and create the database:
```bash
mysql -u root -p

-- Inside MySQL shell:
CREATE DATABASE maven_users;

Set environment variables or update application.properties accordingly.

Build and run the Spring Boot app with Maven:

mvn clean spring-boot:run
```
Visit http://localhost:8089


## 📁 Project Structure
```bash
SpringBoot-Fullstack-UserPortal/
├── Dockerfile
├── docker-compose.yml
├── .env
├── LICENSE
├── README.md
├── pom.xml
├── screenshots/
├── src/
│   ├── main/
│   │   ├── java/com/rahulverse/
│   │   │   ├── AuthController/
│   │   │   ├── controller/
│   │   │   ├── model/
│   │   │   ├── repository/
│   │   │   ├── service/
│   │   │   └── RahulverseApplication.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── templates/
│   └── test/
```

## ✨ Features
- User Registration → /register  
- Login/Logout → /login, /logout  
- Dashboard (post-login) → /dashboard  
- Contact Page → /contact  


## 🔮 Roadmap
- [x] 🐳 Dockerize the application  
- [ ] ☸️ Kubernetes deployment  
- [ ] 🔄 CI/CD with Jenkins  
- [ ] 🏗️ Terraform for AWS EC2 & EKS  
- [ ] 📊 Production deployment & monitoring  

## 🤝 Contributing
Contributions, issues, and feature requests are welcome!  
Feel free to fork this repo and submit a pull request.  

## 📝 License

MIT License © 2025 Rahul Paswan
This project is licensed under the [MIT License](./LICENSE).
