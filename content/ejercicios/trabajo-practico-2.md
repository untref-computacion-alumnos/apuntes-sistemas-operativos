# Trabajo Práctico 2

| Proceso | CPU | E/S | CPU | E/S | CPU | E/S | CPU | E/S | Total CPU | Total E/S | Total | % E/S |
| ------- | --- | --- | --- | --- | --- | --- | --- | --- | --------- | --------- | ----- | ----- |
| 1       | 6   | 40  | 6   | 28  | 6   | 16  | 6   | 32  |           |           |       |       |
| 2       | 6   | 20  | 2   | 10  | 4   | 12  | 8   | 10  |           |           |       |       |
| 3       | 4   | 10  | 2   | 16  | 2   | 10  | 2   | 10  |           |           |       |       |
| 4       | 8   | 12  | 4   | 14  | 6   | 10  | 10  | 20  |           |           |       |       |
| Total   |     |     |     |     |     |     |     |     |           |           |       |       |

| Proceso | CPU | E/S | CPU | E/S | CPU | E/S | CPU | E/S | Total CPU | Total E/S | Total | % E/S |
| ------- | --- | --- | --- | --- | --- | --- | --- | --- | --------- | --------- | ----- | ----- |
| 1       | 20  | 10  | 12  | 2   | 10  | 4   | 8   | 16  |           |           |       |       |
| 2       | 12  | 4   | 4   | 2   | 8   | 4   | 16  | 8   |           |           |       |       |
| 3       | 8   | 12  | 4   | 10  | 4   | 8   | 4   | 12  |           |           |       |       |
| 4       | 30  | 8   | 8   | 6   | 12  | 4   | 20  | 8   |           |           |       |       |
| Total   |     |     |     |     |     |     |     |     |           |           |       |       |

## Ejercicio 1

Con los datos de la primer tabla dibujar los hijos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando aquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es mayor

(medidos ambos en unidades de tiempo)

## Ejercicio 2

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando arquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es mayor

(medidos ambos en unidades de tiempo)

## Ejercicio 3

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando aquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es menor

(medidos ambos en unidades de tiempo)

## Ejercicio 4

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido. Utilizar una ventana de tiempo de cuatro
unidades.

## Ejercicio 5

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido. Utilizar una ventana de tiempo de ocho
unidades.

## Ejercicio 6

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido con una ventana de tiempo de cuatro
unidades, en el que los procesos 2 y 3 conforman una ronda con más prioridad que los procesos 1 y 4.

## Ejercicio 7

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido en el que los procesos 2 y 3 poseen una
ventana de tiempo de 8 unidades y los procesos 1 y 4 una ventana de tiempo de 4 unidades.
