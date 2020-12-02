# Corrección Parcial - Paradigma Orientado a Objetos 2020

Link a la solución usada para la corrección: https://github.com/pdep-mit/parcial-objetos-2020-jlsuh/blob/eb77dbcb8e16b38a16baaee5b94b0882ed02a5cb/src/parcial.wlk

## Feedback

### Punto 1

Bien

### Punto 2

Bien

Me mete ruido el punto de entrada, ya que si bien internamente está muy bien resuelto, y el uso que se le da más adelante a esta lógica es con el nivel propio del cocinero, se pedía poder preguntar si superó **un nivel de aprendizaje**, o sea podría no ser el propio.

De todos modos, más allá del punto de entrada indicado que permite un uso más limitado del pedido, dado que el cocinero inmediatamente delega a su nivel de aprendizaje, este requerimiento se resuelve directamente mandándole el mensaje `cocineroLoSupera(cocinero)` a cualquier nivel.

### Punto 3

Bien-

Teniendo nivel experimentado también debería poder preparar recetas que no sean difíciles, pero al margen de eso, acá hay un problema importante de delegación:

```wollok
method comidasSimilaresALaReceta(unaReceta) = comidasPreparadas.filter{ comidaPreparada => comidaPreparada.suRecetaTieneMismoIngrediente(unaReceta) || comidaPreparada.diferencialDeExperienciaEnesima(1, unaReceta) }
```

El cocinero no tiene por qué saber cuándo una receta es similar a otra, eso es responsabilidad de la receta. Y si la comida es la que conoce a la receta, bien podría entender un mensaje del estilo `recetaSimilar(unaReceta)` que delegue en su receta para que ella determine si es similar a otra, como planteaste para esos dos mensajes que se le están mandando actualmente pero que son menos interesantes como abstracción.

Abstrayendo la idea de tener una receta similar se podría plantear `loPreparoAntes(unaReceta)` con un any, llegando a una solución más declarativa sin que te lleve a repetir lógica.

También se le está quitando la responsabilidad a la receta de la cantidad de experiencia que requiere perfeccionarla, que como se puede ver, no depende del cocinero en absoluto:

```wollok
method experienciaRequeridaParaPerfeccionar(unaReceta) = 3 * unaReceta.experienciaQueAporta()
```

Sobre `calidadComidaQueProduce` que se delega al nivel del cocinero, en tu modelo la comida y su calidad no están separadas, son un mismo objeto, por lo tanto sería más adecuado que se llame `comidaQueProduce`. En un modelo en el cual se reifica la calidad como un objeto independiente de la comida, sería posible retornar la calidad y usarla para crear la comida en cuestión, teniendo la instanciación de la comida propiamente dicha en un solo lugar.

Más allá de eso, la solución está muy bien en términos de polimorfismo entre los distintos niveles y para lo que se pedía, el modelo basado en herencia para las comidas es válido. Eventualmente, ante un requerimiento que lo ponga en jaque, se podría refactorizar fácilmente para separar la idea de comida y calidad.

> Comentarios adicionales:
> - Efectivamente si la receta tiene un set para los ingredientes, la igualdad entre ambos conjuntos sirve para saber si es similar a otra. De hecho, el all planteado se quedaría corto porque la otra receta podría tener otros ingredientes que la receptora no tenga y aún así retornaría true.
> - Respecto a `diferencialDeExperienciaEnesima`, es una abstracción medio rara, por ahí si retornarar la diferencia sería más fácil de reutilizar. Podrías usar `abs()` para que no sea relevante cuál aporta más experiencia.

### Punto 4

Bien

### Punto 5

Bien

Sería mejor que el mensaje entendido por el cocinero sea `entrenar(recetario)` en vez de `prepararRecetaQueMasExperienciaAporte(recetario)`, para que no se pierda la idea de que un cocinero es capaz de entrenar, más allá de cómo lo resuelve internamente que no es tan relevante y podría cambiarse o redefinirse a futuro fácilmente de ser necesario.

## Corrección final

Nota: 9

La solución es muy prolija y aplica muy bien todos los conceptos principales del paradigma. Si bien hay lugares donde se podría haber delegado más, fueron casos aislados, y en general se notó que hiciste foco en eso en otras partes de la solución. Muy buen trabajo 👍
