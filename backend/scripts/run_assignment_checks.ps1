# Run everything needed to generate outputs for assignment questions (Windows PowerShell)
# Usage: Open PowerShell as admin and run this script from the backend folder.

$mysqlContainerName = "smart-clinic-mysql"
$mysqlRootPassword = "Passw0rd!"
$database = "smart_clinic"

# 1) Start MySQL container if not running
$running = docker ps -a --filter "name=$mysqlContainerName" --format "{{.Names}}" | Select-String $mysqlContainerName
if (-not $running) {
    Write-Host "Starting MySQL container..."
    docker run --name $mysqlContainerName -e MYSQL_ROOT_PASSWORD=$mysqlRootPassword -e MYSQL_DATABASE=$database -p 3306:3306 -d mysql:8.0
} else {
    $state = docker inspect -f '{{.State.Status}}' $mysqlContainerName
    if ($state -ne 'running') {
        Write-Host "Starting existing container..."
        docker start $mysqlContainerName
    }
}

# 2) Wait for MySQL to be ready
Write-Host "Waiting for MySQL to initialize..."
Start-Sleep -Seconds 12

# 3) Apply schema (migration SQL) and then seed data
Write-Host "Applying schema (V1__init_schema.sql)"
Get-Content .\src\main\resources\db\migration\V1__init_schema.sql -Raw | docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword $database

Write-Host "Applying seed data (db_seed.sql)"
Get-Content .\db_seed.sql -Raw | docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword $database

# Create output directory
$outputDir = ".\assignment_outputs"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }

# 4) Capture SHOW TABLES
Write-Host "Capturing SHOW TABLES..."
docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword -e "USE $database; SHOW TABLES;" | Out-File -FilePath "$outputDir/show_tables.txt" -Encoding utf8

# 5) Capture 5 patient records
Write-Host "Capturing 5 patients..."
docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword -e "USE $database; SELECT * FROM patients LIMIT 5;" | Out-File -FilePath "$outputDir/patients_limit5.txt" -Encoding utf8

# 6) Run stored procedures
Write-Host "Running GetDailyAppointmentsByDoctor(1,'2025-11-03')"
docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword -e "USE $database; CALL GetDailyAppointmentsByDoctor(1,'2025-11-03');" | Out-File -FilePath "$outputDir/GetDailyAppointmentsByDoctor.txt" -Encoding utf8

Write-Host "Running GetDoctorWithMostPatientsByMonth(11,2025)"
docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword -e "USE $database; CALL GetDoctorWithMostPatientsByMonth(11,2025);" | Out-File -FilePath "$outputDir/GetDoctorWithMostPatientsByMonth.txt" -Encoding utf8

Write-Host "Running GetDoctorWithMostPatientsByYear(2025)"
docker exec -i $mysqlContainerName mysql -uroot -p$mysqlRootPassword -e "USE $database; CALL GetDoctorWithMostPatientsByYear(2025);" | Out-File -FilePath "$outputDir/GetDoctorWithMostPatientsByYear.txt" -Encoding utf8

# 7) Start backend (Flyway disabled) on port 8081
Write-Host "Starting backend jar (port 8081) with Flyway disabled..."
$env:SPRING_DATASOURCE_URL = "jdbc:mysql://127.0.0.1:3306/$database?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true"
$env:SPRING_DATASOURCE_USERNAME = "root"
$env:SPRING_DATASOURCE_PASSWORD = $mysqlRootPassword
$env:SPRING_JWT_SECRET = "replace_with_a_strong_jwt_secret_please_change"
$env:SPRING_FLYWAY_ENABLED = "false"
$env:SERVER_PORT = "8081"
Start-Process -FilePath 'java' -ArgumentList '-jar','target\back-end-1.0.0.jar' -WorkingDirectory (Get-Location) -NoNewWindow

Start-Sleep -Seconds 6

# 8) Capture GET /api/doctors into file (no auth required)
Write-Host "Fetching GET /api/doctors"
curl.exe -s -o "$outputDir/doctors.json" http://localhost:8081/api/doctors
Get-Content "$outputDir/doctors.json" -Raw | Out-File "$outputDir/doctors.json" -Encoding utf8

# 9) Attempt to GET appointments for patient/1 (may require auth)
Write-Host "Fetching GET /api/appointments/patient/1 (may return 401 if authentication is required)"
curl.exe -s -o "$outputDir/appointments_patient1.json" http://localhost:8081/api/appointments/patient/1
Get-Content "$outputDir/appointments_patient1.json" -Raw | Out-File "$outputDir/appointments_patient1.json" -Encoding utf8

Write-Host "All done. Outputs are in $outputDir"
