@echo off
cd /d C:\xampp\htdocs\duckia
start /b node src/server.js > nul 2>&1
echo duckia iniciado