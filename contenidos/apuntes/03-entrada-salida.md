# Subsistema de entrada y salida

El subsistema de entrada/salida ($E/S$) es uno de los componentes más complejos de un sistema operativo debido a la heterogeneidad intrínseca de los periféricos y, fundamentalmente, a la **extrema diferencia en sus velocidades de transferencia**. El desafío del hardware y del software consiste en mitigar el impacto de este cuello de botella sobre el rendimiento de la CPU.

---

(03-entrada-salida-1-perfil-de-velocidades-de-transferencia-tipicas)=

## 1. Perfil de velocidades de transferencia típicas

Las tasas de transferencia varían de forma drástica según la naturaleza del dispositivo:

- **Dispositivos de almacenamiento masivo (discos con buffer)**: $\approx 12000000 \text{ bytes/seg}$.
- **Impresoras láser (con buffer)**: $\approx 1300000 \text{bytes/seg}$.
- **Impresoras de líneas (sin buffer)**: $\approx 150000 \text{bytes/seg}$.
- **Impresoras de caracteres (sin buffer)**: $\approx 2400 \text{bytes/seg}$.
- **Dispositivos de interacción humana**:
  - **Mouse**: $\approx 110 \text{ bytes/seg}$.
  - **Teclado**: $\approx 80 \text{ bytes/seg}$.
  - **Velocidad de digitación de un usuario**: $\approx 3 \text{ bytes/seg}$.

(03-entrada-salida-2-direccionamiento-y-distincion-de-operaciones-de-e-s)=

---

## 2. Direccionamiento y distinción de operaciones de $E/S$

En arquitectura basadas en un único bus compartido, el hardware tiene que implementar una estrategia para diferenciar si una dirección emitida por la CPU corresponde a una celda de la memoria RAM o a los registros de control de un periférico. Existen dos soluciones clásicas:

- **$E/S$ mapeada en memoria (reservar direcciones)**: Consiste en asignar una porción del mapa de direccionamiento global exclusivamente a los dispositivos de $E/S$. La CPU utiliza las mismas instrucciones de lectura y escritura (por ejemplo, `MOV` o `LOAD/STORE`) tanto para la memoria como para los periféricos.
- **$E/S$ aislada (líneas de control diferentes)**: El procesador dispone de líneas de control físicas específicas en el bus para indicar si el acceso es a memoria o a $E/S$ (por ejemplo, una línea $M/\overline{IO}$). Requiere instrucciones de software dedicadas en el juego de la CPU (como `IN` y `OUT` en arquitecturas x86).

---

(03-entrada-salida-3-formas-clasicas-de-realizar-operaciones-de-e-s)=

## 3. Formas clásicas de realizar operaciones de $E/S$

Existen tres metodologías de transferencia fundamentales que determinan la carga de trabajo que soporta el procesador:

(03-entrada-salida-3-1-e-s-en-espera-escrutinio-o-polling)=

### 3.1. $E/S$ en espera (escrutinio o _polling_)

Es el método más rudimentario. El periférico dispone de un registro de estado para indicar que está listo para recibir un dato, para procesar un pedido de lectura, o para señalar que el dato solicitado ya se encuentra disponible.

- **Mecanismo**: La CPU ejecuta un bucle cerrado consultando continuamente el registro de estado del dispositivo hasta que este cambie.
- **Impacto**: Produce un desperdicio absoluto de ciclos de procesamiento, ya que la CPU no puede realizar ninguna otra tarea mientras dure la sincronización con el periférico.

(03-entrada-salida-3-2-por-interrupciones)=

### 3.2. $E/S$ por interrupciones

Para evitar la espera activa, se delega la temporización en el hardware. Cuando el periférico está en condiciones de recibir un nuevo dato o ya tiene listo el dato previamente solicitado, genera de forma asíncrona una interrupción a la CPU.

- **Si es una operación de escritura**: La rutina del sistema operativo entrega el siguiente dato al buffer del periférico y la CPU retoma inmediatamente el hilo de ejecución donde se encontraba.
- **Si es una operación de lectura**: La rutina lee el dato del registro del periférico, lo almacena en la RAM y, de ser necesario, ordena de forma inmediata una nueva lectura para mantener el flujo de datos.

(03-entrada-salida-3-3-acceso-directo-a-memoria-dma-direct-memory-access)=

### 3.3. Acceso directo a memoria (_DMA - Direct Memory Access_)

Para dispositivos de alta velocidad, interrumpir la CPU por cada byte transferido degrada el rendimiento de forma inaceptable. El mecanismo de DMA mitiga esto: la CPU no accede directamente al periférico, sino que delega la tarea a un componente de hardware especializado llamado **controlador de DMA (_DMAC - Direct Memory Access Controller_)** y se desentiende por completo de la transferencia física byte a byte.

---

(03-entrada-salida-4-funcionamiento-detallado-del-dma)=

## 4. Funcionamiento detallado del DMA

(03-entrada-salida-4-1-ambito-de-aplicacion)=

### 4.1. Ámbito de aplicación

El DMA es mandatorio en periféricos que manejan altos volúmenes de datos en ráfagas rápidas:

- Controladores de discos.
- Interfaces gráficas (tarjetas de video).
- Interfaces de red (tarjetas Ethernet o Wi-Fi).
- Plaquetas de sonido de alta fidelidad.
- Copias masivas de datos de **memoria a memoria**.

(03-entrada-salida-4-2-flujo-de-la-operacion)=

### 4.2. Flujo de la operación

1. **Configuración e inicio**: La CPU configura al DMAC como si fuera un periférico común, utilizando esquemas **en espera** o **por interrupciones**. Le provee la información crítica: dirección de la zona de memoria RAM a leer/escribir, la sección del periférico involucrada (como bloques de disco), la cantidad de bytes a transferir y, opcionalmente, qué dispositivo específico está afectado si maneja múltiples periféricos.
2. **Transferencia autónoma**: Una vez inicializado, los datos se transfieren directamente entre el periférico y la memoria principal sin ninguna intervención de la CPU.
3. **Finalización**: Al completar la transferencia total del bloque, el DMAC genera una única interrupción de hardware hacia la CPU para notificar que el proceso concluyó con éxito.

---

(03-entrada-salida-5-competencia-por-el-bus-del-sistema)=

## 5. Competencia por el bus del sistema

Dado que tanto el DMAC como la CPU tienen que acceder a la memoria principal utilizando las mismas líneas físicas del **bus del sistema**, se genera una competencia inevitable por su control. Esta contención se resuelve mediante dos políticas de arbitraje principales:

(03-entrada-salida-5-1-robo-de-ciclos-cycle-stealing)=

### 5.1. Robo de ciclos (_cycle stealing_)

El DMAC tiene la facultad de suspender temporalmente el acceso de la CPU al bus del sistema para intercalar la transferencia de un dato.

- **Señales de arbitraje**: Habitualmente requiere el uso de dos señales físicas dedicadas: `BUS Request` (el DMAC solicita tomar el control) y `BUS Grant` (la CPU concede el bus tras terminar su ciclo actual).
- **Impacto con memoria caché**: Si la CPU dispone de memoria caché interna y encuentra ahí las instrucciones/datos necesarios, la degradación de su rendimiento es casi nula, ya que ejecuta internamente mientras el DMAC usa el bus externo.
- **Impacto sin memoria caché**: Si no hay caché, la CPU se detiene por completo mientras dure el robo de ciclo del DMAC, provocando una degradación notable en la velocidad de procesamiento de las instrucciones.

(03-entrada-salida-5-2-deteccion-de-ocupacion-del-bus-modo-transparente)=

### 5.2. Detección de ocupación del bus (modo transparente)

En esta variante, el DMAC opera de manera "invisible". No interrumpe a la CPU, sino que monitorea el bus y aprovecha únicamente los instantes específicos en los que **la CPU informa formalmente que no va a hacer uso del bus externo** (porque se encuentra realizando una fase puramente interna de decodificación o ejecución). Las señales `BUS Request` y `BUS Grant` pueden reconfigurarse para este propósito de detección.

- **Con caché**: Alta velocidad de $E/S$, dado que la CPU pasa mucho tiempo ejecutando desde su caché interna, dejando el bus externo libre para el DMAC.
- **Sin caché**: Baja velocidad de $E/S$, porque las ventanas de tiempo en las que la CPU libera el bus de forma natural son sumamente escasas.

---

(03-entrada-salida-6-el-impacto-del-cache-la-frecuencia-y-el-pipeline)=

## 6. El impacto del caché, la frecuencia y el pipeline

La relación matemática entre las frecuencias de reloj evidencia la criticidad de la optimización del hardware:

- **Frecuencia típica de la CPU**: $2 \text{ a }3 \text{ GHz}$.
- **Frecuencia típica del bus**: $100 \text{ MHz}$.
- **Relación de velocidades**: $\approx 30 \text{ a } 1$.

Esta brecha temporal se conoce históricamente como el **cuello de botella de Von Neumann**. El impacto de ocupar el bus durante un solo ciclo para una operación de DMA varía drásticamente según la arquitectura interna:

(03-entrada-salida-6-1-arquitectura-sin-memoria-cache)=

### 6.1. Arquitectura sin memoria caché

Las fases de ejecución típicas de una instrucción con referencia a memoria son sumamente dependientes del bus externo:

- **Fetch (captura)**: Utiliza el bus para traer la instrucción desde la RAM ($2 \text{ns} \times 10 \text{ns} = 49 \%$ del tiempo total).
- **Decode (decodificación)**: Proceso interno de la CPU que no utiliza el bus ($2 \text{ns} \times 0.5 \text{ns} = 2 \%$ del tiempo total).
- **Execute (ejecución)**: Utiliza el bus para leer o escribir operandos en la RAM ($2 \text{ns} \times 10 \text{ns} = 49 \%$ del tiempo total).

:::{admonition} Consecuencia
:class: attention
Si el DMAC ocupa el bus durante un ciclo, **demora entre el $24 \%$ y el $50 \%$ de la ejecución de una sola instrucción** de la CPU.
:::

(03-entrada-salida-6-2-arquitectura-con-memoria-cache)=

### 6.2. Arquitectura con memoria caché

Cuando todas las instrucciones y datos se encuentran pre-cargados en la caché, los tiempos cambian drásticamente y ninguna de las fases ordinarias requiere el bus del sistema:

- **Fetch (captura)**: Interno de la caché ($4 \text{ns} \times 0.5 \text{ns} = 40 \%$).
- **Decode (decodificación)**: Interno a la CPU ($2 \text{ns} \times 0.5 \text{ns} = 20 \%$).
- **Execute (ejecución)**: Interno a la caché/CPU ($4 \text{ns} \times 0.4 \text{ns} = 20 \%$).

:::{admonition} Ventaja
:class: attention
Si el DMAC ocupa un ciclo de bus externo, la CPU no se entera; de hecho, **puede ejecutar fluidamente entre $2$ y $3$ instrucciones** de forma interna simultáneamente.
:::

(03-entrada-salida-6-3-el-factor-pipeline-segmentacion-de-instrucciones)=

### 6.3. El factor pipeline (segmentación de instrucciones)

La existencia de una estructura en _pipeline_ agrega una competencia crítica por el bus. Dado que la CPU intenta solapar las fases de Fetch, Decode y Execute de múltiples instrucciones de forma continua, el bus se encuentra constantemente demandado. En sistemas que poseen **pipeline pero carecen de caché, prácticamente no queda espacio de tiempo libre** para aplicar técnicas de detección de ocupación de bus por el DMA de forma transparente.

---

(03-entrada-salida-7-consideraciones-avanzadas-de-arquitectura-de-e-s)=

## 7. Consideraciones avanzadas de arquitectura de $E/S$

(03-entrada-salida-7-coherencia-con-el-cache)=

### 7.1. Coherencia con el caché

Cuando el DMAC realiza una escritura directa sobre una dirección de la memoria principal, las celdas equivalentes que se encuentran copiadas dentro de la memoria caché de la CPU quedan desactualizadas, perdiendo la integridad de los datos. Existen dos formas de resolver esta incoherencia:

1. **Hardware de fisneo del bus (_bus snooping_)**: La propia controladora de la caché monitorea de forma constante los accesos del DMAC al bus; si detecta una escritura en una dirección que posee guardada, invalida de forma automática su copia interna o la actualiza al instante.
2. **Gestión por sistema operativo**: El kernel se encarga de invalidar explícitamente mediante software las líneas de caché afectadas antes de permitir que la CPU lea las zonas de memoria que acaban de ser modificadas por el DMA.

(03-entrada-salida-7-2-soporte-multidispositivo)=

### 7.2. Soporte multidispositivo

Un controlador de DMA robusto usualmente dispone de la capacidad lógica de **manipular y coordinar más de un periférico de forma simultánea**, administrando canales de prioridad interna.

(03-entrada-salida-7-3-estructuras-de-almacenamiento-intermedio-buffers-y-adaptadores)=

### 7.3. Estructuras de almacenamiento intermedio (buffers y adaptadores)

- **Buffers en controladores**: Los controladores de dispositivos complejos (como los de disco) incorporan su propia memoria física interna (que oscila típicamente entre **$8$ MB y $4$ GB**) para resguardar los datos de forma provisoria antes de realizar la escritura física en los platos o después de una lectura masiva.
- **Bus adapters y controllers**: Los adaptadores intermedios de bus también suelen incorporar memorias caché y buffers propios para optimizar el rendimiento y adaptar las velocidades antes de volcar la información al bus principal.

(03-entrada-salida-7-4-memoria-de-puerto-dual-dual-port-memory)=

### 7.4. Memoria de puerto dual (_Dual Port Memory_)

La solución física definitiva al problema de la competencia por el bus consiste en la utilización de **memorias de puerto dual**. Estas memorias poseen una lógica interna duplicada que les permite **atender de forma simultánea dos operaciones independientes**: una solicitada por la CPU y otra gestionada directamente por el hardware de DMA, eliminando por completo la contención sobre el bus del sistema y erradicando los retrasos por arbitraje.
