# Teoría de hilos y procesos livianos

La introducción de los hilos de ejecución (_threads_) responde a la necesidad de subdividir un proceso en múltiples hilos de control concurrentes para maximizar la eficiencia. Conceptualmente, un hilo representa la unidad básica de utilización de la CPU, compartiendo el espacio de direccionamiento y los recursos con sus hilos hermanos dentro del mismo proceso.

---

(11-hilos-1-sistema-operativo-vs-lenguaje)=

## 1.Sistema operativo vs. Lenguaje

La gestión de actividades simultáneas se articula en dos dimensiones independientes: la **concurrencia a nivel de infraestructura (sistema operativo)** mediante procesos, y la **concurrencia a nivel de abstracción (lenguaje)** mediante funciones, procedimientos o métodos. Su cruce determina cuatro modelos arquitectónicos:

|                    | **Lenguaje NO Concurrente**                                                                                                                             | **Lenguaje Concurrente**                                                                                                                               |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **NO Concurrente** | Monosaurio Monotarea: Esquemas primitivos (por ejemplo, MS-DOS). Un solo proceso corre en el sistema y ejecuta un único flujo de instrucciones lineal   | Concurrencia de Funciones: El sistema operativo ve una sola tarea, pero el entorno del lenguaje conmuta internamente entre múltiples rutinas lógicas   |
| **Concurrente**    | Concurrencia de Procesos: El sistema operativo planifica y conmuta entre múltiples procesos independientes, pero cada programa internamente es monohilo | Multihilo Moderno: Coexiste la multiprogramación del sistema con la capacidad nativa de las aplicaciones de bifurcarse en múltiples hilos concurrentes |

---

(11-hilos-2-concepto-de-proceso-liviano-lightweight-process)=

## 2. Concepto de proceso liviado (_lightweight process_)

Los hilos se denominan formalmente **procesos livianos** porque rompen la pesada carga asociada a la gestión de procesos independientes. Esta denominación es idónea cuando cada hilo realiza una actividad diferenciada dentro de la aplicación.

(11-hilos-2-1-ventajas-operativas-de-los-hilos-frente-a-los-procesos)=

### 2.1. Ventajas operativas de los hilos frente a los procesos

- **Velocidad de ciclo de vida**: El tiempo requerido para instanciar (crear) o destruir (eliminar) un hilo es significativamente menor que el de un proceso completo.
- **Conmutación eficiente**: El tiempo de conmutación de contexto entre hilos hermanos es drásticamente inferior, ya que no exige modificar las tablas de páginas de la MMU ni validar las jerarquías de memoria caché.
- **Simplicidad de intercambio**: Compartir información entre procesos exige complejos mecanismos de _IPC_ (como memoria compartida o pasaje de mensajes), mientras que los hilos acceden nativamente a las mismas variables globales dentro del espacio virtual del proceso.

---

(11-hilos-3-arquitectura-de-hilos-a-nivel-de-usuario-user-level-threads-ult)=

## 3. Arquitectura de hilos a nivel de usuario (_User-Level Threads - ULT_)

En el modelo _ULT_, toda la gestión de los hilos se realiza en el espacio de usuario mediante una biblioteca de hilos (_runtime library_) provista por el lenguaje. El kernel del sistema operativo ignora la existencia de los hilos; solo planifica el proceso contenedor como una única unidad monohilo.

(11-hilos-3-1-balance-de-los-user-level-threads)=

### 3.1. Balance de los User-Level Threads

| **Ventajas Académicas**                                                                                                                                                                  | **Desventajas Críticas**                                                                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Sin cambio de modo**: La creación, sincronización y conmutación de hilos se realiza mediante llamadas locales a la biblioteca, sin necesidad de ingresar al Modo Kernel del procesador | **Efecto Bloqueo Cascada**: Si un hilo ejecuta una llamada al sistema bloqueante (por ejemplo, lectura de disco), el sistema operativo bloquea al proceso completo, suspendiendo en cadena a todos los demás hilos hermanos del usuario |
| **Planificación a medida**: Es posible implementar algoritmos de planificación distintos (_scheduling_) adaptados específicamente a las necesidades de cada aplicación                   | **Incapacidad Multiprocesador**: Al mapearse todo el proceso sobre un único hilo del kernel, los hilos no pueden aprovechar la presencia de múltiples procesadores físicos para correr en paralelo real                                 |
| **Portabilidad Absoluta**: No se requiere ninguna adaptación o reconfiguración del código al migrar la aplicación a otra plataforma de hardware o sistema operativo                      | **Equidad Comprometida**: La prioridad ante el planificador del sistema operativo se asigna al proceso; por ende, todos los hilos comparten la misma prioridad global                                                                   |

```{admonition} Mecanismo de mitigación de bloqueos
---
class: hint
---
El bloqueo puede originarse por la duración de la operación o porque el recurso está bajo el uso exclusivo de otro proceso. Para evitar que una llamada bloqueante detenga a todo el proceso, las bibliotecas modernas interceptan las llamadas mediante funciones _wrapper_ no bloqueantes (_jacketing_), convirtiendo el bloqueo del sistema en un bloqueo local controlado a nivel de procedimiento.
```

(11-hilos-4-estructuras-de-control-internas-pcb-y-propiedad-de-recursos)=

## 4. Estructuras de control internas: PCB y propiedad de recursos

La transición hacia sistemas multihilo transforma la organización de las tablas internas del kernel:

```{mermaid}
flowchart LR
  A[Proceso Monohilo] --> B
  B(Posee un único PCB)
  C[Proceso Multihilo] --> D
  D(Mantiene un PCB base y sub-PCBs individuales por cada hilo)
```

(11-hilos-4-distribucion-y-dominio-de-recursos)=

- **Recursos propiedad del proceso (administrados por el sistema operativo)**: Los descriptores de periféricos de uso exclusivo, la lista de archivos abiertos, las conexiones de red y los buffers asociados a cada archivo pertenecen al **proceso contenedor**. Si un hilo abre un archivo, sus hilos hermanos tienen acceso inmediato a él.
- **Recursos propiedad del hilo (administrados por el lenguaje)**: El espacio de memoria dinámica de datos, los registros de trabajo de la CPU (salvados en su bloque de control), la pila (_stack_) local para variables locales y el contador de programa (_PC_) pertenecen de forma exclusiva a **cada hilo individual**.

En arquitecturas de hilos nativos del kernel (_Kernel-Level Threads - KLT_), el sistema operativo se ve obligado a mantener y planificar una **estructura de control o _PCB_ independiente por cada hilo individual vivo en el sistema**.

---

(11-hilos-5-modelos-de-ejecucion-modernos-y-maquinas-virtuales)=

## 5. Modelos de ejecución modernos y máquinas virtuales

La evolución de las plataformas de desarrollo alteró los modelos de ejecución simplificados de los procesos monohilo clásicos, impactando en la forma en que los hilos consumen memoria y CPU:

(11-hilos-5-1-lenguajes-tipo-algol)=

### 5.1. Lenguajes tipo Algol (C, C++, Java, Rust, Go, etc.)

Históricamente compilados a código binario, su modelo de ejecución actual se vio profundamente modificado por dos innovaciones tecnológicas:

1. **La adopción generalizada de máquinas virtuales**: Entornos como la **_JVM_ (_Java Virtual Machine_)** o plataformas modernas como **WebAssembly** actúan como una capa intermedia de abstracción de hardware.
2. **Compilación _JIT_ (_Just-In-Time_)**: El entorno de ejecución traduce dinámicamente bloques de bytecode a instrucciones de máquina nativas "en caliente", haciendo variable el consumo de memoria.

(11-hilos-5-2-lenguajes-dinamicos)=

### 5.2. Lenguajes dinámicos (Python, Ruby, PHP, JavaScript, etc.)

El esquema primitivo basado en un intérprete puro conectado a una tabla de símbolos en software quedó obsoleto. La inmensa amyormayoría de las plataformas modernas emularon la estrategia de los lenguajes tipo Algol, **adoptando el uso de máquinas virtuales dedicadas** que procesan código intermedio:

- **Intérpretes de bytecode avanzados**: Arquitecturas como CPython, PHP4 y Ruby 1.9 traducen el código fuente a bytecode propio antes de su ejecución secuencial.
- **Compiladores _Ahead-Of-Time_ (_AOT_)**: Herramientas como las variantes de Visual Basic que compilan por completo la lógica antes de la ejecución.
- **Esquemas híbridos (intérprete + compilación _JIT_)**: Motores avanzados como Jython o PHP7 que combinan la flexibilidad interpretada con la potencia de compiladores _JIT_ en tiempo de ejecución para optimizar los bucles y la ejecución de hilos.
