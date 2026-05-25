# Sistemas distribuidos y arquitecturas en red

A finales de la década de 1960, surgieron las primeras iniciativas de comunicación intercomputadora con el objetivo central de **compartir recursos de computación** entre diversas instituciones académicas y de investigación. Los hitos fundacionales más destacados fueron la red **ARPANET** en los Estados Unidos y la red **CYCLADES** en Francia.

La principal ruptura paradigmática e innovación de estos proyectos consistió en **concebir un esquema de comunicaciones basado estrictamente en el concepto de red, evitando deliberadamente la existencia de un sistema centralizado**. A partir de este concepto de conectividad, se estructuraron diversas metodologías para compartir recursos, siendo las tres más importantes:

1. Sistemas cliente-servidor.
2. Clusters de computadores.
3. Sistemas operativos distribuidos puros.

---

(15-sistemas-distribuidos-1-el-modo-cliente-servidor)=

## 1. El modelo cliente-servidor

Un sistema cliente-servidor constituye un entorno distribuido compuesto por un conjunto de nodos clientes y unos pocos nodos servidores vinculados lógicamente a través de una red de datos.

(15-sistemas-distribuidos-1-1-propiedades-de-la-arquitectura)=

### 1.1. Propiedades de la arquitectura

- **Especialización**: Cada servidor atiende y resuelve un tipo de servicio específico (por ejemplo, servidor de archivos, servidor de impresión, servidor de bases de datos).
- **Escalabilidad**: Presenta una alta flexibilidad para agregar o remover nodos clientes de la red de forma simplificada sin alterar el funcionamiento global.
- **Heterogeneidad de sistemas**: Los sistemas operativos de las estaciones cliente y de los servidores **pueden diferir completamente entre sí** (por ejemplo, clientes corriendo Windows e interactuando con servidores Linux), así como tambien pueden diferir los sistemas operativos de los servidores entre ellos.
- **Centralización de información**: Existe una fuerte tendencia del diseño a centralizar el almacenamiento de los datos en los servidores para garantizar auditoría y consistencia.
- **Topologías de carga de trabajo**: Dependiendo de dónde resida la lógica de negocio, se distinguen tres modelos operativos:
  - **Procesamiento centralizado en el servidor**: El cliente es un terminal bobo que solo renderiza datos.
  - **Procesamiento centralizado en el cliente**: El servidor solo provee datos crudos y el cliente realiza el cómputo pesado.
  - **Procesamiento compartido**: Cooperación distribuida equilibrada entre ambos nodos.

(15-sistemas-distribuidos-1-2-mecanismos-de-comunicacion-internodo)=

### 1.2. Mecanismos de comunicación internodo

1. **Intercambio de mensajes**: Los clientes y servidores se comunican mediante primitivas de bajo nivel donde, de acuerdo con la lógica de sincronización del diseño, **los mensajes pueden configurarse como bloqueantes o no bloqueantes**.
2. **Invocación remota de procedimientos (_RPC - Remote Procedure Call_)**: Es un mecanismo de abstracción de alto nivel.
   - **Para el invocador (cliente)**: La llamada remota se presenta de forma transparente, comportándose de forma **muy similar a la invocación de un procedimiento local** en memoria.
   - **Para el invocado (servidor)**: La llegada de la petición puede significar e involucrar la instanciación y **ejecución de un nuevo proceso** independiente dentro de su propio entorno.
   - **Propiedades de enlace (binding)**: La ligadura lógica entre el invocante y el invocado puede ser **transitoria o permanente**, e instrumentarse bajo esquemas de sincronización **bloqueantes o no bloqueantes**.

---

(15-sistemas-distribuidos-2-arquitectura-de-clusters-de-computadores)=

## 2. Arquitectura de clusters de computadores

Un **cluster** es un conjunto de computadores independientes interconectados mediante una red de alta velocidad, caracterizados por el hecho de que **el rol de cada uno de ellos en la realización de cualquier actividad es completamente intercambiable**.

Estructuralmente, cada computador del cluster actúa individualmente como un servidor, pero el cluster, concebido como un todo unificado, actúa ante el mundo exterior como un único servidor gigante, **creando la ilusión de tratarse de un solo computador con una enorme capacidad de procesamiento**. La clave absoluta de su funcionamiento radica en un **apropiado balance de la carga de trabajo** entre todos sus nodos.

(15-sistemas-distribuidos-2-1-clasificacion-de-procesos-segun-su-perfil-de-e-s)=

### 2.1. Clasificación de procesos según su perfil de $E/S$

La visibilidad del almacenamiento en un cluster condiciona su rendimiento y tolerancia a fallas:

- **Procesos con abundante uso de discos ($E/S$ intensiva)**: Presentan serias dificultades técnicas para realizar copias de estado dinámicas (_checkpoints_). Obligan a que la arquitectura física del cluster prevea e incorpore **bancos de discos compartidos**, típicamente basados en esquemas de almacenamiento redundante tipo **RAID**.
- **Procesos con escaso uso de discos (cómputo intensivo)**: Facilitan notoriamente la ejecución y captura de _checkpoints_ de software. Al no requerir bancos de discos compartidos complejos, se consolidan como los **procesos ideales para ser ejecutados en clusters de computadores**.

---

(15-sistemas-distribuidos-3-balance-de-carga-y-tolerancia-a-fallos)=

## 3. Balance de carga y tolerancia a fallos

Los clusters proveen una **alta disponibilidad** de servicio, asegurando que la pérdida física de un computador no provoque la caída de ninguna prestación, sino únicamente una degradación menor en la capacidad de cómputo global del sistema.

Para gestionar las peticiones se implementan dos filosofías de distribución:

- **Distribución manual (por usuario)**: El propio usuario evalúa y decide a qué computadora específica envía el trabajo, lo que le impone la responsabilidad de conocer de antemano el estado de carga detallado de cada uno.
- **Distribución centralizada (por gestor)**: El cluster ofrece un **único punto de entrada** para todas las peticiones externas. Uno de los computadores del arreglo asume el rol de **gestor de la distribución de la carga**, enviando una señal de interrogación (ping/heartbeat) de forma periódica a cada nodo para censar su estado. Si un nodo no responde, se lo declara fuera de servicio y su carga se deriva automáticamente a los nodos sanos.

(15-sistemas-distribuidos-3-1-protocolos-de-respaldo-ante-la-perdida-del-gestor)=

### 3.1. Protocolos de respaldo ante la pérdida del gestor

Dado que el nodo gestor representa un punto único de fallo (_Single Point of Failure_), su pérdida se administra mediante tres estrategias de redundancia de hardware:

| **Estrategia de respaldo** | **Mecánica operativa de sincronización y arbitraje**                                                                                                                                                                                                                                                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Cold Standby**           | El nodo de respaldo permanece pasivo. Si el computador en cold standby deja de recibir la interrogación periódica del gestor principal, toma la iniciativa e interroga él mismo a todos los computadores del cluster. Si los nodos confirman unánimemente que no fueron interrogados por el gestor original, el cold standby toma el control y saca de servicio al gestor fallido          |
| **Hot Standby**            | Tanto el gestor activo como el nodo en hot standby interrogan activamente y en paralelo a todo el cluster. Si los computadores informan que no reciben señales del servidor principal, el hot standby asume el control inmediato. Si, por el contrario, los nodos informan que el hot standby no los está interrogando, el gestor principal degrada y saca de servicio al nodo en standby  |
| **Votación**               | Se dispone del gestor principal y dos computadores adicionales en estado de standby interrogando simultáneamente al cluster. Si se produce una divergencia, el sistema aplica un algoritmo de consenso: si dos de ellos coinciden en la interpretación de la respuesta de la red y el tercero disiente, este último es considerado defectuoso y se lo saca de servicio de forma automática |

(15-sistemas-distribuidos-4-mecanica-de-migracion-de-procesos)=

## 4. Mecánica de migración de procesos

Para equilibrar dinámicamente la carga, el sistema operativo del cluster tiene que poseer la capacidad de remover un proceso "en caliente" de una máquina saturada y enviarlo a otra máquina con menor nivel de uso.

(15-sistemas-distribuidos-4-1-el-mecanismo-de-punto-de-control)=

### 4.1. El mecanismo de punto de control (_check-point_)

Para que la migración sea viable, el sistema operativo tiene que ejecutar de forma periódica un _check-point_. Esto consiste en realizar una copia exacta y estructurada del estado de ejecución del proceso, guardando:

- El bloque de control de proceso (**_PCB_**).
- Los contenidos de todos los **buffers** de datos activos.
- La totalidad de las **páginas de memoria** virtuales asociadas al proceso que fueron enviadas al disco.
- El estado de los _mailboxes_ de mensajes en uso por el proceso.

(15-sistemas-distribuidos-4-2-responsabilidad-en-la-toma-de-decisiones)=

### 4.2. Responsabilidad en la toma de decisiones

La gobernanza de la migración está estrictamente delimitada entre el software del nodo local y el gestor global del cluster:

- **¿Quién decide que un proceso tiene que ser enviado a otra máquina?** Es una **responsabilidad compartida**. El sistema operativo del nodo local detecta internamente un uso excesivo y crítico de su CPU, mientras que el nodo gestor del cluster posee la visión macro y sabe qué computadora de la red cuenta con baja carga de trabajo.
- **¿Quién decide qué proceso específico se va a migrar?** Es una **responsabilidad exclusiva del sistema operativo local**, ya que es el único que conoce la criticidad, dependencias de memoria y descriptores de los procesos que corren en su silicio.
- **¿Quién decide a qué computadora de destino se envía el proceso?** Es una **responsabilidad exclusiva del gestor del cluster**, basándose en sus métricas periódicas de balanceo.

(15-sistemas-distribuidos-4-3-estrategias-de-transferencia-de-memoria)=

### 4.3. Estrategias de transferencia de memoria

La migración exige transferir el espacio virtual de memoria del proceso hacia el nodo destino utilizando cinco políticas de optimización de red:

1. **Eager (total)**: Se congela el proceso y se transmite la totalidad del espacio de memoria a la máquina destino antes de permitir que reinicie la ejecución. Es segura pero introduce una alta latencia inicial.
2. **Precopia**:  El proceso continúa ejecutándose en el nodo origen mientras se transmite su memoria en segundo plano. Las páginas que se modifican durante la transmisión se vuelven a copiar en rondas sucesivas hasta congelar y transferir el remanente mínimo.
3. **Eager de páginas sucias**: Se asume que el grueso de las páginas limpias ya reside o es accesible en almacenamiento común, transmitiendo de forma prioritaria únicamente aquellas páginas que fueron modificadas (sucias) por el proceso.
4. **Por demanda**: El proceso se inicia inmediatamente en el computador de destino con cero páginas asignadas en su RAM local. A medida que el procesador ejecuta instrucciones, la MMU genera fallos de páginas (_page faults_) que se resuelven trayendo las páginas bajo demanda a través de la red desde el computador de origen.
5. **Vaciado a disco**: El proceso se suspende, se realiza un volcado completo de su estado persistente a un disco del banco compartido, y el nodo de destino levanta el proceso leyendo directamente desde dicho soporte físico común.

---

(15-sistemas-distribuidos-5-paralelismo-en-entornos-distribuidos)=

## 5. Paralelismo en entornos distribuidos

Todas las leyes y consideraciones analizadas previamente en la materia respecto del **paralelismo por partición de datos** o por **partición de código (control)** aplican idénticamente a la ejecución de programas distribuidos a lo largo de los diversos computadores de un cluster.

La diferencia fundamental estriba en que el **grado de acoplamiento físico e interconexión entre las computadoras de un cluster es notoriamente más bajo** en comparación con el acoplamiento ultra fuerte de los buses internos y cachés L3 compartidas de una arquitectura _multicore_ tradicional, lo que eleva el costo de comunicación de los mensajes e influye en el diseño de los algoritmos de software distribuidos.
