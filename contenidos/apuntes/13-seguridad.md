# Seguridad en sistemas operativos e información

La **seguridad informática** se define formalmente como la disciplina encargada de proteger los activos tangibles e intangibles de una organización, colaborando directamente con sus objetivos estratégicos. Las políticas de seguridad tienen que diseñarse bajo una premisa operativa fundamental: **interferir lo menos posible en la operatoria normal de la organización**, logrando un equilibrio óptimo entre la rigidez del control y la flexibilidad del negocio.

(13-seguridad-1-activos-de-la-organizacion-y-el-plan-de-seguridad)=

## 1. Activos de la organización y el plan de seguridad

El diseño de un sistema seguro exige identificar qué elementos se encuentran bajo protección, clasificándose jerárquicamente en:

- **Activos centrales**: Recursos físicos (hardware, servidores), la información (bases de datos, archivos de configuración) y el personal.
- **Activos marginales**: La reputación institucional y la situación legal de la organización.

(13-seguridad-1-1-el-plan-de-seguridad)=

### 1.1. El plan de seguridad

Es el instrumento formalizado que mitiga las vulnerabilidades mediante las siguientes acciones mandatorias:

1. Descubrir y categorizar los riesgos existentes.
2. Definir e instrumentar políticas de seguridad explícitas.
3. Promover la atención, concientización y capacitación de todos los usuarios involucrados.
4. Estudiar continuamente la efectividad real de las políticas aplicadas.

El plan tiene que ser coherente con el negocio, poseer un costo razonable, delimitar responsabilidades explícitas, ser compatible con la cultura interna de la organización y **adaptarse dinámicamente a las diferentes circunstancias de uso** (operación habitual, fuera de horario o ventanas de mantenimiento técnico).

```{admonition} Regla de diseño temprano
---
class: warning
---
La seguridad no tiene que ser un parche posterior; los requisitos de un sistema de software tienen que incluir los aspectos de control como una **propiedad integrada desde las fases más tempranas del diseño del sistema**.
```

---

(13-seguridad-2-estadisticas-de-amenazas-y-la-triada-cia)=

## 2. Estadísticas de amenazas y la tríada CIA

Un análisis empírico de los vectores de ataque revela una realidad contraintuitiva en la seguridad de sistemas operativos:

```{mermaid}
flowchart LR
  A[Errores y omisiones: 65%] --> B
  B[Empleados deshonestos: 13%] --> C
  C[Inconformes: 10%] --> D
  D[Físicos: 8%] --> E
  E[Hackers: 5%]
```

- **Errores y omisiones**: Constituye la principal fuente de incidentes, provocado no intencionalmente por fallas de usuarios, errores en el ingreso de datos, u omisiones de operadores y programadores.
- **Empleados deshonestos e disconformes**: Superan ampliamente las amenazas externas.
- **Pérdidas físicas**: Caídas del suministro eléctrico, cortes de telecomunicaciones, incendios, inundaciones o huelgas.
- **Hackers**: Se considera la cifra peor documentada porque por razones de prestigio comercial e imagen pública, muchas organizaciones ocultan activamente las intrusiones externas sufridas.

(13-seguridad-2-1-objetivos-fundamentales-de-la-seguridad-de-la-informacion-triada-cia)=

### 2.1. Objetivos fundamentales de la seguridad de la información (tríada CIA)

Toda protección busca garantizar de forma simultánea tres pilares básicos:

- **Confidencialidad**: Asegurar que la información sea accesible única y exclusivamente por aquellas personas o sujetos autorizados que posean el derecho legítimo de hacerlo.
- **Integridad**: Garantizar que la información permanezca exacta, completa y libre de modificaciones o corrupciones no autorizadas.
- **Disponibilidad**: Asegurar que los sujetos autorizados puedan acceder a la información y a los recursos del sistema siempre que lo requieran.

---

(13-seguridad-3-riesgos-y-protecciones-basicas-del-sistema-operativo)=

## 3. Riesgos y protecciones básicas del sistema operativo

Para resguardar los perímetros de seguridad de un sistema, el kernel y las aplicaciones coordinan mecanismos de mitigación específicos ante cada categoría de riesgo:

| **Categoría de Riesgo** | **Naturaleza** | **Mecanismo de Protección Básica**                                                                                                                          |
| ----------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Errores y omisiones** | Interno        | Principio del mínimo privilegio posible: Otorgar a cada usuario o proceso únicamente los derechos estrictamente necesarios para cumplir su tarea acotada    |
| **Fraude interno**      | Interno        | Definición precisa de roles; auditoría sistemática mediante el estudio de registros de operaciones (logs) y realización de copias físicas periódicas        |
| **Hackers/Intrusos**    | Externo        | Endurecimiento de los controles de acceso del sistema operativo; análisis automatizado de bitácoras y búsqueda sistemática de rootkits o programas intrusos |
| **Código malicioso**    | Externo/Mixto  | Antivirus, detectores de Troyanos y Gusanos; políticas estrictas de filtrado de correo electrónico                                                          |
| **Saturación (DDoS)**   | Externo        | Mitigación de comunicaciones parásitas; requiere de forma mandatoria la cooperación y participación de los proveedores de telecomunicaciones                |
| **Ingeniería social**   | Externo/Humano | Políticas y protocolos humanos para controlar e inhibir: el deseo innato de ayudar, la confianza excesiva, el temor a incomodar y la comodidad excesiva     |

---

(13-seguridad-4-el-proceso-secuencial-del-control-de-acceso)=

## 4. El proceso secuencial del control de acceso

El control de acceso regula la interacción entre los **sujetos** activos (usuarios, procesos, aplicaciones cliente) y los **objetos** pasivos del sistema (computadoras, bases de datos, archivos, programas). Se ejecuta obligatoriamente a través de cuatro etapas lógicas y secuenciales:

```{mermaid}
flowchart LR
  A[Identificación] --> B
  B[Autenticación] --> C
  C[Autorización] --> D
  D[Seguimiento/Auditoría]
```

(13-seguridad-4-1-identificacion)=

### 4.1. Identificación

Es el mecanismo inicial mediante el cual el sujeto aspira a ingresar al sistema declara explícitamente su identidad (indica quién es, por ejemplo, ingresando su nombre de usuario o ID).

(13-seguridad-4-2-autenticacion)=

### 4.2. Autenticación

Es el conjunto de mecanismos mediante los cuales el sistema operativo valida y obtiene una certeza matemática o lógica de que el sujeto que aspira a acceder es efectivamente quien decide ser.

**Mecanismos múltiples (análisis de flujo)**: Cuando se implementa más de un factor de identificación o autenticación, su topología altera las propiedades del sistema:

- **Configuración en serie**: Los controles se encadenan uno atrás de otro. **Aumenta drásticamente la seguridad** del sistema, pero inyecta una alta rigidez operativa.
- **Configuración en paralelo**: Basta con validar cualquiera de los mecanismos para otorgar el acceso. **Se pierde nivel de seguridad**, pero se incrementa la flexibilidad del usuario.

(13-seguridad-4-3-autorizacion)=

### 4.3. Autorización

Una vez autenticado el sujeto, el sistema operativo le otorga formalmente los derechos de acceso específicos que le corresponden sobre los objetos del sistema. Puede gestionarse bajo dos variantes:

- **Genérica (implícita)**: El sujeto recibe un token global con todos sus derechos precargados al iniciar la sesión.
- **Explícita**: El sujeto ingresa sin privilegios y tiene que invocar e indicar explícitamente a qué derecho específico aspira acceder en cada operación.

(13-seguridad-4-4-seguimiento)=

### 4.4. Seguimiento

Es el registro cronológico estricto de cada una de las acciones realizadas por el sujeto dentro del sistema. La profundidad y criticidad de este registro de auditoría se encuentra estrechamente vinculada al nivel de especificidad de las autorizaciones previamente otorgadas.

---

(13-seguridad-5-arquitectura-de-los-mecanismos-de-autenticacion)=

## 5. Arquitectura de los mecanismos de autenticación

Los factores de validación de identidad se agrupan en tres categorías académicas, las cuales pueden combinarse en serie para conformar esquemas de autenticación multifactor:

(13-seguridad-5-1-lo-que-el-sujeto-conoce)=

### 5.1. Lo que el sujeto conoce (autenticación por conocimiento)

Se basa en información que el usuario memorizó:

- **Administración de contraseñas**: Exige políticas rigurosas controladas por el sistema operativo: mecanismos de sincronización de claves, capacidad de modificación obligatoria por el usuario, borrado supervisado de credenciales viejas, limitación estricta en la cantidad de intentos fallidos antes del bloqueo, y políticas de obsolescencia o envejecimiento de contraseñas.
- **Vectores de ataque**: Ataques de diccionario, fuerza bruta, acceso no autorizado a los archivos de perfiles del sistema (`/etc/shadow` o SAM) o ataques internos directos.
- **Contraseñas estructuradas y segmentadas**: Claves divididas o calculadas para evitar la intercepción completa.
- **Uso de perfiles**: Implementación de esquemas de autenticación por conocimiento variable, donde el sistema extrae dinámicamente preguntas aleatorias basadas en el perfil histórico del usuario.

(13-seguridad-5-2-lo-que-el-sujeto-posee)=

### 5.2. Lo que el sujeto posee (autenticación por posesión)

Basado en un objeto físico en control del interesado (tarjetas inteligentes, tokens criptográficos, llaves físicas). El plan de seguridad de la organización tiene que normar estrictamente el ciclo de vida de estos objetos: si tienen que permanecer siempre en poder del interesado, depositarse en la organización al finalizar la jornada o si permiten ser transferidos formalmente de persona en persona.

(13-seguridad-5-3-lo-que-el-sujeto-es)=

### 5.3. Lo que el sujeto es (autenticación biométrica)

Mecanismos automatizados basados en características biológicas únicas del ser humano, subdivididos en dos vertientes:

- **Biometría fisiológica (estructuras físicas inmutables)**:
  - Impresiones digitales (dactiloscopía).
  - Escaneo geomorfológico del iris o de la retina.
  - Geometría y topografía de la palma de la mano.
  - Reconocimiento de la estructura facial.
  - Patrones acústicos de la voz.
- **Biometría conductual (patrones dinámicos del comportamiento)**:
  - Tiempos y cadencia de tecleo entre operaciones de usuario.
  - Patrones y flujos de trabajo habituales dentro del entorno.
  - Estructura y dinámica de la fuerza/velocidad al trazar una firma holográfica.

---

(13-seguridad-6-consideraciones-de-administracion-de-privilegios)=

## 6. Consideraciones de administración de privilegios

La gobernanza de la seguridad del kernel impone responder de forma estricta a cinco interrogantes de diseño:

1. **¿Quién aprueba las autorizaciones?** Determinación de los roles de administración central frente a los dueños de los objetos.
2. **¿Los usuarios anteriores conservan sus autorizaciones?** Control de la persistencia de permisos para evitar la acumulación histórica de privilegios innecesarios.
3. **¿Cómo se revocan las autorizaciones?** Instrumentación de mecanismos atómicos e inmediatos para dar de baja los accesos de un sujeto "en caliente".
4. **¿Los accesos son centralizados o múltiples?** Decisión de arquitectura entre mantener un único punto de validación o un esquema distribuido.
5. **¿Las autenticaciones son coherentes con las autorizaciones?** Garantía lógica de que el nivel
