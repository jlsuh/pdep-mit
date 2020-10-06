/* ---------- Primera parte ---------- */
/* ----- a ----- */
% cantante(Nombre, cancion(NombreCancion, DuracionEnMinutos)).
cantante(megurineLuka, cancion(nightFever, 4)).
cantante(megurineLuka, cancion(foreverYoung, 5)).
cantante(hatsuneMiku, cancion(tellYourWorld, 4)).
cantante(gumi, cancion(foreverYoung, 4)).
cantante(gumi, cancion(tellYourWorld, 5)).
cantante(seeU, cancion(novemberRain, 6)).
cantante(seeU, cancion(nightFever, 5)).

/* ---------- 1 ---------- */
esNovedoso(Cantante):-
  esCantante(Cantante),
  minimaCantidadCancionesQueSabe(Cantante, 2),
  duracionTotalDeCanciones(Cantante, DuracionTotal),
  DuracionTotal < 15.

cantidadCancionesQueSabeCantar(Cantante, CantidadDeCancionesQueSabe):-
  findall(Cancion, cantante(Cantante, cancion(Cancion, _)), Canciones),
  length(Canciones, CantidadDeCancionesQueSabe).

minimaCantidadCancionesQueSabe(Cantante, Cantidad):-
  cantidadCancionesQueSabeCantar(Cantante, CantidadDeCancionesQueSabe),
  CantidadDeCancionesQueSabe >= Cantidad.

duracionTotalDeCanciones(Cantante, DuracionTotal):-
  findall(Duracion, cantante(Cantante, cancion(_, Duracion)), Duraciones),
  sum_list(Duraciones, DuracionTotal).

esCantante(Cantante):-
  cantante(Cantante, _).
/* ---------- 2 ---------- */
esAcelerado(Cantante):-
  esCantante(Cantante),
  not((cantante(Cantante, cancion(_, Duracion)), Duracion > 4)).

/* ---------- Segunda parte ---------- */
% concierto(Nombre, Pais, CantidadFama, Tipo).

% gigante(CantidadMinimaCanciones, DuracionTotal).
% mediano(DuracionDeCancionesMenorA).
% pequenio(DuracionDeAlgunaDeLasCanciones).

/* ---------- 1 ---------- */
concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

cumpleRequisito(Cantante, gigante(CantidadMinimaCanciones, DuracionTotalMinima)):-
  esCantante(Cantante),
  minimaCantidadCancionesQueSabe(Cantante, CantidadMinimaCanciones),
  duracionTotalDeCanciones(Cantante, DuracionTotal),
  DuracionTotal > DuracionTotalMinima.
cumpleRequisito(Cantante, mediano(DuracionTotalMaxima)):-
  esCantante(Cantante),
  duracionTotalDeCanciones(Cantante, DuracionTotal),
  DuracionTotal < DuracionTotalMaxima.
cumpleRequisito(Cantante, pequenio(DuracionMinima)):-
  cantante(Cantante, cancion(_, UnaDuracion)),
  UnaDuracion > DuracionMinima.

/*
tipoConcierto(mikuExpo, gigante(2, 6)).
tipoConcierto(magicalMirai, gigante(3, 10)).
tipoConcierto(vocalektVisions, mediano(9)).
tipoConcierto(mikuFest, pequenio(4)).
*/

/* ---------- 2 ---------- */
puedeParticipar(Cantante, _):-vocaloidExcento(Cantante).
puedeParticipar(Cantante, NombreConcierto):-
  concierto(NombreConcierto, _, _, TipoConcierto),
  cumpleRequisito(Cantante, TipoConcierto),
  vocaloidExcento(CantanteExcento), Cantante \= CantanteExcento.

vocaloidExcento(hatsuneMiku).

/* ---------- 3 ---------- */
vocaloidMasFamoso(Cantante):-
  esCantante(Cantante),
  nivelDeFama(Cantante, NivelFama),
  forall( (esCantante(OtroCantante), nivelDeFama(OtroCantante, OtroNivelFama), Cantante \= OtroCantante),
          NivelFama > OtroNivelFama
          ).
/* si no se hace Cantante \= OtroCantante, entonces NivelFama será igual que OtroNivelFama, por lo que
la implicación quedaría V => F, no pudiendo satisfacer la consulta: valorDeVerdad(vocaloidMasFamoso/1) = Falso */

famaTotalConciertosParticipables(Cantante, FamaTotal):-
  findall(Fama, (concierto(NombreConcierto,_,Fama,_), puedeParticipar(Cantante, NombreConcierto)), ListaFama),
  sum_list(ListaFama, FamaTotal).

/* versión de nivelDeFama/2 no inversible */
nivelDeFama(Cantante, NivelFama):-
  famaTotalConciertosParticipables(Cantante, FamaTotal),
  cantidadCancionesQueSabeCantar(Cantante, CantidadDeCancionesQueSabe),
  NivelFama is FamaTotal * CantidadDeCancionesQueSabe.

/*
Si se quería hacer que nivelDeFama sea inversible, y ahorrarnos en unificar a Cantante y OtroCantante en
vocaloidMasFamoso/1:

vocaloidMasFamoso(Cantante):-
  nivelDeFama(Cantante, NivelFama),
  forall( (nivelDeFama(OtroCantante, OtroNivelFama), Cantante \= OtroCantante),
          NivelFama > OtroNivelFama
          ).

nivelDeFama(Cantante, NivelFama):-
  esCantante(Cantante),
  famaTotalConciertosParticipables(Cantante, FamaTotal),
  cantidadCancionesQueSabeCantar(Cantante, CantidadDeCancionesQueSabe),
  NivelFama is FamaTotal * CantidadDeCancionesQueSabe.
*/

/* ---------- 4 ---------- */
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

/* suponiendo que los cantantes siempre irán a donde pueden participar */
unicoQueParticipa(Cantante, NombreConcierto):-
  esCantante(Cantante),
  concierto(NombreConcierto,_,_,_),
  puedeParticipar(Cantante, NombreConcierto),
  forall((esCantante(OtroCantante), Cantante \= OtroCantante), not(puedeParticipar(OtroCantante, NombreConcierto))).

conocido(Cantante, Conocido):-
  conoce(Cantante, Conocido).
conocido(Cantante, Conocido):-
  conoce(Cantante, Intermediario),
  conocido(Intermediario, Conocido).

/* ---------- 5 ---------- */
/*
En caso de tener que agregar otro concierto, solamente hará falta agregar un nuevo hecho, ejemplificado de la siguiente manera:
concierto(unNombre, unPais, nivelFamaGanado, pequenio(1)).

Esta implementación ha sido facilitada gracias al concepto de acoplamiento. Debido a que el 4to argumento de concierto/4 es un functor que
aclara el tipo de concierto que es. Dicho argumento se puede aprovechar para poder definir un predicado polimórfico para que pueda verificar
los requisitos de cada concierto según el tipo de concierto que sea; para el caso en cuestión, el predicado polimófico sería cumpleRequisito/2
concierto/4 y cumpleRequisito/2 no posee acoplamiento, por lo que al agregar un concierto más a la base de conocimiento, no se deberá realizar
refactorizaciones, sino que solamente se debe agregar un hecho más. Dicho hecho agregado actuará de la misma forma que los otros conciertos
originales que ya se encontraban en la base de conocimiento, debido a que cumpleRequisito/2 es una regla que responde polimórficamente dependiendo
el tipo de concierto que sea.
*/