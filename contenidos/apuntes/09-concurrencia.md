# Concurrencia y sincronización de procesos

La concurrencia en los sistemas operativos modernos plantea dos escenarios arquitectónicos con necesidades de arbitraje marcadamente diferenciadas:

- **Procesos que comparten recursos (competencia)**: Son procesos que coexisten interactuando sobre un mismo hardware, pero **poiblemente ignoran la existencia de los otros**. Toda la responsabilidad de aislamiento y arbitraje recae exclusivamente en el sistema operativo.
- **Procesos cooperativos**: Son procesos diseñados en conjunto que **conocen explícitamente la existencia de los demás** y suelen sincronizar sus tiempos aguardándose mutuamente. Acá, una parte crítica del problema de sincronización tiene que ser resuelto por la lógica interna de los propios procesos.

---

(09-concurrencia-1-el-problema-de-la-region-critica-y-condiciones-de-carrera)=

## 1. El problema de la región crítica y condiciones de carrera

Cuando dos o más procesos colaborativos o concurrentes intentan leer y escribir sobre un mismo recurso compartido (como un archivo, una variable en memoria o un registro de base de datos) de forma simultánea, el resultado final de la operación depende del orden exacto de entrelazamiento de sus instrucciones. Este fenómeno destructivo se denomina **condición de carrera (_race condition_)**.

(09-concurrencia-1-1-caso-de-estudio-inconsistencia-de-stock-y-precio)=

### 1.1. Caso de estudio: Inconsistencia de stock y precio

Si se considera un registro de producto compartido que almacena la cantidad en stock y el precio de venta. Dos procesos independientes intentan aplicar modificaciones simultáneas sobre dicho registro:

| Instante | Proceso 1 (Arribo de 500 unidades)  | Proceso 2 (Oferta con rebaja del 10%)                       | Stock Físico en RAM | Precio en RAM |
| -------- | ----------------------------------- | ----------------------------------------------------------- | ------------------- | ------------- |
| t0       | Estado Inicial                      | Estado Inicial                                              | 100                 | $1000         |
| t1       | Lee datos del producto (Stock: 100) | ...                                                         | 100                 | $1000         |
| t2       | Suma 500 al stock local (600)       | Lee datos del producto (Precio: 1000)                       | 100                 | $1000         |
| t3       | Graba datos (Stock: 600)            | Calcula nuevo precio local ($900)                           | 600                 | $1000         |
| t4       | Termina                             | Graba datos (Precio: $900, pero sobreescribe Stock con 100) | 100                 | $900          |

```{admonition} Resultado corrupto
---
class: error
---
El Proceso 2 leyó el stock viejo ($100$) en $t_{2}$; al grabar sus resultados en $t_{4}$ pisó de forma destructiva la actualización legítima realizada por el Proceso 1 en $t_{3}$. Las 500 unidades nuevas desaparecieron del sistema.
```

(09-concurrencia-1-2-definicion-formal-de-region-critica)=

### 1.2. Definición formal de región crítica

Para solucionar las condiciones de carrera, es imperativo aislar el fragmento de código que accede al recurso compartido, denominándolo **región crítica**. Las actividades de los procesos tienen que **serializarse** (ejecutarse uno a la vez):

- **Comienzo de la región crítica**: Protocolo de entrada donde el proceso notifica al sistema.
- **Fin de la región crítica**: Protocolo de salida donde el proceso libera el recurso.

(09-concurrencia-1-3-propiedades-mandatorias-para-una-solucion-valida)=

### 1.3. Propiedades mandatorias para una solución válida

1. **Exclusión mutua**: Si un proceso está en su región crítica, ningún otro puede entrar.
2. **Ausencia de inanición (_starvation_)**: El acceso a la región crítica no tiene que demorarse indefinidamente para un proceso en espera.
3. **Ausencia de abrazos mortales (_deadlocks_)**: Los mecanismos de bloqueo no tienen que inducir un interbloqueo mutuo perpetuo.
4. **Acceso inmediato**: Cuando la región crítica está libre, un proceso que solicita entrar tiene que hacerlo de forma instantánea sin retrasos arbitrales.
5. **Permanencia acotada**: Un proceso tiene que permanecer dentro de la región crítica un tiempo estrictamente reducido.

---

(09-concurrencia-2-mecanismos-de-control-por-hardware-e-inhibicion-de-interrupciones)=

## 2. Mecanismos de control por hardware e inhibición de interrupciones

El control de la exclusión mutua puede implementarse mediante directivas físicas primitivas coordinadas con la MMU y el procesador.

(09-concurrencia-2-1-inhibicion-de-interrupciones-puras-ioff-ion)=

### 2.1. Inhibición de interrupciones puras (`IOFF`/`ION`)

- **Mecánica**: Un proceso apaga las interrupciones de hardware al entrar a la región crítica (`IOFF`) e impide que el timer genere un cambio de contexto involuntario. Al salir, vuelve a encenderlas (`ION`).
- **Restricción**: Estas instrucciones son estrictamente **privilegiadas**; el código de usuario no puede ejecutarlas directamente. En la práctica se implementa mediante un par de llamadas al sistema (_system calls_) donde el kernel provee una inhibición simulada, comprometiéndose a **no realizar conmutación de procesos de usuario** mientras dure la permanencia en la región crítica.
- **Defecto**: Es altamente propenso a producir pérdidas críticas de eficiencia global y neutraliza la capacidad de respuesta en sistemas multiprocesador.

(09-concurrencia-2-2-la-falacia-del-flag-de-software-simple)=

### 2.2. La falacia del flag de software simple

Si se intenta implementar la exclusión mutua usando una variable bandera común (`FLAG = TRUE` ocupado, `FALSE` libre) en un bucle de software convencional:

```txt
; INTENTO DE ESPERA POR SOFTWARE (ERRÓNEO)
ESPERAR: MOV R1, FLAG       ; Lee estado del flag
         TST R1             ; ¿Está ocupado?
         BT  ESPERAR        ; Si está en TRUE, reintenta en bucle
         MOV R1, 'TRUE'     ; Cambia a ocupado localmente
         MOV FLAG, R1       ; Intenta asentar el cierre
         ; ... REGION CRÍTICA ...
```

```{admonition} Fallo crítico de inconsistencia
---
class: warning
---
Si ocurre un cambio de contexto (_context switch_) exactamente después de la instrucción `MOV R1, FLAG` pero antes de que el proceso ejecute `MOV FLAG, R1`, un segundo proceso evaluará el flag como libre, ingresará a la región crítica, y **ambos procesos terminarán ejecutando concurrentemente dentro de la zona prohibida**, rompiendo la exclusión mutua.
```

---

(09-concurrencia-3-instrucciones-atomicas-de-hardware)=

## 3. Instrucciones atómicas de hardware

Para solucionar la inconsistencia del flag, la arquitectura del procesador tiene que proveer instrucciones **atómicas (no interrumpibles)** que agrupen en un único ciclo de bus físico la lectura, prueba y modificación de la memoria.

(09-concurrencia-3-1-compare-and-swap-linea-intel-pentium)=

### 3.1. _Compare and Swap_ (línea Intel/Pentium)

La instrucción `CMPXCHG` combinada con el prefijo `LOCK` (que congela eléctricamente el bus de datos para sistemas multiprocesador) es el estándar de exclusión mutua. Opera comparando de forma oculta contra el registro acumulador (`AX`/`EAX`):

```txt
; Mecánica Matemática de LOCK CMPXCHG Dato, Reg
Si (Acumulador == Dato) entonces:
    Dato = Reg
    ZF = 1 (Bandera de Cero encendida)
Sino:
    Acumulador = Dato
    ZF = 0 (Bandera de Cero apagada)
```

(09-concurrencia-3-1-1-implementacion-practica-de-un-bucle-de-espera-atomica-spinlock)=

#### 3.1.1. Implementación práctica de un bucle de espera atómica (_spinlock_)

```txt
SET LIBRE   0000H            ; Constante estado libre
SET OCUPADO 0FFFFH           ; Constante estado bloqueado
FLAG        DS 2             ; Reserva de 2 bytes para el flag en RAM

LOOP:       MOV  CX, OCUPADO  ; Prepara el valor de cierre en CX
            MOV  AX, LIBRE    ; Prepara el valor esperado en AX
            LOCK CMPXCHG FLAG, CX ; OPERACIÓN ATÓMICA DE HARDWARE
            BNZ  LOOP         ; Si ZF=0 (FLAG estaba OCUPADO), reintenta el bucle

; --- INGRESO LEGÍTIMO A LA REGIÓN CRÍTICA ---
```

(09-concurrencia-3-2-esquema-de-carga-enlazada-almacenamiento-condicional-linea-arm)=

### 3.2. Esquema de carga enlazada / Almacenamiento condicional (línea ARM)

```txt
MOV R0, #FLAG
MOV R1, OCUPADO
STREX R2, R1, [R0] ; Si FLAG estaba libre, graba OCUPADO y retorna R2=0 (Éxito)
                   ; Si FLAG cambió en el intermedio, aborta la escritura y retorna R2=1 (Fallo)
```

(09-concurrencia-3-2-1-defectos-inherentes-a-las-soluciones-de-hardware-puro)=

#### 3.2.1. Defectos inherentes a las soluciones de hardware puro

- **Espera dinámica (_spinlock_)**: El proceso bloqueado consume de forma destructiva ciclos de CPU ejecutando un bucle infinito a la espera de que el flag se libere.
- **Inversión de prioridades y _deadlock_**: Si un proceso de baja prioridad ingresa a la región crítica y es desalojado por el planificador para darle la CPU a un proceso de alta prioridad, el proceso de alta prioridad se quedará atrapado en el bucle del _spinlock_ eternamente. Como el proceso de baja prioridad nunca recupera la CPU para terminar y liberar el flag, el sistema cae en un **abrazo mortal por prioridad**.

```{admonition} Mecanismo relinquish (sleep)
---
class: hint
---
Para mitigar esto, los procesos que fallan en el primer intento atómico pueden invocar voluntariamente una directiva de cesión de CPU (`Sleep(n)`), reduciendo la inanición y desarmando los deadlocks clásicos.
```

---

(09-concurrencia-4-semaforos-la-solucion-del-sistema-operativo)=

## 4. Semáforos (la solución del sistema operativo)

Propuestos originalmente por Edsger Dijkstra en 1965, un **semáforo** es una variable entera protegida administrada en el **espacio privado de memoria del sistema operativo**. Las aplicaciones no pueden leer ni modificar el valor del semáforo directamente; tienen que invocar servicios obligatorios del kernel mediante llamadas al sistema, lo que garantiza la **atomicidad por diseño** de sus operaciones.

(09-concurrencia-4-1-mecanica-operativa)=

### 4.1. Mecánica operativa

Las funciones primitivas operan decrementando e incrementando la variable de control:

(09-concurrencia-4-1-1-primitiva-wait)=

#### 4.1.1. Primitiva `Wait(s)` (históricamente P - Proberen / Probar)

1. Decrementa inmediatamente el valor del semáforo: $s = s - 1$.
2. Evalúa el resultado:
   - **Si $s \geq 0$**: El proceso obtiene la autorización y **continúa su ejecución inmediatamente** hacia la región crítica.
   - **Si $s < 0$**: El recurso está saturado. El sistema operativo detiene la ejecución del proceso, cambia su estado a **bloqueado**, lo remueve de la CPU y lo encola en la lista de espera del semáforo.

(09-concurrencia-4-1-2-primitiva-signal)=

#### 4.1.2. Primitiva `Signal(s)` (históricamente V - Verhogen / Incrementar)

1. Incrementa inmediatamente el valor del semáforo: $s = s + 1$.
2. Evalúa el resultado: Si existen procesos bloqueados en la cola del semáforo (lo cual se deduce si el valor resultante sigue siendo $\leq 0$), el kernel selecciona un proceso de la cola de bloqueados y lo transfiere automáticamente al estado **listo** para que compita por la CPU. Después, retorna de la llamada.

(09-concurrencia-4-2-significado-matematico-del-valor-del-semaforo)=

### 4.2. Significado matemático del valor del semáforo

- **Valor positivo o cero ($\geq 0$)**: Representa el número de procesos que pueden ingresar de forma simultánea e inmediata a la región crítica sin bloquearse.
- **Valor negativo ($< 0$)**: El valor absoluto (cambiado de signo) indica la **cantidad exacta de procesos que se encuentran actualmente suspendidos y bloqueados** en la cola de espera de ese semáforo.

(09-concurrencia-4-3-clasificacion-y-gestion-de-semaforos)=

### 4.3. Clasificación y gestión de semáforos

- **Asignación de identificadores**: Los semáforos se crean dinámicamente o se asignan a pedido de los procesos. Si el identificador es dinámico y lo define el sistema operativo, los procesos colaboradores tienen que coordinarse pasándose el ID por canales alternativos de IPC.
- **Semáforos fuertes**: El proceso que se despierta al ejecutar un `Signal` es estrictamente el más antiguo de la cola (política _FIFO_), garantizando la ausencia de inanición.
- **Semáforos débiles**: No hay garantías de orden; el kernel despierta a cualquier proceso bloqueado de la cola de forma arbitraria.
- **Semáforos mutex**: Tipo especial de semáforo binario donde **únicamente el proceso exacto que bloqueó el semáforo mediante un `Wait` tiene el derecho legítimo de desbloquearlo** ejecutando su correspondiente `Signal`.

---

(09-concurrencia-5-sincronizacion-por-pasaje-de-mensajes)=

## 5. Sincronización por pasaje de mensajes

El pasaje de mensajes elimina por completo la necesidad de mantener memoria compartida, permitiendo la sincronización tanto en sistemas locales como en arquitecturas distribuidas mediante dos operaciones primitivas: `send()` y `receive()`.

(09-concurrencia-5-1-modelos-de-direccionamiento)=

### 5.1. Modelos de direccionamiento

- **Mensajes directos**: Las entidades tienen que especificarse explícitamente: `send(receptor, mensaje)` y `receive(emisor, mensaje)`. El receptor queda atado a aguardar un emisor específico.
- **Mensajes indirectos**: Los mensajes se vuelcan y extraen de un reservorio común compartido denominado **buzón (_mailbox_)**: `send(mailbox, mensaje)` y `receive(mailbox, mensaje)`. Soporta topologías de múltiples emisores y múltiples receptores.

(09-concurrencia-5-2-mecanica-del-rendez-vous)=

### 5.2. Mecánica del Rendez-vous

Cuando tanto la operación `send` como `receive` se configuran en **modo bloqueante**, se produce una sincronización estricta por hardware denominada **Rendez-vous**. El proceso emisor se autoinhibe y bloquea tras enviar el mensaje, y no recupera el estado listo hasta que el proceso receptor efectivamente toma el mensaje y procesa la transacción, logrando exclusión mutua sin banderas lógicas.

---

(09-concurrencia-6-monitores-la-solucion-desde-el-lenguaje-de-programacion)=

## 6. Monitores (la solución desde el lenguaje de programación)

Propuestos por C.A.R. Hoare en 1974, un **monitor** es una estructura de control de **alto nivel provista nativamente por el lenguaje de programación** (por ejemplo, Java con bloques `synchronized`, C#, Pascal Concurrente).

A diferencia de los semáforos, los monitores no abordan la concurrencia entre procesos independientes a un bajo nivel, sino el problema de la **manipulación segura de funciones, procedimientos o métodos concurrentes que comparten variables globales dentro de un mismo proceso**.

(09-concurrencia-6-1-propiedades-de-un-monitor)=

### 6.1. Propiedades de un monitor

- **Encapsulamiento (TAD - Tipo Abstracto de Datos)**: El monitor encapsula las variables y las estructuras de datos compartidas. Los datos privados son completamente invisibles para el exterior; la única forma legítima de acceder es invocando los métodos públicos definidos como puntos de entrada (_entry point_) del monitor.
- **Exclusión mutua automática por compilador**: El compilador del lenguaje garantiza de forma implícita que **solo un hilo o procedimiento puede estar ejecutando un método dentro del monitor en un instante dado**. Si un procedimiento intenta invocar un método del monitor mientras otro está adentro, el propio entorno del lenguaje lo suspende automáticamente en la cola de entrada del monitor, eliminando la prolijidad manual exigida por los semáforos.

(09-concurrencia-6-2-variables-de-condicion-internas)=

### 6.2. Variables de condición internas

Para permitir sincronizaciones complejas dentro del monitor sin bloquear el objeto completo, el lenguaje provee **variables de condición** (gestionadas internamente mediante flags lógicos propios del compilador) que implementan dos funciones dedicadas:

- `wait(condition_flag)`: Suspende inmediatamente la ejecución del procedimiento actual dentro del monitor, libera la exclusión mutua del monitor para que otra función pueda entrar, y coloca el hilo en una cola de espera asociada a esa condición específica.
- `signal(condition_flag)`: Despierta y reanuda de forma inmediata la ejecución de uno de los métodos o procedimientos que se encontraban suspendidos en la cola de esa variable de condición por un `wait` previo.
