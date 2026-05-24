# Comunicación de interprocesos mediante pasaje de mensajes

El pasaje de mensajes es una de las técnicas de **comunicación de interprocesos (_IPC - Inter Process Communication_)** más robustas y versátiles, permitiendo no solo el intercambio de datos entre procesos concurrentes dentro de un mismo computador, sino también la **sincronización de procesos distribuidos en diferentes plataformas y sistemas operativos**.

---

(10-mensajes-1-)=

## 1. Esquemas de direccionamiento en la transmisión y recepción

La forma en que se especifican las entidades de los participantes define la topología y la flexibilidad de la comunicación:

(10-mensajes-1-1-mensajes-directos-simetricos-o-asimetricos)=

### 1.1. Mensajes directos (simétricos o asimétricos)

En este esquema, el canal de comunicación se establece explícitamente entre los hilos de control participantes. Posee las siguientes características:

- Son estrictamente **uno a uno** y de naturaleza **privada**.
- **Envío directo (`send`)**: El emisor tiene que conocer obligatoriamente la identidad exacta del receptor (por ejemplo, su PID) y enviarle el mensaje de forma explícita.
- **Recepción directa (`receive`)**: Puede articularse bajo dos modalidades de diseño:
  - **Explícita**: El receptor bloquea su ejecución esperando un mensaje proveniente única y exclusivamente de un emisor determinado y predecible.
  - **Implícita**: El receptor se configura para recibir un mensaje de cualquier emisor que intente comunicarse con él, determinando la identidad del remitente recién en el momento en que se descola el mensaje.

(10-mensajes-1-2-mensajes-indirectos)=

### 1.2. Mensajes indirectos

La comunicación no se realiza de forma directa entre los procesos, sino que se interpone un objeto intermedio que actúa como **reservorio o contenedor de almacenamiento**, denominado técnicamente **buzón (_mailbox_)**.

Este enfoque es considerablemente más flexible y permite implementar múltiples topologías de comunicación:

- **Uno a uno**: Un emisor dedicado y un receptor exclusivo (similar a un canal privado).
- **Uno a muchos**: Un emisor que difunde información a múltiples procesos receptores (esquema de radiodifusión o _broadcast_).
- **Muchos a uno**: Múltiples clientes que envían peticiones a un único proceso servidor centralizado.
- **Muchos a muchos**: Múltiples hilos que depositan y extraen mensajes de un contenedor común (cola de trabajo compartida).
- **Ámbito de acceso**: Los buzones pueden configurarse con un alcance **público** (accesible por cualquier proceso del sistema que conozca su identificador) o **privado** (restringido a un árbol jerárquico de procesos relacionados).

---

(10-mensajes-2-propiedades-de-los-mensajes-persistencia-y-dimensionamiento)=

## 2. Propiedades de los mensajes: Persistencia y dimensionamiento

La naturaleza del mensaje en tránsito determina el acoplamiento y la tolerancia a fallos entre los procesos cooperativos:

- **Mensajes transitorios**: El mensaje posee un ciclo de vida efímero y estrictamente ligado a la simultaneidad. **El mensaje desaparece por completo si el proceso receptor no se encuentra disponible** en el sistema en ese instante preciso o si meramente no ejecuta la lectura inmediatamente.
- **Mensajes persistentes**: El sistema operativo garantiza que **el mensaje quede almacenado de forma segura en buffers del kernel o del almacenamiento** hasta que el proceso receptor se conecte y ejecute explícitamente la lectura del mismo, independientemente de si el emisor sigue vivo o ya finalizó su ejecución.
- **Dimensionamiento**: Los mensajes pueden ser de **tamaño fijo** (optimizando la gestión de memoria interna del kernel y simplificando el buffer dinámico) o de **tamaño variable** (adecuados para transferencias complejas de estructuras de datos arbitrarias).

---

(10-mensajes-3-gestion-y-propiedades-del-reservorio-mailbox)=

## 3. Gestión y propiedades del reservorio (_mailbox_)

Para que los procesos puedan intercambiar mensajes indirectos, el _mailbox_ tiene que ser administrado siguiendo una serie de pautas operativas y acuerdos de sistema:

- **Capacidad del buffer**: El reservorio puede diseñarse con un **tamaño fijo** (capacidad acotada a $N$ mensajes, lo que fuerza el bloqueo del emisor si la cola se llena) o con un **tamaño indefinido** (limitado únicamente por los recursos físicos de memoria del kernel).
- **Ciclo de vida del _mailbox_**:
  - Puede **preexistir** en el sistema como un recurso estático del entorno y asignarse formalmente ante el pedido explícito de un proceso de usuario.
  - Puede **crearse dinámicamente** bajo demanda en tiempo de ejecución a pedido de un proceso interesado.
- **Propiedad y control de acceso**: El _mailbox_ puede pertenecer a un proceso de usuario específico (el cual actúa como dueño) o ser de la **propiedad exclusiva de un proceso del sistema operativo** encargado de velar por su integridad. El acceso a dicho buzón puede configurarse como **libre o restringido** mediante descriptores de seguridad y permisos de usuario.
- **Vinculación (_binding_)**: La asociación de un proceso a un _mailbox_ determinado puede ser **estática** (fijada de forma invariable en tiempo de compilación o inicialización del proceso) o **dinámica** (permitiendo que el proceso se desvincule de un buzón y se acople a otro en caliente según el flujo de la aplicación).
- **El acuerdo externo (_out-of-band agreement_)**: El kernel provee el mecanismo, pero la lógica de las aplicaciones exige que exista **un acuerdo "por fuera" entre los procesos emisores y los receptores** acerca de cuál es el identificador numérico o la ruta exacta del _mailbox_ que tienen que utilizar para sintonizar la comunicación.

(10-mensajes-3-1-politicas-de-planificacion-y-despacho-de-mensajes)=

### 3.1. Políticas de planificación y despacho de mensajes

Cuando la cola del buzón acumula múltiples mensajes, el orden en que el receptor los extrae puede gestionarse bajo tres criterios por el kernel:

- **Política _FIFO_ (_First-In, First-Out_)**: Los mensajes se despachan estrictamente en el orden cronológico en que fueron depositados por los emisores.
- **Por prioridades**: Cada mensaje se envía acompañado de una etiqueta de prioridad. El kernel ordena la cola internamente de forma que el receptor extraiga siempre los mensajes críticos primero, independientemente de su tiempo de arribo.
- **Por inspección previa (_selective receive_)**: El proceso receptor examina los metadatos de los mensajes en la cola y exige extraer selectivamente aquel que cumpla con un criterio o filtro específico (como un tipo de mensaje particular).

---

(10-mensajes-4-implementaciones-nativas-en-sistemas-operativos)=

## 4. Implementaciones nativas en sistemas operativos

Cada sistema operativo comercial instrumenta el pasaje de mensajes indirectos y colas a través de sus propias APIs y estructuras de datos de bajo nivel:

(10-mensajes-4-1-implementacion-en-entornos-linux-unix-system-v-posix-mqueue)=

### 4.1. Implementación en entornos Linux (Unix System V / POSIX Mqueue)

En los sistemas de tipo Linux, el intercambio de mensajes exige que la información respete formalmente una estructura de datos estricta denominada `msgbuf`:

```{code} c
// Estructura formal exigida por el kernel de Linux
struct msgbuf {
  long  mtype;    // Tipo de mensaje (permite la selección por inspección)
  char  mtext[1]; // Array que actúa como buffer para el texto/datos del mensaje
};
```

- **Mecánica de llamadas al sistema**: El flujo de transferencia física de estos bloques de datos entre los espacios de usuario y kernel se gestionan mediante dos _system calls_ mandatorias:
  - `msgsnd()`: Invoca el envío atómico de la estructura hacia la cola del sistema.
  - `msgrcv()`: Ejecuta la recepción y extracción, soportando filtros basados en el campo `mtype`.

(10-mensajes-4-2-implementacion-en-entornos-windows-mailslots)=

### 4.2. Implementación en entornos Windows (_mailslots_)

En la arquitectura de Windows, el pasaje de mensajes indirectos unidireccionales se modela bajo el concepto de **_mailslots_**.

- **Mecánica**: Un proceso que asume el rol de **servidor** tiene la potestad exclusiva de crear una cola de mensajes denominada _mailslot server_. Una vez establecido, otros procesos del sistema que adoptan el rol de **clientes** pueden conectarse a la ruta del _mailslot_ y depositar mensajes en él de forma segura.

(10-mensajes-4-3-implementacion-en-entornos-apple-macos-darwin-osx)=

### 4.3. Implementación en entornos Apple macOS (Darwin / OSX)

El micronúcleo de los sistemas de Apple (basado en Mach) utiliza colas de mensajes estructuradas denominadas _message queues_.

- **Mecánica**: A diferencia de Linux, macOS unifica el tratamiento de estas colas abstrayéndolas bajo el paradigma de archivos del sistema. Por lo tanto, las operaciones de envío y recepción de mensajes se ejecutan reutilizando de forma nativa las _system calls_ estándar de entrada/salida:
  - `write()`: Introduce y encola el mensaje en la cola.
  - `read()`: Extrae y lee el mensaje correspondiente.
