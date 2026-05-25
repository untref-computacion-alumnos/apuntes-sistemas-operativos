# Sistemas Operativos - Final Regular - 13/12/2019

(final-regular-2019-12-13-ejercicio-1)=

## Ejercicio 1

Considerar las administraciones de discos redundantes denominadas _RAID_.

- ¿Quién es responsable de fragmentar los bytes y/o de calcular la paridad o el código de Hamming?
- ¿De qué manera se ven afectadas las aplicaciones?
- ¿En qué se ve afectada la tabla de espacio libre o los directorios?

(final-regular-2019-12-13-ejercicio-2)=

## Ejercicio 2

Se suele afirmar que la gestión de CPU para sistemas operativos de **tiempo compartido** es más eficiente que la gestión tipo **_batch_**, aún en un contexto de aplicaciones _batch_.

¿Es cierto eso? Si la respuesta es afirmativa, indicar por qué. Si la respuesta es negativa, mostrar un ejemplo en el que no se cumple.

(final-regular-2019-12-13-ejercicio-3)=

## Ejercicio 3

En algunas combinaciones de computador y sistema operativo se tiene que los procesos siempre se tienen que esperar unos a otros, tanto en lo que se refiere al uso del procesador como para cualquier entrada/salida, mientras que en otras combinaciones esto solo sucede con el procesador y finalmente existe un tercer grupo de combinaciones en el que las esperas son mucho menos frecuentes.

¿En qué se diferencian estas tres situaciones? Justificar.

(final-regular-2019-12-13-ejercicio-4)=

## Ejercicio 4

¿Puede ocurrir que una aplicación concurrente se ejecute en un sistema operativo no concurrente? Si la respuesta es afirmativa, explicar cómo se logra eso. Si la respuesta es negativa, indicar cuál es el impedimento.

(final-regular-2019-12-13-ejercicio-5)=

## Ejercicio 5

Explicar por qué las instrucciones del tipo `LOCK CMPXCHG FLAG, CX`, de la línea **Pentium**, permiten sincronizar dos procesos concurrentes que comparten algún recurso.

¿Qué tipo de recurso podría ser protegido mediante esta instrucción?
