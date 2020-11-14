# Halloween

Queremos hacer un programa en objetos que modele el comportamiento de los chicos del vecindario (Rolo, Tito y Juanita) cuando visitan una casa para pedir caramelos y/o hacer bullicio en Halloween. Este programa a su vez va a tener una interfaz gráfica que nos permitirá jugar con nuestros objetos.

## Acciones del teclado

El juego ya tiene configuradas las siguientes teclas:
- **Flechas** arriba, abajo, izquierda y derecha: se usan para que el personaje controlado se mueva.
- Letra **t**: Tito pasa a ser el personaje controlado.
- Letra **r**: Rolo pasa a ser el personaje controlado.
- Números **1, 2 y 3**: se usan para cambiar el disfraz de Tito.
- Números **9 y 0**: se usan para cambiar el disfraz de Juanita.

> Las configuración de las acciones para cambiar el disfraz están comentadas, deben descomentarse luego de definir los disfraces en el objeto `config` de `game/gameConfiguration.wlk`.

Además se puede pasar con el mouse por encima de la casa para ver detalles del estado de ese objeto.

## Dominio

Los chicos que tenemos que modelar para nuestro juego son:
- **Tito**, que cuando visita una casa pide caramelos y aumenta el caos de la misma en una unidad.
- **Juanita**, la hermana menor de Tito, cuando visita una casa sólo pide caramelos.
- **Rolo**, que no está interesado en los caramelos por eso ni se disfraza; cuando visita una casa lo único que hace es aumentar su caos en 5 unidades.

La casa que vamos a usar para nuestro juego tiene 3 habitantes, que se van rotando para abrir la puerta y dar caramelos a los chicos que los pidan. Los habitantes de la casa son:
- **Azucena**, que si le gusta el disfraz da el equivalente a la ternura del mismo en caramelos, o 5 si no le gusta. Le gustan los disfraces adorables (aquellos que tienen ternura mayor a 6 y terror menor a 4).
- **Jorge**, que da 10 caramelos si hay al menos 50 caramelos en la casa, de lo contrario baja su ración a 4. Le gustan los disfraces con terroríficos (aquellos que tienen terror mayor o igual a 8).
- **Sandra**, que da 8 caramelos cuando la casa está en orden (si su nivel de caos es menor a 3), caso contrario da 2 caramelos. Le gustan los disfraces que son más tiernos que aterradores.

Cuando un chico **pide caramelos**, el total de caramelos que hay en la casa disminuye en el **mínimo entre la cantidad de caramelos que puede conseguir y la cantidad de caramelos que efectivamente hayan en la casa**.

Para determinar **cuántos caramelos podría conseguir** un chico de un habitante se siguen estas reglas:
- Juanita podría conseguir 2 caramelos más de los que daría normalmente la persona.
- Rolo (si decidiera pedir caramelos) podría conseguir 1 caramelo de lástima, sin importar quién sea la persona que abra la puerta.
- La cantidad de caramelos que podría conseguir Tito en una casa equivale a la cantidad que podría conseguir su hermana menor si están disfrazados iguales. Si se disfrazó distinto, podría conseguir la cantidad de caramelos que da normalmente esa persona.

Respecto a los disfraces que pueden usar Tito y/o Juanita, debemos contemplar los siguientes (deben definirse en `model/disfraces.wlk` y se espera poder referenciarlos globalmente con los nombres indicados):
- el disfraz de `venom` tiene 0 ternura y terror 8,
- el disfraz de `superheroe` tiene ternura 5 y terror 0,
- el disfraz de `ironman` tiene ternura 1 y terror 4,
- el disfraz de `harleyQuinn` tiene ternura 9 y terror 2.

> Tanto Tito como Juanita deberían usar el disfraz de `superheroe` al iniciar el juego, pero deberían poder cambiar su disfraz independientemente al mandarles el mensaje `disfraz(nuevoDisfraz)`.

Cada vez que la casa recibe la visita de un chico debería pasar lo siguiente:
- Se abre la puerta, y en consecuencia el chico pide caramelos y/o hace bullicio.
- El habitante de la casa que le abrió se despide (como se explica en los requerimientos de juego más adelante).
- Se cierra la puerta, luego de lo cual quien abrió tendrá la oportunidad de hacer algo antes de irse, y además debería cambiar quién abrirá la puerta a continuación.
  - Si quien abrió fue Azucena y quedan al menos 5 caramelos en la casa, se come uno.
  - Si quien abrió fue Jorge, acomoda un poco la casa bajando en 2 unidades el nivel de caos.
  - Sandra no hace nada en particular luego de despedirse.

Inicialmente hay 100 caramelos en la casa, un nivel 0 de caos y es Azucena quien abre la puerta. 
Una vez que los 3 hayan atendido a las visitas (primero Azucena, luego Jorge y luego Sandra), le debería tocar nuevamente a Azucena.

## Requerimientos de dominio

Se espera poder:

- Determinar para cada **habitante** de la casa si le gusta un **disfraz**.
- Determinar cuántos caramelos daría cada **habitante** de la casa en base a un **disfraz**, teniendo en cuenta que dependerá en algunos casos del estado de la casa.
- Determinar cuántos caramelos podría conseguir cada **chico** con los distintos **habitantes** de la casa. Probar esto considerando las distintas combinaciones posibles de chicos y habitantes, teniendo en cuenta que la forma en la que se disfrazan Tito y Juanita, la cantidad de caramelos de la casa y el caos de la misma podría llevar a distintos resultados.

> Definir las pruebas necesarias para estos problemas en los archivos `leGusta.wtest`, `cuantosCaramelosDarian.wtest` y `cuantosCaramelosPuedenConseguir.wtest`.

- Hacer que la **casa** sea visitada por alguno de los **chicos**.

> Las pruebas ya están armadas en el archivo `visitasALaCasa.wtest`.

## Requerimientos de juego

- Rolo y Tito deben poder moverse de forma independiente, pero Juanita siempre debe moverse a la par de Tito. Se espera que **siempre** se encuentre una celda a la izquierda de su hermano.
- Al cambiar el disfraz que usan Tito y Juanita, la imagen de cada personaje debe cambiar adecuadamente (siguiendo la convención `personaje-disfraz.png`). Ver las imágenes disponibles en la carpeta **assets** en caso de dudas.
- Saber si se terminó la diversión, que se cumple si no hay más caramelos en la casa o si su nivel de caos es mayor a 20. Esto determinará el fin del juego.
- Cuando un chico pasa por la puerta de la casa, además de realizar la lógica correspondiente a la visita a la casa que dependerá de quién sea el chico y el habitante que abrió la puerta como se explicó anteriormente, se debe mostrar un saludo saliendo de la casa que dependerá de quién fue que abrió la puerta.
  - Azucena siempre se hace la asustada y dice "¡Ay, qué miedo! Jaja".
  - Sandra saluda con un "¡Pasalo lindo y no hagas lío!" cuando la casa está en orden, y con un "¬¬" cuando no lo está.
  - Jorge saluda con un "¡Feliz Navidad!".
  
  En el caso de que luego de esta visita se termine la diversión, se espera un saludo que es independiente de quién abrió la puerta: "¡Suficiente por hoy! Nos vamos a dormir."
  
> Para estos requerimientos, pueden guiarse por los tests que están en los archivos: `saludos.wtest`, `movimientos.wtest` y `disfraces.wtest`. Los de los disfraces deben completarse acorde a lo indicado en el nombre del test.

## BONUS: Requerimientos adicionales por si quedaron manija

Modificar la lógica de movimiento de modo que:
  - Rolo y Tito no puedan bajar más allá del y = 0.
  - Rolo y Tito no puedan subir más arriba del suelo, donde se encuentra la casa.
  - Si un personaje que se encuentra en el borde derecho o izquierdo de la pantalla se mueve por fuera de la misma, hacer que aparezca del otro lado (porque dio la vuelta a la manzana). Esto también implica que si Tito se encuentra en el borde izquierdo, Juanita debería aparecer en el extremo derecho, a la misma altura que Tito.
  
> Ver el archivo `game/movimientos.wlk`. Tal vez sea útil el objeto `config` de `game/gameConfiguration.wlk`.
