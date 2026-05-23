# Fundamentos de administración de memoria y arquitecturas de asignación

La administración de la memoria central es una tarea co-gestionada de forma indisoluble entre el software y el hardware. Toda estrategia omplementada por el sistema operativo requiere, de forma obligatoria, de un mecanismo físico de apoyo en el procesador. Existe una relación directa y casi unívoca entre las estrategias de asignación de memoria y las arquitecturas de las computadoras que las soportan.

(06-administracion-de-memoria-1-operaciones-de-alteracion-de-direcciones-en-la-mmu)=

## 1. Operaciones de alteración de direcciones en la MMU

La **Unidad de Gestión de Memoria (_MMU - Memory Management Unit_)** es el componente de hardware que se interpone entre la CPU y la memoria RAM física. Mientras que la CPU opera con **direcciones lógicas (o virtuales)**, la MMU las transforma en **direcciones físicas reales** en el bus de memoria.

Para lograr esto, la MMU aplica seis transformaciones u operaciones fundamentales:

(06-administracion-de-memoria-1-1-desplazamiento-relocalizacion-dinamica)=

### 1.1. Desplazamiento (relocalización dinámica)

La CPU ejecuta una instrucción que hace referencia a una dirección lógica, pero la MMU altera dinámicamente el valor sumándole un registro base, accediendo a una celda física distinta.

(06-administracion-de-memoria-1-1-1-ejemplo)=

#### 1.1.1. Ejemplo

Si el registro de desplazamiento se configura en `50000`, las instrucciones lógicas emitidas por la CPU se transforman en el bus físico:

$$
\text{CPU: } \texttt{MOV R1, 2FA09} \longrightarrow \text{MMU Físico: } \texttt{MOV R1, 7FA09} \quad (2\text{FA09} + 50000) \text{}
$$

$$
\text{CPU: } \texttt{ADD R1, 301E4} \longrightarrow \text{MMU Físico: } \texttt{ADD R1, 801E4} \quad (301\text{E4} + 50000) \text{}
$$

(06-administracion-de-memoria-1-2-limites-proteccion-de-memoria)=

### 1.2. Límites (protección de memoria)

La MMU actúa como un guardián impidiendo que las direcciones generadas por la CPU excedan un rango preestablecido (delimitado por registros de límite inferior y superior), garantizando la exclusión mutua entre procesos.

(06-administracion-de-memoria-1-2-1-ejemplo)=

#### 1.2.1. Ejemplo

Con límites fijados por el hardware entre `00000` y `2FFFF`:

- `MOV R1, 2FA09`: Se ejecuta normalmente (está dentro del rango).
- `ADD R1, 301E4`: La MMU bloquea la operación y genera un _trap_ por violación de acceso antes de tocar la RAM.

(06-administracion-de-memoria-1-3-ocultamientos-bank-switching)=

### 1.3. Ocultamientos (_bank switching_)

Ciertos fragmentos o bloques de la memoria física instalada se vuelven invisibles o visibles para la CPU según las necesidades del sistema.

- **Mecanismo**: Permite mapear dos bloques físicos distintos ($A$ y $B$) bajo el mismo rango de direcciones lógicas (por ejemplo, `00000` a `3FFFF`). Una instrucción como `MOV R1, 2FA09` accederá al bloque $A$ o al $B$ dependiendo de cuál esté activo por software.

(06-administracion-de-memoria-1-4-expansion)=

### 1.4. Expansión

Ocurre cuando la cantidad de líneas de dirección que llegan a la MMU (desde la CPU) es **menor** que la cantidad de líneas físicas que salen de ella hacia la RAM. El espacio de direccionamiento lógico de la CPU es más chico que la memoria RAM física real que la MMU puede direccionar.

(06-administracion-de-memoria-1-5-compresion)=

### 1.5. Compresión

Ocurre cuando la cantidad de líneas de dirección lógicas de la CPU es **mayor** que las líneas físicas que salen de la MMU hacia la placa madre. El procesador ve un espacio potencial gigantesco pero la memoria física contectada es inferior.

(06-administracion-de-memoria-1-6-dispersion)=

### 1.6. Dispersión

La CPU ve y ejecuta instrucciones sobre un conjunto de direcciones lógicas contiguas, pero la MMU fragmenta y transforma dichas direcciones en bloques físicos distribuidos de forma **no contigua** a lo largo de la memoria RAM.

| Dirección Lógica (CPU)  | Dirección Física (MMU)  |
| ----------------------- | ----------------------- |
| 0A243 (Bloque Contiguo) | 2A243 (Disperso en RAM) |
| 0BAA4 (Bloque Contiguo) | 2BAA4 (Disperso en RAM) |
| 10662 (Bloque Contiguo) | 00662 (Disperso en RAM) |

(06-administracion-de-memoria-2-flexibilidad-del-software-y-la-falacia-del-tamanio-fijo)=

## 2. Flexibilidad del software y la "Falacia del tamaño fijo"

Históricamente, se analizaban los esquemas de memoria asumiendo que los programas tenían un tamaño estático e invariable. Esta premisa constituye la **falacia del tamaño fijo**, cuya validez depende exclusivamente del tipo de lenguaje de programación ejecutado:

- **Lenguajes estáticos (por ejemplo, FORTRAN, COBOL)**: El tamaño del código, las variables y los datos se determinan por completo en tiempo de compilación. No cambian durante la ejecución.
- **Lenguajes tipo Algol (por ejemplo, C, C++, Java, Rust, Go)**: El tamaño del código es fijo, pero las necesidades de memoria varían dinámicamente por el uso de la pila (_stack_) para funciones recursivas y del montículo (_heap_) para variables dinámicas.
- **Lenguajes dinámicos (por ejemplo, LISP, Python, Ruby, Perl, JavaScript)**: Absolutamente todo es variable. Las estructuras de datos, los objetos y el propio código en memoria mutan de tamaño segundo a segundo.

```{admonition} Impacto del entorno moderno
---
class: note
---
Cualquier programa escrito en un lenguaje dinámico o tipo Algol puede correr perfectamente hasta que, ante un nuevo juego de datos y **sin ninguna indicación previa, falla catastróficamente por falta de memoria**.
```

Esta variabilidad se ve acentuada en la actualidad por dos tecnologías clave:

1. **Vinculación dinámica (_dynamic linking_)**: El tamaño del ejecutable puede alterarse en tiempo de ejecución al cargar librerías externas compartidas (`.dll` en Windows o `.so`/`.elf` en Linux) o plugins adicionales.
2. **Compilación en tiempo de ejecución (_JIT - Just-In-Time_)**: Las máquinas virtuales (como la JVM o V8) interpretan el código pero, al detectar zonas críticas, el compilador JIT traduce bytecode a código de máquina nativo dinámicamente y lo inyecta en la RAM, haciendo que el consumo del propio ejecutable sea totalmente variable impredecible.

---

```{admonition} Conclusión
---
class: important
---
Cualquier análisis estricto sobre el impacto de la **fragmentación interna** en una estrategia de administración de memoria es correcto para lenguajes estáticos, pero resulta **altamente dudoso y cuestionable** en los sistemas actuales dominados por lenguajes dinámicos y entornos virtuales.
```

---

(06-administracion-de-memoria-3-tipos-clasicos-de-administracion-de-memoria)=

## 3. Tipos clásicos de administración de memoria

(06-administracion-de-memoria-3-1-memoria-plana)=

### 3.1. Memoria plana

- **Mecanismo**: Es el esquema más rudimentario. **No existe MMU** ni alteración de direcciones. La memoria física conectada puede ser menor que el espacio máximo de direccionamiento de la CPU.
- **Impacto**: No provee exclusión mutua ni protección entre procesos. Coexisten tanto fragmentación interna como externa.
- **Solución a la falta de espacio**: Obliga a los programadores a diseñar **overlays** (superposiciones), implementando swaps parciales por software de fragmentos de código dentro de una misma zona de memoria de forma manual.

(06-administracion-de-memoria-3-2-bancos-de-memoria-bank-switching)=

### 3.2. Bancos de memoria (_bank switching_)

- **Mecanismo**: La memoria se divide en bloques físicos o bancos. **La MMU no realiza alteración de direcciones aritméticas**, sino que activa de forma exclusiva un banco completo por proceso.
- **Impacto**: Excelente exclusión mutua. Suele reservarse un banco exclusivo para el sistema operativo. No requiere relocalización por el cargador (los programas se compilan para la dirección efectiva del banco). Al ser bloques rígidos, si un proceso excede el tamaño del banco, se incrementa críticamente el riesgo de cancelación, forzando nuevamente el uso de _overlays_.

(06-administracion-de-memoria-3-3-particiones-fijas)=

### 3.3. Particiones fijas

- **Mecanismo**: La memoria fija se divide estáticamente al arrancar el sistema en particiones que suelen ser de tamaños disímiles. La MMU tiene registrados estos límites de forma rígida.
- **Impacto**: Existe compresión de direcciones y el hardware exige saber qué partición está activa para aplicar los límites de exclusión mutua. El sistema operativo ocupa una partición pero conserva el derecho de acceder a toda la memoria. **La MMU no altera direcciones**, por lo que el programa requiere que el **cargador (_loader_) realice una reubicación estática** modificando las instrucciones en el momento de la carga.

(06-administracion-de-memoria-3-4-particiones-dinamicas)=

### 3.4. Particiones dinámicas

- **Mecanismo**: Los límites de las particiones son elegidos y modificados bajo demanda por el sistema operativo, amoldando con exactitud el tamaño de la partición al tamaño del proceso en el momento de su instanciación.
- **Variantes**:
  1. La partición se crea a la medida del proceso pero después permanece inmutable.
  2. La partición es dinámica y permite cambiar su tamaño en tiempo de ejecución (el proceso puede solicitar una ampliación si se queda sin espacio).
- **Impacto**: Disminuye drásticamente la necesidad de usar _overlays_ y optimiza la fragmentación interna, pero la continua creación y destrucción de procesos genera **fragmentación externa** (huecos vacíos dispersos en la RAM).

(06-administracion-de-memoria-3-5-segmentacion-externa)=

### 3.5. Segmentación externa

- **Mecanismo**: Evolución de las particiones dinámicas. Suma la **alteración automática de direcciones por parte de la MMU**. Se denomina "externa" porque **la CPU y el programador ignoran su existencia**; el programa piensa que corre en la dirección cero.
- **Impacto**: Evita que el _loader_ tenga que reubicar las instrucciones sumándoles la dirección de inicio en el disco, ya que la MMU hace el desplazamiento por hardware en cada ciclo.
- **El problema del costo temporal**: Al igual que en las particiones dinámicas, la memoria se llema de huecos de fragmentación externa. Para resolver esto, el kernel tiene que realizar una **compactación de memoria**, un proceso con un costo temporal masivo ya que implica detener el sistema y mover físicamente megabytes o gigabytes de datos en la RAM para agrupar los bloques libres.

---

(06-administracion-de-memoria-4-el-problema-de-la-reubicacion-relocalizacion)=

## 4. El problema de la reubicación (relocalización)

Cuando un sistema carece de una MMU con registro de desplazamiento automático, las instrucciones de código que hacen referencia explícita a una celda de memoria (por ejemplo, `MOV R1, 2FA09` o `JMP 2E014`) representan un problema crítico si el programa no se carga exactamente en la dirección para la cual fue compilado.

- **El formato reubicable**: El compilador y el linker no generan un ejecutable puro. Guardan el programa acompañado de una tabla que indexa cada una de las instrucciones que hacen referencia a una dirección de memoria.
- **La tarea del loader**: Al cargar el programa en una dirección base determinada (por ejemplo, dirección `10000`), el cargador (_loader_) tiene que recorrer la lista y alterar físicamente el código binario sumándole la dirección de comienzo a cada instrucción afectada.
- **Agravamiento por _swapping_**: Si el proceso es expulsado al disco por el planificador y, al retornar, la memoria original está ocupada, el proceso tiene que reubicarse en una dirección base distinta. Si la relocalización fue estática (por el _loader_), reubicar el proceso "en caliente" es una tarea sumamente compleja y costosa.

---

(06-administracion-de-memoria-5-algoritmos-de-asignacion-de-espacio-libre)=

## 5. Algoritmos de asignación de espacio libre

Cuando el kernel administra particiones dinámicas o segmentos externos, tiene que elegir qué hueco libre asignar a un proceso nuevo. Los algoritmos clásicos son:

- **First fit (primer ajuste)**: Recorre la lista de bloques desde el inicio y asigna el primer hueco disponible que sea lo suficientemente grande. Es rápido en ejecución.
- **Next fit (siguiente ajuste)**: Similar a _First fit_, pero inicia la búsqueda desde el punto donde se hizo la última asignación, distribuyendo de forma más homogénea los bloques.
- **Best fit (mejor ajuste)**: Recorre toda la lista buscando el hueco cuyo tamaño se aproxime al máximo requerido por el proceso. Minimiza el desperdicio inmediato pero genera micro-huecos inutilizables.
- **Worst fit (peor ajuste)**: Elige deliberadamente el hueco más grande disponible con el fin de que el espacio sobrante sea lo suficientemente grande como para albergar a otro proceso.
- **Buddy system (sistema de compañeros)**: Divide la memoria de forma binaria. Si la memoria total es $m$, las asignaciones se fuerzan estrictamente en potencias de dos: $m$, $\frac{m}{2}$, $\frac{m}{4}$, $\frac{m}{8}$, etc.
  - **Ventaja**: Disminuye radicalmente la fragmentación externa y el costo de compactación, ya que fusionar bloques compañeros (_buddies_) es computacionalmente instantáneo.
  - **Desventaja**: Incrementa notablemente la fragmentación interna si el proceso no se ajusta exactamente a la potencia de dos asignada.

---

(06-administracion-de-memoria-6-segmentacion-interna)=

## 6. Segmentación interna

A diferencia de la segmentación externa, la segmentación interna pasa cuando **la CPU participa activamente en la gestión y el programador o compilador conocen la existencia de los segmentos**. Un mismo proceso se fragmenta de forma lógica en múltiples segmentos diferenciados (código, datos, pila).

Para mapear esto por hardware, la MMU utiliza información provista en tiempo real por los estados de control de la propia CPU:

(06-administracion-de-memoria-6-1-discriminacion-por-ciclo-de-ejecucion)=

### 6.1. Discriminación por ciclo de ejecución

- **Durante el ciclo FETCH**: El procesador sabe que está buscando instrucciones. La MMU aplica automáticamente el registro base del **segmento de código (_code segment_)**.
- **Durante el ciclo EXECUTE**: Si la instrucción realiza un acceso directo o indexado a memoria, la MMU asume que busca variables y aplica el registro del **segmento de datos (_data segment_)**.

(06-administracion-de-memoria-6-2-discriminacion-por-tipo-de-direccionamiento-e-instruccion)=

### 6.2. Discriminación por tipo de direccionamiento e instrucción

El hardware evalúa qué registros están involucrados en la instrucción de ensamblador:

- `MOV AX, [SP+20]`: Al utilizar el puntero de pila (`SP`), la CPU conmuta automáticamente al **segmento de pila (_stack segment_)**.
- `MOV AX, [BP+20]`: Al operar con el puntero base (`BP`), la arquitectura lo deriva de forma exclusiva al **segmento extra (_extra segment_)**.

(06-administracion-de-memoria-6-3-balance-general)=

### 6.3. Balance general

- **Co-gestión**: No es transparente para el software. El compilador o el intérprete de un lenguaje deben generar código binario específico respetando la sintaxis y los selectores de los segmentos de la arquitectura.
- **Persistencia de problemas**: Aunque la fragmentación externa es menor y el costo temporal de compactación se reduce (porque se mueven bloques individuales pequeños en lugar de procesos gigantes completos), **los riesgos de conflictos de memoria y la fragmentación externa persisten en el sistema**.
