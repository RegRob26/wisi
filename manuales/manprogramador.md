* * *
<center> Autores:
                    ```
                    Ayuzo Pacheco Jordan,
                    Robles Robles Emmanuel Guadalupe
                    ```
* * *

# <center> 「 MANUAL DE PROGRAMADOR」

<center> <b> ◈  wisi (Interprete de comandos)  ◈

* * *
<center> **[Repositorio del proyecto.](https://github.com/RegRob26/pareshell.git)**

* * *

## <center> Tabla de Contenido

* * *

1. Introducción

          1.1. Vista general
          1.2. Requerimientos

2. Programas incluidos

        2.1. SHELL ~
            2.1.1. Descripción del programa.
            2.1.2. Segmento de datos.
            2.1.3. Funciones.
                2.1.3.1. Main
                2.1.3.2. Cic
                2.1.3.3. Despan
        2.2. CHECK ~
            2.2.1. Descripción del programa.
            2.2.2. Segmento de datos.
            2.2.3. Funciones.
                2.2.3.1. Verificador
                2.2.3.2. Ejecutador
        2.3.FILEOTH
            2.3.1. Descripción del programa.
            2.3.2. Segmento de datos.
            2.3.3. Funciones.
                2.3.3.1. Comparaciones
                2.3.3.2. Sal_file
        2.4.MSHELL
            2.4.1. Macros.
                2.4.1.1 lenar.
                2.4.1.2 sepcom.
                2.4.1.3 cadprint
                2.4.1.3 clean_arr
                2.4.1.3 despnum

<div style="page-break-after:always"></div>

***

## <center> ➀ Introducción.

* * *

### 1.1. Vista general

<div style="text-align:center">
En este documento se encuentran redactadas y explicadas las funciones más importantes en la ejecución del código, cada parte de los 3 generales índices se fragmentan en subíndices para explicar de mejor manera el contenido de todo el programa.

<center> ¡AVISO!
<center> Para ensamblar el programa se necesita de TASM Y TLINK que en este documento se asume que el programador ya lo tiene previamente instalado y configurado para funcionar desde cualquier carpeta. Dada esta explicación se proce a indicar la forma correcta de ensamblar el programa y ejecutarlo

</div>


```
                                                            1. tasm shell
                                                            2. tasm check
                                                            3. tasm fileoth
                                                            4. tasm fun
                                                            5. tlink shell check fileoth fun
                                                            6. SHELL.EXE

```
<center> Continúa la lectura.

* * *


##  <center>➁ Programas incluídos.

***

### 2.1. SHELL.

#### 2.1.1. Descripción del programa.

Es el programa principal que se encarga de gestionar el funcionamiento general de la SHELL mediante un ciclo que se finaliza cuando el usuario lo requiera. No tiene mucha complejidad en su funcionamiento menos atómico.

#### 2.1.2. Segmento de datos.

En el segmento de datos encontrarán las principales variables utilizadas durante la ejecución del programa. Todas ellas son de
importancia por lo que se listarán según el orden en que aparecen en dicho segmento detallando su uso y parámetros iniciales.

+ **DTA**

    Es una estructura que permite almacenar los datos de un archivo al ser leído por el sistema, contiene distintos atributos que la conforman tales como:
    +   attr

        time

        date

        sizel

        sizeh

        fname

                Valor por defecto de fname (db 13 dup(0))
                Este es de gran importancia para todo el programa puesto que tiene la pauta para determinar el número máximo de caracteres que es capaz de almacenar el nombre de un archivo junto con la extensión de este.
                Nombre del archivo será de máximo 8 caracteres y 3 caracteres de la extensión.

+ **BIEN**

    Puesto que la interrupción 21 junto a la función 27 recogen el directorio actual excluyendo el símbolo del directorio raíz, este se mostrará con la ayuda del arreglo BIEN que contiene de manera predeterminada lo siguiente:
    + Predeterminado

        + "> \"

+ **ndir**

    Contendrá en sí la ruta del directorio actual (En donde se encuentra el usuario).
    + Valor predeterminado

        + db 164 dup('-')

        El guión medio es un estandar para la inicialización de arreglos cuyo valor será utilizado, medido o separado.


+ **lendir**

    Arreglo que almacena el tamaño real leído de distintas cadenas, utilizado con frecuencia en el programa principal.
    + Valor predeterminado

        + dw ?  (Sin valor)

+ **renglon**

    Este arreglo es de suma importancia para la parte gráfica del programa ya que tendrá el control del número total líneas impresas y/o utilizadas durante la ejecución del programa, permitiendo así el manejo correcto de la pantalla principal.

    + Valor predeterminado
        + 0
***

+ **lencomando**

    Es el tamño real leído de la cadena **comando**, se utiliza para la separación de cadenas (comando de instrucciones).

    + Valor predeterminado
        + 0

+ **flagverifi**

    Una bandera para el control de la ejecución de comandos, su uso específico y detallado se redacta más adelante (Función main)

    + Valor predeterminado
        + 0

+ **cadena**

    Este arreglo es de suma importancia para la parte lógia del programa, puesto que contendrá los datos ingresados por el usuario pero
    todos juntos, es decir, tendrá los comando a ejecutar y sus instrucciones

    + Valor predeterminado
        + db 30 dup('-')

        El valor predeterminado puede cambiar en función del tamaño total de cadena que se requiera, pero si este número (19) llegáse a ser modificado se necesitarían cambiar algunos otros parámetros como el valor predeterminado de **comando** e **instrucciones**, además de otros parámetros en algunas funciones de SHELL. Se marcará con un comentario especial más adelante los lugares que se ven afectados por el cambio de este valor predeterminado



+ **comando**

    Como se explico en el punto anterior **cadena** contiene todos los datos pero juntos, por lo que al separarlos en este arreglo se encontrará el valor del comando a ejecutar.   Depende del valor predeterminado de cadena

    + Valor predeterminado
        + db 6 dup ('-')

        El guión medio es un estandar para la inicialización de arreglos cuyo valor será utilizado, medido o separado.



+ **instrucciones**

    Arreglo que contiene las instrucciones a realizar (máximo una para esta versión, además de una ruta solamente o algunas otras instrucciones explicadas más adelante) extraídas **cadena**. Su valor predeterminado depende de **cadena**

    + Valor predeterminado
        + db 25 dup('-')

        El guión medio es un estandar para la inicialización de arreglos cuyo valor será utilizado, medido o separado.


<div style="page-break-after:always"></div>
***


#### 2.1.3. Funciones.

***


##### 2.1.3.1. Main
+ Descripción
Es la función principal de todos los programas puesto que su funcionamiento permite la ejecución además de tener la estructura del
programa y la forma en que se busca ser utilizado. Tiene varios parámetros iniciales y rutinas utilizadas que se detallan a continuación, las de mayor obiedad y menor uso se detallan dentro del código por lo que su documentación será omitida en este archivo.

##### 2.1.3.2. Cic

+ Descripción
    + En estas tres líneas se hace la separación del comando y su instrucción por medio de una macro cuya explicación se reserva para otra sección, pero es importante decir que con el parámetro de cx en 0 se tendrá la separación respecto al valor predeterminado que es '-' (guión medio). Este proceso se realiza en dos pasos, primeramente con **lenar** se calcula el tamaño real de la cadena leída para posteriormente separarla con **sepcom**.

         ```
            mov cx, 0
            lenar cadena lendir cx
            sepcom cadena comando instrucciones
        ```

    + Aquí es en donde se realiza la parte central del programa y su principal objetivo, es decir verificar de que comando se trata y ejecutarlo, son dos funciones que reciben parámetros mediante la pila. Para **verificador** necesitamos *instrucciones*, *flagverifi*, *lencomando* y *comando*. De los cuales solamente *flagverifi* se verá afectado dentro de dicha función y de esta manera tendremos la indicación en forma de número del comando a realizar y de este dependerá la siguiente función.

        ```

        mov bx, offset instrucciones
		push bx
		mov bx, offset flagverifi			;[bp+8]
		push bx
		mov dx, lencomando			;[bp + 6]
		push dx
		mov dx, offset comando		;[bp+4]
		push dx
		call verificador
		add sp, 8
        ```

    + Ejecutador depende de la función anterior por medio del parámetro *flagverifi*, además recibe como parámetros *instrucciones* y *renglon*, donde esta última se verá afectada dentro de la función ya que como se indica en la sección de **segmento de datos** este nos permite tener el control de cuántas líneas han sido escritas para posteriormente limpiar la pantalla. El parámetro instrucciones será la acción a realizar dentro de la función.

        ```
		mov dx, offset renglon			;[bp + 8]
		push dx
		mov dx, offset instrucciones ;[bp+6]
		push dx
		mov dx, flagverifi		;[bp+4]
		push dx
		call ejecutador
		add sp, 6
		mov flagverifi, 0

		```


    + Puesto que los arreglos se ven afectados en la ejecución de **cic** es necesario colocarlos a sus valores predeterminados, esa acción es realizada por la macro clean_arr, pero por ahora lo que interesa es conocer que las cadenas tendrán que ser reinicializadas exclusivamente con los parámetros que hayan sido precargados en la sección de datos.

    ```
        clean_arr comando 6 '-'
		clean_arr cadena 19 '-'
		clean_arr instrucciones 14 '-'
		clean_arr ndir 164 '-'

    ```



##### 2.1.3.3. Despan
+ En esta sección se verá afectada la parte gráfica del programa mediante el incremento del renglon en que se encuentra el cursor.
    + Se hace uso de la interrupción 10 en su función 6h que permite realizar un scroll de la pantalla,  en este caso el scroll es hacia arriba. En el código se indica por cada línea a qué parámetro se refiere, además como en ciertos casos el valor **renglón** superará en demasía la cantidad permitida, la función crea un ciclo para dejar el valor de **renglon** menor a 25 (25 ya que es el tamaño de la gráfica creada y utilizada en el programa por lo cual no se garantiza su funcionamiento si este parámetro es modificado sin cambiar también el tamaño de la pantalla -definido en el main-).
    Si la ejecución ha terminado, continua el ciclo normal del programa respecto a la función **cic**.

    ```
        mov ah, 6
    	mov al, 2
    	mov bh, 0
    	mov ch, 0
    	mov cl, 0
    	mov dh, 0
    	mov dl, 80
    	int 10h

		sub renglon, 02h
		cmp renglon, 25
		jge despan
		jmp cic
    ```


### 2.2. CHECK.
#### 2.2.1. Descripción del programa.

Es el programa encargado de administrar la interpretación de los comandos para posteriormente realizar su ejecución con los parámetros dados. Contiene dos principales funciones a las que se les asignan estas tareas.

#### 2.2.2. Segmento de datos.
+ **Outhandle**
    Valor que contiene la dirección de un archivo abierto
    + Valor predeterminado

        + dw ?

+ **Comandos predefinidos**
    Son 9 líneas de datos que están previamente cargados por el programador ya que contienen en sí cada arreglo en la forma deseada para compararlos con los dados por el usuario. Tienen cierta sintáxis especial puesto que requieren de un caracter final para ser totalmente compatibles con los ingresados, por ejemplo "exit-", este guión es para saber que el comando ha terminado y además es exactamente igual al leído.
    + Valor predeterminado

        + Se listan todos los comandos predefinidos

        ```
            cexit 	db "exit-"
            ccd		db "cd-"
            ctouch	db "touch-"
            cdir	db "dir-"
            cmkdir 	db "mkdir-"
            crm		db "rm-"
            crmdir	db "rmdir-"
            ccls	db "cls-"
            help 	db "&&help-"
            helpt 	db "&help-"

        ```

+ **patron**
    Arreglo utilizado en el listado de archivos y carpetas que un directorio contiene (mediante el comando dir).
    + Valor predeterminado

        + "\*.\*", listará sin importar el nombre ni la extensión.

+ **DTIA**

    Es una estructura que permite almacenar los datos de un archivo al ser leído por las funciones de este programa (de manera interna sin afectar al programa principal **SHELL**), contiene distintos atributos que la conforman tales como:
    +   attr

        time

        date

        sizel

        sizeh

        fname

                Valor por defecto de fname (db 13 dup(0))
                Este es de gran importancia para todo el programa puesto que tiene la pauta para determinar el número máximo de caracteres que es capaz de almacenar el nombre de un archivo junto con la extensión de este.
                Nombre del archivo será de máximo 8 caracteres y 3 caracteres de la extensión.

+ **counter**
    Valor utilizado para el comando help ya que permite identificar que bloque de ayuda se busca, su valor siempre deberá ser un múltiplo de dos puesto que cada bloque contiene dos tokens,uno de inicio y uno de paro. Este depende del archivo helpfile.txt además del bloque buscado.
    + Valor predeterminado

        + 0


+ **lenfname**
    Auxiliar durante la ejecución del comando dir, ya que almacenará el tamaño del nombre cuyo archivo vaya a ser listado, de esta manera se tendrá control del valor para el nombre de cada archivo en una sola variable.
    + Valor predeterminado

        + 0

+ **divesizeH**
    Tendrá la parte alta de un registro como dx (dh).
    + Valor predeterminado

        +  0


+ **divesizeL**
    Tendrá la parte baja de un registro como dx (dl).
    + Valor predeterminado

        + 0

+ **renglon**
    Variable interna utilizada para desplegar datos en pantalla respecto a **renglon** del programa principal **shell**
     + Valor predeterminado

        + 0

+ **columna**
    Variable interna utilizada para desplegar datos en pantalla respecto a la columna en la que se desea iniciar el despligue de datos.
    + Valor predeterminado

        + 0




#### 2.2.3. Funciones.

##### 2.2.3.1. Verificador
+ Descripción

Verificador se encarga de comparar la cadena **comando** (de **SHELL**) pasada mediante la pila con los comandos predefinidos en la sección de datos de este programa (**CHECK**), además de ver si la **instrucción** es exactamente igual a **&&help** para dar paso a diferente activamiento de banderas respecto a verificador en su estado nato.
    + Contenido
    Veamos un ejemplo de estas Comparaciones, en realidad no existen muchas diferencias en cada una de las etiquetas internas de verificador, por lo que tomaremos una como ejemplo para detallar su funcionamiento. Si se desea agregar una nueva etiqueta para un nuevo comando se tendrán que seguir las mismas instrucciones que en esta sección.


    * La primera etiqueta (*com_cd*) compara el **comando** recibido con *comando* interno predefinido, el primer dato en el registro si y el segundo en di, posteriormente el **tamaño** en el registro cx y se hace uso de operaciones con arreglos para realizar la comparación.
    Si el dato llegara a ser diferente se saltará a la siguiente etiqueta que sigue la misma estructura que **com_cd** (en este caso es **com_dir**). Si el dato es igual se modifica **flagverifi** (mediante apuntador) con el valor predefinido (2 para este caso) que incrementará según se avance en las etiquetas (para **com_cd** el valor de **flagverifi** es 3h).
    Una vez realizado el paso anterior se compara la instrucción recibida con *&&help* si llegara a ser igual se modifica nuevamente el valor
    de **flagverifi** con un valor predefinido (21h para este caso, para **com_dir** es 31h) y se termina la ejecución de la función (salto a
    *ret_ver*). Por lo que lo descrito anteriormente se puede resumir en el siguiente pseudocódigo y código posteriormente.

    ```

        1. Comparar comando predefinido con comando recibido
        2. Si son diferentes saltar al paso 4
        3. Si son iguales hacer
            3.1. Cambiar el valor de la bandera (flagverifi) al valor predefinido            (valor predefinido(varía) 2 )
            3.2. Comparar instrucciones con '&&help'
            3.3. Si son diferentes saltar a paso 5
            3.4. Si son iguales hacer
                3.4.1. Cambiar el valor de la bandera (flagverifi) al {valor_predefinido, 1} (valor predefinido(varía) 21)
                3.4.2. Saltar a paso 5
        4. Continuar Comparaciones

        5. Salir


        Código

        com_cd:
                cld
                mov si, [bp+4]
                mov di, offset ccd
                mov cx, [bp+6]
                repe cmpsb
                jne com_dir

                mov bx, [bp+8]
                mov word ptr [bx], 2h

         help_cd:
                cld
                mov si, [bp+10]
                mov di, offset help
                mov cx, 6
                repe cmpsb
                jne ret_ver
                mov bx, [bp+8]
                mov word ptr [bx], 21h
                jmp ret_ver
    ```


##### 2.2.3.2. Ejecutador
+ Descripción
    Se encargará de realizar la ejecución del comando elegido con la respectiva instrucción. Al igual que en verificador se sigue la misma metodología para añadir una nueva funcionalidad.

    + Contenido
    Veamos un ejemplo de una de estas etiquetas para comprender su funcionamiento. Para el caso de *flag_cd* tenemos lo siguiente:
    movemos a un registro el valor predefinido que representa el comando actual, posteriormente lo comparamos con el parámetro **flagverifi** recibido mediante la pila, si llegara a ser igual ejecuta las instrucciones predefinidos, de lo contrario continuará la comparación con los demás comandos. Po lo que lo anterior se puede resumir en los siguientes pasos:

    ```

    1. Compara el parámetro flagverifi con el valor predefinido con el comando
    2. Si no es igual saltar al paso 4
    3. Si es igual hacer
        3.1. Realizar las instrucciones predefinidas por el programador
        3.2. Ir al paso
    4. Comparar el parámetro flagverifi con el valor predefinido para la ayuda del comando en el que se encuentre
    5. Si no es igual saltar al paso 7
    6. Si es igual hacer
        6.1. Llamamos a la función que despliega los datos con el número de bloqueas a omitir (véase sección de helpfile)
        6.2. Sumamos al parámetro renglon con 20
        6.3. Ir a 8
    7. Continuar Comparaciones
    8. Salir

    ```

    ```
    Código

        flag_cd:
                mov bx, 2
                cmp [bp+4], bx
                jne flag_helpcd

                mov ah, 3BH
                mov dx, [bp+6]
                int 21h
                jmp ret_eje
        flag_helpcd:
                mov bx, 21h
                cmp [bp+4], bx
                jne flag_dir

                mov dx, 4
                call comparaciones
                mov bx, [bp+8]
                mov dl, counter
                add byte ptr [bx], 20

                jmp ret_eje
    ```

<div style="page-break-after:always"></div>
***


### 2.3.FILEOTH

#### 2.3.1. Descripción del programa.
Es el programa encargado de gestionar la lectura y despliegue de datos para la función help de los distintos comandos. Su "único trabajo" es obtener los datos que se requieren mediante diversas rutinas aplicadas al archivo **helpfile.txt**.
#### 2.3.2. Segmento de datos.

En el segmento de datos encontrarán las principales variables utilizadas durante la ejecución del programa. Todas ellas son de
importancia por lo que se listarán según el orden en que aparecen en dicho segmento detallando su uso y parámetros iniciales.

+ **dirupa**
    Contiene el símbolo del directorio raíz puesto que dentro del programa lo necesitaremos para encontrar el archivo **helpfile.txt** ubicado en la carpeta principal del programa

    + Valor predeterminado

        + "\", 0

+ **setdir**
    Contiene la ruta que hace referencia a la carpeta del programa **SHELL** donde se ubica **helpfile.txt**. Es necesario que tenga el valor predefinido que se indica, ya que de esta manera el programa funcionará, de lo contrario se tendrá que cambiar la ruta si el programa cambia de dirección.
    + Valor predeterminado

        + "\SHELL", 0

+ **ndirtemp**
    Variable que permite almacenar de manera temporal el directorio actual antes de realizar cambios en este.
    + Valor predeterminado
        + db 64 dup('$')
+ **setloc**
    Arreglo será una versión funcional para cambiar de directorio de *ndirtemp*.
    + Valor predeterminado
        + db 64 dup('$')
+ **narchivo**
    Contiene el nombre del archivo principal donde se resguardan los datos de help.
    + Valor predeterminado
        + db "helpfile.txt", 0h
+ **fid**
    Será el valor de resguardo para el identificador de un archivo abierto dentro del programa
    + Valor predeterminado
        + dw ?
+ **lendirint**
    Arregló que almacenará el tamaño del directorio que se utiliza de manera interna.
    + Valor predeterminado
        + dw ?

+ **contador**
    Es el valor encargado de llevar el conteo de los caracteres designados como condición de apertura y cierre para los bloques de texto ('%')
    + Valor predeterminado
        + 0
+ **elegido**
    Permitirá identificar el bloque de texto buscado para mostrar la ayuda por lo que contendrá el valor de **counter** del programa **CHECK**.
    + Valor predeterminado
        +
+ **temporal**
    Arreglo al que será copiado el bloque de texto buscado para mostrarlo en pantalla.
    + Valor predeterminado
        + db ?
+ **bufer**
    Bufer principal en el que será leído el archivo principal **helpfile.txt**.
    + Valor predeterminado
        + db ?


#### 2.3.3. Funciones.

##### 2.3.3.1. Comparaciones
+ Descripción

    + Contenido

    + En las primeras líneas de esta función se recupera el directorio actual, se cambia al directorio buscado y se lee el archivo, pero estos pasos no se consideran en esta explicación. Por lo cual, tomaremos la explicación hasta la etiqueta *cic_comp*.

        + Antes de comenzar *cic_comp* se inicializa *contador* a 0 al igual que un contador interno de la función (si). Posteriormente en *cic_comp* se hace la lectura del bufer caracter por caracter buscando los caracteres de apertura y cierre de los bloques. Cada vez que se encuentra uno de estos el contador se incrementa en 1 hasta y se compara con *elegido* hasta que sean iguales. Una vez que el valor a sido igualado se procede a copiar los datos del *bufer* hacia *temporal* con tamaño máximo del contador interno.
        Una vez terminado el proceso se despliega temporal, se pone el directorio actual con el valor de **ndirtemp** y se retorna de la función. Por lo que se puede resumir en los siguientes pasos

        ```

        1. colocar contadores a 0 y dar a elegido el valor recibido por pila
        2. Realizar la búsqueda de la cantidad de tokens ('%') necesarios para llegar al bloque correcto
        3. Una vez que se alcance el valor deseado, realizar la copia de un bufer a otro
        4. Reubicar el directorio al guardado al comienzo del programa
        5. Salir

        ```







***

#### 2.4.1. Macros.

##### 2.4.1.1 lenar.
+ Descripción
    Macro que nos permite obtener el tamaño de una cadena recibida mediante dos modos disponibles.

    + Contenido
    Se identifica el modo deseado (0 o '-') y posterior a ello se realiza la comparación caracter por caracter hasta llegar a la condición de paro.
    Retorna en lendir el tamaño obtenido
##### 2.4.1.2 sepcom.
+ Descripción
    sepcom es una macro que recibe tres cadenas: la cadena principal, comando e instrucciones y se encarga de separar el comando de los argumentos. Se busca el factor de separación que es 0D o 20, es decir '\n' o ' '. para luego copiar
    el comando en una variable previamente definida al igual que las instrucciones
    + Contenido
    Un ciclo de búsqueda que se encarga de encontrar las condiciones de paro para posteriormente pasar por medio de operaciones con arreglos a copiar los respectivos datos en cada una de las dos cadenas de destino.
##### 2.4.1.3 cadprint
+ Descripción
    Macro que nos permite imprimir una cadena respecto a la posición dada mediante renglón y columna, además del tamaño de esta cadena.
    + Contenido
    Se hace uso de la interrupción 10h función 13h para desplegar la cadena en las direcciones dadas para la pantalla.

##### 2.4.1.3 clean_arr
+ Descripción
    Macro que se encarga de reiniciar un arreglo a su valor inicial, recibe como parámetros la cadena, su tamaño y el caracter con el cual se va a reiniciar.
    + Contenido
    operaciones con arreglos (stosb) para hacer la carga del dato.
##### 2.4.1.3 despnum
+ Descripción
    Macro que nos permite imprimir un número respecto a la posición dada mediante renglón y columna, además del número separado en la parte alta y parte baja.
    + Contenido
    Se hace uso de la interrupción 10h función 02h para situar el cursor en la posición dada además del uso de la función des4 (la cual se omite su documentación, pero imprime un número de 16 bits en hexadecimal).

***


