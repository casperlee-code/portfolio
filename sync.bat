@echo off
:: Set character encoding to UTF-8 to support Chinese text in prompt
chcp 65001 > nul
echo ==========================================
echo       Casper Portfolio Sync Tool
echo ==========================================
echo.
echo 1. Staging all changes (git add .)...
git add .
echo.
echo 2. Enter a description of your updates (Commit Message).
echo (If you leave it blank, it will default to: "update portfolio content")
set /p commit_msg="Description: "
if "%commit_msg%"=="" set commit_msg=update portfolio content
echo.
echo 3. Committing changes...
git commit -m "%commit_msg%"
echo.
echo 4. Pushing changes to GitHub...
git push origin HEAD
echo.
echo ==========================================
echo  Sync completed! Your website is updated.
echo ==========================================
pause
