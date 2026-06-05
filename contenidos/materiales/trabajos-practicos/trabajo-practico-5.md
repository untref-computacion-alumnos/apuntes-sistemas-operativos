# Trabajo Práctico 5

(trabajo-practico-5-ejercicio-1)=

## Ejercicio 1

Se tiene un disco que gira a $3000 \text{ RPM}$. En la zona media, este disco tiene $5040$ sectores de $4096 \text{ B}$ cada uno.

¿Cuáles serán los números que se asignan a los veinte primeros sectores físicos de esa pista, sabiendo que el controlador necesita como máximo 25 microsegundos para procesar el sector anterior?

(trabajo-practico-5-ejercicio-2)=

## Ejercicio 2

En el mismo disco del {ref}`trabajo-practico-5-ejercicio-1`.

¿Qué ocurre si el disco gira a $6000 \text{ RPM}$?

(trabajo-practico-5-ejercicio-3)=

## Ejercicio 3

¿Cuál es la capacidad de un disco que posee la siguiente cantidad de sectores de $4096 \text{ B}$ que se indica?

- Pistas $0$ a $131071 \rightarrow 12540 \text{ sectores}$
- Pistas $131072$ a $196607 \rightarrow 12080 \text{ sectores}$
- Pistas $196608$ a $327679 \rightarrow 12900 \text{ sectores}$

(trabajo-practico-5-ejercicio-4)=

## Ejercicio 4

Se tiene un archivo de clientes, en el que cada cliente ocupa $712 \text{ B}$. Este archivo se encuentra ubicado en un disco cuyas pistas poseen $3296$ sectores de $512 \text{ B}$ cada uno. Este disco está organizado utilizando clusters de $4096 \text{ B}$. Se sabe además que en cada cluster se pueden almacenar $1024$ índices. Los archivos se ubican a partir de sector 0 de la pista 2. En el directorio se indica que el índice de este archivo está ubicado en el cluster 55304. A su vez, este cluster contiene los siguientes números de clusters: 63145, 120223, 48313, 110301, 71333, 71334 y 39405.

1. Realizar un esquema que muestre en qué pistas y en qué sector de esas pistas se encuentran ubicados los siete clusters del archivo y el cluster de índices.
2. ¿Cuál es el número de cliente más alto que puede almacenarse en forma completa en esta situación?

(trabajo-practico-5-ejercicio-5)=

## Ejercicio 5

En el contexto del archivo del {ref}`trabajo-practico-5-ejercicio-4`, existe un proceso que necesita acceder a los clientes 8, 26, 19 y 38, en ese orden. Se sabe que al comienzo de la ejecución la cabeza lecto-grabadora está ubicada en la pista correspondiente al cliente 13. Se debe tener en cuenta que cada vez que se accede a un cluster nuevo se debe leer el cluster donde están almacenados los índices y que el tiempo de _seek_ es de $5 \text{ ms}$.

¿Cuánto se tarda en acceder a los 4 clientes indicados?

(trabajo-practico-5-ejercicio-6)=

## Ejercicio 6

Después de una compactación el archivo del {ref}`trabajo-practico-5-ejercicio-5` queda reubicado de la siguiente forma:

- Cluster de índices: 42111
- Contenido del cluster de índices: 42112, 42113, 42114, 42115, 42116 y 42117.

¿Cuánto tarda ahora para acceder a los 4 clientes indicados?

(trabajo-practico-5-ejercicio-7)=

## Ejercicio 7

Considerar un disco que recibe la siguiente secuencia de pedidos:

```txt
35, 33, 44, 98, 99, 43, 120, 40, 41, 42, 60
0, 10, 30, 40, 80, 90, 92, 95, 110, 160, 162
```

en los tiempos indicados.

Se sabe que este disco tiene un tiempo de _seek_ entre dos pistas contiguas de $2 \text{ ms}$, un tiempo de _seek_ entre pistas lejanas de $12 \text{ ms}$ y un tiempo de retorno rápido a pista de $0 \text{ ms}$ a $10 \text{ ms}$.

Comparar las estrategias _FIFO_, _SSTF_, _CLOCK_ y _SCAN_ suponiendo que a tiempo $0$ se encuentra en la pista $100$.

(trabajo-practico-5-ejercicio-8)=

## Ejercicio 8

Considerar los siguientes datos, sabiendo que los mismos están codificados utilizando el código de Hamming. ¿Qué se puede decir de ellos?

1. 68
2. 65
3. 64

(trabajo-practico-5-ejercicio-9)=

## Ejercicio 9

Se tiene un esquema _RAID_ 3 con 7 discos. Al leer un archivo ocurre que el primer sector del mismo, en el disco 2 resulta ilegible. Si el primer byte de los discos 1, 3, 4, 5 y 6 contienen las siguientes letras:

- Disco 1: E
- Disco 2: ?
- Disco 3: s
- Disco 4: n
- Disco 5: f
- Disco 6: b

Y el disco 7 contiene el valor E3.

¿Qué contenía el primer byte del Disco 2?

(trabajo-practico-5-ejercicio-10)=

## Ejercicio 10

Considerar la estrategia de gestión de bloques del sistema operativo Linux, suponiendo que se está utilizando un disco de $2 \text{ TB}$ con clusters de $64 \text{ KB}$.

¿Cuál será el tamaño mínimo de un archivo para que sea necesario utilizar una referencia de dos niveles?

(trabajo-practico-5-ejercicio-11)=

## Ejercicio 11

Si en un disco en el que los sectores son de $4 \text{ KB}$ y cada cluster contiene 8 sectores.

¿Cuál es el espacio libre en los primeros 80 clusters, si en el mapa de bits de clusters ocupados se indica con un 0 los clusters libres?

FF FE AO DF F7 FF 9C F0 5F FD
