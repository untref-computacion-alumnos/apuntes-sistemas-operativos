# Modelos de ejecución

Un modelo de ejecución define la relación arquitectónica entre los procesos de usuario y el núcleo (_kernel_) del sistema operativo. Determina si el kernel se concibe como un programa independiente que corre fuera de todo proceso, o si las rutinas del sistema se ejecutan "adentro" del contexto de los propios procesos de usuario.

---

(05-modelos-de-ejecucion-1-ejecucion-fuera-de-todo-proceso)=

## 1. Ejecución fuera de todo proceso

Es el enfoque más tradicional y primitivo, comúnmente usado en los primeros sistemas operativos monolíticos y en grandes mainframes.

(05-modelos-de-ejecucion-1-1-caracteristicas-mecanicas)=

### 1.1. Características mecánicas

- **Separación absoluta**: El concepto de **proceso** se aplica única y exclusivamente a los programas del usuario. El sistema operativo existe como una entidad monolítica global y separada que opera por encima de cualquier proceso.
- **Mapa de memoria**: El kernel reside en un área de memoria protegida fija. Cuando un proceso de usuario está corriendo, el procesador está en Modo Usuario.
- **Flujo de control**:
  1. Un proceso de usuario se está ejecutando.
  2. Ocurre un evento (Interrupción, Trap o Llamada al sistema).
  3. El hardware salva el contexto del proceso actual y conmuta al Modo Privilegiado, transfiriendo el control al código del sistema operativo.
  4. El kernel ejecuta la rutina correspondiente de forma aislada.
  5. Al finalizar, el planificador del kernel decide qué proceso de usuario se ejecutará a continuación, restaura su contexto y degrada el procesador a Modo Usuario.

(05-modelos-de-ejecucion-1-2-propiedades)=

### 1.2. Propiedades

- **Abstracción**: El sistema operativo no es un proceso; es un  **manejador de interrupciones** o un monitor residente avanzado que no tiene un PCB ni compite en las colas de planificación.
- **Desventaja**: El cambio entre el espacio de usuario y el espacio del kernel es costoso a nivel de hardware por la reconfiguración total de los mapas de memoria y registros.

---

(05-modelos-de-ejecucion-2-ejecucion-dentro-de-los-procesos-de-usuario)=

## 2. Ejecución dentro de los procesos de usuario

A medida que los sistemas operativos se volvieron más complejos, se adoptó este modelo (característico de sistemas tipo Unix/Linux modernos), donde el código del sistema operativo **se ejecuta en el contexto del proceso que solicita el servicio o que fue interrumpido**.

(05-modelos-de-ejecucion-2-1-caracteristicas)=

### 2.1. Características mecánicas

- **Compartición del bloque de control**: Cada proceso de usuario contiene no solo su propio código y datos (espacio de usuario), sino también una copia o mapeo de las rutinas esenciales y estructuras del kernel (espacio del kernel).
- **Pilas de ejecución duplicadas**: Cada proceso posee dos pilas (_stacks_) de ejecución diferenciadas en su PCB: una **pila de Modo Usuario** (para llamadas a funciones locales de la aplicación) y una **pila de Modo Kernel** (para registrar el flujo de las llamadas al sistema).
- **Flujo de control**:
  1. El proceso $A$ ejecuta su código en Modo Usuario.
  2. El proceso $A$ realiza una llamada al sistema (_system call_).
  3. El procesador conmuta a Modo Privilegiado, pero **no cambia de proceso**. El hilo de ejecución sigue perteneciendo al proceso $A$, pero ahora ejecuta las instrucciones del kernel usando su pila de Modo Kernel.
  4. Si la llamada al sistema requiere bloquearse (por ejemplo, esperar un disco), el proceso $A$ pasa a estado Bloqueado y se realiza un cambio de contexto (_context switch_) real hacia el proceso $B$.

(05-modelos-de-ejecucion-2-2-propiedades)=

### 2.2. Propiedades

- **Identidad**: No existe un proceso llamado "Sistema Operativo". El kernel es simplemente un conjunto de rutinas privilegiadas que los procesos de usuario ejecutan cuando lo necesitan.
- **Ventaja**: Optimiza drásticamente las llamadas al sistema cortas. Si una llamada al sistema puede resolverse rápido (por ejemplo, consultar la hora del sistema), no se requiere hacer un cambio de contexto completo entre procesos, solo un cambio de modo en el procesador, ahorrando ciclos de CPU masivos.

---

(05-modelos-de-ejecucion-3-el-kernel-basado-en-procesos)=

## 3. Kernel basado en procesos

Es el modelo más modular y elegante, fuertemente vinculado a las arquitecturas de **Microkernel** (como Mach o QNX) y sistemas distribuidos.

(05-modelos-de-ejecucion-3-1-caracteristicas-mecanicas)=

### 3.1. Características mecánicas

- **Funciones como procesos**: El sistema operativo se divide en componentes funcionales pequeños y bien definidos (el administrador de memoria, el driver de red, etc.). **Cada uno de estos componentes se implementa como un proceso independiente del sistema**.
- **Microkernel mínimo**: Solo una porción minúscula de software (el microkernel real) corre en el Modo Privilegiado del hardware. Sus únicas tareas son gestionar el cambio de contexto básico, atender las interrupciones de hardware crudas y proveer el mecanismo de comunicación.
- **Flujo de control**:
  1. Un proceso de usuario quiere leer un archivo.
  2. En lugar de hacer una llamada directa al kernel, le envía un mensaje lógicamente estructurado (IPC) al proceso "Servidor de Archivos".
  3. El microkernel intercepta el mensaje y despierta al proceso Servidor de Archivos.
  4. El Servidor de Archivos (que corre en Modo Usuario o con privilegios acotados) procesa la solicitud, interactúa con el driver y le responde con otro mensaje al proceso usuario.

(05-modelos-de-ejecucion-3-2-propiedades)=

### 3.2. Propiedades

- **Tolerancia a fallos y seguridad**: Si el proceso "Servidor de Archivos" falla o tiene un error de programación (_trap_), el sistema operativo no se cae. El microkernel puede reiniciar ese proceso servidor de forma aislada sin afectar al resto del sistema.
- **Extensibilidad**: Es sumamente fácil agregar nuevos servicios al sistema operativo; basta con compilar un nuevo proceso e instanciarlo, sin necesidad de modificar ni recompilar el núcleo del sistema.
- **Desventaja**: El rendimiento se ve penalizado por la sobrecarga constante de enviar mensajes a través de la memoria (_IPC overhead_) y conmutar continuamente entre múltiples procesos para resolver una sola tarea de $E/S$.

---

(05-modelos-de-ejecucion-4-cuadro-comparativo-de-modelos-de-ejecucion)=

## 4. Cuadro comparativo de modelos de ejecución

| Criterio                 | Modelo A: Fuera de todo proceso                      | Modelo B: Dentro de procesos de usuario                    | Modelo C: Basado en procesos                                  |
| ------------------------ | ---------------------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------- |
| ¿Dónde corre el Kernel?  | Espacio de memoria e hilo de control aislado         | Dentro del espacio virtual y contexto del proceso actual   | Dividido en múltiples procesos independientes del sistema     |
| ¿El SO tiene PCB?        | No, opera por fuera de las estructuras de procesos   | No tiene un PCB propio; usa los PCBs de los usuarios       | Sí, cada servidor del SO es un proceso con su propio PCB      |
| Costo de una System Call | Alto (Cambio de modo + Cambio de contexto implícito) | Bajo (Solo cambio de modo del procesador si no se bloquea) | Muy Alto (Múltiples cambios de contexto y pasaje de mensajes) |
| Uso Principal            | Sistemas antiguos, Mainframes monolíticos            | Unix, Linux, Windows moderno (híbrido)                     | Sistemas de Tiempo Real estrictos, Microkernels               |
