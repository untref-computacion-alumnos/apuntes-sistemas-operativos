# Sistemas Operativos - Parcial - ##/##/####

(parcial-anio-mes-dia-1-ejercicio-1)=

## Ejercicio 1

Suponer que se está ejecutando en una CPU en la que la fase FETCH requiere 8 ciclos de CPU, la fase DECODE requiere 2 ciclos de CPU y la fase EXECUTE varía dependiendo del tipo de instrucción.

1. Instrucciones aritméticas entre registros: 1 ciclo.
2. Instrucciones aritméticas entre memoria (directa) y registros: 9 ciclos.
3. Instrucciones aritméticas entre memoria (indexada) y registros: 20 ciclos.
4. Instrucciones de bifurcación: 22 ciclos.

La frecuencia del BUS es de 200 MHz y la de la CPU 2 GHz.

La misma CPU comparte el CPU con un dispositivo de acceso directo a memoria que funciona por robo de ciclos. El _DMA_ espera que termine una instrucción la CPU y ocupa el BUS durante 4 ciclos de BUS. Después espera 16 ciclos de BUS antes de comenzar un nuevo robo de ciclo.

¿Cuántos bytes transferirán mediante el _DMA_ y cuántas instrucciones se ejecutarán durante un segundo, si ocurre que en el programa existe un 25% de instrucciones de cada grupo?

(parcial-anio-mes-dia-1-ejercicio-2)=

## Ejercicio 2

Considerar un computador que posee un BUS con 16 líneas de direcciones y 48 líneas de datos, en el que cada dirección se refiere a una palabra de 48 bits. El sistema operativo ocupa $48 \text{ B}$ y se encuentra ubicado en las direcciones más bajas. En el mismo se instaló memoria hasta la dirección `EFFF`. La primera partición fija es de $96 \text{ KB}$ y se ubica a continuación del sistema operativo. En el resto de la memoria se planifica crear particiones chicas de $24 \text{ KB}$.

1. ¿Cuántas particiones chicas se pueden crear?
2. ¿En qué dirección comienza y en qué dirección termina cada partición?

(parcial-anio-mes-dia-1-ejercicio-3)=

## Ejercicio 3

En un computador con segmentos externos se instalaron $1024 \text{ KB}$ de memoria. Cada dirección posee $16 \text{ b}$. Los segmentos se crean en tamaños que son múltiplos de $16 \text{ KB}$.

¿Cuántos bits posee el registro de la _MMU_ que almacena la dirección de comienzo del segmento?

(parcial-anio-mes-dia-1-ejercicio-4)=

## Ejercicio 4

Se tiene un sistema operativo con una memoria virtual de $8 \text{ TB}$ con una memoria real de $4 \text{ GB}$ y páginas de $32 \text{ KB}$, donde cada dirección corresponde a un byte. Se sabe que la página virtual `29F0016`, es almacenada en la página real `9627`.

¿Cuál es la dirección real correspondiente a la dirección virtual `14F800B6F13`?

(parcial-anio-mes-dia-1-ejercicio-5)=

## Ejercicio 5

Se tiene un disco en cuya zona media tiene 4960 sectores de 4096 bytes cada uno. Se sabe que la numeración de los sectores en cada pista sigue el siguiente patrón: $0, 20, 40, ..., 4940, 1, 21, 41, ...$. Se sabe además que la lógica de verificación de cada sector necesita 35 microsegundos después de cada lectura.

¿Cuál es la máxima velocidad de rotación del disco?
