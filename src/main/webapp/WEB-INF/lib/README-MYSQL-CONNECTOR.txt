========================================
MySQL Connector/J - Required for ChocoAura
========================================

The project needs the MySQL JDBC driver to connect to the database.

STEP 1: Download the JAR
------------------------
- Go to: https://dev.mysql.com/downloads/connector/j/
- Choose "Platform Independent"
- Download the ZIP (e.g. mysql-connector-j-8.0.33.zip or newer)
- Extract the ZIP and find the file: mysql-connector-j-8.x.x.jar (or similar name)

STEP 2: Copy the JAR here
-------------------------
- Copy the JAR file into THIS folder:
  src/main/webapp/WEB-INF/lib/

- RENAME the JAR to exactly:
  mysql-connector-j-8.0.33.jar
  (so that .classpath finds it)

  OR if you keep a different name (e.g. mysql-connector-j-9.1.0.jar):
  In Eclipse: Project -> Build Path -> Configure Build Path -> Libraries ->
  Remove the broken mysql-connector entry, then Add JARs -> select your JAR from WEB-INF/lib.

- After copying, this folder should contain:
  README-MYSQL-CONNECTOR.txt  (this file)
  mysql-connector-j-8.0.33.jar (or your version - see above)

STEP 3: Eclipse / Build path (if needed)
----------------------------------------
- In Eclipse: Right-click project -> Build Path -> Configure Build Path
- Libraries tab -> Add JARs -> select the JAR from WEB-INF/lib
- Or the .classpath is already set to use this folder

STEP 4: Restart the server
--------------------------
- Clean the project and restart Tomcat (or your server)
- Try registration again

========================================
