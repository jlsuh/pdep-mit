precio(asado,450).
precio(hamburguesa,350).
precio(papasFritas,220).
precio(ensalada,190).
precio(revueltoGramajo, 220).
precio(tresEmpanadas, 120).
precio(pizza, 250).

leGusta(pepe, pizza).
leGusta(pipo, pizza).
leGusta(tito, pizza).
leGusta(toto, pizza).
leGusta(tato, pizza).
leGusta(pepe, revueltoGramajo).
leGusta(pepe, hamburguesa).
leGusta(pipo, ensalada).
leGusta(tito, hamburguesa).
leGusta(tito, tresEmpanadas).
leGusta(toto, papasFritas).
leGusta(tato, papasFritas).
leGusta(tito, papasFritas).
leGusta(pepe, papasFritas).
leGusta(pipo, papasFritas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
masBarata(UnaComida, OtraComida):-
  precio(UnaComida, UnPrecio),
  precio(OtraComida, OtroPrecio),
  UnPrecio < OtroPrecio.

comidaPopular(UnaComida):-
  precio(UnaComida, _),
  forall(precio(OtraComida, _), not(masBarata(OtraComida, UnaComida))).
  
comidaPopular(UnaComida):-
  precio(UnaComida, _),
  forall(leGusta(UnaPersona, _), leGusta(UnaPersona, UnaComida)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
servidor(ps1, fila1, 1).
servidor(ps2, fila1, 2).
servidor(was1, fila2, 1).
servidor(was1_2, fila2, 4).
servidor(fs_x48, fila2, 1).
esCliente(ps1,fs_x48). % acá dice que el servidor PS1 es cliente de FS_X48
esCliente(was1,fs_x48). % acá dice que el servidor WAS1 es cliente de FS_X48

requiereAtencion(UnServidor, corteDeLuz(Fila), inmediata):-
  servidor(UnServidor, Fila, _).
requiereAtencion(Afectado, rebooteo(Afectado), normal).
requiereAtencion(UnServidor, rebooteo(Afectado), normal):-
%  servidor(UnServidor, _, _),
  esCliente(UnServidor, Afectado).
requiereAtencion(Afectado, cuelgue(Afectado), inmediata):-
  servidor(Afectado, _, Criticidad),
  between(1, 2, Criticidad).
requiereAtencion(Afectado, cuelgue(Afectado), normal):-
  servidor(Afectado, _, Criticidad),
  between(3, 4, Criticidad).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tarea(basico,buscar(libro,jartum)).
tarea(basico,buscar(arbol,patras)).
tarea(basico,buscar(roca,telaviv)).
tarea(intermedio,buscar(arbol,sofia)).
tarea(intermedio,buscar(arbol,bucarest)).
tarea(avanzado,buscar(perro,bari)).
tarea(avanzado,buscar(flor,belgrado)).

%tarea(basico, buscar(libro, roma)).

nivelActual(pepe,basico).
nivelActual(lucy,intermedio).
nivelActual(juancho,avanzado).

idioma(alejandria,arabe).
idioma(jartum,arabe).
idioma(belgrado,serbio).

%idioma(roma, italiano).

destinoPosible(UnaPersona, UnDestino):-
  nivelActual(UnaPersona, UnNivel),
  tarea(UnNivel, buscar(_, UnDestino)).

interesante(UnNivel):-
  tarea(UnNivel, _),
  forall(tarea(UnNivel, buscar(Algo, _)), estaVivo(Algo)).
interesante(UnNivel):-
  nivelActual(UnaPersona, UnNivel),
  destinoPosible(UnaPersona, UnDestino),
  idioma(UnDestino, italiano).

estaVivo(arbol).
estaVivo(perro).
estaVivo(flor).

homogeneo(UnNivel):-
  tarea(UnNivel, _),
  forall( (tarea(UnNivel, buscar(Algo, _)), tarea(UnNivel, buscar(Otro, _))), sonLoMismo(Algo, Otro)).

sonLoMismo(Algo, Algo).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tieneFicha(carlos,ficha(0,4)).
tieneFicha(carlos,ficha(0,6)).
tieneFicha(carlos,ficha(5,1)).
tieneFicha(german,ficha(5,0)).
tieneFicha(miguel,ficha(3,2)).
tieneFicha(miguel,ficha(3,3)).
tieneFicha(juan,ficha(1,6)).

jugadas(ficha(0,1),ficha(1,4)).
jugadas(ficha(1,4),ficha(4,2)).
jugadas(ficha(4,2),ficha(2,2)).
jugadas(ficha(2,2),ficha(2,5)).

esFichaJugada(UnaFicha):-
  jugadas(UnaFicha, _).
esFichaJugada(UnaFicha):-
  jugadas(_, UnaFicha).

extremoIzquierdo(UnaFicha):-
  esFichaJugada(UnaFicha),
  not(jugadas(_, UnaFicha)).

extremoDerecho(UnaFicha):-
  esFichaJugada(UnaFicha),
  not(jugadas(UnaFicha, _)).

cedeTurno(UnJugador):-
  tieneFicha(UnJugador, UnaFicha),
  noCalzaEnNingunExtremo(UnaFicha).

noCalzaEnNingunExtremo(ficha(LadoIzquierdo, LadoDerecho)):-
  extremoIzquierdo(ExtremoIzquierdo),
  extremoDerecho(ExtremoDerecho),
  ladoIzquierdo(ExtremoIzquierdo, LadoIzquierdoExtremo),
  ladoDerecho(ExtremoDerecho, LadoDerechoExtremo),
  LadoIzquierdo \= LadoIzquierdoExtremo,
  LadoDerecho \= LadoIzquierdoExtremo,
  LadoIzquierdo \= LadoDerechoExtremo,
  LadoDerecho \= LadoDerechoExtremo.

ladoIzquierdo(ficha(Izquierda, _), Izquierda).
ladoDerecho(ficha(_, Derecha), Derecha).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ana prefiere a Luis antes que a Juan y a Juan antes que a Pedro.
%% preferencia(UnaPersona, GradoPreferencia, OtraPersona).
preferencia(ana, 1, luis).
preferencia(ana, 2, juan).
preferencia(ana, 3, pedro).
preferencia(nora, 3, luis).
preferencia(nora, 1, juan).
preferencia(nora, 2, pedro).
preferencia(marta, 2, luis).
preferencia(marta, 3, juan).
preferencia(marta, 1, pedro).
preferencia(luis, 1, ana).
preferencia(luis, 2, nora).
preferencia(luis, 3, marta).
preferencia(juan, 1, marta).
preferencia(juan, 2, ana).
preferencia(juan, 3, nora).
preferencia(pedro, 3, nora).
preferencia(pedro, 2, marta).
preferencia(pedro, 1, ana).
preferencia(milhouse, 1, ana).
preferencia(milhouse, 2, marta).
preferencia(milhouse, 3, nora).

parejaPosible(UnaPersona, pareja(UnaPersona, OtraPersona, GradoCompatibilidad)):-
  preferencia(UnaPersona, UnGrado, OtraPersona),
  preferencia(OtraPersona, OtroGrado, UnaPersona),
  GradoCompatibilidad is 6 - UnGrado - OtroGrado,
  UnaPersona \= OtraPersona.

mejorPareja(UnaPersona, pareja(UnaPersona, OtraPersona, GradoCompatibilidad)):-
  parejaPosible(UnaPersona, pareja(UnaPersona, OtraPersona, GradoCompatibilidad)),
  forall((parejaPosible(UnaPersona, pareja(UnaPersona, TerceraPersona, OtroGradoCompatibilidad)), OtraPersona \= TerceraPersona), GradoCompatibilidad >= OtroGradoCompatibilidad).

esPareja(UnaPersona, OtraPersona):-
  preferencia(UnaPersona, OtraPersona, _).

seVanAPelear(pareja(PersonaA, PersonaB, _), pareja(PersonaC, PersonaD, _)):-
  quiereDejar(PersonaA, PersonaB, PersonaC, PersonaD).
seVanAPelear(pareja(Persona, _, _), OtraPareja):-
  preferencia(Persona, _, _),
  integrante(Persona, OtraPareja).
seVanAPelear(OtraPareja, pareja(Persona, _, _)):-
  preferencia(Persona, _, _),
  integrante(Persona, OtraPareja).

integrante(UnaPersona, pareja(UnaPersona, _, _)).
integrante(UnaPersona, pareja(_, UnaPersona, _)).

quiereDejar(PersonaA, PersonaB, PersonaC, PersonaD):-
  prefiereAntesQue(PersonaA, PersonaC, PersonaB),
  prefiereAntesQue(PersonaC, PersonaA, PersonaD).
quiereDejar(PersonaB, PersonaA, PersonaD, PersonaC):-
  prefiereAntesQue(PersonaA, PersonaC, PersonaB),
  prefiereAntesQue(PersonaC, PersonaA, PersonaD).
% quiereDejar(PersonaC, PersonaD, PersonaA, PersonaB):-
%   prefiereAntesQue(PersonaA, PersonaC, PersonaB),
%   prefiereAntesQue(PersonaC, PersonaA, PersonaD).
% quiereDejar(PersonaD, PersonaC, PersonaB, PersonaA):-
%   prefiereAntesQue(PersonaA, PersonaC, PersonaB),
%   prefiereAntesQue(PersonaC, PersonaA, PersonaD).

prefiereAntesQue(PersonaA, PersonaB, PersonaC):-
  preferencia(PersonaA, UnGrado, PersonaB),
  preferencia(PersonaA, OtroGrado, PersonaC),
  UnGrado < OtroGrado.