# Trabajo Práctico 1 Resuelto

(trabajo-practico-1-resuelto-ejercicio-1)=

## Ejercicio 1

Suponer que se está ejecutando en un computador en el que la _CPU_ trabaja a $4 \text{ GHz}$, el BUS a $2 \text{ GHz}$ y la memoria tiene un tiempo de latencia de $80 \text{ ns}$. Cumplido el cual puede transferir hasta $64 \text{ B}$ a la velocidad del BUS. Suponer además que todo el programa reside en el caché, de manera que el ciclo **FETCH** toma un ciclo de _CPU_, el ciclo **DECODE** toma otro ciclo de _CPU_ y ciclo **EXECUTE** toma un ciclo del BUS. En ese computador se desea ejecutar el siguiente loop de transferencia a disco.

```txt
              MOV R2, 1024      ;R2 = CANTIDAD DE BYTES
              MOV R1, DATOS     ;R1 = UBICACIÓN DE LOS DATOS
OTRO          OUT #17, (R1)     ;ESCRIBIR UN BYTE AL DISCO
              INC R1            ;APUNTAR AL DATO SIGUIENTE
              DEC R2            ;CONTAR EL DATO ENVIADO
              BNZ OTRO          ;A OCUPARSE DEL SIGUIENTE
```

¿Durante cuánto tiempo está ocupada la _CPU_?

---

(trabajo-practico-1-resuelto-resolucion-ejercicio-1)=

### Resolución Ejercicio 1

#### Paso 1: Determinar el tiempo base de los ciclos

- **Frecuencia de CPU**: $4 \text{ GHz} \implies 1 \text{ ciclo de CPU} = \frac{1}{4 \cdot 1000000000} \cdot 10^{9} = 0.25 \text{ ns}$.
- **Frecuencia de BUS**: $2 \text{ GHz} \implies 1 \text{ ciclo de BUS} = \frac{1}{2 \cdot 1000000000} \cdot 10^{9} = 0.5$.

#### Paso 2: Calcular el tiempo de una instrucción en caché

Como todo el programa reside en la memoria caché, la _CPU_ no sufre retrasos por latencia de acceso a la memoria principal.

- **FETCH (1 ciclo de _CPU_)**: $0.25 \text{ ns}$.
- **DECODE (1 ciclo de _CPU_)**: $0.25 \text{ ns}$.
- **EXECUTE (1 ciclo de _CPU_)**: $0.5 \text{ ns}$.

Se suman los tiempos de los ciclos **FETCH**, **DECODE** y **EXECUTE**:

$$
0.25 \text{ ns} + 0.25 \text{ ns} + 0.5 \text{ ns} = 1.0 \text{ ns}
$$

- **Tiempo total por instrucción en caché**: $1.0 \text{ ns}$.

#### Paso 3: Calcular el tiempo de ejecución del código

El bucle transfiere $1024 \text{ B}$ usando $E/S$ programada, por lo que la _CPU_ se encarga de todo el proceso.

- **Inicialización**: $2$ instrucciones (`MOV R2...` y `MOV R1...`) $\implies 2.0 \cdot 1.0 \text{ ns} = 2.0 \text{ ns}$.
- **Loop**: 4 instrucciones por ciclo (`OUT`, `INC`, `DEC`, `BNZ`) iteradas $1024$ veces.
- **Tiempo del loop**: $1024 \cdot (4 \cdot 1.0 \text{ ns}) = 4096 \text{ ns}$.
- **Tiempo total de CPU ocupada**: $2.0 + 4096 = 4098 \text{ ns}$.

---

(trabajo-practico-1-resuelto-ejercicio-2)=

## Ejercicio 2

La misma _CPU_ ejecuta el mismo loop, pero desafortunadamente, hay un inconveniente que impide la traducción `DEC R2` resida en el caché, lo que obliga a traerla de memoria principal cada ciclo. Esta traducción ocupa $2 \text{ B}$.

¿Cuánto se ocupa ahora la _CPU_?

---

(trabajo-practico-1-resuelto-resolucion-ejercicio-2)=

### Resolución Ejercicio 2

En este escenario hay un fallo de caché constante para la instrucción `DEC R2` ($2 \text{ B}$), lo que obliga al hardware a solicitarla repetidamente desde la memoria física lenta.

#### Paso 1: Calcular el nuevo ciclo FETCH para `DEC R2`

- **Latencia de memoria obligatoria**: $80 \text{ ns}$.
- **Tiempo de transferencia**: Asumiendo que el BUS transfiere $1 \text{ B}$ por ciclo de BUS, transferir $2 \text{ B}$ tomaría $2 \cdot 0.5 \text{ ns}$ (asumiendo la velocidad del BUS como $1 \text{ B/ciclo}$).
- **Tiempo total del ciclo FETCH modificado**: $80 + 1.0 = 81 \text{ ns}$.

#### Paso 2: Calcular el tiempo total de la instrucción `DEC R2`

- **FETCH (desde memoria)**: $81 \text{ ns}$.
- **DECODE (en CPU)**: $0.25 \text{ ns}$.
- **EXECUTE (en BUS)**: $0.5 \text{ ns}$.

- **Tiempo total de `DEC R2`**: $81.75 \text{ ns}$.

#### Paso 3: Calcular el tiempo del programa modificado

- **Tiempo de las otras 3 instrucciones en caché**: $3.0 \text{ ns}$.
- **Tiempo del loop modificado**: $1024 \cdot (3.0 \text{ ns} + 81.75 \text{ ns}) = 1024 \cdot 84.75 = 86784 \text{ ns}$.
- **Tiempo total de CPU ocupada**: $2.0 \text{ ns (inicialización)} + 86784 \text{ ns} = 86786 \text{ ns}$.

---

(trabajo-practico-1-resuelto-ejercicio-3)=

## Ejercicio 3

En la misma _CPU_ se realiza la misma transferencia utilizando el _DMA_, mediante el programa:

```txt
MOV R1, 1024          ;R1 = CANTIDAD DE BYTES
OUT #45, R1           ;INDICAR AL DMA LA CANTIDAD
MOV R1, DATOS         ;R1 = UBICACIÓN DE LOS DATOS
OUT #46, R1           ;INDICAR AL DMA EL LUGAR
MOV R1, 0xFF          ;R1 = INDICACIÓN DE ESCRITURA
OUT #47, R1           ;ORDENAR LA ESCRITURA
```

Suponiendo que todo el programa reside en el caché.

¿Durante cuánto tiempo está ocupada la _CPU_?

---

(trabajo-practico-1-resuelto-resolucion-ejercicio-3)=

### Resolución Ejercicio 3

Al implementar el _DMA_, la _CPU_ ya no realiza el copiado de los datos _byte_ por _byte_, simplemente delegando la tarea al_DMAC_ y queda libre de la carga.

El programa ejecutado por la _CPU_ se limita exclusivamente a 6 instrucciones de configuración del dispositivo _DMA_. Sabiendo que el programa reside en caché, el cálculo es directo:

- **Tiempo total de CPU ocupada**: $6 \text{ instrucciones} \cdot 1.0 \text{ ns} = 6 \text{ ns}$.

Una vez pasados estos $6 \text{ ns}$, la transferencia continúa físicamente de forma autónoma sin intervención directa del _CPU_.

---
(trabajo-practico-1-resuelto-ejercicio-4)=

## Ejercicio 4

Si la unidad de _DMA_ transfiere ráfagas de $64 \text{ B}$ y luego espera $1000 \text{ ns}$.

¿Cuánto tarda la transferencia antes de la próxima ráfaga?

---

(trabajo-practico-1-resuelto-resolucion-ejercicio-4)=

### Resolución Ejercicio 4

Se analiza una "ráfaga" (_burst_) de transferencia desde el periférico utilizando el controlador _DMA_.

- **Latencia de memoria inicial**: $80 \text{ ns}$.
- **Transferencia de la ráfaga de $64 \text{ B}$ a velocidad del BUS ($64 \cdot 0.5 \text{ ns}$)**: $32 \text{ ns}$.
- **Tiempo neto que tarda la transferencia**: $80 + 32 = 112 \text{ ns}$.
- **Tiempo total del ciclo de ráfaga**: $112 \text{ ns} (\text{transferencia}) + 1000 \text{ ns} (\text{espera}) = 1112 \text{ ns}$.

---

(trabajo-practico-1-resuelto-ejercicio-5)=

## Ejercicio 5

Comparar los resultados del {ref}`trabajo-practico-1-ejercicio-1`, {ref}`trabajo-practico-1-ejercicio-2` y {ref}`trabajo-practico-1-ejercicio-4`.

---

(trabajo-practico-1-resuelto-resolucion-ejercicio-5)=

### Resolución Ejercicio 5

| Ejercicio | Método          | Tiempo total / Ocupación     | Observaciones                                     |
| --------- | --------------- | ---------------------------- | ------------------------------------------------- |
| 1         | _CPU_ con caché | $4098 \text{ ns}$            | La _CPU_ está 100% dedicada a mover bytes         |
| 2         | _CPU_ sin caché | $86786 \text{ ns}$           | El rendimiento  por la latencia de memoria        |
| 4         | _DMA_           | $1112 \text{ ns}$ por bloque | El hardware es más rápido que el loop de software |
