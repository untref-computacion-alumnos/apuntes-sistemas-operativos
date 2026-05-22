# Mecanismos de control del hardware

Para que un sistema operativo moderno pueda gestionar de forma segura y eficiente la multiprogramación, el tiempo compartido y el tiempo real, requiere de mecanismos de hardware que le permitan retomar el control del procesador ante determinados eventos. Estos mecanismos se dividen fundamentalmente en **asíncronos** (provenientes del hardware externo) y **síncronos** (originados por la propia ejecución de instrucciones).

---

(02-sistemas-operativos-1-interrupciones-hardware-interrupts)=

## 1. Interrupciones (_hardware interrupts_)

Una interrupción es un mecanismo de hardware asíncrono mediante el cual un dispositivo periférico o un componente interno (como un temporizador) envía una señal a la CPU para indicarle que requiere atención inmediata. Al recibirla, la CPU detiene temporalmente la ejecución del programa actual, salva su contexto y ejecuta una rutina específica del kernel denominada **rutina de servicio de interrupcion (_ISR - Interrupt Service Routine_)**.

El rol y la naturaleza de las interrupciones evolucionaron y se complejizaron junto con los modelos de ejecución:

(02-sistemas-operativos-1-1-el-esquema-en-sistemas-operativos-batch-procesamiento-por-lotes)=

### 1.1. El esquema en sistemas operativos batch (procesamiento por lotes)

En estos sistemas, las interrupciones están vinculadas casi exclusivamente a la optimización de las operaciones de entrada/salida. El esquema básico de funcionamiento es el siguiente:

1. **La CPU ordena la operación**: El procesador emite una directiva al controlador del periférico para iniciar la transferencia de datos y queda libre para realizar otras tareas.
2. **El periférico procesa de forma autónoma**: El dispositivo realiza la operación de forma independiente y sumamente lenta en comparación con la velocidad de la CPU.
3. **Notificación de finalización**: Una vez que la operación concluye con éxito (o falla), el periférico avisa a la CPU mediante el envío de una interrupción.

(02-sistemas-operativos-1-2-incorporaciones-en-sistemas-de-tiempo-compartido-time-sharing)=

### 1.2. Incorporaciones en sistemas de tiempo compartido (_time-sharing_)

A la gestión de entrada/salida tradicional se le agrega una interrupción crítica: **la interrupción del timer**. El hardware genera interrupciones periódicas que definen la base de tiempo o "cuanto" (_quantum_). Esto le permite al planificador de corto plazo del sistema operativo forzar un **cambio de contexto (_context switch_)** para desalojar al proceso actual de la CPU y dársela a otro, garantizando la interactividad del sistema.

(02-sistemas-operativos-1-3-incorporaciones-en-sistemas-de-tiempo-real-real-time)=

### 1.3. Incorporaciones en sistemas de tiempo real (_real-time_)

En los entornos de tiempo real, la predictibilidad ante eventos externos es vital. Por eso, se acoplan interrupciones vinculadas directamente a sensores y periféricos del mundo físico o de telecomunicaciones, tales como:

- Dispositivos de comunicación de alta velocidad.
- Entradas y lecturas de variables del mundo externo.
- Sistemas de seguridad perimetral (por ejemplo, alarma de intrusión).
- Automatización de transporte y logística (por ejemplo, arribo de un tren a la plataforma).
- Control industrial y de telemetría (por ejemplo, confirmación del cierre de una compuerta).

(02-sistemas-operativos-1-4-acciones-del-sistema-operativo-ante-una-instruccion)=

### 1.4. Acciones del sistema operativo ante una instrucción

Dependiendo del origen de la señal, el kernel toma diferentes caminos de acción:

- **Interrupciones internas del sistema (periféricos/timer)**: Solo involucran tareas administrativas dentro del propio sistema operativo. Sus acciones típicas son:
  - Continuar o encadenar una nueva operación de entrada/salida si la transferencia actual no se completó en su totalidad.
  - Evaluar las colas de listos y ejecutar un **cambio de contexto (_context switch_)** si el cuanto de tiempo del proceso expiró o si un proceso bloqueado de mayor prioridad pasó a estar listo.
- **Interrupciones del mundo externo (tiempo real)**: Generalmente disparan una urgencia que rompe el flujo planificado, involucrando la instanciación o el **comienzo inmediato de la ejecución de un proceso nuevo** diseñado específicamente para atender dicho evento.

---

(02-sistemas-operativos-2-traps)=

## 2. Traps

A diferencia de las interrupciones de hardware (que son asíncronas y externas), los traps son interrupciones síncronas generadas internamente por la propia CPU como consecuencia directa de la ejecución de la instrucción en curso.

Se pueden clasificar en dos grandes grupos según su naturaleza:

(02-sistemas-operativos-2-1-traps-por-errores-de-ejecucion)=

### 2.1. Traps por errores de ejecución

Pasan cuando el hardware detecta que una instrucción de usuario trata de realizar una operación inválida o matemáticamente imposible. El procesador interrumpe el programa y transfiere el control al sistema operativo para que tome medidas correctivas (habitualmente abortar el proceso emitiendo un volcado de memoria o _core dump_). Algunos ejemplos típicos son:

- **División por cero**: Intento de ejecutar un flujo aritmético indeterminable.
- **Instrucción inexistente/inválida**: El decodificador de la CPU encuentra un código de operación (_opcode_) que no pertenece al juego de instrucciones de la arquitectura.
- **Overflow/Underflow**: Operaciones matemáticas cuyos resultados exceden los límites máximos o mínimos representables por los registros de la CPU.

```{admonition} NOTA
---
class: note
---
Las violaciones de acceso a memoria (como un _page fault_ o un fallo de protección de segmento) también entran en esta categoría de traps de hardware.
```

(02-sistemas-operativos-2-2-traps-voluntarios-por-llamada-al-sistema)=

### 2.2. Traps voluntarios por llamadas al sistema

Es el mecanismo por el cual un programa en Modo Usuario genera deliberadamente un trap (mediante una instrucción de software dedicada, como `INT`, `SYSCALL` o `SYSENTER`) para pasar al Modo Kernel de forma controlada y solicitarle un servicio al sistema operativo.

---

(02-sistemas-operativos-3-clocks-y-timers)=

## 3. Clocks y timers

Un sistema de computación moderno no posee una única referencia temporal, sino que conviven numerosas bases de tiempo con órdenes de magnitud marcadamente disímiles para cumplir propósitos de sincronización de silicio o de plainificación de software:

| Denominación                 | Valor/Período Típico              | Naturaleza y Función Principal                                                                                                                                                                    |
| ---------------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Clock de la CPU              | "0,3 nseg (0,3×10−9 seg)"         | Determinado por el cristal de cuarzo del procesador. Sincroniza los ciclos de ejecución internos de las compuertas lógicas y las microinstrucciones +                                             |
| Clock del BUS                | 10 nseg (10×10−9 seg)             | Sincroniza la transferencia de datos e instrucciones entre la CPU, la memoria caché, la memoria RAM y los controladores de la placa madre                                                         |
| Clock del Sistema Operativo  | 10 mseg (10×10−3 seg)             | Es el intervalo regular (pulso de reloj del sistema o tick) en el cual el hardware interrumpe a la CPU para cederle el control al kernel. Define la unidad de asignación de tiempo a los procesos |
| Timers del Sistema Operativo | Arbitrario (Definido por demanda) | Estructuras de software o contadores de hardware configurados para alertar sobre eventos específicos tras transcurrir un lapso determinado                                                        |

(02-sistemas-operativos-3-1-diferencia-conceptual-entre-clock-y-timer)=

### 3.1. Diferencia conceptual entre clock y timer

- **Clock (reloj)**: Se refiere a un oscilador de hardware que genera pulsos de onda cuadrada de forma constante, fija y periódica para mantener la asincronía del sistema.
- **Timer (temporizador)**: Se reserva esta denominación de forma estricta cuando la duración del período puede ser modificada programáticamente mediante software.

En las arquitecturas modernas, el componente físico que general el clock del sistema operativo es, de hecho, un dispositivo temporizador programable. Esto permite que el kernel configure de forma dinámica y por software cuántos milisegundos durará la ráfaga de tiempo asignada a cada proceso antes de que se dispare de forma mandatoria la interrupción de hardware.
