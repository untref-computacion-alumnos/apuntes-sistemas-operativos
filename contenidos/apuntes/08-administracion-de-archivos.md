# Subsistema de administración de archivos y almacenamiento secundario

El subsistema de administración de archivos es la capa del sistema operativo encargada de abstraer las complejidades del hardware de almacenamiento masivo, proveyendo al usuario una visión lógica y persistente de la información mediante archivos y directorios.

---

(08-administracion-de-arhcivos-1-taxonomia-de-perifericos-e-interfaces)=

## 1. Taxonomía de periféricos e interfaces

El sistema operativo clasifica los dispositivos periféricos según su interacción con el sistema y el entorno:

- **Con el ser humano (interfaz de usuario)**: Dispositivos que adaptan señales físicas a flujos lógicos interpretables. Por ejemplo, teclado, mouse, micrófono, pantalla, parlantes, impresoras, escáneres, etc.
- **De almacenamiento masivo**: Medios persistentes que resguardan el software y los datos del usuario. Incluye discos rígidos magnéticos (fijos o removibles), cintas magnéticas (abiertas o en cassette) y memorias flash.
- **De comunicación**: Dispositivos orientados a la interconexión de sistemas distribuidos, como placas Ethernet, módems e interfaces inalámbricas.
- **Con el mundo físico (sistemas de control/embebidos)**:
  - **Sensores**: Traducen variables analógicas o estados discretos mediante conversores analógico/digital (ADC) y entradas digitales.
  - **Actuadores**: Modifican el estado del mundo físico mediante conversores digital/analógico (DAC) y salidas digitales.

(08-administracion-de-arhcivos-1-1-tipos-de-interfaces-de-transferencia)=

### 1.1. Tipos de interfaces de transferencia

1. **Interfaz programada**: El procesador hace la transferencia operando con un volumen mínimo de datos (escasos bits) en cada instrucció (`IN`/`OUT`), lo que ata la CPU a la velocidad del periférico.
2. **Acceso directo a memoria (_DMA - Direct Memory Access_)**: Transferencia por bloques de datos de forma completamente asíncrona respecto de la CPU. La CPU solo interviene de forma programada al inicio para configurar el controlador y al final para atender la interrupción de cierre.

---

(08-administracion-de-arhcivos-2-fisica-y-geometria-del-disco-rigido-magnetico)=

## 2. Física y geometría del disco rígido magnético

El disco magnético rotante es un dispositivo electromecánico cuya geometría interna condiciona los tiempos de acceso del sistema operativo.

(08-administracion-de-arhcivos-2-1-parametros-fisicos-y-metricas-tipicas)=

### 2.1. Parámetros físicos y métricas típicas

- **Densidad de pistas**: $\approx 250000 \text{ pistas/pulgada}$, con una separación física de apenas $1\,\mu\text{m}$ ($10^{- 6} \ m$) entre ellas.
- **Geometría del plato (3.5 pulgadas)**: Posee un recorrido de cabezal útil de $1.2$ pulgadas, logrando albergar cerca de $300000$ pistas en una superficie útil de $8.5$ pulgadas cuadradas.
- **Capacidad de almacenamiento**: Con una densidad superficial de $1 \text{ TB/pulgada}$ cuadrada, se alcanza una capacidad de $1 \ TB$ por superficie de plato.
- **Estructura de la pista**: Una pista promedio almacena $4 \text{ MB}$ de datos distribuidos en $1024$ sectores ($1 \text{ Ksector}$).
- **Tamaño del sector**:
  - **Valor clásico**: $512 \ b$.
  - **Formato avanzado (_advanced format_)**: $4096 \text{ B}$ ($4 \text{ KB}$).
- **_Inter Record Gap (IRG)_**: Espacio de separación física de $\approx 500 \text{ B}$ entre sectores contiguos. Se utiliza para la identificación del sector y contiene los códigos de control de integridad: Código de Redundancia Cíclica (**_CRC_**) y Código de Corección de Errores (**_ECC_**).

(08-administracion-de-arhcivos-2-2-metricas-temporales-de-acceso)=

### 2.2. Métricas temporales de acceso

El tiempo total para leer o escribir un bloque en el disco se compone de tres variables de hardware:

1. **Tiempo de búsqueda (_seek time_)**: El tiempo que requiere el brazo mecánico para posicionar la cabeza lecto-grabadora sobre el cilindro o pista deseada.
   - Entre pistas contiguas: $0.2 \text{ ms}$ a $1 \text{ ms}$.
   - Saltos largos (extremos): $8 \text{ ms}$ a $12 \text{ ms}$.
   - Retorno mandatorio a pista cero: $15 \text{ ms}$ a $25 \text{ ms}$.
2. **Latencia rotacional (_rotational latency_)**: El tiempo necesario para que, una vez posicionado el cabezal en la pista, el plato gire hasta colocal el sector buscado debajo de la cabeza. Depende de las revoluciones por minuto (RPM) del motor:
   - A 3000 RPM (50 giros/s): Cada vuelta tarda $20 \text{ ms}$. La latencia media (media vuelta) es de $10 \text{ ms}$.
   - A 6000 RPM (100 giros/s): Cada vuelta tarda $10 \text{ ms}$. La latencia media es de $5 \text{ ms}$.
3. **Tiempo de transferencia**: El tiempo que toma pasar físicamente los bits desde la superficie magnética al controlador (depende de la densidad de la pista).

(08-administracion-de-arhcivos-2-3-evolucion-del-direccionamiento)=

### 2.3. Evolución del direccionamiento

- **Esquema _CHS_ (_Cylinder, Head, Sector_)**: Direccionamiento físico clásico donde el software indicaba el número exacto de Cilindro, Cabeza y Sector. El direccionamiento típico de $24 \text{ b}$ dividía los campos en $10 \text{ b}$ para cilindr ($1024$), $8 \text{ b}$ para sectores ($256$) y $6 \text{ b}$ para cabezas ($64$), limitando la capacidad máxima direccionable a $8192 \text{ MB}$ ($8 \text{ GB}$) con sectores de $512 \text{ B}$.
- **Esquema _LBA_ (_Logical Block Address_)**: Direccionamiento lineal moderno. El disco se presenta ante el sistema operativo como una secuencia contigua y unificada de bloques lógicos indexados desde $0$ hasta $N$, abstrayendo la geometría real interna. La electrónica del disco se encarga de mapear el _LBA_ a la pista física correspondiente mediante una placa de direccionamiento (_addressing plate_), permitiendo omitir sectores defectuosos remapeándolos hacia pistas alternativas de respaldo.

---

(08-administracion-de-arhcivos-3-algoritmos-de-planificacion-de-disco-disk-scheduling)=

## 3. Algoritmos de planificación de disco (_disk scheduling_)

Cuando múltiples procesos concurrentes exigen accesos al disco, el kernel acumula las peticiones en una cola y aplica algoritmos de planificación para ordenar los movimientos del cabezal electromecánico con el fin de minimizar el _seek time_ acumulado.

(08-administracion-de-arhcivos-3-1-algoritmos-clasicos)=

### 3.1. Algoritmos clásicos

- **_FIFO_ (_First-In, First-Out_)**: Atiende las solicitudes estrictamente en el orden en que arribaron. Es equitativo pero provoca recorridos caóticos y costosos del cabezal si las peticiones están dispersas en extremos opuestos del disco.
- **_SSTF_ (_Shortest Service Time First_)**: Elige siempre la petición de la cola que se encuentre más cerca de la posición actual del cabezal. Minimiza de forma drástica el movimiento, pero introduce el riesgo de **inanición (_starvation_)** para las pistas lejanas si entran continuamente pedidos en las pistas cercanas.
- **_LIFO_ (_Last-In, First-Out_)**: Atiende la última petición que ingresó. Aprovecha la localidad si un mismo proceso lee archivos secuenciales, pero perjudica gravemente a los procesos contiguos.
- **_SCAN_ (algoritmo del ascensor)**: El cabezal se mueve en una única dirección barriendo las pistas y atendiendo las solicitudes pendientes a su paso hasta llegar al extremo del disco; ahí invierte el sentido de la marcha y hace el barrido de regreso. Provee tiempos de respuesta más estables y evita la inanición.
- **_C-SCAN_ (_circular SCAN_)**: Similar a _SCAN_, pero restringe la atención de pedidos a un único sentido del viaje. Al llegar al extremo opuesto, el cabezal realiza un retorno rápido sin atender peticiones directo hacia la pista cero (aprovechando que los discos poseen un mecanismo acelerado de retracción para volver al inicio), reiniciando el barrido.
- **_N-SCAN_</_F-SCAN_**: Variantes segmentadas que congelan la cola de peticiones durante un barrido; los pedidos nuevos se acumulan en una subcola secundaria para ser procesados en el siguiente viaje, neutralizando la posibilidad de que el cabezal se quede estancado eternamente en una pista debido a una ráfaga masiva de solicitudes concentradas.

---

(08-administracion-de-arhcivos-4-naturaleza-de-errores-en-discos-y-codigo-de-hamming)=

## 4. Naturaleza de errores en discos y código de Hamming

La detección y corrección de errores difiere notablemente entre la memoria RAM y el almacenamiento en disco:

- **En memorias (errores aleatorios)**: Históricamente (como en las memorias de núcleos), los fallos ocurren por la inversión fortuita de un bit aislado en ubicaciones aleatorias. El bit extra de **paridad** (sea par o impar) se calcula automáticamente en la escritura y se verifica en la lectura; es capaz de **detectar** un bit erróneo pero es incapaz de identificar cuál fue, forzando la detención total del sistema mediante una instrucción `HLT`.
- **En discos (errores agrupados)**: Los fallos no son aislados; se presentan fuertemente concentrados en ráfagas (_burst errors_) debido a defectos macroscópicos físicos en el substrato magnético o irregularidades físicas del plato (_bad spots_). Teniendo en cuenta que el ancho de una pista es de $\approx 500 \text{ nm}$ y la longitud de un sector ronda los $150 \ \mu \text{m}$, cualquier imperfección daña decenas de miles de bits contiguos.

(08-administracion-de-arhcivos-4-1-manifestacion-del-error)=

### 4.1. Manifestación del error

A diferencia de las memorias donde el bit muta de forma invisible, en los discos el error se manifiesta como un **dato faltante o no disponible**. Esto se debe a que el controlador valida preventivamente cada sector mediante el código **CRC**; si el CRC no coincide, el sector se declara dañado e inaccesible.

(08-administracion-de-arhcivos-4-2-el-codigo-de-hamming)=

### 4.2. El código de Hamming

A diferencia de la paridad simple, el código de Hamming agrega múltiples bits de verificación cruzada distribuidos en posiciones estratégicas potencia de dos ($P_{1}, P_{2}, P_{4}, ...$), permitiendo al hardware no solo detectar el fallo, sino deducir la posición exacta del bit erróneo para **corregirlo en "caliente"** invirtiendo su valor lógico sin detener la CPU.

---

(08-administracion-de-arhcivos-5-arquitectura-de-arreglos-de-discos-redundantes-raid)=

## 5. Arquitectura de arreglos de discos redundantes (RAID)

La tecnología **_RAID_ (_Redundant Array of Independent Disks_)** combina múltiples unidades de disco físicas independientes para presentarlas ante el sistema operativo como un único disco lógico unificado, persiguiendo dos objetivos fundamentales: incrementar el rendimiento (velocidad) y/o garantizar la tolerancia a fallos (seguridad).

(08-administracion-de-arhcivos-5-1-analisis-de-los-niveles-raid-estandar)=

### 5.1. Análisis de los niveles _RAID_ estándar

- **_RAID_ 0 (distribución por bandas - _striping_)**: Divide los archivos en fragmentos de tamaño medio denominados bandas (_strips_) y los distribuye de forma alternada a lo largo de múltiples unidades.
  - **Velocidad**: Máxima (excelente para archivos grandes ya que permite lecturas/escrituras paralelas).
  - **Seguridad**: Nula (si un solo disco físico falla, se corrompe la totalidad del volumen lógico).
- **_RAID_ 1 (espejado - _mirroring_)**: Duplica idénticamente cada dato escrito en una unidad en un segundo disco físico de respaldo. Puede configurarse con un disco activo y uno pasivo, o con ambos activos en paralelo. Si se duplica también la tarjeta controladora de bus para eliminar ese punto único de fallo, la técnca se denomina _disk duplexing_.
  - **Velocidad**: Estándar en escritura, optimizada en lectura (pueden contestar ambos discos alternando peticiones).
  - **Seguridad**: Alta. Costo espacial del $50 \%$ de la capacidad total.
- **_RAID_ 2 (código de Hamming)**: Divide los datos en tiras extremadamente cortas (a nivel de bits o nibbles) distribuidas en discos sincronizados a nivel de eje, dedicando discos exclusivos para almacenar los bits de verificación calculados mediante el código de Hamming. Es costoso y complejo, capaz de recuperar el fallo simultáneo de hasta dos unidades.
- **_RAID_ 3 (paridad intercalada a nivel de bits)**: Similar a _RAID_ 2, pero al aprovechar que los discos modernos notifican autónomamente qué sector falló mediante el CRC, simplifica la matemática utilizando un único **bit de paridad simple** concentrado exclusivamente en una sola unidad física independiente. Exige discos físicamente sincronizados.
- **_RAID_ 4 (paridad de bloques concentrada)**: Utiliza bloques o bandas de gran tamaño operando con discos independientes sincronizados. Calcula la paridad interbloques y la concentra de forma fija en un único disco dedicado a tal fin. Sufre un cuello de botella crítico, ya que cada operación de escritura en cualquier disco exige modificar y escribir mandatoriamente el disco de paridad.
- **_RAID_ 5 (paridad de bloques distribuida)**: Mantiene el esquema de bloques grandes y discos independientes, pero **distribuye de forma rotativa la paridad a lo largo de todas las unidades físicas del arreglo**. Rompe el cuello de botella de _RAID_ 4, permitiendo escrituras paralelas eficientes. Puede tolerar la pérdida de un disco.
- **_RAID_ 6 (redundancia doble)**: Evolución de _RAID_ 5 que implementa un esquema de doble paridad utilizando ecuaciones matemáticas independientes (por ejemplo, paridad $P$ y paridad $Q$) distribuidas en todos los discos. Garantiza la integridad de los datos incluso ante la **falla simultánea de dos discos físicos** del arreglo.

(08-administracion-de-arhcivos-5-2-raids-anidados-hibridos)=

### 5.2. _RAIDs_ anidados (híbridos)

En entornos de alto rendimiento se combinan niveles estructurados en dos capas jerárquicas, configurando el nivel superior bajo **_RAID_ 0** para maximizar la velocidad de transferencia, sobre discos virtuales que internamente son arreglos tolerantes a fallos:

- **_RAID_ 10 (_RAID_ 0 + _RAID_ 1)**: Segmentación por bandas sobre conjuntos previamente espejados.
- **_RAID_ 50 (_RAID_ 0 + _RAID_ 5)**: Segmentación por bandas sobre arreglos con paridad distribuida.

---

(08-administracion-de-arhcivos-6-disrupcion-de-la-memoria-flash)=

## 6. Disrupción de la memoria flash

Las unidades de estado sólido (SSD) basadas en **memoria flash** están reemplazando progresivamente a los discos rotantes tradicionales. Al carecer de componentes electromagnéticos móviles, las variables mecánicas clásicas se erradican por completo: **el tiempo de búsqueda (_seek_) y la latencia rotacional no existen** en estos dispositivos. El acceso es puramente aleatorio y directo por direccionamiento electrónico a nivel de celdas, logrando tasas de transferencia radicamente más rápidos.

(08-administracion-de-arhcivos-6-1-restricciones-fisicas-de-la-memoria-flash)=

### 6.1. Restricciones físicas de la memoria flash

1. **Borrado previo mandatorio**: Las celdas de memoria flash no permiten la sobreescritura directa de bits de forma aislada. Para escribir un dato en una zona ocupada, el hardware tiene que aplicar obligatoriamente un pulso de alta tensión para limpiar y **borrar bloques completos** de memoria (típicamente de $4 \text{ KB}$ o superiores) antes de asentar los nuevos datos.
2. **Vida útil degradable**: Las celdas sufren un desgaste físico irreversible por el estrés eléctrico, tolerando una **cantidad limitada de ciclos de escritura/borrado** antes de quedar inutilizables. Esto obliga al firmware de la unidad (capa FTL) a implementar algoritmos sofisticados de nivelación de desgaste (_wear leveling_) para distribuir homogéneamente las escrituras sobre la superficie de silicio.

---

(08-administracion-de-arhcivos-7-estructuras-del-sistema-de-archivos-y-asignacion-de-espacio)=

## 7. Estructuras del sistema de archivos y asignación de espacio

Un archivo se define formalmente como una unidad lógica reconocible por el sistema, caracterizada por su persistencia, capacidad de ser compartida y poseer una estructura interna (registros y campos de longitud fija o variable) junto con un conjunto de atributos de control (fechas de creación/modificación/backup, propietario, permisos y estado de consistencia).

(08-administracion-de-arhcivos-7-1-el-rol-del-directorio)=

### 7.1. El rol del directorio

El directorio mapea el nombre del archivo con su ubicación física en el almacenamiento masivo. Estructuralmente se organizan en forma de **árbol jerárquico** (directorio principal que anida subdirectorios y archivos) delimitando el concepto de **directorio corriente** o de **trabajo**. Mientras atributos como el nombre y el tipo residen de forma estricta en el directorio, campos de control dinámico como el uso actual (procesos que lo tienen abierto o bloqueado) y su estado de consistencia se administran dinámicamente en las estructuras de la memoria RAM del sistema operativo.

| Derecho de Acceso | Operación Permitida sobre Archivos                                                                   | Operación Permitida sobre Subdirectorios                                                            |
| ----------------- | ---------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Ninguno           | El usuario no puede conocer la existencia del archivo                                                | Bloquea por completo cualquier exploración o conocimiento del subdirectorio                         |
| Existencia        | Permite conocer el nombre y atributos mínimos, pero prohíbe leer su contenido                        | Se conoce la existencia del subdirectorio, pero no la lista de archivos internos                    |
| Ejecución         | Permite cargar el programa en memoria para correrlo, pero prohíbe copiarlo o modificarlo             | Permite transitarlo o invocarlo como parte de una ruta (path), pero prohíbe listar su contenido     |
| Lectura           | Inspección y lectura irrestricta de los datos. Puede ser restringida a ciertos programas específicos | Permite listar y leer el contenido completo del subdirectorio                                       |
| Agregado          | Permite escribir datos nuevos única y exclusivamente al final del archivo, sin alterar lo existente  | Permite crear nuevos archivos en su interior, pero prohíbe alterar o borrar los archivos existentes |
| Modificación      | Modificación, edición y alteración irrestricta de cualquier sección del archivo                      | Permite alterar nombres de archivos o modificar los atributos internos del subdirectorio            |
| Protecciones      | Permite alterar de forma limitada o irrestricta las ACLs y permisos de acceso del archivo            | Permite alterar las reglas y derechos de acceso del subdirectorio completo                          |
| Borrado           | Eliminación física del archivo liberando sus bloques                                                 | Elimina el subdirectorio y su contenido, si se posee derecho de borrado sobre los hijos             |

---

(08-administracion-de-arhcivos-8-estrategias-de-asignacion-de-espacio-y-bloques)=

## 8. Estrategias de asignación de espacio y bloques

Los sectores físicos del disco se agrupan lógicamente en unidades de asignación mayores denominadas **bloques** o **clusters** para optimizar la velocidad de transferencia de datos.

- **Bloques grandes**: Optimizan la transferencia secuencial masiva, pero incrementan le desperdicio por **fragmentación interna** si los archivos son pequeños.
- **Bloques pequeños**: Minimizan el desperdicio de espacio, pero complejizan las estructuras de indexación del disco y degradan la velocidad de transferencia.

(08-administracion-de-arhcivos-8-1-modelos-de-organizacion-fisica-de-archivos)=

### 8.1. Modelos de organización física de archivos

1. **Asignación contigua**: El archivo se almacena en una secuencia ininterrumpida de bloques físicos contiguos en el disco.
   - **Ventaja**: Velocidad de transferencia máxima (el cabezal casi no se mueve).
   - **Desventaja**: Sufre de fragmentación externa masiva. Hace extremadamente difícil y costoso expandir el tamaño de un archivo en caliente. Requiere procesos periódicos de **compactación** o **desfragmentación**.
2. **Asignación encadenada**: Cada bloque del archivo contiene los datos de usuario y un puntero físico al siguiente bloque del disco. El directorio solo apunta al bloque inicial.
   - **Ventaja** No hay fragmentación externa; expansión inmediata.
   - **Desventaja**: El acceso aleatorio es lento (se debe leer toda la cadena). Si un puntero se corrompe por un fallo físico, se pierde el resto del archivo.
3. **Asignación indexada**: El directorio apunta a un bloque especial llamado **bloque de índices** (o nodo-i), que contiene un vector ordenado de punteros que referencian a los bloques de datos puros del archivo dispersos por el disco.
   - **Indexado de longitud fija**: Almacena punteros planos uno a uno; ideal para archivos con alta movilidad y dispersos.
   - **Indexado de longitud variable (_extents_)**: Almacena tuplas compuestas por la dirección del bloque de inicio y la cantidad de bloques contiguos asignados (por ejemplo, `(37, 4), (47, 8)`); óptimo para sistemas compactados con baja movilidad.

(08-administracion-de-arhcivos-8-2-escalabilidad-del-indexado-multiple)=

### 8.2. Escalabilidad del indexado múltiple

En un disco de $2 \text{ TB}$ ($2^{41} \text{ B}$) con bloques de $2 \text{ KB}$ ($2^{11} \text{ B}$), se requiere numerar e indexar $2^{30}$ bloques libres (punteros de $30 \text{ B} \rightarrow 4 \text{ b}$). Por lo tanto, un único bloque de índices de $2 \text{ KB}$ puede albergar un máximo de $\frac{2048}{4} = 512$ entradas:

- **Indexado simple**: Puede direccionar como máximo $512 \times 2 \text{ KB} = 1 \text{ MB}$.
- **Indexado doble (indirecto)**: El bloque del directorio apunta a una tabla de $512$ índices, donde cada uno apunta a una segunda tabla de índices finales de $512$ entradas que referencian a los bloques de datos. Capacidad máxima: $512 \times 512 \times 2 \text{ KB} = 512 \text{ MB}$.
- **Indexado triple**: Añade un nivel más de indirección profunda. Capacidad máxima: $512 \times 512 \times 512 \times 2 \text{ KB} = 256 \text{ GB}$.

(08-administracion-de-arhcivos-8-3-implementaciones-reales-de-sistemas-de-archivos)=

### 8.3. Implementaciones reales de sistemas de archivos

- **Esquema de Linux (ext4)**: Implementa estructuras de nodos-i estructuradas habitualmente con **12 referencias directas**, 1 referencia de primer nivel indirecto, 1 de segundo nivel, 1 de tercer nivel y opcionalmente un cuarto nivel, operando sobre bloques mínimos estandarizados de $4 \text{ KB}$.
- **Esquema de Windows (NTFS)**: Utiliza un mapa adaptativo que escala dinámicamente el tamaño del cluster según la capacidad total del volumen físico para equilibrar la eficiencia y el aprovechamiento del espacio:

| Tamaño del Volumen NTFS           | Tamaño del Bloque / Cluster Asignado |
| --------------------------------- | ------------------------------------ |
| $\leq 512 \text{ MB}$             | $512 \text{ B}$                      |
| $512 MB$ a $1 GB$                 | $1 \text{ KB}$                       |
| $1 \text{ GB}$ a $2 \text{ GB}$   | $2 \text{ KB}$                       |
| $2 \text{ GB}$ a $4 \text{ GB}$   | $4 \text{ KB}$                       |
| $4 \text{ GB}$ a $8 \text{ GB}$   | $8 \text{ KB}$                       |
| $8 \text{ GB}$ a $16 \text{ GB}$  | $16 \text{ KB}$                      |
| $16 \text{ GB}$ a $32 \text{ GB}$ | $32 \text{ KB}$                      |
| $> 32 \text{ GB}$                 | $64 \text{ KB}$                      |

---

(08-administracion-de-arhcivos-9-administracion-del-espacio-libre-en-disco)=

## 9. Administración del espacio libre en disco

Para asignar nuevos bloques, el sistema operativo mantiene una estructura de control del espacio libre mediante diferentes estrategias:

- **Tabla de bits (vector de bits)**: Una matriz contigua de bits en memoria donde cada bit representa un bloque del disco ($1 = \text{ ocupado}, 0 = \text{ libre}$).
  - **Cálculo mecánico**: Para localizar el estado del cluster número $85$ bajo una organización matricial de bytes de $8 \text{ b}$: se divide $\frac{85}{8} = 10$ con resto $5$. Significa que el estado del bloque corresponde exactamente al bit número $5$ del byte número $10$ dentro del mapa de bits indexado.
- **Encadenado de fragmentos**: Los bloques libres se apuntan entre sí formando una cadena. No consume espacio en RAM, pero buscar bloques libres contiguos es ineficiente.
- **Lista de bloques libres**: Los bloques libres se indexan dedicadas utilizando enfoques de longitud fija o variable para agilizar la búsqueda de sectores contiguos por el planificador.
