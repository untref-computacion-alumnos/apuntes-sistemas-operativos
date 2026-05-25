# Sistemas Operativos - Final Regular - 21/02/2025

(final-regular-2025-02-21-ejercicio-1)=

## Ejercicio 1

Es conocido que el principio de localidad permite asignar a un programa solo unas pocas páginas de memoria real en cada momento en lugar de asignar memoria a todo el programa.

- ¿El principio de localidad es beneficioso, perjudicial o instrascendente para la memoria caché?
- ¿Qué ocurre con la cantidad de filas del _TLB_ (_Translation Lookaside Buffer_)?
- ¿Hay algún otro componente del sistema operativo o de la arquitectura de soporte que podría ser beneficiado o perjudicado por el principio de localidad?

(final-regular-2025-02-21-ejercicio-2)=

## Ejercicio 2

Comparar los semáforos de un sistema operativo de tiempo compartido con los semáforos de un sistema de tiempo real.

¿Son iguales o difieren en algo? Si son iguales, justificar. Si son diferentes, explicar la diferencia.

(final-regular-2025-02-21-ejercicio-3)=

## Ejercicio 3

Considerar la necesidad de compartir una biblioteca entre varios procesos.

- ¿Cómo se puede lograr eso en un sistema operativo basado en particiones fijas?
- ¿Cómo se lo puede hacer en un sistema operativo basado en expansión de memoria mediante paginado?

(final-regular-2025-02-21-ejercicio-4)=

## Ejercicio 4

Considerar las siguientes formas de ingreso al Modo Privilegiado en un sistema operativo de tiempo compartido:

1. Interrupción de la propia CPU.
2. Interrupción de un timer.
3. Interrupción de un dispositivo externo.

- ¿Cuáles son las posibles causas de esas interrupciones?
- ¿Qué acciones tomará el sistema operativo en cada caso?

(final-regular-2025-02-21-ejercicio-5)=

## Ejercicio 5

Considerar el algoritmo de prevención de abrazos mortales denominado **avoidance**.

¿En qué tipo de situaciones podría aplicarse? Justificar.
