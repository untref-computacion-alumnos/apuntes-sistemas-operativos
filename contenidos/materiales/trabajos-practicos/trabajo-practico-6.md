# Trabajo Práctico 6

(trabajo-practico-6-ejercicio-1)=

## Ejercicio 1

Suponiendo que el proceso está esperando para ingresar a una región crítica.

¿En qué lugares una intervención del sistema operativo provocando un _context switch_ es riesgosa y en qué lugares no?

```txt
SET LIBRE 0000H
SET OCUPADO 0FFFFH
ESPERAR MOV R1, FLAG          ; Mover valor del Flag al R1
        CMP R1,OCUPAD0        ; Comparar con codigo de ocupado
        BE ESPERAR            ; SI- Está ocupado, seguir esperando
        MOV R1,OCUPADO        ; NO- Mover codigo de ocupado al R1
        MOV FLAG, R1          ; Depositarlo en el Flag
```

(trabajo-practico-6-ejercicio-2)=

## Ejercicio 2

En el contexto del {ref}`trabajo-practico-6-ejercicio-1`:

¿Cuál es la mejor manera de usar las instrucciones `ION` e `IOFF` para declarar libre una zona crítica, en caso de que el proceso estuviera autorizado a usarlas?

(trabajo-practico-6-ejercicio-3)=

## Ejercicio 3

En el contexto del {ref}`trabajo-practico-6-ejercicio-1`:

¿Qué información guardada en el _Process Control Block_ es esencial para continuar sin inconvenientes si el _context switch_ se produce entre las instrucciones:

```txt
CMP R1, OCUPADO
BE ESPERAR
```

(trabajo-practico-6-ejercicio-4)=

## Ejercicio 4

Considerar la organización de las pilas de ejecución de un lenguaje tipo Algol con varios hilos de ejecución.

¿Si se crea un nuevo hilo, la pila de este se crea en un hueco entre las pilas de otros hilos?

1. Nunca.
2. Siempre.
3. Depende. ¿De qué?

(trabajo-practico-6-ejercicio-5)=

## Ejercicio 5

Suponiendo que se está utilizando el siguiente código para controlar el acceso a una región crítica:

```txt
SET LIBRE 0000H
SET OCUPADO 0FFFFH
FLAG  DS 2
LOOP: MOV   CX, OCUPADO       ; PREPARAR REGISTRO CX
      MOV   AX, LIBRE         ; PREPARAR REGISTRO AX
      LOCK  CMPXCHG FLAG, CX  ; PROBAR EL ESTAD0 DEL FLAG
      BNZ   LOOP              ; FLAG OCUPADO, ESPERAR
                              ; INGRESAR EN LA REGIÓN CRÍTICA
```

Sin embargo, se observa que los procesos que utilizan esta estrategia consumen su ventana de tiempo sin poder hacer nada, ni dejar hacer nada a ningún otro proceso, por lo que se decide introducir la siguiente modificación:

```txt
SET LIBRE 0000H
SET OCUPADO 0FFFFH
FLAG  DS 2
LOOP: MOV   CX, OCUPADO       ; PREPARAR REGISTRO CX
      MOV   AX, LIBRE         ; PREPARAR REGISTRO AX
      LOCK  CMPXCHG FLAG, CX  ; PROBAR EL ESTADO DEL FLAG
      BZ    INGRESAR          ; SALTAR A LA REGIÓN CRÍTICA
      MOV   AX, 10            ; INDICAR DURACIÓN DE LA ESPERA
      CALL SLEEP              ; INVOCAR SYSTEM CALL SLEEP
      BRI LOOP                ; PROBAR OTRA VEZ
                              ; INGRESAR A LA REGIÓN CRÍTICA
```

Donde `SLEEP` es el comienzo de una función que invoca la _system call_ del sistema operativo que suspende el proceso y el número 10 indica que el proceso decide suspenderse durante $10 \text{ ms}$. Suponer además que la conmutación entre procesos en este sistema se basa en un timer que interrumpe cada $10 \text{ ms}$.

- ¿Es apropiado ese valor?
- ¿Es preferible que sea mayor?
- ¿Es preferible que sea menor?
- ¿Cuánto mayor?
- ¿Cuánto menor?

(trabajo-practico-6-ejercicio-6)=

## Ejercicio 6

Considerar la situación que se plantea cuando en un cluster de computadores el gestor del cluster, por razones de balance de carga decide trasladar un proceso de un computador a otro.

¿Qué precauciones se tienen que tomar con el intercambio de mensajes que realizaba el proceso trasladado?
