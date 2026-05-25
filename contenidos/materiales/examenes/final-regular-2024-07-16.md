# Sistemas Operativos - Final Regular - 16/07/2024

(final-regular-2024-07-16-ejercicio-1)=

## Ejercicio 1

Considerar un sistema operativo que utiliza una gestión de memoria basada en memoria virtual que utiliza una _TLB_ para la conversión del número de página virtual en el número de página real.

- ¿En qué situación se produce un fallo de página?
- ¿En qué situación se produce un fallo de _TLB_?
- ¿Pueden ocurrir ambos fallos en el mismo acceso a memoria?

(final-regular-2024-07-16-ejercicio-2)=

## Ejercicio 2

- ¿Qué acciones lleva a cabo un sistema operativo cuando una aplicación decide abrir un archivo?
- ¿Qué acciones lleva a cabo cuando la aplicación solicita una lectura?
- ¿Qué acciones lleva a cabo cuando la aplicación decide cerrar el archivo?

Centrar la respuesta en la gestión de los buffers necesarios.

(final-regular-2024-07-16-ejercicio-3)=

## Ejercicio 3

- ¿Qué acciones lleva a cabo un sistema operativo cuando una aplicación decide abrir un archivo?
- ¿Qué acciones lleva a cabo cuando la aplicación solicita una lectura?
- ¿Qué acciones lleva a cabo cuando la aplicación decide cerrar el archivo?

Centrar la respuesta en la gestión de CPU.

(final-regular-2024-07-16-ejercicio-4)=

## Ejercicio 4

Considerar un sistema operativo que utiliza una gestión de memoria basada en memoria virtual.

¿Qué ventajas e inconvenientes se producen si se aumenta el tamaño de página?

(final-regular-2024-07-16-ejercicio-5)=

## Ejercicio 5

Considerar un computador basado en el bus multibus standard (`ANSI/IEEE Std 796-1983`), donde las líneas que conectan la CPU con la memoria son:

```txt
INIT (INITIALIZE)
BHEN+ (BYTE HIGH ENABLE)
ADDRESS (A0 TO A23)
DATA (D0 TO D15)
XACK (TRANSFER ACKNOWLEDGE)
MWTC+ (MEMORY WRITE COMMAND)
MRDC+ (MEMORY READ COMMAND)
```

En el mismo se instaló una unidad de gestión de memoria, para lo cual se interfirieron las líneas `A0 TO A23` y las líneas `D0 TO D15`.

¿Es esa la solución correcta? Si la respuesta es negativa, indicar por qué falla. Si la respuesta es positiva, indicar cómo funciona.
