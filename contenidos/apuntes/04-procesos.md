# Teoría de procesos

En el ámbito de los sistemas operativos modernos, un **proceso** se define formalmente como una unidad de actividad caracterizada por la ejecución de una secuencia de instrucciones, un estado actual y un conjunto de recursos del sistema asociados.

---

(04-procesos-1-taxonomia-de-los-procesos-segun-su-interaccion)=

## 1. Taxonomía de los procesos según su interacción

La forma en que los procesos conviven en el sistema determina las responsabilidades y mecanismos que el kernel tiene que desplegar:

(04-procesos-1-1-procesos-independientes)=

### 1.1. Procesos independientes

Son aquellos que ejecutan sus tareas de forma totalmente aislada. **No comparten absolutamente nada** (ni datos en memoria, ni recursos físicos de $E/S$).

- **Competencia**: Solo compiten de forma genérica por la asignación de tiempo de CPU y por el espacio en la memoria central.
- **Responsabilidad del sistema operativo**: Intercala de forma eficiente la ejecución de los mismos a través del planificador de corto plazo para simular simultaneidad.

(04-procesos-1-3-procesos-relacionados)=

### 1.2. Procesos relacionados

Son procesos que, todavía siendo lógicamente independientes en su flujo de datos, **comparten algún dispositivo externo o recurso físico** del computador (como una impresora, una unidad de cinta magnética o sectores de un disco duro compartido).

- **Responsabilidad del sistema operativo**: Además de intercalar su ejecución, tiene que definir e instrumentar **políticas de asignación y arbitraje** por los recursos físicos compartidos. Nace la obligación mandatoria de implementar algoritmos de prevención o detección de **bloques mutuos (_deadlocks_)**.

(04-procesos-1-3-procesos-colaborativos)=

### 1.3. Procesos colaborativos

Son procesos diseñados explícitamente para trabajar en conjunto hacia un fin común. **Comparten datos** y presentan una fuerte dependencia temporal: frecuentemente, un proceso tiene que suspender su ejecución a la espera de que otro proceso genera y le provea cierta información.

- **Responsabilidad del sistema operativo**: Reúne todas las obligaciones de las categorías anteriores y le agrega la exigencia crítica de **proveer mecanismos formales de comunicación de interprocesos (_IPC - Inter-Process Communication_)**, tales como una memoria compartida, tuberías (_pipes_), pasaje de mensajes o semáforos a nivel de sistema.

---

(04-procesos-2-el-bloque-de-control-de-procesos-pcb-process-control-block)=

## 2. El bloque de control de procesos (_PCB - Process Control Block_)

Para poder gestionar lso procesos, el sistema operativo mantiene una estructura de datos estricta por cada proceso vivo en el sistema, denominada **PCB**. El PCB es el reflejo del proceso en el kernel y contiene la siguiente información mínima:

- **Identificador (_PID_)**: Un número único que distingue al proceso de todos los demás.
- **Prioridad**: El nivel de precedencia asignado para los algoritmos de planificación.
- **Información de memoria**: Punteros a las tablas de páginas o segmentos que delimitan el espacio de direccionamiento del proceso.
- **Límites**: Indicadores de los límites de memoria asignados para garantizar la protección del sistema.
- **Estado actual**: El estado en el que se encuentra el proceso (Listo, Ejecutando, Bloqueado, etc.).
- **Contador de programa (_PC - Program Counter_)**: La dirección de la próxima instrucción que el proceso tiene que ejecutar cuando recupere la CPU.
- **Registros de la CPU**: Copia de todos los registros de hardware del procesador (acumuladores, índices, punteros de pila) salvados durante el último cambio de contexto.
- **Información de $E/S$**: Lista de archivos abiertos, dispositivos de $E/S$ asignados y peticiones de transferencia pendientes.
- **Estadísticas de control**: Tiempo de CPU acumulado, tiempo de creación, consumo de recursos para auditoría y facturación.

---

(04-procesos-3-evolucion-de-los-modelos-de-estados-de-los-procesos)=

## 3. Evolución de los modelos de estados de los procesos

Durante su ciclo de vida, un proceso transita por diferentes estados de forma dinámica. La cantidad de estados que un kernel discrimina está ligada directamente a la complejidad de las estructuras de datos que maneja y a los servicios que provee.

(04-procesos-3-1-modelo-primitivo-de-dos-estados)=

### 3.1. Modelo primitivo de dos estados

Es el esquema más simple, donde un proceso solo puede estar en dos condiciones: **Ejecutando** (en control de la CPU) o **No Ejecutando** (Detenido). Para gestionarlo, el kernel administra:

- Una lista única de procesos detenidos explicitando el motivo.
- Una lista de pedidos de uso exclusivo por cada recurso no compartible.
- Una lista de operaciones pendientes asociadas a cada proceso que las guarda.

(04-procesos-3-2-modelo-academico-de-cinco-estados)=

### 3.2. Modelo académico de cinco estados

La limitación del modelo de dos estados es que la lista de "No Ejecutando" mezcla procesos que están listos para correr con aquellos que están esperando un periférico lento. El modelo de cinco estados resuelve esto separándolos:

(04-procesos-3-2-1-matriz-de-transicion-de-cinco-estados)=

#### 3.2.1. Matriz de transición de cinco estados

| Estado Origen | Obtención de Recursos | Selección (Despacho) | Postergación (Desalojo) | Pedido de Servicio | Atención de Servicio | Fin de Ejecución |
| ------------- | --------------------- | -------------------- | ----------------------- | ------------------ | -------------------- | ---------------- |
| Comienzo      | Listo                 |                      |                         |                    |                      |                  |
| Listo         |                       | Ejecución            |                         |                    |                      |                  |
| Ejecución     |                       |                      | Listo                   | Bloqueado          |                      | Finalizado       |
| Bloqueado     |                       |                      |                         |                    | Listo                |                  |
| Finalizado    |                       |                      |                         |                    |                      |                  |

(04-procesos-3-2-2-analisis-mecanico-de-las-transiciones-criticas)=

#### 3.2.2. Análisis mecánico de las transiciones críticas

- **Selección (Listo $\rightarrow$ Ejecución)**: El planificador de corto plazo exige un proceso de la cola de listos para ocupar la CPU.
  - **En sistemas batch**: Ocurre únicamente cuando el proceso actual termina o solicita una $E/S$ de forma voluntaria.
  - **En sistemas de tiempo compartido**: Ocurre además cuando expira el cuanto de tiempo asignado al proceso de ejecución.
- **Postergación (Ejecución $\rightarrow$ Listo)**: El proceso es desalojado de la CPU de forma involuntaria.
  - **En sistemas batch**: Se dispara si concluye la operación de $E/S$ de un proceso suspendido que posee **mayor prioridad** que el actual en ejecución.
  - **En sistemas de tiempo compartido**: Se genera de forma mandatoria por la interrupción del timer al **agotarse la ventana de tiempo (_quantum_) otorgada**.

---

(04-procesos-4-analisis-de-rendimiento-y-trazas-de-planificacion)=

## 4. Análisis de rendimiento y trazas de planificación

Para comprender cómo impactan los algoritmos de planificación y la naturaleza de las tareas en la eficiencia global de la CPU, se analizan las trazas de ejecución.

(04-procesos-4-1-planificacion-rigida-batch-monolitica)=

### 4.1. Planificación rígida (batch/monolítica)

Se considera una traza temporal de 19 unidades de tiempo con 4 procesos, donde la CPU asigna ráfagas fijas prolongadas (típico de sistemas batch antiguos).

- `X`: Existente.
- `C`: Comienzo.
- `L`: Listo.
- `E`: Ejecución.
- `B`: Bloqueado.

| Proceso | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   | 9   | 10  | 11  | 12  | 13  | 14  | 15  | 16  | 17  | 18  | 19  |
| ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P1      | X   | X   | X   | C   | L   | E   | E   | E   | B   | B   | B   | B   | B   | B   | B   | B   | B   | B   | E   |
| P2      | X   | X   | X   | X   | X   | X   | X   | C   | L   | E   | E   | E   | B   | B   | B   | B   | B   | B   | B   |
| P3      | C   | L   | E   | E   | E   | L   | L   | L   | E   | L   | L   | L   | E   | E   | E   | B   | B   | B   | B   |
| P4      | X   | C   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | E   | E   | B   | B   |
| Nulo    | E   | E   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | E   | L   |

(04-procesos-4-1-1-calculo-del-porcentaje-de-utilizacion-de-la-cpu)=

#### 4.1.1. Cálculo del porcentaje de utilización de la CPU

El proceso **Nulo** (o proceso ocioso/idle) toma el control del procesador únicamente cuando no existe ningún proceso de usuario en estado **Listo**. Evaluando la fila del proceso **Nulo**, vemos que la CPU estuvo ociosa en los instantes $1$, $2$ y $18$ (3 unidades de tiempo de un total de 19).

$$
\text{Utilización de CPU } = (1 - \frac{\text{Tiempo Nulo}}{\text{Tiempo Total}}) \cdot 100 = (1 - \frac{3}{19}) \cdot 100 \approx 84.21 \%
$$

(04-procesos-4-2-introduccion-de-hilos-threads-y-ventanas-flexibles)=

### 4.2. Introducción de hilos (_threads_) y ventanas flexibles

Al implementar **hilos de ejecución** dentro de un mismo proceso o aplicar **mecanismos combinados** (como la creación de rondas diferenciadas por prioridad o la extensión dinámica de la ventana de tiempo), se logra una alternancia mucho más fina y adaptativa:

| Proceso | 1   | 2   | 3   | 4   | 5   | 6   | 7   | 8   | 9   | 10  | 11  | 12  | 13  | 14  | 15  | 16  | 17  | 18  | 19  |
| ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P1      | X   | X   | X   | C   | L   | E   | E   | L   | E   | L   | L   | E   | B   | B   | B   | B   | B   | B   | B   |
| P2      | X   | X   | X   | X   | X   | X   | X   | C   | L   | E   | L   | L   | E   | L   | E   | B   | B   | B   | B   |
| P3      | C   | L   | E   | L   | E   | L   | L   | E   | L   | L   | E   | L   | L   | E   | E   | E   | L   | E   | B   |
| P4      | X   | C   | L   | E   | L   | E   | B   | B   | B   | B   | B   | B   | B   | B   | B   | B   | E   | L   | E   |
| Nulo    | E   | E   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   | L   |

(04-procesos-4-2-1-calculo-del-nuevo-rendimiento)=

#### 4.2.1 Cálculo del nuevo rendimiento

En esta configuración optimizada, la CPU solo cae en el proceso **Nulo** durante las unidades de tiempo $1$ y $2$.

$$
\text{Utilización de CPU } = (1 - \frac{2}{19}) \cdot 100 \approx 89.47 \%
$$

---

```{admonition} Conclusión
---
class: hint
---
La granularidad fina de los hilos y la flexibilidad en las ráfagas reducen drásticamente el tiempo muerto del procesador, elevando la eficiencia global del sistema.
```

---

(04-procesos-5-el-mecanismo-de-intercambio-swapping-y-el-modelo-de-siete-estados)=

## 5. El mecanismo de intercambio (_swapping_) y el modelo de siete estados

A pesar de las optimizaciones intrínsecas del tiempo compartido, cuando los procesos cargados en memoria solicitan operaciones de $E/S$ masivas, tienden a bloquearse en cadena, provocando que la utilización de la CPU se desplome.

- **El problema**: Para elevar el rendimiento es imperativo aumentar el **grado de multiprogramación** (introducir más procesos al sistema). Sin embargo, la memoria RAM física es finita y suele estar completamente saturada.
- **La solución (_swapping_)**: El kernel desaloja físicamente de la memoria RAM aquellos procesos que se encuentran en estado bloqueado y los transfiere temporalmente a un área de almacenamiento secundario en disco (área de intercambio o _swap_), liberando espacio para cargar procesos que sí están listos para ejecutar.

(04-procesos-5-1-necesidad-del-modelo-de-siete-estados)=

### 5.1. Necesidad del modelo de siete estados

El fenómeno de mover procesos al disco obliga a romper el modelo clásico de 5 estados, dado que ahora el kernel tiene que discriminar si un proceso cuenta con residencia en la RAM o si está suspendido en el disco. Se introducen dos estados adicionales:

1. **Listo y Suspendido (Casi Listo)**: El proceso tiene todas las condiciones para ejecutar, pero **carece de memoria física** por haber sido movido al disco.
2. **Bloqueado y Suspendido**: El proceso está esperando un evento de $E/S$ y, además, fue desalojado de la memoria RAM hacia el disco.

(04-procesos-6-mecanica-de-entrada-al-modo-privilegiado-del-cpu)=

## 6. Mecánica de entrada al Modo Privilegiado del CPU

El **Modo Privilegiado** (Modo Kernel o Supervisor) es una propiedad nativa del hardware del procesador que le otorga al software que se ejecuta bajo dicho estado la potestad de invocar instrucciones privilegiadas y acceder a recursos físicos e internos totalmente invisibles e inaccesibles para las aplicaciones comunes de usuario.

- **Regla de seguridad de hardware**: Un programa de usuario **no puede mutar su estado a Modo Privilegiado mediante una instrucción directa de salto o asignación**. No existe una instrucción de ingreso voluntaria y directa.
- **Mecanismo de salida**: El kernel si dispone de instrucciones de hardware explícitas para degradar el estado del procesador de Modo Privilegiado a Modo Usuario antes de cederle el control a una aplicación.

(04-procesos-6-1-vias-de-ingreso-al-modo-privilegiado)=

### 6.1. Vías de ingreso al Modo Privilegiado

El procesador solo conmuta al Modo Privilegiado ante la ocurrencia de tres vectores de interrupción de hardware específicos:

1. **Pedido de servicio (llamada al sistema/_system call_)**: Es un acto deliberado e intencional del proceso de usuario. Se ejecuta mediante instrucciones especiales de software (como `INT#21H` en entornos históricos o arquitecturas x86, o llamadas mediante vectores específicos). Al dispararse, los registros del procesador tienen que contener los códigos del servicio solicitado y los parámetros requeridos para su ejecución.
2. **Trap (excepción por programa)**: Un hecho síncrono provocado por un error grave en la instrucción actual del proceso de usuario (como una división por cero o un fallo de página). Obliga al hardware a transferir el control a la rutina de manejo de excepciones del kernel en modo privilegiado.
3. **Interrupción de hardware (periféricos o timer)**: Un suceso completamente asíncrono, externo y ajeno a la instrucción que la CPU está procesando en ese instante preciso. Fuerza el resguardo de contexto inmediato y salta a la ISR del sistema operativo bajo el esquema de máxima jerarquía de privilegios.
