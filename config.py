import psycopg2
from psycopg2 import sql, errors

# Configuración de la base de datos
DB_CONFIG = {
    'dbname': 'reserva_asiento',
    'user': 'postgres',
    'password': 'event123',
    'host': 'localhost',
    'port': '5432'
}

def get_connection(isolation_level=None):
    conn = psycopg2.connect(**DB_CONFIG)
    if isolation_level:
        conn.set_isolation_level(isolation_level)
    return conn

def initialize_database():
    """Ejecuta los scripts SQL para crear la estructura inicial"""
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            # Eliminar tablas si existen (en orden inverso por dependencias)
            cursor.execute("DROP TABLE IF EXISTS Reserva_detalle;")
            cursor.execute("DROP TABLE IF EXISTS Reserva;")
            cursor.execute("DROP TABLE IF EXISTS Asiento;")
            cursor.execute("DROP TABLE IF EXISTS Usuario;")
            cursor.execute("DROP TABLE IF EXISTS Evento;")
            cursor.execute("DROP TABLE IF EXISTS Ubicacion;")
            
            # Ejecutar DDL
            with open('database/ddl.sql', 'r') as f:
                cursor.execute(f.read())
            # Ejecutar datos de prueba
            with open('database/data.sql', 'r') as f:
                cursor.execute(f.read())
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()