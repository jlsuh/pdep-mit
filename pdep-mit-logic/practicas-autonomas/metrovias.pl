%            0      1     2      3        4        5            6        7
%            1      2     3      4        5        6            7        8
linea(a,[plazaMayo,peru,lima,congreso,miserere,rioJaneiro,primeraJunta,nazca]).
linea(b,[alem,pellegrini,callao,gardel,medrano,malabia,lacroze,losIncas,urquiza]).
linea(c,[retiro,diagNorte,avMayo,independenciaC,plazaC]).

combinacion([lima,avMayo]).
combinacion([once,miserere]).
combinacion([pellegrini,diagNorte,nueveJulio]).

/*
Tenemos un modelo de la red de subtes, por medio de un predicado linea/2 que relaciona el nombre de la linea con la lista de sus estaciones, en orden.

Sabiendo que no hay dos estaciones con el mismo nombre, se pide desarrollar los siguientes predicados:
estaEn/2: que relaciona una estacion con la linea a la que pertenece.
distancia/3: que relaciona dos estaciones de la misma linea, con la cantidad de estaciones que hay entre ellas.
mismaAltura/2: relaciona a dos estaciones de distintas lineas si se encuentran a la misma altura.
viajeFacil/2: que relaciona dos estaciones si puedo llegar facil de una a la otra, es decir si estan en la misma linea o solo se requiere una combinacion.
*/

estaEn(Estacion, Linea):-
  linea(Linea, ListaEstaciones),
  member(Estacion, ListaEstaciones).

distancia(EstacionOrigen, EstacionOrigen, 0).
distancia(EstacionOrigen, EstacionDestino, CantidadEstacionesEntreEllas):-
  estaEn(EstacionOrigen, Linea), estaEn(EstacionDestino, Linea),
  alturaEnDichaLinea(Linea, EstacionOrigen, AlturaOrigen), alturaEnDichaLinea(Linea, EstacionDestino, AlturaDestino),
  Desplazamiento is AlturaDestino - AlturaOrigen,
  CantidadEstacionesEntreEllas is abs(Desplazamiento),
  EstacionOrigen \= EstacionDestino.

alturaEnDichaLinea(Linea, Estacion, Altura):-
  linea(Linea, EstacionesDeLaLinea),
  nth0(Altura, EstacionesDeLaLinea, Estacion).

mismaAltura(UnaEstacion, OtraEstacion):-
  estaEn(UnaEstacion, UnaLinea), estaEn(OtraEstacion, OtraLinea),
  alturaEnDichaLinea(UnaLinea, UnaEstacion, UnaAltura), alturaEnDichaLinea(OtraLinea, OtraEstacion, UnaAltura),
  UnaLinea \= OtraLinea.

/*
viajeFacil/2: que relaciona dos estaciones si puedo llegar facil de una a la otra, es decir si estan en la misma linea o solo se requiere una combinacion.
*/
estanEnMismaLinea(UnaEstacion, OtraEstacion):-
  estaEn(UnaEstacion, Linea), estaEn(OtraEstacion, Linea).

viajeFacil(UnaEstacion, OtraEstacion):-
  estanEnMismaLinea(UnaEstacion, OtraEstacion),
  UnaEstacion \= OtraEstacion.
viajeFacil(EstacionOrigen, EstacionDestino):-
  combinacion(Combinaciones),
  member(EstacionCombinacionUno, Combinaciones),
  estanEnMismaLinea(EstacionOrigen, EstacionCombinacionUno),
  member(EstacionCombinacionDos, Combinaciones),
  estanEnMismaLinea(EstacionDestino, EstacionCombinacionDos),
  EstacionCombinacionUno \= EstacionCombinacionDos,
  EstacionOrigen \= EstacionDestino.

/*
combinacion([lima,avMayo]).
combinacion([once,miserere]).
combinacion([pellegrini,diagNorte,nueveJulio]).
*/