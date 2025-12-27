@echo off
REM Database and Backend Setup Script

echo.
echo ========================================
echo Gear Guard Backend Setup Script
echo ========================================
echo.

REM Check if npm is installed
where npm >nul 2>nul
if errorlevel 1 (
    echo ERROR: Node.js/npm is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo [1/3] Installing dependencies...
call npm install
if errorlevel 1 (
    echo ERROR: npm install failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Dependencies installed successfully!
echo.
echo ========================================
echo MongoDB Setup
echo ========================================
echo.
echo Make sure MongoDB is running:
echo.
echo Option 1: Local MongoDB
echo   - Start MongoDB service on your system
echo   - Or run: mongod
echo.
echo Option 2: MongoDB Atlas (Cloud)
echo   - Update MONGODB_URI in .env file with your connection string
echo   - Example: mongodb+srv://user:pass@cluster.mongodb.net/flutter_db
echo.
pause

echo.
echo [3/3] Seeding database with dummy data...
call npm run seed
if errorlevel 1 (
    echo ERROR: Database seeding failed!
    echo Make sure MongoDB is running and connection is correct.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To start the server, run:
echo   npm start
echo.
echo For development with auto-reload, run:
echo   npm run dev
echo.
echo Server will run on: http://localhost:5000
echo.
pause
