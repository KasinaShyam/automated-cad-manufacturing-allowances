@echo off
setlocal
title CastingApp - ME222 IITG
echo.
echo =====================================================
echo   CastingApp  -  ME222 IITG
echo =====================================================
echo.

rem Resolve script directory
set SCRIPT_DIR=%~dp0

echo Attempting to use conda environment 'casting_app'...
set "CONDA_BAT="
if "%CONDA_BAT%"=="" if exist "%USERPROFILE%\anaconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\anaconda3\condabin\conda.bat"
if "%CONDA_BAT%"=="" if exist "%USERPROFILE%\miniconda3\condabin\conda.bat" set "CONDA_BAT=%USERPROFILE%\miniconda3\condabin\conda.bat"
if "%CONDA_BAT%"=="" if exist "%ProgramData%\Anaconda3\condabin\conda.bat" set "CONDA_BAT=%ProgramData%\Anaconda3\condabin\conda.bat"
if "%CONDA_BAT%"=="" if exist "%ProgramData%\Miniconda3\condabin\conda.bat" set "CONDA_BAT=%ProgramData%\Miniconda3\condabin\conda.bat"
if not "%CONDA_BAT%"=="" goto :UseConda
echo Conda not found. Trying to activate a local venv if present...
if exist "%SCRIPT_DIR%venv\Scripts\activate.bat" call "%SCRIPT_DIR%venv\Scripts\activate.bat"
if exist "%SCRIPT_DIR%.venv\Scripts\activate.bat" call "%SCRIPT_DIR%.venv\Scripts\activate.bat"
if errorlevel 1 echo No local venv found. Continuing with system Python (if available).
if errorlevel 1 echo To create a venv: python -m venv venv
set "USE_CONDA=0"
goto :EnvReady

:UseConda
set "USE_CONDA=1"

:EnvReady

echo Installing pip requirements (skips conda-only packages)...
if "%USE_CONDA%"=="1" call "%CONDA_BAT%" run -n casting_app python -m pip install --upgrade pip
if "%USE_CONDA%"=="1" call "%CONDA_BAT%" run -n casting_app python -m pip install -r "%SCRIPT_DIR%requirements.txt"
if "%USE_CONDA%"=="0" call python -m pip install --upgrade pip
if "%USE_CONDA%"=="0" call python -m pip install -r "%SCRIPT_DIR%requirements.txt"

echo Starting server...
echo The browser URL will be printed below.
echo.
set "BACKEND_DIR=%SCRIPT_DIR%backend"
set "APP_ENTRY=import os, runpy; os.chdir(r'%BACKEND_DIR%'); runpy.run_path('app.py', run_name='__main__')"
if "%USE_CONDA%"=="1" call "%CONDA_BAT%" run --no-capture-output -n casting_app python -c "%APP_ENTRY%"
if "%USE_CONDA%"=="0" pushd "%BACKEND_DIR%"
if "%USE_CONDA%"=="0" call python app.py
if "%USE_CONDA%"=="0" popd
pause
endlocal
