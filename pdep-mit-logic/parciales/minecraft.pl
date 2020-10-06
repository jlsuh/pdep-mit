jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

/* -------- 1 - Jugando con los items -------- */
/* ---- a ---- */
itemsJugador(Jugador, ListaItems):-
  jugador(Jugador, ListaItems, _).

tieneItem(Jugador, Item):-
  itemsJugador(Jugador, ListaItems),
  member(Item, ListaItems).

/* ---- b ---- */
sePreocupaPorSuSalud(Jugador):-
  itemsJugador(Jugador, ListaItems),
  member(UnComestible, ListaItems), member(OtroComestible, ListaItems),
  comestible(UnComestible), comestible(OtroComestible), UnComestible \= OtroComestible.

/* ---- c ---- */
cantidadDeItem(Jugador, UnItem, CantidadQueTiene):-
  itemsJugador(Jugador, ListaItems),
  tieneItem(_, UnItem),
  findall(UnItem, member(UnItem, ListaItems), MismoItem),
  length(MismoItem, CantidadQueTiene).
cantidadDeItem(Jugador, UnItem, 0):-
  itemsJugador(Jugador, ListaItems),
  tieneItem(_, UnItem),
  not(member(UnItem, ListaItems)).

/* ---- d ---- */
tieneMasDe(UnJugador, UnItem):-
  cantidadDeItem(UnJugador, UnItem, UnaCantidad),
  forall((cantidadDeItem(OtroJugador, UnItem, OtraCantidad), UnJugador \= OtroJugador),
          UnaCantidad > OtraCantidad
        ).

/* -------- 2 - Alejarse de la oscuridad -------- */
/* ---- a ---- */
hayMonstruos(Lugar):-
  lugar(Lugar, _, NivelOscuridad),
  NivelOscuridad > 6.

/* ---- b ---- */
correPeligro(Jugador):-
  lugar(Lugar, Jugadores, _),
  member(Jugador, Jugadores),
  hayMonstruos(Lugar).
correPeligro(Jugador):-
  itemsJugador(Jugador, ListaItems),
  forall(member(Item, ListaItems), not(comestible(Item))),
  jugadorConHambre(Jugador).

jugadorConHambre(Jugador):-
  jugador(Jugador, _, NivelHambre),
  NivelHambre < 4.

/* ---- c ---- */
nivelPeligrosidad(Lugar, 100):-
  hayMonstruos(Lugar).
nivelPeligrosidad(Lugar, NivelDePeligro):-
  lugar(Lugar, _, NivelOscuridad),
%  not(member(_, JugadoresPresentes)),
  not(hayJugadores(Lugar)),
  NivelDePeligro is 10 * NivelOscuridad.
nivelPeligrosidad(Lugar, NivelDePeligro):-
  lugar(Lugar, JugadoresPresentes, _),
  not(hayMonstruos(Lugar)),
  hayJugadores(Lugar), % -> esto es clave, porque sino ocurriría la división por cero
  hambrientosEn(Lugar, Hambrientos),
  length(Hambrientos, CantidadHambrientos), length(JugadoresPresentes, TotalJugadores),
  NivelDePeligro is (CantidadHambrientos * 100) / TotalJugadores.

hayJugadores(Lugar):-
  lugar(Lugar, Jugadores, _),
  member(_, Jugadores).

hambrientosEn(Lugar, Hambrientos):-
  lugar(Lugar, JugadoresDelLugar, _),
  findall(Jugador, (member(Jugador, JugadoresDelLugar), jugadorConHambre(Jugador)), Hambrientos).

/* -------- 3 - A construir -------- */
item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador, UnItem):-
  item(UnItem, ItemsQueNecesita),
  tieneParaConstruir(Jugador, ItemsQueNecesita).

materialSuficiente(Jugador, Item, Cantidad):-
  itemsJugador(Jugador, ListaItems),
  findall(Item, member(Item, ListaItems), ItemBuscado),
  length(ItemBuscado, Cantidad).

tieneParaConstruir(Jugador, [itemCompuesto(Item) | RestoItems]):-
  item(Item, LoQueNecesita),
  append(LoQueNecesita, RestoItems, ItemsQueNecesita),
  tieneParaConstruir(Jugador, ItemsQueNecesita).
tieneParaConstruir(Jugador, [itemSimple(Item, CantidadRequerida) | RestoItems]):-
  materialSuficiente(Jugador, Item, CantidadAdquirida),
  CantidadAdquirida >= CantidadRequerida,
  tieneParaConstruir(Jugador, RestoItems).
tieneParaConstruir(Jugador, [itemSimple(Item, CantidadRequerida)]):-
  materialSuficiente(Jugador, Item, CantidadAdquirida),
  CantidadAdquirida >= CantidadRequerida.

/* -------- 4 - Para pensar sin bloques -------- */
/* ---- a ---- */
/*
?- nivelPeligrosidad(desierto, Nivel). 
false.

La consulta siempre no se podrá satisfacer, pues basándonos en el principio de universo cerrado, el desierto al no estar definida en
nuestra base de conocimiento, nunca se satisfacerá la consulta (siempre será falso).
*/
/* ---- b ---- */
/*
En funcional, al no existir el concepto de inversibilidad sobre las funciones, sino que se tiene en cuenta o no la aplicación parcial o total
de la misma; el paradigma lógico permite realizar consultas existenciales mediante el concepto de Variable no unificada, en las cuales estas
son unificadas una vez dentro del predicado mediante el motor de inferencia de Prolog.
*/
