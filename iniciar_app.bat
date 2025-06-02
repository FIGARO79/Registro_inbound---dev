@echo off
echo --- Iniciando Aplicacion Inbound con Waitress ---

REM --- Establecer el directorio de trabajo actual al del script ---
REM %~dp0 es la ruta de la carpeta donde se encuentra este archivo .bat
echo Cambiando al directorio del script: %~dp0
cd /d "%~dp0"
IF ERRORLEVEL 1 (
    echo ERROR: No se pudo cambiar al directorio del script.
    pause
    exit /b 1
)
echo Directorio de trabajo actual establecido a: %CD%

REM --- Activacion del Entorno Virtual (Recomendado) ---
set VENV_PATH=venv
echo Verificando entorno virtual en: %CD%\%VENV_PATH%

if exist "%VENV_PATH%\Scripts\activate.bat" (
    echo Activando entorno virtual...
    call "%VENV_PATH%\Scripts\activate.bat"
    IF ERRORLEVEL 1 (
        echo ADVERTENCIA: Fallo al activar el entorno virtual.
        echo             Asegurate de que Waitress y otras dependencias esten instaladas globalmente si continuas.
    ) else (
        echo Entorno virtual activado.
    )
) else (
    echo Advertencia: Entorno virtual no encontrado en '%CD%\%VENV_PATH%'.
    echo             Asegurate de que Waitress, Flask y otras dependencias (pandas, openpyxl, Flask-CORS)
    echo             esten instalados globalmente o en el PATH de Python, o crea un entorno virtual
    echo             llamado 'venv' en este directorio (%CD%) e instala los paquetes dentro de el.
)

echo.
echo --- Iniciando Servidor Backend con Waitress ---
REM Tu app.py ya maneja la inicializacion (DB, carpetas, CSVs de ejemplo) cuando es importado.
REM Asegurate de que 'app.py' define una instancia de Flask llamada 'app'.
REM Usamos 'python -m waitress' para mayor robustez.
REM --host 0.0.0.0 permite conexiones desde otras maquinas en la red.
REM --port=5000 define el puerto.
echo Ejecutando: python -m waitress --host 0.0.0.0 --port=5000 app:app
start "Backend Server (Waitress)" python -m waitress --host 0.0.0.0 --port=5000 app:app

echo.
echo Esperando unos segundos para que el servidor Waitress se inicie completamente...
REM Pausa de 3 segundos (puedes ajustar este tiempo)
timeout /t 3 /nobreak > nul

echo.
echo --- Abriendo Interfaz Web en el navegador ---
REM Abre la URL que sirve tu aplicacion Flask (inbound.html a traves de la ruta /Registro_inbound)
echo Abriendo http://localhost:5000/Registro_inbound
start http://localhost:5000/Registro_inbound

echo.
echo --- Proceso de inicio completado ---
echo El servidor backend (Waitress) deberia estar ejecutandose en su propia ventana.
echo La interfaz web deberia haberse abierto en tu navegador en la ruta /Registro_inbound.
echo.
echo Puedes cerrar esta ventana de script cuando desees.
echo El servidor Waitress seguira ejecutandose en su propia ventana hasta que la cierres manualmente.

REM Opcional: Manten esta ventana abierta hasta que se presione una tecla.
REM pause
