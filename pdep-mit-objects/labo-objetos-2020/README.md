# Práctica grupal - PdeP MiT 2020

## Objetivos

- Trabajar en equipo usando un repositorio compartido
- Poner en práctica las ideas principales de objetos: **encapsulamiento, delegación y polimorfismo**
- Trabajar iterativamente con testeo unitario para validar problemas complejos
- Divertirse :tada:

## Modalidad de trabajo

Luego de importar el proyecto en el IDE, cada integrante debería...
- Correr todos los tests del proyecto, para conocer la situación actual
- Elegir un problemita chico para resolver (incluyendo los tests asociados en caso de no estar ya implementados)
- Resolverlo asegurando que las pruebas para ese problema den verde y no haber roto nada de lo demás que andaba
- **Commitear** los cambios con una descripción representativa
- Antes de intentar pushear (en caso de que se hayan hecho cambios en el repo que no estén localmente, el push va a fallar), usar la opción para hacer **Pull** (desde el plugin SGit o con click derecho sobre el proyecto, `Team -> Pull`, que puede que de mejor feedback).
- Si al hacer pull se incorporaron cambios, volver a correr los tests
  - Si no hubieron conflictos, deberían seguir dando verde las pruebas de la funcionalidad desarrollada
  - Si hubo un conflicto, arreglarlo, correr los tests y commitear nuevamente
- **Pushear** los cambios, elegir un nuevo problemita chico y repetir el ciclo.

> Luego de cualquier pausa post push, antes de arrancar el ciclo, hacer pull otra vez para tener el repo local al día.

Tips para evitar conflictos durante la práctica:
  1. ¡Hablarse! coordinen qué problemita agarrar a continuación, avisen al resto cuando suben cambios al repo
  2. Asegurar que las iteraciones sean lo más cortas posibles. Commits chicos -> menos chances de pisarse.
  
> Las consignas se encuentran en el archivo `consignas/README.md`. No son fáciles de "repartir", están interconectadas. Pónganse de acuerdo en cómo encarar los requerimientos, y trabajen en conjunto en pos de completarlos gradualmente. Es más fácil repartirse objetos a implementar luego de decidir la interfaz que requerimientos completos.   

## Cómo probar el programa

Lo que más nos va a interesar es el **testeo automático**. Los tests se encuentran en la carpeta `src/test`, y se pueden correr todos los tests de un archivo .wtest (seleccionando ese archivo en particular), así como también todos los tests del proyecto (seleccionando el proyecto o la carpeta que los contiene). Se recomienda correr todos los tests del proyecto para esta ejercitación.

A su vez puede ser probada manualmente con una interfaz gráfica (Wollok Game). Para iniciar el juego hay que correr desde el IDE el archivo `halloween.wpgm` que se encuentra en `src/game` con la opción `Run As -> Wollok Program`.
