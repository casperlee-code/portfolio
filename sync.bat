@echo off
:: Set character encoding to UTF-8 to support Chinese text in prompt
chcp 65001 > nul
echo ==========================================
echo       Casper Portfolio Sync Tool
echo ==========================================
echo.
echo [1/4] Staging and committing source code...
git add .
set /p commit_msg="Enter update description (or Enter for default): "
if "%commit_msg%"=="" set commit_msg=update portfolio content
git commit -m "%commit_msg%"

echo.
echo [2/4] Pushing source code to GitHub (master branch)...
git push origin HEAD:master

echo.
echo [3/4] Building the website (npm run build)...
call npm run build

echo.
echo [4/4] Deploying static website to GitHub Pages (gh-pages branch)...
cd dist
if exist .git rmdir /s /q .git
git init
git config user.name "Casper Lee"
git config user.email "Casper.lee.family@gmail.com"
git add .
git commit -m "Deploy: rebuild portfolio"
git remote add origin https://github.com/casperlee-code/portfolio.git
git push origin HEAD:gh-pages --force
cd ..

echo.
echo ==========================================
echo  Sync completed! Your website is updated.
echo  Live site: https://casperlee-code.github.io/portfolio/
echo ==========================================
pause
