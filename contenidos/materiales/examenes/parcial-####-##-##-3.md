# Sistemas Operativos - Parcial - ##/##/####

(parcial-anio-mes-dia-3-ejercicio-1)=

## Ejercicio 1

Se tiene un sistema operativo con una memoria virtual de $8 \text{ TB}$ con una memoria real de $4 \text{ GB}$ y páginas de $32 \text{ KB}$, donde cada dirección corresponde a un byte. Se sabe que a la dirección virtual `14F800B6F13` le corresponde a la dirección real `4B13EF13`.

¿Qué valores se encuentran almacenados en la entrada del _TLB_ correspondiente a esta página?

(parcial-anio-mes-dia-3-ejercicio-2)=

## Ejercicio 2

Considerar un computador que posee un BUS con 16 líneas de direcciones y 48 líneas de datos, en el que cada dirección se refiere a una palabra de $48 \text{ b}$. El sistema operativo ocupa $48 \text{ KB}$ y se encuentra ubicado en las direcciones más bajas. En el mismo se instaló memoria hasta la dirección `CFFF`. En este computador existe un sistema operativo basado en particiones dinámicas, las que pueden ser de $24 \text{ KB}$, $48 \text{ KB}$, $72 \text{ KB}$, $96 \text{ KB}$ o $120 \text{ KB}$. En este computador comienza la ejecución de los siguientes procesos:

- **P1**: $55 \text{ KB}$.
- **P2**: $90 \text{ KB}$.
- **P3**: $20 \text{ KB}$.
- **P4**: $42 \text{ KB}$.
- **P5**: $88 \text{ KB}$.
- **P6**: $60 \text{ KB}$.

Suponiendo que el orden en que se solicita la ejecución de esos procesos es el indicado.

¿Cuáles procesos pueden comenzar a ejecutarse inicialmente?

(parcial-anio-mes-dia-3-ejercicio-3)=

## Ejercicio 3

En un computador con segmentos externos, la unidad de gestión de memoria, posee $5 \text{ b}$ que sumados a los bits más significativos de la dirección emitida por la CPU permite acceder a todas las direcciones internas del segmento. Sabiendo además que en el computador se instalaron $256 \text{ KB}$ de memoria y que cada dirección es de $16 \text{ b}$.

- ¿Cuál es el tamaño mínimo de un segmento?
- ¿Cuál es la cantidad máxima de procesos que se pueden ejecutar concurrentemente, sabiendo que uno de los segmentos está reservado al sistema operativo?

(parcial-anio-mes-dia-3-ejercicio-4)=

## Ejercicio 4

En el mismo contexto del {ref}`parcial-anio-mes-dia-3-ejercicio-1`, se tiene que este computador posee una memoria el cual posee bloques de $8 \text{ B}$ y 256 líneas.

- ¿Qué se encuentra almacenado en la línea que está almacenado el bloque correspondiente a la dirección indicada?
- ¿A qué direcciones de la memoria real corresponden el byte 0 y el byte 7 de la línea almacenada?

(parcial-anio-mes-dia-3-ejercicio-5)=

## Ejercicio 5

Se tiene un archivo de productos, en el que cada registro lógico ocupa $1031 \text{ B}$. Este archivo se encuentra ubicado en un disco cuyas pistas poseen 3296 sectores de $412 \text{ B}$ cada uno. A su vez, este disco está organizado utilizando clusters de $4096 \text{ B}$. Se sabe además que en cada cluster se pueden almacenar 1024 índices. En el directorio se indica que el índice de este archivo está ubicado en el cluster 31202. A su vez, este cluster contiene los siguientes números de clusters; 41213, 41214, 41215, 18333, 18334 y 22141.

- ¿En qué pistas y en qué sectores se encuentran ubicados en los primeros 6 clusters de este archivo?
- ¿Cuál es el cliente más alto que puede almacenarse en forma completa?
