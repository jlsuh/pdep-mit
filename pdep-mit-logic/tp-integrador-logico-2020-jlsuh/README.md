# TP Integrador - Paradigma Lógico 2020

Nombre y apellido: Joel Leonardo Suh

## Consignas

Este trabajo, a diferencia de los anteriores, tiene consignas abiertas con la intención de que tomes decisiones respecto al modelo de datos y predicados a desarrollar. También tiene las dimensiones y complejidad de un parcial.

Podés encontrar el enunciado del trabajo práctico [acá](https://docs.google.com/document/d/10XcbIdvrKsSOzAvsT-C2atIwaj4x3tXvYKXN6OJBOKc/edit).

Desarrollá lo indicado en cada punto en el archivo `src/TP.pl`. Para responder al punto teórico podés escribir la explicación en forma de comentario en el mismo archivo `src/TP.pl`. También se espera que incluyas como comentario las pruebas que realices sobre los predicados que resuelven los distintos puntos del TP, para mostrar el uso y cuál es la respuesta obtenida con la solución actual (en caso de haber muchas respuestas, se pueden incluir sólo algunas como ejemplo).

## Modalidad de trabajo

Al igual que para los trabajos prácticos anteriores, se recomienda dar pasos chicos: implementar lo que se pide para un punto, probar lo desarrollado para validar que funciona correctamente y subir esos cambios.

Para este trabajo no se proveen pruebas automáticas que verifiquen los resultados de los predicados a desarrollar en cada punto, para no comprometer la libertad para diseñar la solución. Igualmente recordá que podés probar tu trabajo manualmente desde la consola, corriendo el comando `swipl src/TP.pl` sobre la raíz de tu proyecto.

> En caso de que te sirva para las pruebas manuales, tené en cuenta que existe el predicado `distinct/1` de orden superior que puede usarse de esta forma con consultas existenciales:
>
> ```prolog
> ?- distinct(predicado(Parametro1, Parametro2)).
> Parametro1 = algo, Parametro2 = otroAlgo ;
> ...
> ```
> para evitar que se repitan las respuestas para la consula realizada.
>
> A efectos de la evaluación, no consideramos a las respuestas repetidas como un problema, esto es sólo para tu comodidad.

Si tenés dudas, recordá que podés abrir un issue en este repositorio arrobando a tus tutores para que te den una mano, y no te olvides de abrir un issue para avisar a tus tutores cuando hayas terminado.
