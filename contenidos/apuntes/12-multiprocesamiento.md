# Multiprocesamiento y paralelismo

El fin de la era de la computación puramente secuencial estuvo signado por limitaciones físicas insalvables. Para abordar las arquitecturas modernas, el primer requisito consiste en precisar y diferenciar tres conceptos que suelen utilizarse de forma imprecisa:

- **Concurrencia**: Una única CPU alterna velozmente su ejecución entre varios procesos mediante ráfagas de tiempo, simulando simultaneidad.
- **Multiprocesamiento**: Múltiples CPUs independientes atienden de forma simultánea y real cada una un proceso o hilo diferenciado.
- **Paralelismo**: Múltiples CPUs coordinan sus esfuerzos para procesar e intervenir sobre un único proceso o tarea unificada, subdividida en fragmentos concurrentes.

---

(12-multiprocesamiento-1-el-concepto-de-hilo-en-el-paralelismo-real)=

## 1. El concepto de hilo en el paralelismo real

Anteriormente se definió al hilo como un "proceso liviano" bajo la hipótesis de que cada hilo realizaba una actividad o funcionalidad diferente dentro del programa. Sin embargo, esta noción cambia en el cómputo de alta performance:

Existen escenarios donde se instancian múltiples hilos y **todos poseen exactamente la misma funcionalidad y código**. En este caso, los hilos se utilizan como el vehículo del software para **lograr paralelismo**, forzando a que un solo proceso se ejecute ocupando varios procesadores físicos al mismo tiempo.

(12-multiprocesamiento-1-1-grados-de-multiprocesamiento)=

###

- **Multiprocesamiento completo**: Se procesan exactamente $N$ entidades (procesos/hilos) utilizando de forma dedicada $N$ procesadores físicos ($N = M$). No hay entrelazamiento por software.
- **Multiprocesamiento parcial**: Se procesan $N$ entidades mediante $M$ procesadores, cumpliéndose que el número de hilos supera la cantidad de silicio ($M < N$). Coexiste intrínsecamente un grado de concurrencia y reparto de tiempo en cada núcleo.

(12-multiprocesamiento-1-2-entidades-n-vs-procesadores-m)=

### 1.2. Entidades ($N$) vs. Procesadores ($M$)

| **Procesadores Entidades**    | **Un solo procesador ($M = 1$)**                                                  | **Varios procesadores ($M > 1$)**                                                       |
| ----------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| **Un solo proceso ($N = 1$)** | Ni concurrencia, ni paralelismo, ni multiprocesamiento                            | Paralelismo puro: El proceso se descompone y ocupa todo el silicio disponible           |
| **Varios procesos ($N > 1$)** | Concurrencia: Reparto de tiempo clásico por el planificador del sistema operativo | Combinación compleja: Entrelazamiento de multiprocesamiento, concurrencia y paralelismo |

(12-multiprocesamiento-1-3-analisis-de-escenarios-con-varios-procesadores)=

### 1.3. Análisis de escenarios con varios procesadores ($M > 1$)

1. **Si $M < N$ (menos procesadores que procesos)**: Si los procesadores se comparten de forma global, es una combinación de concurrencia y multiprocesamiento. Si un proceso toma más de un núcleo, se suman los tres fenómenos simultáneamente.
2. **Si $M = N$ (igual cantidad de procesadores que procesos)**: Si cada núcleo se adueña de un proceso, es multiprocesamiento completo. Si se comparte algún núcleo por ráfagas, reaparece la concurrencia.
3. **Si $M > N$ (más procesadores que procesos)**: Si algunos procesos corren en núcleos individuales aislados, es multiprocesamiento con paralelismo. Si todos los procesos logran expandirse y ocupar más de un núcleo, se reduce a paralelismo puro.

---

(12-multiprocesamiento-2-tipos-de-fragmentacion-para-el-paralelismo)=

## 2. Tipos de fragmentación para el paralelismo

Para que un programa secuencial aproveche múltiples núcleos, la tarea tiene que subdividirse mediante dos estrategias fundamentales:

(12-multiprocesamiento-2-1-fragmentacion-de-datos)=

### 2.1. Fragmentación de datos

El proceso se enfrenta a un volumen masivo de información (común en procesamiento de señales o modelos estocásticos).

- **Mecánica**: Se divide el set de datos en fragmentos independientes y se asigna un hilo idéntico para procesar cada porción.
- **Ejemplo**: En un algoritmo de alisado de imágenes, la matriz de píxeles se fragmenta en 9 cuadrantes lógicos y se instancian 9 hilos coordinados. Si el sistema operativo despacha cada hilo a una CPU física diferente, se consolida un paralelismo de datos puro.

(12-multiprocesamiento-2-1-fragmentacion-de-codigo-control)=

### 2.2. Fragmentación de código (control)

La tarea se descompone dividiendo los bloques lógicos de instrucciones que no poseen dependencia de flujo entre sí.

- **Ejemplo**: Se evalúa la siguiente sentencia booleana:

  ```{code-block} c
  if (funcion1() and funcion2()) {
    return ();
  }
  ```

  Un compilador optimizado para arquitecturas multiprocesador puede determinar que `funcion1()` y `funcion2()` no se alteran mutuamente y ordenar su ejecución paralela y simultánea en dos núcleos distintos para acelerar la resolución del condicional.

(12-multiprocesamiento-2-3-instrumentacion-del-paralelismo)=

### 2.4. Instrumentación del paralelismo

Esta división puede ejecutarse de dos formas:

- **Manual**: Diseñada explícitamente por el programador mediante el uso de primitivas e hilos de software.
- **Automática (intrínseca del lenguaje)**: Llevada a cabo de forma autónoma por el compilador o la máquina virtual. Por ejemplo, en **ALGOL 68**, los parámetros de la sentencia `for i from A by B, to C while D to E` se consideran estructuralmente colaterales (_collateral_), permitiendo al compilador fragmentarlos. Así mismo, entornos modernos como la **_JVM_** ejecutan de forma paralela e interna muchas de sus actividades de sopórte (como la recolección de basura o _Garbage Collection_).

---

(12-multiprocesamiento-3-la-pared-de-la-potencia-y-la-arquitectura-multicore)=

## 3. La "pared de la potencia" y la arquitectura multicore

Históricamente, el rendimiento de los procesadores aumentaba incrementando de forma directa la frecuencia de reloj, una tendencia amparada por la **Ley de Moore** (que dictamina desde 1965 que la cantidad de transistores en una unidad de superficie se duplica aproximadamente cada dos años).

Sin embargo, el incremento de los GHz colisionó contra la **pared de la potencia (_power wall_)**: el exceso de calor generado por la disipación térmica de los transistores a frecuencias extremas impidió continuar por esa vía, obligando a la industria a cambiar el enfoque hacia la construcción de múltiples procesadores elementales dentro de un mismo chip, consolidando los **procesadores multicore**.

(12-multiprocesamiento-3-el-problema-critico-el-acceso-a-la-memoria-principal)=

### 3.1. El problema crítico: El acceso a la memoria principal

Dado que todos los núcleos de un procesador _multicore_ comparten el acceso a la misma memoria RAM física global, se genera un cuello de botella severo. Si un núcleo toma las líneas del bus para acceder a la RAM, el resto de los núcleos queda completamente bloqueado en espera activa.

Para mitigar la degradación del paralelismo, es imperativo reducir los accesos a la memoria principal, garantizando que casi la totalidad de las instrucciones y datos residan de forma local en la jerarquía de cachés. La arquitectura estándar implementa un acoplamiento fuerte estructurado en tres niveles.

```{mermaid}
flowchart LR
  A[Núcleo 1] --> B
  B[Caché L1 propia] --> C
  C[Caché L2 propia] --> G
  D[Núcleo 2] --> E
  E[Caché L1 propia] --> F
  F[Caché L2 propia] --> G
  G[Caché L3 compartida] --> H
  H[RAM]
```

- **Caché L1**: Nivel primario e interno, propio y exclusivo de cada CPU del núcleo.
- **Caché L2**: Nivel secundario de alta velocidad, propio y dedicado a cada núcleo individual.
- **Caché L3**: Memoria caché de mayor envergadura, compartida de forma colectiva entre todos los núcleos del mismo chip para agilizar la coherencia de datos antes de golpear la RAM.

---

(12-multiprocesamiento-4-evolucion-historica-de-las-tecnologias-paralelas)=

## 4. Evolución histórica de las tecnologías paralelas

- **Supercomputadoras (cálculo técnico-científico)**: Los primeros intentos formales se remontan al período 1968-1972 con el computador **CDC 8600** de Control Data Corporation, equipado con cuatro procesadores paralelos. Esta evolución derivó en las supercomputadoras modernas con más de un millón de unidades de cálculo, orientadas a problemas naturalmente paralelizables como física cuántica, modelos climáticos, simulaciones farmacológicas y fusión nuclear, consolidando históricamente las extensiones del lenguaje **FORTRAN Paralelo**.
- **Transputers (cómputo modular)**: En la década de 1980 surgieron los _transputers_, microprocesadores integrados diseñados para interconectarse en mallas y ofrecer alto paralelismo a bajo costo. Fueron el ecosistema nativo del lenguaje **OCCAM** (1983), un hito conceptual basado en el álgebra de procesos comunicantes.
- **La convergencia en el PC**: Al chocar contra la pared de la potencia, las computadoras personales adoptaron la historia de los supercomputadores. En los 90 proliferaron iniciativas para trasladar las extensiones paralelas de FORTRAJ y C al escritorio. El paradigma actual se desplaza hacia las **arquitecturas heterogéneas** (por ejemplo, big.LITTLE), donde los procesadores se agrupan en categorías con propiedades disímiles (núcleos de alta potencia vs. núcleos de alta eficiencia energética), imponiendo al planificador del sistema operativo el desafío de decidir a qué tipo de procesador despacha cada fragmento de código.

---

(12-multiprocesamiento-5-la-clasificacion-taxonomica-de-flynn)=

## 5. La clasificación taxonómica de Flynn

Orientada estrictamente a la estructura del hardware y los procesadores, la taxonomía de Flynn organiza los estilos de computación en cuatro grandes categorías:

(12-multiprocesamiento-5-1-sisd-single-instruction-single-data)=

### 5.1. SISD (Single Instruction, Single Data)

Un procesador ejecuta un único flujo de instrucciones de forma secuencial operando sobre un único flujo de datos a la vez. Representa la arquitectura tradicional de un solo procesador. El sistema operativo en este entorno solo puede ejecutar flujos monolíticos o estructurar concurrencia por reparto de tiempo.

(12-multiprocesamiento-5-2-simd-single-instruction-multiple-data)=

### 5.2. SIMD (Single Instruction, Multiple Data)

Un único componente de control ejecuta de forma asíncrona una única instrucción de máquina, pero la aplica simultáneamente sobre un conjunto masivo de datos distribuidos en múltiples unidades de procesamiento. Son los denominados procesadores vectoriales o _array computers_ (un ancestro conceptual de las GPUs actuales).

- **Responsabilidad del sistema operativo**: Prácticamente nula. Este multiprocesamiento se hace puramente a nivel de hardware y el software del kernel solo asume responsabilidades de inicialización y control perimetral sumamente básicas.

(12-multiprocesamiento-5-3-misd-multiple-instruction-single-data)=

### 5.3. MISD (Multiple Instruction, Single Data)

Múltiples procesadores aplican de forma simultánea diferentes instrucciones y operaciones sobre un único flujo de datos unificado. **Es una categoría teórica que nunca se llevó a la práctica** en la arquitectura comercial.

(12-multiprocesamiento-5-4-mimd-multiple-instruction-multiple-data)=

### 5.4. MIMD (Multiple Instruction, Multiple Data)

Un conjunto de procesadores autónomos ejecutan simultáneamente diferentes flujos de instrucciones operando sobre flujos de datos totalmente diferenciados. Es la materialización de los sistemas multiprocesador y multicore modernos.

- **Responsabilidad del sistema operativo**: Máxima. Al incluir arquitecturas híbridas y procesadores no homogéneos (heterogéneos), el planificador (_scheduler_) del kernel se complejiza de forma crítica: ya no solo tiene que arbitrar prioridades y cuantos de tiempo, sino evaluar la **compatibilidad estricta entre el tipo de hilo/proceso y la naturaleza específica de las CPUs físicas disponibles** antes de realizar el despacho.
