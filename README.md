# Sistema de Reservas Concurrente
Este proyecto simula un sistema de reservas de asientos para un evento, permitiendo probar concurrencia y manejo de transacciones en una base de datos PostgreSQL utilizando Python.

## ¿Qué hace?
- Simula múltiples usuarios intentando reservar asientos al mismo tiempo.
- Maneja bloqueos, concurrencia y transacciones con distintos niveles de aislamiento.
- Registra logs de intentos exitosos o fallidos de reserva.

## ¿Cómo ejecutarlo?
Clona el repositorio: https://github.com/AleWWH1104/Proyecto2_BD1.git 
Configura la conexión a la base de datos en el archivo config.py con tus credenciales 
Ejecutar: python sistema.py

## Tecnologías usadas
- Python 3
- PostgreSQL
- Librerías: psycopg2, threading, time, random
