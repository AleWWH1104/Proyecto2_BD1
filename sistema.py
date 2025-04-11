import threading
import time
import random
from datetime import datetime
from config import get_connection, initialize_database
import psycopg2
from psycopg2 import errors

# Configuración
EVENTO_ID = 1  # ID del evento de prueba
NUM_ASIENTOS = 20  # Total de asientos disponibles

class SistemaReservas:
    def __init__(self):
        self.lock = threading.Lock()
        self.log = []
        
    def registrar_evento(self, mensaje):
        with self.lock:
            timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
            log_entry = f"[{timestamp}] {mensaje}"
            self.log.append(log_entry)

    def reservar_asiento(self, user_id, isolation_level=None):
        conn = get_connection(isolation_level)
        asiento_id = random.randint(1, NUM_ASIENTOS)
        start_time = time.perf_counter()
        
        try:
            with conn.cursor() as cursor:
                conn.autocommit = False
                
                self.registrar_evento(f"Usuario {user_id} intentando reservar asiento {asiento_id}")
                
                # Verificar disponibilidad con bloqueo
                cursor.execute(
                    "SELECT estado FROM Asiento WHERE asiento_id = %s FOR UPDATE NOWAIT;",
                    (asiento_id,)
                )
                estado = cursor.fetchone()
                
                if not estado or estado[0] != 'disponible':
                    conn.rollback()
                    return {'status': 'failed', 'duration': time.perf_counter() - start_time}
                
                time.sleep(0.1)  # Pequeña pausa para simular procesamiento
                
                # Crear reserva
                cursor.execute(
                    "INSERT INTO Reserva (evento_id, usuario_id, estado) VALUES (%s, %s, 'confirmada');",
                    (EVENTO_ID, user_id)
                )
                
                # Actualizar asiento
                cursor.execute(
                    "UPDATE Asiento SET estado = 'reservado' WHERE asiento_id = %s;",
                    (asiento_id,)
                )
                
                conn.commit()
                return {'status': 'success', 'duration': time.perf_counter() - start_time}
                
        except (errors.SerializationFailure, errors.OperationalError) as e:
            conn.rollback()
            return {'status': 'failed', 'duration': time.perf_counter() - start_time}
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            conn.close()

def run_concurrency_test(num_users, isolation_level):
    sistema = SistemaReservas()
    
    # Resetear estado
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("TRUNCATE TABLE Reserva_detalle, Reserva RESTART IDENTITY CASCADE;")
            cursor.execute("UPDATE Asiento SET estado = 'disponible' WHERE evento_id = %s;", (EVENTO_ID,))
            conn.commit()
    finally:
        conn.close()
    
    resultados = []
    threads = []
    
    def worker(user_id):
        resultado = sistema.reservar_asiento(user_id, isolation_level)
        resultados.append(resultado)
    
    # Crear hilos
    for i in range(1, num_users + 1):
        thread = threading.Thread(target=worker, args=(i,))
        threads.append(thread)
        thread.start()
    
    # Esperar hilos
    for thread in threads:
        thread.join()
    
    # Calcular estadísticas
    exitosos = sum(1 for r in resultados if r['status'] == 'success')
    fallidos = num_users - exitosos
    
    # Calcular tiempo promedio (asegurando que todos tengan 'duration')
    tiempos = [r.get('duration', 0) for r in resultados]  # Usar get() con valor por defecto
    avg_time = (sum(tiempos) / len(tiempos)) * 1000  # en ms
    
    return {
        'Usuarios': num_users,
        'Nivel': isolation_level,
        'Exitosas': exitosos,
        'Fallidas': fallidos,
        'TiempoPromedio': f"{avg_time:.2f} ms",
        'Log': sistema.log
    }

def main():
    print("Inicializando base de datos...")
    initialize_database()
    
    tests = [
        (5, psycopg2.extensions.ISOLATION_LEVEL_READ_COMMITTED),
        (10, psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ),
        (20, psycopg2.extensions.ISOLATION_LEVEL_SERIALIZABLE),
        (30, psycopg2.extensions.ISOLATION_LEVEL_SERIALIZABLE)
    ]
    
    reporte_total = []
    
    print("\nIniciando pruebas de concurrencia...")
    for num_users, isolation_level in tests:
        resultado = run_concurrency_test(num_users, isolation_level)
        reporte_total.append(resultado)
        print(f"Completada prueba con {num_users} usuarios")
    
    # Mostrar resumen final
    print("\nRESULTADOS FINALES:")
    print("+" + "-"*63 + "+")
    print(f"| {'Usuarios':<8} | {'Nivel':<15} | {'Exitosas':<8} | {'Fallidas':<8} | {'Tiempo (ms)':<10} |")
    print("+" + "-"*63 + "+")
    
    nivel_names = {
        psycopg2.extensions.ISOLATION_LEVEL_READ_COMMITTED: "READ COMMITTED",
        psycopg2.extensions.ISOLATION_LEVEL_REPEATABLE_READ: "REPEATABLE READ",
        psycopg2.extensions.ISOLATION_LEVEL_SERIALIZABLE: "SERIALIZABLE"
    }
    
    for test in reporte_total:
        nivel = nivel_names.get(test['Nivel'], str(test['Nivel']))
        print(f"| {test['Usuarios']:<8} | {nivel:<15} | {test['Exitosas']:<8} | {test['Fallidas']:<8} | {test['TiempoPromedio']:<10} |")
    print("+" + "-"*63 + "+")
    
    # Guardar log completo
    with open('log_reservas.txt', 'w') as f:
        for test in reporte_total:
            f.write(f"\nPrueba con {test['Usuarios']} usuarios (Nivel: {nivel})\n")
            f.write("\n".join(test['Log']))
    
    print("\nDetalles completos guardados en 'log_reservas.txt'")

if __name__ == "__main__":
    main()