# Sistemas Operativos - Parcial - ##/##/####

(parcial-anio-mes-dia-2-ejercicio-1)=

## Ejercicio 1

Se tiene una tabla de clusters libres en un disco con los siguientes valores en los primeros lugares: `FF FE EF AB AA BA CC FF 0F 9C 7E 4F`... Se necesita ubicar tres clusters libres contiguos.

¿Cuáles son los tres primeros clusters libres contiguos?

(parcial-anio-mes-dia-2-ejercicio-2)=

## Ejercicio 2

Se tiene un computador con una memoria de $128 \text{ K direcciones}$ de $48 \text{ b}$ cada una. El mismo tiene organizada esta memoria mediante particiones fijas. En la partición número 3, que comienza en la dirección `0C000` y termina en la dirección `11FFF`, se ejecutará rutinariamente un programa en un lenguaje estático que posee una matriz cuadrada de $50 \times 50$ reales de $64 \text{ b}$, ubicada a partir de la dirección `6E0`. Surge la necesidad de agrandar esa matriz.

¿Cuál es el tamaño máximo que puede adquirir?

(parcial-anio-mes-dia-2-ejercicio-3)=

## Ejercicio 3

Se tiene un arreglo de discos que utilizan 4 discos de datos y 3 discos de verificación utilizando el código de Hamming. En el mismo se necesita escribir el número entero `0014F000`.

¿Qué se escribirá en cada disco?

(parcial-anio-mes-dia-2-ejercicio-4)=

## Ejercicio 4

Se tiene un computador que posee una unidad de expansión de direccionamiento. En el mismo se encuentra ejecutando un programa ubicado en las páginas virtuales `1A`, `1B`, `1C`, `1D` y `1E`. Se sabe que la última página es la `7F`. El contenido de la tabla de la unidad de gestión de memoria _MMU_ es: `1A` $\rightarrow$ `37F`, `1B` $\rightarrow$ `076`, `1C` $\rightarrow$ `233`, `1D` $\rightarrow$ `19C`, `1E` $\rightarrow$ `200`. El registro de próxima instrucción o contador de programa de la CPU posee $17 \text{ b}$.

¿A qué dirección real se accede cuando la CPU direcciona a `068D4`, `074C0` y `07801`?

(parcial-anio-mes-dia-2-ejercicio-5)=

## Ejercicio 5

Se tiene un sistema operativo cuya gestión de CPU se basa en tiempo compartido. En el mismo se tiene que el cambio entre dos procesos consume $0.5 \text{ ms}$ y el cambio entre hilos consume $0.1 \text{ ms}$. Por otro lado, se tiene que el 50% de las conmutaciones son entre procesos y el otro 50% entre hilos.

¿Cuál es el menor clock que garantiza que el costo de conmutación sea inferior al 10%?

(parcial-anio-mes-dia-2-ejercicio-6)=

## Ejercicio 6

En un sistema operativo con una memoria virtual de $32 \text{ TB}$ y una memoria real de $8 \text{ GB}$, donde cada dirección corresponde a un byte se tiene una memoria caché con bloques de $8 \text{ B}$ y 128 líneas.

- ¿En qué línea se ubica la dirección real `142F046A`?
- ¿A qué byte del bloque se refiere?
