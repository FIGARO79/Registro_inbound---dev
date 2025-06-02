import os
import sqlite3
import pandas as pd

# --- Configuración de Archivos (Debe coincidir con app.py) ---
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
DATABASE_FOLDER = os.path.join(APP_ROOT, 'databases')
ITEM_MASTER_CSV_PATH = os.path.join(DATABASE_FOLDER, 'AURRSGLBD0250 - Item Stockroom Balance.csv')
GRN_CSV_FILE_PATH = os.path.join(DATABASE_FOLDER, 'AURRSGLBD0280 - Stock In Goods Inwards And Inspection.csv')
DB_FILE_PATH = os.path.join(APP_ROOT, 'inbound_log.db')
# --- Fin Configuración ---

def init_db():
    """Inicializa la base de datos SQLite y crea la tabla 'logs' si no existe."""
    try:
        # Crear la carpeta 'databases' si no existe (movido aquí)
        if not os.path.exists(DATABASE_FOLDER):
            os.makedirs(DATABASE_FOLDER)
            print(f"Carpeta creada: {DATABASE_FOLDER}")

        conn = sqlite3.connect(DB_FILE_PATH)
        cursor = conn.cursor()
        print(f"Conectado a la base de datos: {DB_FILE_PATH}")
        # Crear tabla si no existe
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp TEXT NOT NULL,
                importRef TEXT,
                waybill TEXT,
                itemCode TEXT,
                itemDescription TEXT,
                binLocation TEXT,
                relocatedBin TEXT,
                qtyReceived INTEGER,
                qtyGrn INTEGER,
                difference INTEGER
            )
        ''')
        print("Tabla 'logs' verificada/creada.")
        # Crear índice si no existe
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_importRef_itemCode ON logs (importRef, itemCode)")
        print("Índice 'idx_importRef_itemCode' verificado/creado.")
        conn.commit()
        conn.close()
        print(f"Base de datos SQLite inicializada correctamente.")
    except sqlite3.Error as e:
        print(f"Error al inicializar la base de datos SQLite: {e}")
    except Exception as e:
        print(f"Error general durante la inicialización de la BD: {e}")


def create_example_csvs():
    """Crea archivos CSV de ejemplo si no existen."""
    try:
        # Verificar/Crear archivo maestro CSV de ejemplo
        if not os.path.exists(ITEM_MASTER_CSV_PATH):
             print(f"ADVERTENCIA: Archivo maestro no encontrado. Creando ejemplo en: {ITEM_MASTER_CSV_PATH}")
             example_master_df = pd.DataFrame({
                 'Item_Code': ['BG1234567890123', 'FT9876543210987'],
                 'Item_Description': ['Maintenance Kit 1000h', 'Filtro de Aceite Modelo X'],
                 'Weight_per_Unit': ['10 kg', '2 kg'], 'Bin_1': ['RA25A', 'SB10C'],
                 'Aditional_Bin_Location': ['RA25A', 'SB10C, SB11A']
             })
             example_master_df.to_csv(ITEM_MASTER_CSV_PATH, index=False)
             print("Archivo maestro de ejemplo creado.")

        # Verificar/Crear archivo GRN CSV de ejemplo
        if not os.path.exists(GRN_CSV_FILE_PATH):
             print(f"ADVERTENCIA: Archivo GRN no encontrado. Creando ejemplo en: {GRN_CSV_FILE_PATH}")
             example_grn_df = pd.DataFrame({'Item_Code': ['BG1234567890123', 'FT9876543210987', 'ITEM_SIN_DETALLES'], 'Quantity': [1, 5, 10]})
             example_grn_df.to_csv(GRN_CSV_FILE_PATH, index=False)
             print("Archivo GRN de ejemplo creado.")
    except Exception as e:
        print(f"Error creando archivos CSV de ejemplo: {e}")

# --- Ejecución del Script de Setup ---
if __name__ == '__main__':
    print("--- Iniciando Configuración ---")
    # 1. Inicializar la base de datos (crea carpeta si es necesario)
    init_db()
    # 2. Crear archivos CSV de ejemplo si no existen (opcional)
    create_example_csvs()
    print("--- Configuración Completada ---")

