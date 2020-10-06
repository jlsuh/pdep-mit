# Corrección Parcial - Paradigma Funcional 2020

> Importante: esta corrección fue realizada sobre la solución del parcial entregada dentro del horario pautado.
>
> Dicha solución debe aplicar apropiadamente y aprovechar de formas no triviales los siguientes conceptos del paradigma: **composición, aplicación parcial y orden superior**.
>
> A su vez se espera que se haya evitado repetir lógica y resoluciones poco declarativas, especialmente para problemas complejos.

Link a la solución usada para la corrección: https://github.com/pdep-mit/parcial-funcional-2020-jlsuh/blob/correccion-2020-06-14-132802--0300/src/Lib.hs

## Feedback

### Punto 1

 a) B. Detalle: Faltó multiplicar por experiencia en el cálculo para primeraLínea

 b) B

 c) B. Detalle: Hay un error al nombrar la última variable por lo que no compilaría pero la idea está ok

 d) B

### Punto 2

B. Detalle: La función laAptitud era innecesaria en ese caso, lo que estabas necesitando era aplicar algo que era una función y eso es la función ($).

Respecto a la función principal, `nuevoRol :: Participante -> [Rol] -> Participante`, el nombre elegido no es el más representativo, sería mejor algo como `elegirMejorRol` (seguramente fue por eso que te complicaste de más en el 4a) y sería más conveniente que la lista de roles sea el primer parámetro por el uso que se le quiere dar más adelante.

### Punto 3

 a) B

 b) B

 c) B

### Punto 4

 a) B-, te complicaste de más con la parte de los roles, ya sea por interpretación de enunciado o confusión respecto a tus propias abstracciones:
 
 ```haskell
 -- Punto 4a
encararDesafio :: Desafio -> [Participante] -> [Participante]
encararDesafio desafio participantes =      -- Participante -> Bool                                 -- [Rol]
  repartirExperiencia participantes . filtrarLosQueAprueban desafio . map (flip nuevoRol participantesConRolesMasAptos) $ participantes
  where
    participantesConRolesMasAptos = (map (elegirRolMasApto desafio) participantes) -- [Rol]
    
elegirRolMasApto :: Desafio -> Participante -> Rol
elegirRolMasApto desafio participantes =
  elRolMasApto participante (rolesDisponibles desafio)
 ```
 
 La lista de roles a usar con la función nuevoRol directamente debían ser los roles disponibles del desafío.

 b) B

 c) R. Muy bien por los ejemplos! Igualmente hay algo raro en tu explicación y es que partís de la base de que se resuelve primero cuáles son los ganadores del desafío, y eso va en contra de lo que sucedería con lazy evaluation => se intenta resolver la expresión de más afuera sin resolver necesariamente los parámetros (sólo en la medida en la que sea necesario).

### Punto 5

B-. La lógica es correcta pero se podía implementar con fold, usando encararDesafío con los participantes como semilla.

## Corrección final

Nota: 9

Muy bien aplicados los conceptos que vimos durante la cursada. Excelente trabajo, se notan las ganas puestas!

