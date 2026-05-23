# Paginación y memoria virtual

La transición desde los esquemas de asignación contigua (particiones y segmentos) hacia la **paginación** responde a dos motores esenciales en el diseño de sistemas operativos:

1. **La necesidad de aumentar el grado de multiprogramación**: Maximizar la cantidad de procesos concurrentes en la RAM para elevar la utilización de la CPU.
2. **La dificultad de estimación de memoria**: Satisfacer la demanda errática e impredecible de espacio que representan las aplicaciones desarrolladas en lenguales tipo Algol o dinámicos. La fuerza bruta que consiste en proveer un espacio lógico ridículamente grande para mitigar el riesgo de colisión, pero el desafío radica en instrumentar esto de forma eficiente en el hardware real.

---

(07-paginacion-1-el-principio-de-localidad-y-el-cambio-de-paradigma)=

## 1. El principio de localidad y el cambio de paradigma

El pilar científico que justifica el éxito de la paginación es el **principio de localidad**. El análisis del comportamiento de programas reales en intervalos breves de tiempo revela dos verdades empíricas:

- Las direcciones de memoria accedidas (tanto en el ciclo _Fetch_ como en el _Execute_) representan una fracción inferior a una milésima parte ($< 0.1 \%$) del tamaño total del proceso.
- Los accesos no se distribuyen uniformemente, sino que se agrupan de forma compacta en unos pocos **clusters** (típicamente menos de 10) que se encuentran muy distantes geográficamente entre sí dentro del mapa de direccionamiento.

(07-paginacion-1-1-excepciones-y-perdida-de-la-localidad)=

### 1.1. Excepciones y pérdida de la localidad

El principio de localidad **no es una ley universal**; su vigencia es independiente del lenguaje o la calidad de la programación, vinculándose de forma unívoca a patrones de acceso específicos:

- **Por ejecución dispersa**: Ocurre en programas que invocan de forma masiva y repetitiva funciones o métodos extremadamente pequeños y muy distantes entre sí en el código. Es un fenómeno característico de la **programación orientada a objetos (_OOP - Object Oriented Programming)** con árboles de jerarquías y herencias muy detallados.
- **Por estructura de datos (acceso disperso)**: Clásico en el manejo de matrices de gran tamaño ($n \times m$). Si un algoritmo intenta inicializar una matriz asignando ceros mediante un bucle, la orientación del recorrido es crítica:

```c
// Se recore por filas
for (int i = 0; i < n; i++) {
  for (int j = 0; j < m; j++) {
    x[i][j] = 0; // Cumple estrictamente el principio de localidad
  }
}

// Recorrido por columnas
for (int j = 0; j < m; j++) {
  for (int i = 0; i < n; i++) {
    x[i][j] = 0; // Atenta contra el principio de localidad
  }
}
```

Dado que casi la totalidad de los compiladores almacenan las matrices contiguamente **"por filas"** en la RAM, el primer recorrido accede a celdas vecinas. El segundo fragmento, en cambio, salta de fila en fila en cada iteración interna, forzando accesos a direcciones lógicamente lejanas e invalidando la localidad.

```{admonition} Cambio de paradigma
---
class: note
---
Comprender la dispersión de los clusters determinó que los sistemas operativos **abandonaran el tratamiento de grandes bloques contiguos** (procesos o segmentos enteros) para comenzar a administrar la memoria en un conjunto de **pequeñas porciones fijas denominadas páginas**.
```

---

(07-paginacion-2-clasificacion-segun-el-mapa-de-direcciones)=

## 2. Clasificación según el mapa de direcciones

La división de la memoria se articuló históricamente bajo dos enfoques de hardware opuestos:

(07-paginacion-2-1-expansion-de-direccionamiento)=

### 2.1. Expansión de direccionamiento

- **Mecanismo**: El espacio de direccionamiento de la MMU es **superior** al de la CPU. Se aplica cuando una arquitectura física "queda chica" y se quiere conectar más memoria real que la que la CPU puede direccionar de forma nativa.
- **Propiedades**: El paradigma es que **"sobra memoria"**. Todo el proceso reside de forma íntegra en la RAM, eliminando la necesidad de compactación y disminuyendo el _swapping_. Los _overlays_ se gestionan por hardware poniendo "a la vista" distintas páginas según el instante de ejecución.

(07-paginacion-2-1-1-ejemplo)=

#### 2.1.1. Ejemplo

Conversión de una CPU con direccionamiento de $128 \ KB$ ($17 \ b$) a una MMU conectada a $16 \ MB$ ($24 \ b$), con páginas de $2 \ KB$ ($2^{11} b$, lo que requiere $11 \ b$ de una dirección interna o desplazamiento).

Un acceso lógico en el rango `04000` - `047FF` comparte los mismos bits más significativos:

$$
\text{Dirección CPU (Binario): } \underbrace{001000}_{6 \text{ bits: Nro. Página Virtual}} \ \underbrace{xxxx \ xxxx \ xxxx}_{11 \text{ bits: Desplazamiento Interno}} \text{}
$$

$$
\text{Dirección MMU (Física): } \overbrace{1100 \ 0101 \ 1000 \ 1}^{13 \text{ bits: Nro. Página Real}} \ \overbrace{xxxx \ xxxx \ xxxx}_{11 \text{ bits: Desplazamiento Interno}} \text{}
$$

La CPU "ve" $2^{6} = 64$ páginas virtuales, mientras que la MMU administra $2^{13} = 8192$ páginas reales. La tabla de páginas en la MMU es una memoria simple y rápida de $64$ entradas por $12 \ b$ de ancho.

(07-paginacion-2-2-memoria-virtual)=

### 2.2. Memoria virtual

**Mecanismo**: El espacio de direccionamiento de la CPU es **notoriamente superior** al de la MMU y a la memoria RAM real disponible. La memoria que la CPU cree poseer es, en su gran mayoría, inexistente (virtual).

(07-paginacion-2-2-1-ejemplo)=

#### 2.2.1. Ejemplo

CPU con direccionamiento de $4 \ TB$ ($42 \ b$), memoria RAM real de $2 \ GB$ ($31 \ b$) y tamaño de página de $16 \ KB$ ($2^{13} \ b \rightarrow 14 \ b$ de desplazamiento).

- Cantidad de páginas reales: $2^{31 - 14} = 2^{17}$ páginas reales.
- Cantidad de páginas virtuales: $2^{42 - 14} = 2^{28}$ páginas virtuales.

Si la CPU emite la dirección virtual `28023AB0774` y la MMU la tiene mapeada la dirección física `31920774`: los $14 \ b$ inferiores de desplazamiento (`0774H`) pasan idénticos. Los $28 \ b$ superiores virtuales (`A008EAC` en hexadecimal) se traducen a través de la tabla al número de página real de $17 \ b$ (`0C648` en hexadecimal).

---

(07-paginacion-3-estrcuturas-de-conversion-de-direcciones-avanzadas)=

## 3. Estructuras de conversión de direcciones avanzadas

Construir una tabla de conversión secuencial directa para el ejemplo de memoria virtual anterior requeriría un vector de $2^{28}$ filas (más de $268$ millones de entradas). Al estar la mayoría de las páginas virtuales vacías, está el problema de **matrices ralas**. Para resolver este desperdicio de memoria se implementan dos soluciones de hardware:

(07-paginacion-3-1-memoria-asociativa)=

### 3.1. Memoria asociativa

Consiste en un chip de memoria especial de alta velocidad que busca de forma simultánea y en paralelo por contenido. La CPU presenta el número de página virtual y la memoria asociativa compara concurrentemente todas sus filas.

- **Resultado**: Si encuentra la coincidencia, devuelve instantáneamente el número de página real; si no, genera un _trap_ por **fallo de página (_page fault_)**.
- **Limitación**: Debido a su alto costo de fabricación, solo es viable para una cantidad de entradas reducida (por ejemplo, las arquitecturas IBM/370 tenían tablas asociativas de apenas 64 entradas).

(07-paginacion-3-2-tlb-translation-lookaside-buffer)=

### 3.2. TLB (_Translation Lookaside Buffer_)

Al volverse los esquemas asociativos puros inviables por el crecimiento de la RAM, se introdujo el **_TLB_**, el cual opera como un "diccionario" o memoria caché especializado en traducciones de páginas.

- **Mecámica del _TLB Miss_**: Si una página virtual es consultada y no figura en el _TLB_, ocurre un _TLB Miss_. Esto **no significa** que la página no resida en la RAM; implica que el hardware tiene que ir a buscar la traducción a la tabla de páginas completa que el sistema operativo mantiene guardada en la memoria principal. Después, la traducción se precarga en el _TLB_ para futuros accesos.
- **Mitigación por software**: Para reducir el tamaño de las tablas de páginas en memoria común se recurre a **aumentar el tamaño de la página** (a mayor tamaño de página, menos filas requiere la tabla). Así mismo, el tamaño de la tabla efectiva se acota al tamaño real del proceso y no al máximo teórico de la CPU.
- **_Context switch_**: Las arquitecturas modernas incorporan múltiples _TLB_ independientes o etiquetas de identificador de proceso (ASID) para evitar la costosa necesidad de vaciar (_flush_) y restaurar el _TLB_ completo en cada cambio de contexto.

---

(07-paginacion-4-co-gestion-con-la-memoria-cache-del-procesador)=

## 4. Co-gestión con la memoria caché del procesador

En el acceso a una dirección conviven el _TLB_ y la memoria caché de datos. La decisión de diseño crítica del hardware es el orden de consulta:

1. **Estrategia VIVT/VIPT (primero caché)**: Se intenta acceder al caché utilizando la dirección virtual. Solo si el caché falla, se invoca al _TLB_ para traducir la dirección física y buscar en la RAM.
   - **Desventaja**: Al usar direcciones virtuales, se incrementa el tamaño de la parte asociativa del caché y pueden producirse graves conflictos de inconsistencia en entornos de memoria compartida interproceso.
2. **Estrategia PIPT (primero _TLB_)**: Primero se traduce de forma mandatoria la dirección virtual a física mediante el _TLB_, y con la dirección física resultante se inspecciona la jerarquía de cachés.

(07-paginacion-4-1-mecanica-del-cache-por-mapeo-directo)=

### 4.1. Mecánica del caché por mapeo directo

El caché se organiza en una cantidad de líneas equivalente a una potencia de dos ($2^{t} = \text{ número de líneas}$), donde $t$ representa los bits del **tag** o etiqueta. Cada línea contiene un índice de validación y un bloque de datos ($2$, $4$ y $8$ bytes).

- **Operación de lectura/escritura**: Los bits del tag determinan qué línea del caché tiene que inspeccionarse. Se compara el índice; si hay coincidencia (_hit_), la operación se hace directamente sobre el bloque del caché a velocidad de nanosegundos. Si no hay coincidencia (_miss_), el hardware lee el bloque desde la memoria principal, actualiza el índice en el caché y completa la operación.

---

(07-paginacion-5-paginacion-por-demanda-y-gestion-de-fallos-de-pagina)=

## 5. Paginación por demanda y gestión de fallos de página

Para que un proceso se ejecute eficientemente sin saturar la RAM, el kernel calcula su **conjunto de trabajo (_working set_)**, que es la cantidad mínima de páginas que el proceso requiere residentes en memoria para operar de forma fluida en un período de tiempo sin disparar fallos continuos.

La estrategia más eficiente para construir este conjunto es la **paginación por demanda**. El proceso se inicia con cero páginas en la RAM; a medida que intenta ejecutar instrucciones, la ausencia de la página virtual dispara un _trap_ de hardware por **fallo de página (_page fault_)** hacia la CPU. El kernel intercepta el _trap_, busca la página en el disco, selecciona una **página real víctima** en la RAM, la desaloja (escribiéndola en el disco si estaba "sucia" o modificada) y carga la nueva página solicitada en su lugar.

(07-paginacion-5-1-algoritmos-de-reemplazo-de-paginas-seleccion-de-la-victima)=

### 5.1. Algoritmos de reemplazo de páginas (selección de la víctima)

- **Algoritmo óptimo**: Consiste en desalojar la página que va a tardar más tiempo en volver a ser utilizada por el proceso. **Es teóricamente irrealizable**, dado que el kernel no puede predecir el futuro flujo de instrucciones del programa. Se utiliza exclusivamente como métrica estándar de referencia para comparar la eficiencia de los algoritmos reales.
- **_LRU_ (_Least Recently Used_)**: Asume que el pasado reciente es un buen predictor del futuro. Desaloja la página que no fue utilizada durante el período de tiempo más largo. Requiere soporte de hardware complejo para mantener marcas temporales.
- **_FIFO_ (_First In, First Out_)**: Desaloja la página que lleva más tiempo residente en la memoria RAM, sin considerar si es intensamente utilizada en el presente. Puede sufrir de la anomalía de Belady (más marcos de memoria pueden provocar más fallos).
- **Algoritmo del reloj (_clock_)**: Solución de bajo costo computacional que aproxima a _LRU_. Las páginas se organizan en una lista circular con un bit de uso (0 o 1). Una aguja recorre la lista; si el bit es 1, lo pasa a 0 y avanza; si encuentra un 0, elige esa página como la víctima para el reemplazo.

---

(07-paginacion-6-conceptos-clave)=

## 6. Conceptos clave

- **Páginas limpias vs. sucias**: Una página está **limpia** si su contenido en la RAM es idéntico al que reside en el disco; su desalojo es instantáneo. Está **sucia** si fue modificada por el proceso, obligando al kernel a escribirla en el disco antes de liberar el marco.
- **Páginas bloqueadas**: Páginas críticas del sistema (como las del código del kernel o buffers de DMA activos) que tienen prohibido ser elegidas como víctimas de reemplazo.
- **_Thrashing_ (hiperpaginación)**: Fenómeno destructivo que ocurre cuando el sistema operativo incrementa el grado de multiprogramación al punto que la memoria RAM asignada a cada proceso es inferior a su _working set_ mínimo. Los procesos pasan cerca del $100 \%$ del tiempo desalojando y cargando páginas desde el disco en cadena, provocando que la utilización útil de la CPU se desplome prácticamente a cero.
