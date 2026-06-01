# Evolución de los modos de ejecución de programas

La evolución de las modalidades de ejecución de programas estuvo históricamente condicionada por el balance entre dos factores críticos:

- El costo de equipamiento físico.
- Las necesidades de procesamiento de los usuarios.

A medida que el hardware se volvió más accesible y potente, el foco de los **sistemas operativos** mutó desde la optimización absoluta del tiempo de CPU hacia la mejora del tiempo de respuesta y la interactividad.

---

(01-ejecucion-de-programas-1-ejecucion-manual)=

## 1. Ejecución manual

(01-ejecucion-de-programas-1-1-contexto-y-usos)=

### 1.1. Contexto y usos

En los albores de la computación, el hardware era un recurso críticamente costoso, escaso y centralizado en grandes organizaciones. Se utilizaba principalmente para el **cálculo científico puro**, caracterizado por algoritmos complejos con un escaso procesamiento de datos masivos. En este esquema, los tiempos de ejecución eran poco previsibles.

(01-ejecucion-de-programas-1-2-organizacion-y-el-rol-del-usuario)=

### 1.2. Organización y el rol del usuario

- **Estructura organizacional**: Propia de universidadesm centros de investigación y empresas industriales de gran envergadura. Acá nace la noción primitiva de **centro de cómputo**.
- **El rol del usuario**: No existía una división de tareas profesionalizada. La misma persona asumía todos los roles (usuario, analista, programador, operador). El programador reservaba un turno, se sentaba físicamente frente a la máquina y tenía acceso directo a hardware. La reiteración de las ejecuciones era muy baja.

(01-ejecucion-de-programas-1-3-exigencias-tecnicas-del-sistema)=

### 1.3. Exigencias técnicas del sistema

Dado que el usuario operaba la máquina de forma directa y exclusiva, las exigencias del software eran rudimentarias y se centraban en la interacción física:

- **Mecanismos de carga manual**: Uso de interruptores, cintas de papel o tarjetas perforadas para introducir secuencialmente el programa y los datos en la memoria elemental.
- **Entrega de resultados**: Directamente a través de luces en el panel de control o mediante primitivas impresoras de texto.
- **Mecanismos de detención**: El control total del flujo lo tenía el operador, pudiendo pausar o detener el hardware mediante llaves físicas.

---

(01-ejecucion-de-programas-2-sistemas-batch-procesamiento-por-lotes-de-una-sola-tarea)=

## 2. Sistemas batch (procesamiento por lotes) de una sola tarea

(01-ejecucion-de-programas-2-1-contexto-y-usos)=

### 2.1. Contexto y usos

Para mitigar el enorme desperdicio de tiempo que significaba la preparación manual de la máquina entre un usuario y otro, surgieron los sistemas por lotes (_batch_). El hardware seguía siendo sumamente costoso, pero el volumen de datos a procesar empezó a crecer, incrementando la necesidad de reiterar ejecuciones.

(01-ejecucion-de-programas-2-1-organizacion-y-el-rol-del-usuario)=

### 2.2. Organización y el rol del usuario

- **Cambio de paradigma**: El usuario **pierde el acceso directo al equipo**. El programador entrega su trabajo (en un fajo de tarjetas perforadas) y regresa horas o días después por los resultados impresos.
- **Aparición del operador técnico**: Se profesionaliza el Centro de Cómputos. Los operadores están siempre presentes y gestionan la cola de trabajos de forma continua, separando formalmente los roles de analista, programador y operador.

(01-ejecucion-de-programas-2-3-exigencias-tecnicas-y-el-nacimiento-del-monitor-residente)=

### 2.3. Exigencias técnicas y el nacimiento del "monitor residente"

Para automatizar la transición entre tareas sin intervención humana, surge el **monitor residente** (el ancestro directo del sistema operativo moderno). Esto exigió por primera vez soporte del hardware y del software en materia de control y aislamiento.

- **Protección del monitor**: El monitor reside en una zona de memoria que los programas de usuario no deben corromper. Nace la necesidad de proteger la memoria central.
- **Instrucciones privilegiadas y modos de ejecución**: El procesador implementa dos modos de operación (Modo Usuario y Modo Supervisor/Kernel). Las operaciones de control y de entrada/salida se vuelven "privilegiadas" y solo el monitor puede ejecutarla.
- **Llamadas al sistema (_System Calls_)**: Los programas de usuario ya no acceden directamente a los periféricos. Tienen que solicitar servicios al monitor residente mediante puntos de entrada controlados.
- **Control de ejecución**: El monitor tiene que ser capaz de retomar el control si un programa de usuario falla o entra en un bucle infinito (introducción de temporizadores o _timers_ por hardware).

---

(01-ejecucion-de-programas-3-sistemas-batch-procesamiento-por-lotes-de-multiples-tareas)=

## 3. Sistemas batch (procesamiento por lotes) de múltiples tareas (multiprogramación)

(01-ejecucion-de-programas-3-1-precondicion-tecnica-fundamental)=

### 3.1. Precondicion técnica fundamental

**El paralelismo entre CPU y E/S**: Las operaciones de entrada/salida (leer un disco, grabar una cinta) son órdenes de magnitud más lentas que la velocidad de procesamiento de la CPU. La existencia de varias tareas concurrentes en memoria presupone que, mientras una tarea está bloqueada esperando que termine su operación de E/S, la CPU puede conmutar y ejecutar otra tarea, maximizando el factor de utilización del procesador.

(01-ejecucion-de-programas-3-contexto-y-usos)=

### 3.2. Contexto y usos

Esta modalidad se implementa ante un volumen masivo de procesamiento de datos corporativos (liquidación de sueldos, inventarios) y una altísima reiteración de tareas, relegando el cálculo científico a un segundo plano.

(01-ejecucion-de-programas-3-3-organizacion-y-el-rol-del-usuario)=

### 3.3. Organización y el rol del usuario

Aumenta la dispersión tecnológica hacia organizaciones de menor tamaño y entidades públicas. En el Centro de Cómputos, la tarea del operador se vuelve crítica y compleja, ya que tiene que manipular masivamente diferentes soportes físicos (discos, cintas magnéticas, tarjetas, papel continuo) y planificar qué lote de carga es óptimo ejecutar en cada momento.

(01-ejecucion-de-programas-3-4-exigencias-tecnicas-del-sistema-operativo)=

### 3.4. Exigencias técnicas del sistema operativo

La convivencia de múltiples programas en la memoria central y la disputa por la CPU transformaron al sistema operativo en un administrador avanzado de recursos concurrentes:

- **Exclusión mutua y aislamiento**: El sistema operativo tiene que garantizar de forma estricta que un proceso no pueda acceder ni modificar la memoria o los recursos asignados a otro proceso.
- **Planificación del procesador y prioridades**: Mecanismos algorítmicos para decidir qué proceso listo toma el control de la CPU (planificadores de corto, mediano y largo plazo).
- **Gestión de estados (suspensión y reinicio)**: El sistema tiene que guardar el estado exacto de un proceso (registros, contador de programa) al retirarlo de la CPU (conmutación de contexto) para poder reanudarlo idénticamente más tarde.
- **Mecanismos de sincronización e interacción**: Primitivas para permitir la comunicación segura entre tareas concurrentes y evitar condiciones de carrera o bloqueos mutuos (_abrazo mortal_ o _deadlock_).
- **Estadísticas de consumo**: Registro del tiempo de CPU y uso de recursos por tarea para fines de auditoría y facturación interna.

(01-ejecucion-de-programas-3-5-niveles-de-interaccion)=

### 3.5. Niveles de interacción

```{mermaid}
flowchart TB
  A(Usuario final)
  B(Programador)
  C(Creador del sistema operativo)

  subgraph G[Equipo]
      subgraph F[Sistema operativo]
          subgraph Capa_Superior[" "]
              direction LR
              E[Herramientas]
              H[Shell]
              D[Aplicación]
          end
      end
  end

  A ----> D
  A ----> H
  B ----> E
  B ----> F
  B ----> H
  C ----> G

  style Capa_Superior fill:none,stroke:none
```

---

(01-ejecucion-de-programas-4-sistemas-de-tiempo-compartido-time-sharing)=

## 4. Sistemas de tiempo compartido (_time-sharing_)

(01-ejecucion-de-programas-4-1-contexto-y-usos)=

### 4.1. Contexto y usos

Con el abaratamiento del hardware y **la aparición de las terminales de usuario** (teclado y pantalla remotos), el paradigma cambia drásticamente. El objetivo ya no es exprimir cada ciclo de la CPU al máximo, sino simular que cada usuario interactivo dispone de una **máquina virtual** dedicada en exclusiva. El procesamiento de lotes masivos decrece y aumentan exponencialmente los ciclos de desarrollo: edición de código, pruebas y ejecuciones dinámicas reales.

(01-ejecucion-de-programas-4-2-organizacion-y-el-rol-del-usuario)=

### 4.2. Organización y el rol del usuario

El centro de cómputos tradicional pierde centralidad. Las terminales se distribuyen en oficinas, universidades y centros de atención al público, permitiendo que el **usuario remoto** interactúe en tiempo real con el sistema para editar y ejecutar sus programas inmediatamente.

(01-ejecucion-de-programas-4-3-exigencias-tecnicas-del-sistema-operativo)=

### 4.3. Exigencias técnicas del sistema operativo

- **Optimización del tiempo de respuesta**: El algoritmo de planificación prioriza que el usuario reciba un _feedback_ inmediato a sus comandos (milisegundos), implementando técnicas de reparto de tiempo (_round-robin_ o asignación por ráfagas de tiempo/cuantos).
- **Planificación de mediano plazo e intercambio (_swapping_)**: Ante la alta cantidad de usuarios interactivos, la memoria física total puede verse superada. El sistema operativo tiene que mover procesos enteros o páginas de memoria inactivas hacia el almacenamiento secundario (disco) para liberar espacio.
- **Pérdida de peso de las prioridades fijas**: Las prioridades internas pasan a un segundo plano; el sistema busca equidad (_fairness_) entre todos los usuarios conectados.
- **Robusta interacción entre tareas y estadísticas**: Al haber múltiples usuarios concurrentes operando de forma activa, la necesidad de controlar la seguridad, el acceso a archivos compartidos y el registro de uso se vuelve crítica.

---

(01-ejecucion-de-programas-5-sistemas-de-tiempo-real-real-time)=

## 5. Sistemas de tiempo real (_real-time_)

(01-ejecucion-de-programas-5-contexto-y-usos)=

### 5.1. Contexto y usos

A diferencia de los sistemas operativos donde un retraso es molesto, en los sistemas de tiempo real **la corrección del sistema depende no solo del resultado lógico, sino del momento exacto en que se entrega dicho resultado**. Se utilizan en el control automático industrial (robótica, refinerías), sistemas de guiado, telecomunicaciones, bases de datos transaccionales centralizadas y servicios críticos con requisitos de disponibilidad absoluta.

(01-ejecucion-de-programas-5-2-organizacion-y-el-rol-del-usuario)=

### 5.2. Organización y el rol del usuario

El entorno muta hacia un **centro de control**. El operador humano ya no interactúa típicamente para programar o editar, sino para supervisar el estado del sistema, realizar el mantenimiento de soportes de datos (discos/cintas) y atender de forma inmediata **alarmas y eventos críticos** disparados por el entorno.

(01-ejecucion-de-programas-5-exigencias-tecnicas-del-sistema-operativo)=

### 5.3. Exigencias técnicas del sistema operativo

- **Retorno absoluto de las prioridades externas**: Las prioridades vuelven a ser el eje central de la planificación. El sistema operativo tiene que ser determinista. Las prioridades son asignadas por eventos externos al sistema (por ejemplo, una lectura crítica de un sensor de temperatura tiene que desalojar inmediatamente a cualquier otra tarea del procesador).
- **El tiempo de respuesta pierde peso relativo frente al determinismo**: No importa que el sistema atienda rápido en promedio; importa que garantice cumplir con los plazos límite estrictos (_deadlines_) en el peor de los casos concebible.
- **Alta interacción y sincronización estricta**: Las tareas de control tienen que comunicarse a velocidades extremadamente altas y con mecanismos de exclusión mutua que eviten la inversión de prioridades.
- **Registros de eventos (_logging_)**: Auditoría estricta en tiempo real de cada suceso, falla o cambio de estado para diagnóstico inmediato y tolerancia de fallas.

---

(01-ejecucion-de-programas-6-matriz-de-correspondencia-equipos-vs-sistemas-operativos)=

## 6. Matriz de correspondencia: Equipos vs. Sistemas operativos

| Tipo de Equipo                          | Manuales | Batch 1 tarea | Batch n tareas | Tiempo compartido | Tiempo real        |
| --------------------------------------- | -------- | ------------- | -------------- | ----------------- | ------------------ |
| Mainframes                              | Sí       | Sí            | Sí             | Sí                | < (Limitado/Nicho) |
| Minicomputadores                        | Sí       | ∼ (Rareza)    | ∼ (Rareza)     | Sí                | Sí                 |
| Microcomputadores (PCs comunes)         | Sí       | ∼ (Rareza)    | ∼ (Rareza)     | Sí                | Sí                 |
| Microcontroladores (Sistemas embebidos) | Sí       | ∼ (Rareza)    | ∼ (Rareza)     | Sí                | Sí                 |
| Dispositivos Móviles                    | No (x)   | No (x)        | No (x)         | Sí                | No (x)             |

---

(01-ejecucion-de-programas-7-mecanismos-de-interrupcion-y-comunicacion-con-el-entorno)=

## 7. Mecanismos de interrupción y comunicación con el entorno

Para soportar estas modalidades (especialmente las multiprogramadas, de tiempo compartido y tiempo real), los sistemas operativos implementan estructuras basadas en **eventos y señales**.

(01-ejecucion-de-programas-7-system-calls-y-señales)=

### 7.1. Llamadas al sistema y señales

- **Llamada al sistema (_system call_)**: Es un mecanismo síncrono mediante el cual un programa en espacio de usuario solicita explícitamente un servicio al kernel (como leer un archivo o reservar memoria). Provoca un cambio controlado del modo de ejecución del procesador.
- **Señal (_signal_)**: Es un mecanismo asíncrono utilizado para notificar a un proceso que ocurrió un evento específico (por ejemplo, una violación de memoria, una interrupción por teclado o una alarma de tiempo).

(01-ejecucion-de-programas-7-2-intercambio-de-modo-entre-espacios-de-memoria)=

### 7.2. Intercambio de modo entre espacios de memoria

Para garantizar la exclusión mutua, las solicitudes y las señales transitan a través de fronteras de hardware definidas:

 ```{mermaid}
flowchart TB
  A(Usuario) ---> Espacio_Usuario

  subgraph Espacio_Usuario [Usuario]
    direction LR
    H[Aplicaciones]
    I[Shell]
    J[Herramientas]
  end

  subgraph Espacio_Kernel [Sistema operativo]
    direction TB
    K[Interfaz de System Calls]
    S[Manejador de Señales / Internals]
    subgraph HW [Hardware]
      CPU[CPU / Disco / Memoria]
    end
  end

  Espacio_Usuario ===>|Invocan System Call| K
  K --->|Ejecuta en modo protegido| HW
  HW -.->|Devuelve resultado| K
  K -.->|Retorno de la Syscall| Espacio_Usuario

  S ==>|Envía Señal| Espacio_Usuario
```

(01-ejecucion-de-programas-7-3-captura-de-seniales-en-alto-nivel)=

### 7.3. Captura de señales en alto nivel

Los lenguajes de programación interactúan con las señales del sistema operativo permitiendo definir rutinas de captura personalizadas.

Por ejemplo, en **Perl**, la captura se realiza mapeando el hash global `%SIG`:

```{code-cell} perl
# Asignación de un puntero a una función propia para manejar la señal
%SIG{NOMBRE_DE_LA_SEÑAL} = \&rutina_propia;
```

Cuando el sistema operativo envía la señal especificada al proceso, la ejecución normal se interrumpe y el control se transfiere inmediatamente a `rutina_propia`.

---

(01-ejecucion-de-programas-8-evolucion-de-las-interfaces-de-usuario)=

## 8. Evolución de las interfaces de usuario

El modo en que los usuarios interactúan con estas estructuras internas de los sistemas operativos también sufrió una transformación radical:

```{mermaid}
flowchart LR
  A(Línea de comandos / CLI) --> B
  B(Surgimiento de interfaces gráficas / GUI)
```

1. **Interfaces de línea de comandos (_CLI_)**: Propias de los primeros sistemas de tiempo compartido (consolas Unix/Shell). Todo el control se ejercía mediante sintaxis estricta de comandos de texto.
2. **Interfaces gráficas de usuario (_GUI_)**: Introdujeron el paradigma de abstracción visual (ventanas, íconos, punteros). Sus hitos históricos de masificación e integración con el kernel incluyen:
   - **XEROX PARC**: Pioneros absolutos en el concepto de GUI y el mouse.
   - **X-Windows (X11)**: Arquitectura cliente-servidor de red para entornos gráficos en sistemas Unix/Linux. Actualmente se busca reemplazar por **Wayland**.
   - **macOS**: Integración fluida de una interfaz gráfica de alta fidelidad sobre bases sólidas de sistemas tipo Unix.
   - **Windows 3.1/Windows NT**: Transición de Microsoft desde un entorno gráfico corriendo sobre una base batch/CLI (MS-DOS) hacia un sistema operativo con un kernel multiprogramado real y subsistema gráfico integrado de alto rendimiento (**Windows NT** y sucesores modernos).

(01-ejecucion-de-programas-8-1-capas-logicas-en-subsistemas-graficos-gui)=

### 8.1. Capas lógicas en subsistemas gráficos (_GUI_)

La incorporación de un entorno gráfico asocia la captura de eventos físicos de entrada/salida con llamadas del subsistema de ventanas sincronizadas con el núcleo:

 ```{mermaid}
flowchart TB
  A(Usuario) ---> H

  subgraph Espacio_Usuario [Usuario]
    direction LR
    H[Aplicaciones]
    E_Prop[Eventos propios]
  end

  subgraph Interfaz_Grafica [Interfaz gráfica]
    T[Eventos gráficos]
    API_GUI[API a la interfaz gráfica]
  end

  subgraph Espacio_Kernel [Sistema operativo]
    direction TB
    API_SO[API al sistema operativo]
    K[Interfaz de System Calls]
    subgraph HW [Hardware]
      CPU[CPU / Disco / Memoria]
    end
  end

  %% Conexiones solicitadas
  T ---> H
  H ---> API_GUI
  H ---> E_Prop
  H ---> API_SO

  %% Flujo base de System Calls
  API_SO ===>|Invocan System Call| K
  K --->|Ejecuta en modo protegido| HW
  HW -.->|Devuelve resultado| K
  K -.->|Retorno de la Syscall| H
```
