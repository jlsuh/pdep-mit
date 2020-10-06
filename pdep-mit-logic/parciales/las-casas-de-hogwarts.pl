/*
Consigna: https://docs.google.com/document/d/e/2PACX-1vR9SBhz2J3lmqcMXOBs1BzSt7N1YWPoIuubAmQxPIOcnbn5Ow9REYt4NXQzOwXXiUaEQ4hfHNEt3_C7/pub
*/

mago(harry, sangre(mestiza), [corajudo, amistoso, orgulloso, inteligente]).
mago(draco, sangre(pura), [inteligente, orgulloso]).
mago(hermione, sangre(impura), [inteligente, orgulloso, responsable]).

% mago(joel, sangre(coreana), [corajudo, amistoso, orgulloso, inteligente]).
% odiariaQueLoMandenA(joel, slytherin).

/* ----- Primera 1 - Sombrero Seleccionador ----- */
/* ----------- 1 ----------- */

permiteEntrar(gryffindor, _).
permiteEntrar(ravenclaw, _).
permiteEntrar(hufflepuff, _).
permiteEntrar(slytherin, UnMago):-
  mago(UnMago, sangre(TipoDeSangre), _),
  TipoDeSangre \= impura.

/*
Es mejor generalizar que hablar puntualmente de una de ellas.
A pesar de que esta resolución hubiese estado correcto para el dominio aclarado por el problema,
quizás sea mejor producir reglas que generalicen mi dominio, y realizar
los acomplamientos correspondientes, con la finalidad de no crear predicados de más, sino que
mediante una regla, se pueda acoplar dicha regla a un hecho en nuestra base de conocimiento.
Si una cosa implica la otra, por qué noa aprovechar dicha implicancia.
*/

/* ----------- 2 ----------- */
unaCasa(UnaCasa):-
  permiteEntrar(UnaCasa, _).

tieneCaracterApropiado(UnaCasa, UnMago):-
  unaCasa(UnaCasa),
  mago(UnMago, _, ListaDeCaracter),
  apropiadoParaLaCasa(UnaCasa, LoQueBuscaLaCasa),
  forall(member(LoBuscado, LoQueBuscaLaCasa), member(LoBuscado, ListaDeCaracter)).

apropiadoParaLaCasa(gryffindor, [corajudo]).
apropiadoParaLaCasa(hufflepuff, [amistoso]).
apropiadoParaLaCasa(ravenclaw, [inteligente, responsable]).
apropiadoParaLaCasa(slytherin, [orgulloso, inteligente]).

/* Corrección:
Estaría bueno considerar que no solamente hay que tirarse a modelar con listas, sino que también es
posible modelar con una mayor de cantidad de predicados que cumplan el objetivo, sin producir el efecto
de que, al optar por modelar con las listas, haya un menor grado de declaratividad, que naturalmente
se produce por el manejo de listas.
*/

/* ----------- 3 ----------- */
odiariaQueLoMandenA(harry, slytherin).
odiariaQueLoMandenA(draco, hufflepuff).

podriaQuedarSeleccionado(gryffindor, hermione).
podriaQuedarSeleccionado(UnaCasa, UnMago):-
  tieneCaracterApropiado(UnaCasa, UnMago),
  permiteEntrar(UnaCasa, UnMago),
  not(odiariaQueLoMandenA(UnMago, UnaCasa)).

/*
Observaciones:
Ir declarando hechos a medida que se dicte en el enunciado.
No hubieron mayores errores :)
*/

/* ----------- 4 ----------- */
/*
Observaciones:
-> Quizás esté bueno hacer una abstracción mediante el predicado todosAmistosos/1, en donde
realice la abstracción sobre el forall que se implementa (1)
-> No lo pide el enunciado (2)
-> Se puede hacer eso con las listas (3)
*/
esAmistoso(UnMago):-
  mago(UnMago, _, ListaDeCaracter),
  member(amistoso, ListaDeCaracter).

cadenaDeAmistades(ListaDeMagos):-
%  list_to_set(ListaDeMagos, ListaDeMagosSinRepetir),            (2)
  forall(member(UnMago, ListaDeMagos), esAmistoso(UnMago)),    % (1)
  puedeSerDeLaMismaCasaQueElSiguiente(ListaDeMagos).

/* Lo dejo como ejemplo porque está bueno para no usar el sublist/2 que quedó deprecado.
    forall( (member(UnMago, ListaDeMagos), member(OtroMago, ListaDeMagos)),
            (puedenSerDeLaMismaCasa(UnMago, OtroMago), UnMago \= OtroMago)
          ).
  puedeSerMismaCasaQueElSiguiente(ListaDeMagos).
*/
/*
puedenSerDeLaMismaCasa(UnMago, OtroMago):-
  podriaQuedarSeleccionado(UnaCasa, UnMago), podriaQuedarSeleccionado(UnaCasa, OtroMago).
*/

puedeSerDeLaMismaCasaQueElSiguiente([MagoUno, MagoDos]):-                % (3)
  podriaQuedarSeleccionado(UnaCasa, MagoUno), podriaQuedarSeleccionado(UnaCasa, MagoDos).
puedeSerDeLaMismaCasaQueElSiguiente([MagoUno, MagoDos | RestoDeMagos]):-
  podriaQuedarSeleccionado(UnaCasa, MagoUno), podriaQuedarSeleccionado(UnaCasa, MagoDos),
  puedeSerDeLaMismaCasaQueElSiguiente([MagoDos | RestoDeMagos]).
/*
Se podría haber agregado:
puedeSerDeLaMismaCasaQueElSiguiente([_]). -> para indicar que en caso de que sea de 1 mago la cadena
puedeSerDeLaMismaCasaQueElSiguiente([]).  -> en caso de llegar a la lista vacía
*/

/*
head([X | _], X).
puedeSerDeLaMismaCasaQueElSiguiente([Mago | RestoDeMagos]):-
  head(RestoDeMagos, MagoSiguiente),
  podriaQuedarSeleccionado(UnaCasa, Mago), podriaQuedarSeleccionado(UnaCasa, MagoSiguiente).
puedeSerDeLaMismaCasaQueElSiguiente([Mago | RestoDeMagos]):-
  head(RestoDeMagos, MagoSiguiente),
  podriaQuedarSeleccionado(UnaCasa, Mago), podriaQuedarSeleccionado(UnaCasa, MagoSiguiente),
  puedeSerDeLaMismaCasaQueElSiguiente(RestoDeMagos).
*/

/* ----- Primera 2 - La copa de las casas ----- */
/*
Correcciones:
-> Es mejor agrupar en un functor los lugares a los que fue un mago (1)
irA(talLugar).
-> Se cometió el error de definir los puntajes tal que quedaron repetidamente en distintas clásulas de
acción/2
*/

% (3) {
accion(harry, mala(fueraDeCama, -50)).  % (2)
accion(harry, mala(bosque, -50)).       % (2)                       % (1)
accion(harry, mala(tercerPiso, -75)).   % (2)                       % (1)
accion(harry, buena(ganarleAVoldemort, 60)).
accion(hermione, mala(tercerPiso, -75)).% (2)                       % (1)
accion(hermione, mala(seccionRestringidaBiblioteca, -10)).% (2)     % (1)
accion(hermione, buena(salvarAmigosDeLaMuerteConSuIntelecto, 50)).
accion(ron, buena(partidaAjedrezMagico, 50)).
% }

% accion(draco, buena(sonreir, 100)).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% malaAccion(fueraDeCama).
% malaAccion(bosque).
% malaAccion(fueraDeCama).

% buenaAccion(UnaAccion):-
%   accion(_, UnaAccion),
%   not(malaAccion(UnaAccion)).

/* ----------- 1 ----------- */
/* ----- a ----- */
/*
Correcciones:
-> Quizás estuviese mejor si se abstraía en un predicado los puntajes que generan las malas acciones
y aprovechar el polimorfismo. Este punto quizás era mejor orientarlo a existencial. (3)
*/

esBuenAlumno(UnMago):-
  accion(UnMago, _),
  forall(accion(UnMago, UnaAccion), UnaAccion \= mala(_, _)).       % (3)

/* ----- b ----- */
esRecurrente(UnaAccion):-
  accion(UnMago, UnaAccion),
  accion(OtroMago, UnaAccion),
  UnMago \= OtroMago.
/*
esRecurrente(mala(tercerPiso, _)).
*/

/* ----------- 2 ----------- */
/*
Correcciones:
-> No ameritaba abstraer de esta manera. Directamente hubiese estado correcto usar esDe/2 (1)
-> Se ha hecho lo que justamente no buscamos hacer. Se ha creado dos findalls (adiós declaratividad), cuando en realidad se pudo haber hecho
solamente 1 findall, y aprovechar el polimorfismo bajo un mismo predicado, por ejemplo: puntajeQueGenera, que dado algo que hizo, pueda utilizar
el polimorfismo. Dicha cosa que hizo puede ser una acción (mala o buena), o bien puede ser una respuesta correcta que haya respondido. (2)
*/
esUnaCasa(UnaCasa):-   % (1)
  esDe(_, UnaCasa).

puntajeTotal(UnaCasa, PuntajeTotal):-
  esUnaCasa(UnaCasa),
  findall( Punto,                                         % (2)
            (esDe(UnMago, UnaCasa), accion(UnMago, Accion), puntajeDeAccion(Accion, Punto)),
            PuntosDeLasAcciones
          ),
  findall( PuntosPorLaRespuesta,                          % (2)
            (esDe(UnMago, UnaCasa), respuesta(UnMago, _, NivelDificultad, ElProfesorQueHizoLaPregunta), puntajeRespuesta(NivelDificultad, ElProfesorQueHizoLaPregunta, PuntosPorLaRespuesta)),
            PuntosPorRespuestas
          ),
  sum_list(PuntosDeLasAcciones, PuntajeTotalAcciones),
  sum_list(PuntosPorRespuestas, PuntajeTotalRespuestas),
  PuntajeTotal is PuntajeTotalAcciones + PuntajeTotalRespuestas.

puntajeDeAccion(mala(_, Punto), Punto).
puntajeDeAccion(buena(_, Punto), Punto).

/* ----------- 3 ----------- */
casaGanadora(UnaCasa):-
  puntajeTotal(UnaCasa, UnPuntaje),
%  not( (puntajeTotal(_, OtroPuntaje), OtroPuntaje > UnPuntaje) ). % (1)

/* Es el pasaje del not al forall (1)
  forall( puntajeTotal(_, OtroPuntaje),
          UnPuntaje =< OtroPuntaje
        ).
*/ %Se puede observar que no cumple con lo que le estamos pidiendo, pues el pasaje de not al forall pide que la casa ganadora tenga
   %menos puntos que las otras casas

/*
Debido a que se contempló que puede haber un empate, faltó contemplar el caso límite entre los puntos de las dos casas:
*/
  forall( (puntajeTotal(OtraCasa, OtroPuntaje), UnaCasa \= OtraCasa), UnPuntaje >= OtroPuntaje ).

/* ----------- 4 ----------- */
/*
Correcciones:
-> Es interesante ver que se puede, en vez de crear otro predicado respuesta/4, utilizar a accion/2, u otro mejor predicado que se nos haya
ocurrido, en utilizar para modelar las respuestas de un mago. (1)
-> Hubiese estado bueno unificar bajo un solo predicado, los puntajes que generar para:
  1) cuando se van a ciertos lugares prohibidos, o bien hacen malas acciones
  2) cuando hacen buenas acciones
  3) las respuestas que generan puntos también
*/
% respuesta(UnMago, LaPregunta, Dificultad, ElProfesorQueHizoLaPregunta).
respuesta(hermione, dondeSeEncuentraUnBezoar, 20, snape).           % (4)
respuesta(hermione, comoHacerLevitarUnPluma, 25, flitwick).         % (4)

puntajeRespuesta(NivelDificultad, snape, Puntos):-
  Puntos is NivelDificultad / 2.
puntajeRespuesta(NivelDificultad, UnProfesor, NivelDificultad):-
  UnProfesor \= snape.