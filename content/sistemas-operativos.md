# Sistemas Operativos

## 1. Fundamentos y Gestión de Procesos

- **Concepto de proceso**: Definición, estados de un proceso, bloque de control de proceso (PCB) y
  transiciones.
- **Administración y gestión de procesos y procesadores**: Algoritmos de planificación (Scheduling),
  niveles de planificación y métricas de rendimiento.
- **Interacción del Sistema Operativo con el lenguaje**: System Calls, APIs del sistema y la interfaz
  entre el código de usuario y el Kernel.

## 2. Administración de Memoria

- **Administración de memoria**: Esquemas de asignación contigua, fragmentación interna/externa y
  compactación.
- **Memoria virtual**: Paginación, segmentación, algoritmos de reemplazo de páginas y manejo de faltas
  de página (Page Faults).

## 3. Concurrencia y Sincronización

- **Comunicación, sincronización y manejo de recursos**: IPC (Inter-Process Communication), semáforos,
  monitores y paso de mensajes.
- **Concurrencia de ejecución (Interbloqueos)**: Condiciones de Coffman, prevención, evitación
  (Algoritmo del Banquero) y detección de Deadlocks.
- **Concurrencia a nivel lenguaje**: Soporte nativo de los lenguajes para hilos (Threads), promesas y
  async/await.
- **Integración de la concurrencia del sistema operativo con el lenguaje**: Mapeo de hilos de usuario a
  hilos de kernel (modelos 1:1, N:1, M:N).

## 4. Entrada/Salida y Archivos

- **Gestión de entrada/salida**: Manejo de interrupciones, Buffering, Spooling y el rol del DMA.
- **Sistema de archivos y sus directorios**: Estructuras de datos (Inodos, FAT), métodos de asignación
  de espacio y gestión de metadatos.

## 5. Seguridad y Protección

- **Sistemas de protección**: Mecanismos de control de acceso, dominios de protección y matrices de
  acceso.
- **Seguridad en sistemas operativos**: Amenazas, autenticación, cifrado y políticas de seguridad del
  kernel.

## 6. Arquitecturas Avanzadas y Paralelismo

- **Procesadores de alta performance**: Pipeline, superescalabilidad y optimizaciones a nivel de
  hardware.
- **Procesamiento paralelo**: Modelos de computación paralela y escalabilidad.
- **Arquitecturas multiprocesadores**: Sistemas SMP (Symmetric Multiprocessing), NUMA y coherencia de
  caché.
