# Sistemas empotrados

Refiere a la integración e introducción de electrónica y software dentro de un producto u objeto.

Formalmente, un sistema empotrado constituye una **combinación sinérgica de hardware, software y, eventualmente, componentes mecánicos**, diseñada específicamente para cumplir una **función única y acotada**. En la inmensa mayoría de los escenarios prácticos, estos sistemas no operan de forma aislada, sino que forman parte integrada de sistemas o productos considerablemente más grandes y complejos (por ejemplo, el módulo de inyección electrónica de un automóvil o el controlador de un marcapasos).

---

(13-sistemas-empotrados-1-caracteristicas-operativas-y-restricciones-de-diseno)=

## 1. Características operativas y restricciones de diseño

Los sistemas empotrados se diferencian drásticamente de los sistemas de cómputo de propósitos generales (como una PC o un servidor) por un conjunto de restricciones físicas y operativas normadas por su entorno de aplicación:

- **Comportamiento en tiempo real**: En una porción significativa de los sistemas empotrados, el procesamiento de los datos está sujeto a restricciones temporales estrictas. El sistema requiere computar los algoritmos y ejecutar las acciones correspondientes dentro de un **marco temporal restringido y predecible**.
- **Funcionamiento reactivo**: Operan de forma reactiva y orientada a eventos. El sistema permanece en espera hasta que tiene que **responder de forma inmediata a estímulos provenientes del mundo externo**. Estos eventos e impulsos son, por su naturaleza, completamente **asíncronos**.
- **Ubicación y variabilidad del contexto**: Estos dispositivos son notoriamente **ubicuos** (están presentes en todo tipo de entornos cotidianos, industriales, médicos y aeroespaciales). Como consecuencia directa, las características físicas, térmicas y eléctricas del contexto en el que se desenvolverán son enormemente variadas, lo que inyecta una gran variabilidad en sus requisitos de diseño y tolerancia a fallos.

---

(13-sistemas-empotrados-2-flexibilidad-del-kernel-e-interacciones-de-bajo-nivel)=

## 2. Flexibilidad del kernel e interacciones de bajo nivel

La especialización funcional de estos equipos permite simplificar o prescindir de estructuras que son mandatorias en los sistemas operativos tradicionales:

(13-sistemas-empotrados-2-1-subsistema-de-e-s-acotado)=

### 2.1. Subsistema de $E/S$ acotado

A diferencia de un sistema de propósito general que tiene que soportar una cantidad infinita y desconocida de periféricos "en caliente", la cantidad de dispositivos y sensores conectados a un sistema empotrado es **estrictamente reducida y fija**.

Por esta previsibilidad, **no siempre es necesario incorporar los drivers dentro del núcleo del sistema operativo**. Es una práctica sumamente frecuente que los drivers específicos de los sensores se compilen e incorporen directamente dentro del código de los propios programas de aplicación de usuario.

(13-sistemas-empotrados-2-2-relajacion-de-los-mecanismos-de-proteccion-de-hardware)=

### 2.2. Relajación de los mecanismos de protección de hardware

En una computadora común, el kernel tiene que implementar un aislamiento estricto (Modo Usuario vs. Modo Kernel y protección de memoria MMU) para evitar que programas defectuosos o maliciosos rompan el sistema.

- **El escenario empotrado**: Al ser sistemas dedicados a una sola tarea fija, usualmente poseen pocas o nulas dificultades relacionadas con la coexistencia de programas de terceros en desarrollo o defectuosos. Por lo tanto, las protecciones de hardware y las tablas de límites suelen ser poco necesarias.
- **Consecuencia**: Instrucciones de control de hardware que serían consideradas estrictamente **privilegiadas** en un sistema operativo de propósito general, **no lo son en los sistemas empotrados**, permitiendo que el programa de aplicación interactúe con los registros del chip sin la penalización temporal de una llamada al sistema (_system call_).

(13-sistemas-embebidos-2-3-gestion-directa-de-interrupciones)=

### 2.3. Gestión directa de interrupciones

Tanto por razones de **simplicidad en el diseño del código**, como por motivos de **eficiencia temporal** (minimizar la latencia ante un evento crítico), es habitual que los programas de los sistemas empotrados **manipulen y atiendan las interrupciones de hardware directamente**, puenteando o anulando por completo la intervención e intermediación del sistema operativo.

---

(13-sistemas-embebidos-3-filosofia-de-desarrollo-del-software-empotrado)=

## 3. Filosofía de desarrollo del software empotrado

La remoción de los mecanismos de protección de bajo nivel y el acceso directo al hardware solo son viables bajo una condición estricta: **el entorno de aplicación tiene que ser altamente seguro y controlado**. Por este motivo, los desarrollos de software para sistemas empotrados se rigen bajo una filosofía de ingeniería de software con las siguientes propiedades:

1. **Procesos de ingeniería rigurosa**: Se implementa un diseño de código sumamente cuidado acompañado de **procesos de prueba y validación extremadamante exigentes** (como pruebas de cobertura estricta y simulación de fallos en lazo cerrado).
2. **Inmutabilidad del firmware**: El ciclo de vida del producto asume que existirá una **escasa o nula modificación del software a lo largo de toda su vida útil**. El programa se graba en memorias ROM o flash de solo lectura y raramente recibe actualizaciones o parches en frío.

---

(13-sistemas-embebidos-4-panorama-de-los-sistemas-operativos-empotrados)=

## 4. Panorama de los sistemas operativos empotrados

La arquitecturas del software de control evolucionaron históricamente siguiendo dos grandes tendencias:

(13-sistemas-embebidos-4-1-ejecucion-sin-sistema-operativo)=

### 4.1. Ejecución sin sistema operativo (_bare metal_)

Históricamente, muchos sistemas empotrados fueron construidos, y en el presente siguen construyéndose, **sin la utilización de ningún sistema operativo**. El programa de aplicación toma el control absoluto del procesador desde el vector de _reset_. Esta decisión estuvo fuertemente influenciada por las drásticas limitaciones de hardware del equipamiento utilizado (procesadores de $8 \text{ b}$ con escasos bytes de memoria RAM donde el _overhead_ de un kernel era inaceptable).

(13-sistemas-embebidos-4-2-inclusion-de-sistemas-operativos-dedicados-y-adaptados)=

### 4.2. Inclusión de sistemas operativos dedicados y adaptados

A medida que los microcontroladores ganaron potencia y complejidad (arquitecturas de 32 y 64 bits modernos), la presencia de sistemas operativos en este dominio se volvió **notablemente difundida**.

Para instrumentarlo, la industria aplicó dos caminos diferenciados:

1. **Sistemas operativos de tiempo real dedicados (_RTOS_)**: Microkernels compactos diseñados desde cero para garantizar determinismo y predictibilidad temporal absolito (por ejemplo, FreeRTOS, VxWorks, QNX).
2. **Adaptaciones de sistemas operativos de propósito general**: Consiste en tomar kernels comerciales monolíticos y aplicarles reingeniería y parches de tiempo real para embeberlos en el hardware. Esta experiencia se llevó a la práctica masivamente con Linux, pero también se replicó utilizando núcleos de tipo Windows y derivados de BSD, entre otros.
