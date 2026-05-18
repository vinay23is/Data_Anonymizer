# Data Anonymizer

A web application for anonymizing sensitive datasets using the **ARX Data Anonymization Library**. Supports k-anonymity and l-diversity privacy models with a configurable, file-based pipeline.

## Live Demo

> **URL:** *(update after deployment)*  
> **Login:** `admin@iiitb` / `admin`

## Features

- Upload CSV datasets for de-identification
- Configure anonymization rules through an XML-based configuration system
- Supports **k-anonymity** privacy model with configurable suppression rates
- Attribute classification: Identifying, Quasi-Identifying, Sensitive, Insensitive
- Generalization hierarchy support per attribute
- Download anonymized output as CSV
- REST API backend (JAX-RS / Jersey) on Apache Tomcat

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java (JAX-RS / Jersey), Apache Tomcat |
| Anonymization | ARX Library (k-anonymity, l-diversity) |
| Frontend | HTML5, Bootstrap, JavaScript |
| Build | Maven |
| Deployment | Docker |

## Running Locally

**With Docker:**

```bash
docker build -t data-anonymizer .
docker run -p 8080:8080 data-anonymizer
```

Then open: [http://localhost:8080/DataAnonymizer/page-login.html](http://localhost:8080/DataAnonymizer/page-login.html)

**With Tomcat directly:**

1. Download Apache Tomcat 9
2. Copy `DPS_project/code_implementation/DataAnonymizer/target/DataAnonymizer.war` to Tomcat's `webapps/` directory
3. Start Tomcat: `./bin/startup.sh`
4. Open: [http://localhost:8080/DataAnonymizer/page-login.html](http://localhost:8080/DataAnonymizer/page-login.html)

## Usage

1. **Login** with `admin@iiitb` / `admin`
2. **Upload** a CSV data source
3. **Create or upload** an XML configuration defining attribute types and privacy model parameters
4. **Anonymize** — the app applies k-anonymity via the ARX engine
5. **Download** the anonymized output CSV

## Sample Dataset

The repo includes the UCI Adult dataset (`adult.csv`) with pre-built generalization hierarchies for attributes like age, education, occupation, and race — ready to use out of the box.

## Architecture

```
Client (HTML/JS)
     │
     ▼
Tomcat Servlet Container
     │
     ├── /anonymizer/signin       — Authentication
     ├── /anonymizer/uploadSource — CSV upload
     ├── /anonymizer/uploadConfig — Config XML upload
     ├── /anonymizer/anonymize    — Run ARX anonymization
     └── /anonymizer/download     — Download result CSV
```
