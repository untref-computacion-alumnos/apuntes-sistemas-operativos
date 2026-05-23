# Trabajo Práctico 5

(trabajo-practico-5-ejercicio-1)=

## Ejercicio 1

Se tiene un disco que gira a 3000 revoluciones por minuto. En la zona media, este disco tiene 5040 sectores de 4096 bytes cada uno.

¿Cuáles serán los números que se asignan a los veinte primeros sectores físicos de esa pista, sabiendo que el controlador necesita como máximo 25 microsegundos para procesar el sector anterior?

### Resolución Ejercicio 1

3000 rpm -> 50 rps -> 20 mseg por vuelta

cada sector, 1 sector tarda en pasar (o pasa frente a la cabeza) 20 mseg/5040 sectores = 2 mseg/504 sectores = aprox 4 microsegundos por sector

durante el procesamiento pasan 6 sectores

último sector 5040/7 = 720 - 1 = 719

(trabajo-practico-5-ejercicio-2)=

## Ejercicio 2

En el mismo disco del {ref}`trabajo-practico-5-ejercicio-1`.

¿Qué ocurre si el disco gira a 6000 revoluciones por minuto?

(trabajo-practico-5-ejercicio-3)=

## Ejercicio 3

¿Cuál es la capacidad de un disco que posee la siguiente cantidad de sectores de 4096 bytes que se indica?
