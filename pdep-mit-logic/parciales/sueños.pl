/* ---------- 1 ---------- */
/* ----- a -----*/
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

suenio(gabriel, ganarLoteria([5, 9])).
suenio(gabriel, futbolista(arsenal)).
suenio(juan, cantante(100000)).
suenio(macarena, cantante(10000)).

/* ----- b -----*/
/*
Entraron en juego conceptos como el polimorfismo en el predicado suenio/2, en donde el polimorfismo se
refleja en el segundo argumento, los cuales son disferentes functores que modelan a los tipo de sueños.
También se refleja el concepto de pattern matching sobre los predicados creeEn/2 y suenio/2, en donde
se forma a la base de conocimientos de hechos que queremos reflejar que ya se cumplen.
*/

/* ---------- 2 ---------- */
tieneAmbicion(Persona):-
  suenio(Persona, _),
  findall(Dificultad , (suenio(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), ListaDificultades),
  sum_list(ListaDificultades, DificultadTotal),
  DificultadTotal > 20.

dificultadSuenio(cantante(CantidadVendida), 6):-
  CantidadVendida > 500000.
dificultadSuenio(cantante(CantidadVendida), 4):-
  CantidadVendida =< 500000.
dificultadSuenio(ganarLoteria(ListaNumeros), Dificultad):-
  length(ListaNumeros, CantidadNumerosApostados),
  Dificultad is 10 * CantidadNumerosApostados.
dificultadSuenio(futbolista(Equipo), 3):-
  equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo), 16):-
  not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

/* ---------- 3 ---------- */
tieneQuimica(Personaje, Persona):-
  creeEn(Persona, Personaje),
  cumpleRequisito(Persona, Personaje).

cumpleRequisito(Persona, campanita):-
  suenio(Persona, Suenio),
  dificultadSuenio(Suenio, Dificultad),
  Dificultad < 5.
cumpleRequisito(Persona, Personaje):-
  suenio(Persona, _),
  forall(suenio(Persona, Suenio), esPuro(Suenio)),
  not(tieneAmbicion(Persona)),
  Personaje \= campanita.

esPuro(futbolista(_)).
esPuro(cantante(CantidadVendida)):-
  CantidadVendida < 200000.

/* ---------- 4 ---------- */
amigoDe(campanita, reyesMagos).
amigoDe(campanita, conejoDePascua).
amigoDe(conejoDePascua, cavenaghi).

puedeAlegrar(Personaje, Persona):-
  suenio(Persona, _),
  tieneQuimica(Personaje, Persona),
  condicionExtraParaAlegrar(Personaje).

condicionExtraParaAlegrar(Personaje):-
  not(enfermo(Personaje)).
condicionExtraParaAlegrar(Personaje):-
  personajeBackup(Personaje, PersonajeBackup),
  not(enfermo(PersonajeBackup)).

personajeBackup(Personaje, PersonajeBackup):-
  amigoDe(Personaje, PersonajeBackup).
personajeBackup(Personaje, PersonajeBackup):-
  amigoDe(Personaje, Intermediario),
  amigoDe(Intermediario, PersonajeBackup).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).