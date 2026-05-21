# Trabajo Práctico 1 Resuelto

## Ejercicio 1

Suponer que se está ejecutando en un computador en el que la CPU trabaja a 4 GHz, el BUS a 2 GHz y
la memoria tiene un tiempo de latencia de 80 nseg. Cumplido el cual puede transferir hasta 64 bytes
a la velocidad del bus. Suponer además que todo el programa reside en el cache, de manera que el
ciclo FETCH toma un ciclo de CPU, el ciclo DECODE toma otro ciclo de CPU y ciclo EXECUTE toma un
ciclo del BUS. En ese computador se desea ejecutar el siguiente loop de transferencia a disco.

```txt
              MOV R2, 1024      ;R2 = CANTIDAD DE BYTES
              MOV R1, DATOS     ;R1 = UBICACIÓN DE LOS DATOS
OTRO          OUT #17, (R1)     ;ESCRIBIR UN BYTE AL DISCO
              INC R1            ;APUNTAR AL DATO SIGUIENTE
              DEC R2            ;CONTAR EL DATO ENVIADO
              BNZ OTRO          ;A OCUPARSE DEL SIGUIENTE
```

¿Durante cuánto tiempo está ocupada la CPU?

### Resolución Ejercicio 1

#### 1. Parámetros del sistema

Primero se calcula la duración de los ciclos de reloj:

- **Ciclo de CPU ($T_{CPU}$)**: $\frac{1}{4} \ GHz = 0.25 \ ns$
- **Ciclo de BUS ($T_{BUS}$)**: $\frac{1}{2} \ GHz = 0.5 \ ns$
- **Latencia de memoria**: $80 \ ns$ (Este dato es importante para la carga inicial, pero el
  enunciado indica que el programa ya reside en el **cache**, por lo que se usan los tiempos de
  CPU/BUS para las instrucciones).

#### 2. Análisis de tiempos por instrucción

Según el enunciado, cada instrucción sigue este esquema de tiempos:

- **FETCH**: 1 ciclo de CPU ($0.25 \ ns$)
- **DECODE**: 1 ciclo de CPU ($0.25 \ ns$)
- **EXECUTE**: 1 ciclo de BUS ($0.5 \ ns$)
- **Total por instrucción**: $0.25 \ ns + 0.25 \ ns + 0.5 \ ns = 1 \ ns$

#### 3. Ejecución del programa

##### A. Instrucciones fuera del Loop (Setup)

Estas se ejecutan una sola vez al principio:

1. `MOV R2, 1024` ($1 \ ns$)
2. `MOV R1, DATOS` ($1 \ ns$)

**Subtotal Setup**: $2 \ ns$

##### B. Instrucciones dentro del loop (`OTRO`)

El bloque `OTRO` se repite **1024 veces** (una por cada byte, ya que el registro R2 se decrementa de
a uno y el salto es `BNZ`):

1. `OUT #17, (R1)`: $1 \ ns$
2. `INC R1`: $1 \ ns$
3. `DEC R2`: $1 \ ns$
4. `BNZ OTRO`: $1 \ ns$

**Total por iteración**: $4 \ ns$

#### 4. Cálculo del tiempo total de ocupación de CPU

La CPU está ocupada procesando instrucciones durante toda la ejecución del Loop. Dado que el
enunciado pregunta específicamente por el tiempo que la CPU está ocupada ejecutando este código:

$$
Tiempo = Tiempo_{Setup} + (Iteraciones \cdot Tiempo_{Loop})
$$

1. **Tiempo Setup**: $2 \ ns$
2. **Tiempo Loop**: $1024 \ iteraciones \cdot \frac{4 \ ns}{iteración} = 4096 \ ns$

**Tiempo total**: $2 \ ns + 4096 \ ns = 4098 \ ns$ (o $\frac{4098}{mus}$)

---

## Ejercicio 2

La misma CPU ejecuta el mismo loop, pero desafortunadamente, hay un inconveniente que impide la
traducción **DEC R2** resida en el cache, lo que obliga a traerla de memoria principal cada ciclo. Esta
traducción ocupa dos bytes.

¿Cuánto se ocupa ahora la CPU?

### Resolución Ejercicio 2

En este escenario, la instrucción `DEC R2` no está en la cache. Esto implica que en cada una de las
1024 iteraciones, la CPU debe esperar a la memoria principal.

#### 1. Análisis del nuevo tiempo de instrucción para `DEC R2`

Como la instrucción ocupa **2 bytes** y la memoria tiene una latencia de **$80 \ ns$**, el ciclo de FETCH
cambia drásticamente:

- **FETCH (Memoria)**: $80 \ ns \ (latencia) + tiempo \ de \ transferencia$.
  - **Nota**: Aunque la memoria transfiere hasta 64 bytes, acá solo se necesitan 2. Al ser a velocidad
    de BUS ($0.5 \ ns$ por ciclo), el tiempo de transferencia es despreciable frente a la latencia o
    se considera incluido en el tiempo que la memoria "entrega" el dato tras los $80 \ ns$.
- **DECODE**: $0.25 \ ns$ (1 ciclo CPU).
- **EXECUTE**: $0.5 \ ns$ (1 ciclo BUS).

**Total `DEC R2`**: $80 \ ns+ 0.25 \ ns+ 0.5 \ ns= 80.75 \ ns$

#### 2. Nuevo tiempo del Loop

1. `OUT #17, (R1)`: $1 \ ns$
2. `INC R1`: $1 \ ns$
3. `DEC R2`: $80.75 \ ns$
4. `BNZ OTRO`: $1 \ ns$

**Total por iteración**: $83.75 \ ns$

#### 3. Cálculo final

$$
Tiempo = 2 \ ns \ (Setup) + (1024 \cdot 83.75 \ ns) = 2 + 85760 = 85762 \ ns
$$

## Ejercicio 3

En la misma CPU se realiza la misma transferencia utilizando el DMA, mediante el programa:

```txt
MOV R1, 1024          ;R1 = CANTIDAD DE BYTES
OUT #45, R1           ;INDICAR AL DMA LA CANTIDAD
MOV R1, DATOS         ;R1 = UBICACIÓN DE LOS DATOS
OUT #46, R1           ;INDICAR AL DMA EL LUGAR
MOV R1, 0xFF          ;R1 = INDICACIÓN DE ESCRITURA
OUT #47, R1           ;ORDENAR LA ESCRITURA
```

Suponiendo que todo el programa reside en el cache.

¿Durante cuánto tiempo está ocupada la CPU?

### Resolución Ejercicio 3

Acá la CPU ya no transfiere los datos byte a byte. Solo se encarga de **configurar** el controlador de
DMA. Una vez dada la orden, la CPU queda libre.

#### Análisis de instrucciones (todas en Cache)

Cada una de las 6 instrucciones toma **$1 \ ns$** ($Fetch \ CPU + Decode \ CPU + Execute \ BUS$).

1. `MOV R1, 1024` ($1 \ ns$)
2. `OUT #45, R1` ($1 \ ns$) - Configura cuenta
3. `MOV R1, DATOS` ($1 \ ns$)
4. `OUT #46, R1` ($1 \ ns$) - Configura dirección
5. `MOV R1, 0xFF` ($1 \ ns$)
6. `OUT #47, R1` ($1 \ ns$) - Inicia operación

**Tiempo de ocupación de CPU**: $6 \ ns$

#### Conclusión

La CPU se libera casi instantáneamente para hacer otras tareas mientras el hardware de DMA trabaja
en paralelo.

## Ejercicio 4

Si la unidad de DMA transfiere ráfagas de 64 bytes y luego espera 1000 useg.

¿Cuánto tarda la transferencia antes de la próxima ráfaga?

### Resolución Ejercicio 4

Acá se calcula cuánto tarda el **hardware** en mover los datos (independientemente de la CPU). Se quiere
saber cuánto tarda en procesar 64 bytes (una ráfaga) y el tiempo total.

#### Tiempo por ráfaga (64 bytes)

- **Latencia inicial de memoria**: $80 \ ns$
- **Transferencia de 64 bytes**: Se transfieren a velocidad de bus ($2 \ GHz \rightarrow 0.5 \ ns$ por
  transferencia).
  - $64 \ bytes \cdot \frac{0.5 \ ns}{byte} = 32 \ ns$

**Tiempo total de una ráfaga**: $80 + 32 + 1000 = 1112 \ ns$

## Ejercicio 5

Comparar los resultados de los ejercicios 1, 2 y 4.

### Resolución Ejercicio 5

| Ejercicio | Método         | Tiempo total / Ocupación | Observaciones                                           |
| --------- | -------------- | ------------------------ | ------------------------------------------------------- |
| 1         | CPU (Cache)    | $4098 \ ns$              | La CPU está 100% dedicada a mover bytes                 |
| 2         | CPU (no Cache) | $85762 \ ns$             | El rendimiento cae ~20 veces por la latencia de memoria |
| 3         | Ocupación DMA  | $6 \ ns$                 | Ganador en eficiencia de CPU                            |
| 4         | Tiempo DMA     | $1112 \ ns$ por bloque   | El hardware es más rápido que el loop de software       |

#### Conclusiones

1. **Impacto en la Cache**: El ejercicio 2 demuestra que sin cache, la CPU desperdicia la mayor parte
   del tiempo esperando a la memoria (latencia).
2. **Ventaja del DMA**: Mientras que en el Ejercicio 1 la CPU está "secuestrada" por $4098 \ ns$, con
   DMA (Ejercicio 3) solo trabaja $6 \ ns$. Esto permite la **multiprogramación**: la CPU podría estar
   ejecutando otro proceso mientras el DMA transfiere.
3. **Velocidad de ráfaga**: El DMA no solo libera a la CPU, sino que al usar ráfagas (_burst mode_),
   aprovecha mejor el ancho de banda del bus que el acceso byte a byte del software.
