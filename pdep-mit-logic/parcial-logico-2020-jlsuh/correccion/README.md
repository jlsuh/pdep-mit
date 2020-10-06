# Corrección Parcial - Paradigma Lógico 2020

Link a la solución usada para la corrección: https://github.com/pdep-mit/parcial-logico-2020-jlsuh/blob/9c66225a72bd3846b0ca68fe9928b2c51314d598/src/parcial.pl

## Feedback

### Punto 1

B

### Punto 2

R. La lógica principal de `estaDeModa/2` está correcta, pero no es inversible (UnDisfraz y UnAnio se usan por primera vez en un predicado auxiliar no inversible). En `fueMuyUsado/1` se liga la variable UnaFiesta que debería llegar libre al forall para que funcione como se espera.

### Punto 3

B

### Punto 4

R. Se repite lógica entre las dos definiciones de `seLePuedeSugerir(UnDisfraz, UnaPersona, UnaFiesta)`, se podía extraer algún predicado que indique si un disfraz es una sugerencia válida para una persona en un año. Además hay problemas de inversibilidad respecto al segundo parámetro.

### Punto 5

B-. No me queda claro por qué se usa `categoriaDisfraz(UnDisfraz, _)` si el disfraz no era relevante para armar el conjunto de personas que asistieron.

### Punto 6

B-. La solución principal está muy bien y con buenas abstracciones. La lógica de la segunda regla de `huboBuenNumeroAsistentes/1` no está del todo correcta, no me queda claro por qué afirmás que ninguna de esas dos fiestas (UnaFiesta y FiestaPrevia) sea la primera fiesta de ese organizador, lo que debería asegurarse es que no exista una fiesta posterior a FiestaPrevia y anterior a UnaFiesta para asegurar que haya sido la inmediata anterior.

### Punto 7

B. No se hace foco en el hecho de que quienes usan `esApropiado/2` no necesitan cambiar, a pesar de que haya nuevas formas para este tipo de individuo. Ahí es donde el polimorfismo es más interesante, en el uso en el cual es indistinto de qué tipo de fiesta se trate.

## Corrección final

Nota: 8

Hay problemas relacionados con inversibilidad y ligado incorrecto de variables que impactan a la funcionalidad en los puntos 2 y 4, sin embargo en el resto de la solución (incluso en problemas más complejos, puntualmente en el punto 6) esta clase de problemas se resuelven correctamente.

Sólo en el punto 2 se ven problemas relacionados con el uso de predicados de orden superior, todos los otros usos de predicados de orden superior son correctos.

El modelo planteado para representar la información está muy bien y se aprovecha el polimorfismo entre los tipos de fiestas.
