@echo off
echo --- Script de Instalacion de Dependencias de Python ---

REM --- Establecer el directorio de trabajo actual al del script ---
echo Cambiando al directorio del script: %~dp0
cd /d "%~dp0"
IF ERRORLEVEL 1 (
    echo ERROR: No se pudo cambiar al directorio del script.
    pause
    exit /b 1
)
echo Directorio de trabajo actual establecido a: %CD%

REM --- Verificar si Python esta instalado y en el PATH ---
python --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo.
    echo ERROR: Python no parece estar instalado o no esta en el PATH del sistema.
    echo        Por favor, instala Python (asegurandote de marcar "Add Python to PATH"
    echo        durante la instalacion) y vuelve a intentarlo.
    echo        Puedes descargarlo desde https://www.python.org/downloads/
    pause
    exit /b 1
)
echo Version de Python encontrada:
python --version

REM --- Opcional: Creacion y Activacion del Entorno Virtual ---
set VENV_PATH=venv
set CREATE_VENV=N

echo.
choice /C YN /M "Deseas crear/usar un entorno virtual llamado '%VENV_PATH%' para este proyecto? (S/N)"
IF ERRORLEVEL 2 set CREATE_VENV=N
IF ERRORLEVEL 1 set CREATE_VENV=Y

if "%CREATE_VENV%"=="Y" (
    if not exist "%VENV_PATH%\Scripts\activate.bat" (
        echo.
        echo Creando entorno virtual en '%CD%\%VENV_PATH%'...
        python -m venv %VENV_PATH%
        IF ERRORLEVEL 1 (
            echo ERROR: Fallo al crear el entorno virtual. Verifica tu instalacion de Python.
            pause
            exit /b 1
        )
        echo Entorno virtual creado.
    ) else (
        echo.
        echo Usando entorno virtual existente en '%CD%\%VENV_PATH%'.
    )

    echo.
    echo Activando entorno virtual...
    call "%VENV_PATH%\Scripts\activate.bat"
    IF ERRORLEVEL 1 (
        echo ERROR: Fallo al activar el entorno virtual.
        pause
        exit /b 1
    )
    echo Entorno virtual activado. (Deberias ver "(%VENV_PATH%)" al inicio del prompt si esta ventana se mantiene abierta)
) else (
    echo.
    echo Omitiendo creacion/activacion de entorno virtual. Se instalaran los paquetes globalmente o en el entorno activo.
    echo (ADVERTENCIA: Se recomienda usar entornos virtuales para proyectos de Python).
)

REM --- Verificar si requirements.txt existe ---
if not exist "requirements.txt" (
    echo.
    echo ERROR: El archivo 'requirements.txt' no se encontro en el directorio actual (%CD%).
    echo        Este archivo es necesario para saber que paquetes instalar.
    echo        Por favor, crea 'requirements.txt' en tu entorno de desarrollo ejecutando:
    echo        pip freeze ^> requirements.txt
    echo        (Asegurate de que tu entorno virtual de desarrollo este activado al hacerlo).
    if "%CREATE_VENV%"=="Y" (
        echo Desactivando entorno virtual antes de salir...
        call "%VENV_PATH%\Scripts\deactivate.bat"
    )
    pause
    exit /b 1
)

REM --- Instalacion de Paquetes ---
echo.
echo --- Iniciando Instalacion de Paquetes desde requirements.txt ---
pip install -r requirements.txt
IF ERRORLEVEL 1 (
    echo.
    echo ERROR: Ocurrio un problema durante la instalacion de los paquetes.
    echo        Revisa los mensajes de error de 'pip' arriba.
    echo        Asegurate de tener conexion a internet y de que 'pip' este funcionando correctamente.
    if "%CREATE_VENV%"=="Y" (
        echo Desactivando entorno virtual antes de salir...
        call "%VENV_PATH%\Scripts\deactivate.bat"
    )
    pause
    exit /b 1
)

echo.
echo --- Instalacion de Dependencias Completada Exitosamente ---

if "%CREATE_VENV%"=="Y" (
    echo.
    echo El entorno virtual '%VENV_PATH%' esta activado en esta ventana.
    echo Puedes cerrarla o ejecutar otros comandos aqui.
    echo Para desactivarlo manualmente en esta ventana, escribe: deactivate
)

echo.
echo Proceso finalizado.
pause
