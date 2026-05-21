# Trabajo Práctico 2 Resuelto

| **Proceso** | **CPU** | **E/S** | **CPU** | **E/S** | **CPU** | **E/S** | **CPU** | **E/S** | **Total CPU** | **Total E/S** | **Total** | **% E/S**      |
| ----------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------------- | ------------- | --------- | -------------- |
| **1**       | **6**   | **40**  | **6**   | **28**  | **6**   | **16**  | **6**   | **32**  | _24_          | _116_         | _140_     | _82.85714286%_ |
| **2**       | **6**   | **20**  | **2**   | **10**  | **4**   | **12**  | **8**   | **10**  | _20_          | _52_          | _72_      | _72.22222222%_ |
| **3**       | **4**   | **10**  | **2**   | **16**  | **2**   | **10**  | **2**   | **10**  | _10_          | _46_          | _56_      | _82.14285714%_ |
| **4**       | **8**   | **12**  | **4**   | **14**  | **6**   | **10**  | **10**  | **20**  | _28_          | _56_          | _84_      | _66.66666667%_ |
| **Total**   | _24_    | _82_    | _14_    | _68_    | _18_    | _48_    | _26_    | _72_    | _82_          | _270_         | _352_     | _76.70454545%_ |

| **Proceso** | **CPU** | **E/S** | **CPU** | **E/S** | **CPU** | **E/S** | **CPU** | **E/S** | **Total CPU** | **Total E/S** | **Total** | **% E/S**      |
| ----------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------------- | ------------- | --------- | -------------- |
| **1**       | **20**  | **10**  | **12**  | **2**   | **10**  | **4**   | **8**   | **16**  | _50_          | _32_          | _82_      | _39.02439024%_ |
| **2**       | **12**  | **4**   | **4**   | **2**   | **8**   | **4**   | **16**  | **8**   | _40_          | _18_          | _58_      | _13.79310345%_ |
| **3**       | **8**   | **12**  | **4**   | **10**  | **4**   | **8**   | **4**   | **12**  | _20_          | _42_          | _62_      | _67.74193548%_ |
| **4**       | **30**  | **8**   | **8**   | **6**   | **12**  | **4**   | **20**  | **8**   | _59_          | _26_          | _85_      | _30.58823529%_ |
| **Total**   | _70_    | _34_    | _28_    | _20_    | _34_    | _20_    | _48_    | _44_    | _169_         | _118_         | _287_     | _41.11498258%_ |

## Ejercicio 1

Con los datos de la primer tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando aquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es mayor

(medidos ambos en unidades de tiempo)

### Resolución Ejercicio 1

**Orden**:

$$
P4 = \frac{1}{2} = 0.5
$$

$$
P2 = \frac{5}{13} = 0.3846153846
$$

$$
P3 = \frac{5}{23} = 0.217391
$$

$$
P1 = \frac{6}{29} = 0.2068965517
$$

En un sistema Batch, un proceso no libera la CPU hasta que termina su ráfaga actual (en este caso,
se asume que corre el proceso completo hasta su fin o que respeta la secuencia CPU-E/S).

## Ejercicio 2

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando arquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es mayor

(medidos ambos en unidades de tiempo)

### Resolución Ejercicio 2

**Orden**:

$$
P4 = \frac{59}{26} = 2.269230769
$$

$$
P2 = \frac{20}{9} = 2.222222222
$$

$$
P1 = \frac{13}{8} = 1.625
$$

$$
P3 = \frac{10}{21} = 0.4761904762
$$

1. 0 a 70: P4 ocupa la CPU
2. 70 a 110: P2 ocupa la CPU
3. 110 a 160: P1 ocupa la CPU
4. 160 a 180: P3 ocupa la CPU

## Ejercicio 3

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo Batch, priorizando aquellos proyectos cuyo cociente:

Uso de CPU / Uso de E/S es menor

(medidos ambos en unidades de tiempo)

### Resolución Ejercicio 3

**Orden**:

$$
P3 = \frac{10}{21} = 0.4761904762
$$

$$
P1 = \frac{13}{8} = 1.625
$$

$$
P2 = \frac{20}{9} = 2.222222222
$$

$$
P4 = \frac{59}{26} = 2.269230769
$$

1. 0 a 20: P3 ocupa la CPU
2. 20 a 70: P1 ocupa la CPU
3. 70 a 110: P2 ocupa la CPU
4. 110 a 180: P4 ocupa la CPU

## Ejercicio 4

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido. Utilizar una ventana de tiempo de cuatro
unidades.

### Resolución Ejercicio 4

Se usa **Round Robin**. El orden de llegada es P1, P2, P3, P4.

- **$t = 0$**: P1 usa 4 (le restan 16 de su primera ráfaga de 20).
- **$t = 4$**: P2 usa 4 (le restan 8 de su ráfaga de 12).
- **$t = 8$**: P3 usa 4 (termina su ráfaga de 8 y pasa a E/S).
- **$t = 12$**: P4 usa 4 (le restan 26 de su ráfaga de 30).
- **$t = 16$**: Vuelve a P1... y así sucesivamente

## Ejercicio 5

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido. Utilizar una ventana de tiempo de ocho
unidades.

### Resolución Ejercicio 5

- **$t = 0$**: P1 usa 8, le restan 12.
- **$t = 8$**: P2 usa 8, le restan 4.
- **$t = 16$**: P3 usa 8, termina ráfaga de 8, va a E/S.
- **$t = 24$**: P4 usa 8, le restan 22.

## Ejercicio 6

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido con una ventana de tiempo de cuatro
unidades, en el que los procesos 2 y 3 conforman una ronda con más prioridad que los procesos 1 y 4.

### Resolución Ejercicio 6

- **Grupo alta prioridad**: $\{P2, P3\}$
- **Grupo baja prioridad**: $\{P1, P4\}$

El sistema no atiende a P1 o P4 mientras P2 o P3 estén listos para ejecutar.

1. P2 y P3 se intercalan (4 unidades cada uno) hasta que ambos pasen a E/S o terminen.
2. Solo cuando P2 y P3 están bloqueados en E/S, la CPU se le asigna a P1 y P4 (intercalados cada 4
   unidades).
3. Si P2 termina su E/S mientras P1 está en CPU, P1 es desalojado (preeemptive) para que entre P2.

## Ejercicio 7

Con los datos de la segunda tabla dibujar los hilos de ejecución de los cuatro procesos suponiendo
que se trata de un sistema operativo de tiempo compartido en el que los procesos 2 y 3 poseen una
ventana de tiempo de 8 unidades y los procesos 1 y 4 una ventana de tiempo de 4 unidades.

### Resolución Ejercicio 7

- P2, P3: $Q = 8$
- P1, P4: $Q = 4$

Se aplica Round Robin estándar, pero la duración del turno depende de quién entre:

1. Entra P1: corre 4 unidades
2. Entra P2: corre hasta 8 unidades
3. Entra P3: corre hasta 8 unidades
4. Entra P4: corre 4 unidades

Esto favorece a los procesos 2 y 3, dándoles más tiempo de CPU por cada vez que tienen el turno.
