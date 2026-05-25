# Sistemas Operativos - Final Regular - 26/07/2025

(final-regular-2025-07-26-ejercicio-1)=

## Ejercicio 1

El problema de _thrashing_ o hiperpaginado es usualmente relacionado con la existencia de una cantidad excesiva de fallos de página.

- ¿Puede existir un fenómeno similar con el _TLB_?
- ¿Puede existir un fenómeno similar con el caché?

Si la respuesta es negativa, explicar por qué no es posible. Si la respuesta es positiva, indicar la importancia relativa de cada uno de ellos considerando las demoras que pueden producir.

(final-regular-2025-07-26-ejercicio-2)=

## Ejercicio 2

- ¿Por qué se abandonó la técnica de identificar la posición de una determinada información en los discos utilizando la técnica basada en cilindro, cabeza y sector?
- ¿Eso tiene algo que ver con el uso de clusters como unidad mínima de asignación de espacio?

Si ambos hechos están relacionados explicar cómo. Si no están relacionados, indicar también cuál es la razón que justifica el uso de clusters.

(final-regular-2025-07-26-ejercicio-3)=

## Ejercicio 3

¿Cómo logra el sistema operativo hacer que la unidad de gestión de memoria (_MMU_) sepa donde comienza y donde termina una partición en el contexto de partciciones dinámicas?

(final-regular-2025-07-26-ejercicio-4)=

## Ejercicio 4

¿La instrucción `compare and exchange(CMPXCHG)` es privilegiada o no?

Si la respuesta es afirmativa, explicar por qué se prohibe su uso por parte de las aplicaciones. Si la respuesta es negativa, explicar cómo es que la usa el sistema operativo para crear semáforos.

(final-regular-2025-07-26-ejercicio-5)=

## Ejercicio 5

Se suele afirmar que el algoritmo de prevención de abrazos mortales denominado _avoidance_ es aplicable en contextos de sistemas operativos _batch_, pero no en sistemas operativos de tiempo compartido.

¿Es cierto eso?

Si la respuesta es afirmativa, indicar por qué. Si la respuesta es negativa, indicar en qué casos se puede aplicar y en qué casos no.
