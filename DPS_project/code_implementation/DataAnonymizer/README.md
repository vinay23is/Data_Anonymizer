# Data Anonymizer

A web application for de-identifying sensitive datasets using the **ARX Data Anonymization Library**, letting a user upload a CSV, define which columns are identifying/quasi-identifying/sensitive, and generate a k-anonymized output they can download.

**Live Demo:** [data-anonymizer.onrender.com](https://data-anonymizer.onrender.com/DataAnonymizer/page-login.html)
**Login:** `admin@iiitb` / `admin` (seeded demo account — feel free to log in and click around)

## What problem does this solve?

Raw datasets with names, ages, zip codes, and occupations can often be re-identified even after "obvious" identifiers are stripped out — that's the classic k-anonymity problem. This project gives a non-technical user a web UI to apply real anonymization theory (k-anonymity via generalization hierarchies, powered by the ARX library) to a dataset without writing any code: upload a CSV, classify each column, attach a generalization hierarchy, and download the anonymized result. I built it as part of a data privacy course project and I keep it running as a demo of applying an academic privacy model through a usable interface.

## Tech Stack

- **Backend:** Java (JAX-RS / Jersey REST API), Apache Tomcat 9
- **Anonymization Engine:** ARX Data Anonymization Library (k-anonymity, l-diversity)
- **Frontend:** HTML5, Bootstrap, JavaScript
- **Build:** Maven
- **Infra/Deployment:** Docker (JDK 8 Tomcat base image), deployed on Render

## Architecture

```
Client (HTML/JS)
     │
     ▼
Tomcat Servlet Container (JAX-RS / Jersey)
     │
     ├── POST /anonymizer/signin           — authentication
     ├── GET  /anonymizer/getSources        — list uploaded datasets
     ├── GET  /anonymizer/getConfigurations — list saved XML configs
     ├── POST /anonymizer/uploadSource      — CSV/Excel upload
     ├── POST /anonymizer/uploadConfig      — upload an attribute-type config XML
     ├── POST /anonymizer/uploadHeirarchy   — upload a generalization hierarchy CSV
     ├── POST /anonymizer/createConfig      — build a config from the UI
     ├── POST /anonymizer/getColumns        — inspect a dataset's columns
     ├── POST /anonymizer/anonymize         — run the ARX k-anonymity pipeline
     └── GET  /anonymizer/download          — download the anonymized CSV
```

At `anonymize` time, the service reads the uploaded config XML to learn each attribute's type (`IDENTIFYING`, `QUASI_IDENTIFYING`, `SENSITIVE`, `INSENSITIVE`), attaches a per-attribute generalization hierarchy CSV for every quasi-identifying column, builds an ARX `Data` object from the source (CSV, Excel, or a live JDBC table), and runs ARX's anonymization engine against that definition.

## Key Features

- Upload CSV (or Excel, or connect a live JDBC table) as the data source
- Define attribute types and privacy model parameters through an XML-based configuration system, buildable either by uploading XML or through the UI
- k-anonymity via configurable generalization hierarchies per attribute
- Column inspection endpoint so the UI can help a user classify attributes before anonymizing
- Download the anonymized dataset as a CSV
- Ships with the UCI Adult dataset and pre-built generalization hierarchies (age, education, occupation, race, etc.) so it's usable out of the box with no data prep

## Interesting Engineering Decisions

- **Config-as-XML rather than hardcoded rules** — attribute classification and privacy parameters live in an editable XML file, not in code, so a user can re-run anonymization with a different privacy model on the same dataset without touching the server.
- **Hierarchies are per-attribute CSV files, resolved by naming convention** (`<dataset>_hierarchy_<attribute>.csv`) — a deliberately simple convention over a database of hierarchy metadata, which keeps the ARX integration straightforward at the cost of being filesystem-coupled.
- **Same code path handles CSV, Excel, and JDBC sources** — `anonymize()` branches early on source type but converges on the same ARX `Data`/`DataSource` API, so the anonymization logic itself doesn't care where the rows came from.
- **JDK 8 base image is a deliberate fix, not legacy drift** — the project originally hit a `ClassNotFoundException` for JAXB on newer JDKs (JAXB was removed from the default JDK classpath in Java 9+), so the Docker image was pinned to `tomcat:9.0-jdk8-temurin` to keep the XML config parsing working without pulling in JAXB dependencies by hand.

## Running Locally

**With Docker:**
```bash
docker build -t data-anonymizer .
docker run -p 8080:8080 data-anonymizer
```
Open [http://localhost:8080/DataAnonymizer/page-login.html](http://localhost:8080/DataAnonymizer/page-login.html)

**With Tomcat directly:**
1. Download Apache Tomcat 9
2. Copy `DPS_project/code_implementation/DataAnonymizer/target/DataAnonymizer.war` to Tomcat's `webapps/` directory
3. Start Tomcat: `./bin/startup.sh`
4. Open [http://localhost:8080/DataAnonymizer/page-login.html](http://localhost:8080/DataAnonymizer/page-login.html)

**Usage:**
1. Log in with `admin@iiitb` / `admin`
2. Upload a CSV data source (or use the bundled UCI Adult dataset)
3. Create or upload an XML configuration defining attribute types
4. Run **Anonymize** — the ARX engine applies k-anonymity using the attached hierarchies
5. **Download** the anonymized output CSV
