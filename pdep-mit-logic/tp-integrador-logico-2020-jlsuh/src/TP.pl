/*
Consigna:
https://docs.google.com/document/d/10XcbIdvrKsSOzAvsT-C2atIwaj4x3tXvYKXN6OJBOKc/edit
*/

/* Tripulantes */
% rol(UnTripulante, RolQueCumplia).
rol(robert, capitan).
rol(lewis, maestre).
rol(robin, maestre).
rol(martin, asistirA(capitan)).
rol(richard, asistirA(maestre)).
rol(john, asistirA(maestre)).
rol(oliver, marinero(hacerVigilancia)).
rol(oliver, marinero(timonear)).
rol(george, marinero(timonear)).
rol(george, marinero(izarVelas)).
rol(george, marinero(hacerVigilancia)).
rol(charles, marinero(hacerLimpieza)).
rol(charles, marinero(izarVelas)).
rol(beng, pasajero).
rol(lim, pasajero).
rol(thomas, cocinero).

% paisOrigen(UnTripulante, Pais).
paisOrigen(lewis, francia).
paisOrigen(robin, canada).
paisOrigen(beng, china).
paisOrigen(lim, china).
paisOrigen(thomas, inglaterra).
paisOrigen(robert, inglaterra).
paisOrigen(oliver, inglaterra).
paisOrigen(george, inglaterra).
paisOrigen(charles, inglaterra).
paisOrigen(martin, inglaterra).
paisOrigen(richard, inglaterra).
paisOrigen(john, inglaterra).

/*
paisOrigen(UnTripulante, inglaterra):-
  rol(UnTripulante, Rol),
  esIngles(Rol).

% esIngles(UnRol).
esIngles(capitan).
esIngles(marinero(_)).
esIngles(asistirA(_)).
*/

/* Luego del análisis forense */
% @ Léase "Victimario mató a Víctima"
% matoA(Victimario, Victima).
matoA(george, richard).
matoA(george, martin).
matoA(george, oliver).
matoA(lewis, beng).
matoA(lewis, robin).
matoA(charles, lewis).
matoA(john, george).
matoA(richard, charles).
matoA(richard, lim).

/* ---------- 1 ---------- */
pais(UnPais):-
  paisOrigen(_, UnPais).

origenDeLaVictima(ElAsesinado, UnPais):-
  paisOrigen(ElAsesinado, UnPais),
  matoA(_, ElAsesinado).

tripulantesDeUnPaisQueFueronVictimas(UnPais, CantidadVictimas):-
  pais(UnPais),
  findall(UnaVictima, distinct(UnaVictima, origenDeLaVictima(UnaVictima, UnPais)), ListaDeVictimas),
  length(ListaDeVictimas, CantidadVictimas).

/*
?- distinct(UnPais, tripulantesDeUnPaisQueFueronVictimas(UnPais, CantidadVictimas)). 
UnPais = francia,
CantidadVictimas = 1 ;
UnPais = canada,
CantidadVictimas = 1 ;
UnPais = china,
CantidadVictimas = 2 ;
UnPais = inglaterra,
CantidadVictimas = 5 ;
false.
*/

/* ---------- 2 ---------- */
paisesConFinSangriento(UnPais):-
  pais(UnPais),
  forall(paisOrigen(UnTripulante, UnPais), matoA(_, UnTripulante)).

/*
?- distinct(UnPais, paisesConFinSangriento(UnPais)). 
UnPais = francia ;
UnPais = canada ;
UnPais = china ;
false.
*/

/* ---------- 3 ---------- */
esCercanoA(UnTripulante, OtroTripulante):-
  rol(UnTripulante, UnRol),
  rol(OtroTripulante, OtroRol),
  rolesCercanos(UnRol, OtroRol),
  UnTripulante \= OtroTripulante.

/*
 * @ Un tripulante asiste el Rol de otro tripulante, no al propio tripulante en sí
*/
rolesCercanos(asistirA(UnRol), UnRol).
rolesCercanos(UnRol, asistirA(UnRol)).
rolesCercanos(cocinero, _).
rolesCercanos(_, cocinero).
rolesCercanos(UnRol, UnRol).
%rolesCercanos(marinero(Tarea), marinero(Tarea)). -> rolesCercanos(UnRol, UnRol) contiene a este patrón.

/*
?- distinct(UnTripulante, esCercanoA(UnTripulante, OtroTripulante)). 
UnTripulante = robert,
OtroTripulante = martin ;
UnTripulante = lewis,
OtroTripulante = robin ;
UnTripulante = robin,
OtroTripulante = lewis ;
UnTripulante = martin,
OtroTripulante = robert ;
UnTripulante = richard,
OtroTripulante = lewis ;
...
*/

/* ---------- 4 ---------- */
tripulante(UnTripulante):-
  rol(UnTripulante, _).

esTraidor(UnTripulante):-
  esCercanoA(UnTripulante, OtroTripulante),
  matoA(UnTripulante, OtroTripulante).

tripulanteInocente(UnTripulante):-
  tripulante(UnTripulante),
  forall(matoA(UnTripulante, OtroTripulante), esTraidor(OtroTripulante)).

/*
?- distinct(UnTripulante, tripulanteInocente(UnTripulante)). 
UnTripulante = robert ;
UnTripulante = robin ;
UnTripulante = martin ;
UnTripulante = john ;
UnTripulante = oliver ;
UnTripulante = charles ;
UnTripulante = beng ;
UnTripulante = lim ;
UnTripulante = thomas.
*/

/* ---------- 5 ---------- */
muertePorVenganza(Vengador, Vengado, BlancoDeVenganza):-
  matoA(BlancoDeVenganza, Vengado),
  matoA(Vengador, BlancoDeVenganza),
  esCercanoA(Vengado, Vengador).

/*
?- muertePorVenganza(Vengador, Vengado, BlancoDeVenganza).
Vengador = john,
Vengado = richard,        
BlancoDeVenganza = george ;
Vengador = richard,
Vengado = lewis,
BlancoDeVenganza = charles ;
Vengador = george,
Vengado = charles,
BlancoDeVenganza = richard ;
false.
*/

/* ---------- 6 ---------- */
paisHonorable(inglaterra).
paisHonorable(UnPais):-
  pais(UnPais),
  forall(paisOrigen(UnTripulante, UnPais), not(esTraidor(UnTripulante))).

/*
?- distinct(UnPais, paisHonorable(UnPais)). 
UnPais = inglaterra ;
UnPais = canada ;
UnPais = china ;
false.
*/

/* ---------- 7 ---------- */
fueParteDelMotin(UnTripulante):-
  matoA(UnTripulante, TripulanteAlMando),
  rol(TripulanteAlMando, Rol),
  estaAlMando(Rol).
fueParteDelMotin(UnTripulante):-
  esCercanoA(UnTripulante, OtroTripulante),
  rol(TripulanteAlMando, Rol),
  estaAlMando(Rol),
  matoA(OtroTripulante, TripulanteAlMando).

estaAlMando(capitan).
estaAlMando(asistirA(capitan)).

/*
?- distinct(UnTripulante, fueParteDelMotin(UnTripulante)). 
UnTripulante = george ;
UnTripulante = oliver ;
UnTripulante = charles ;
UnTripulante = thomas ;
false.
*/

/* ---------- 8 ---------- */
causalDeVenganza(Vengador, Causal):-
  muertePorVenganza(Vengador, _, Causal).
causalDeVenganza(Vengador, Causal):-
  muertePorVenganza(Vengador, _, Blanco),
  causalDeVenganza(Blanco, Causal).

/*
?- causalDeVenganza(Vengador, Causal).
Vengador = john,
Causal = george ;
Vengador = richard,
Causal = charles ;
Vengador = george,
Causal = richard ;
Vengador = john,
Causal = richard ;
Vengador = john,
Causal = charles ;
Vengador = george,
Causal = charles ;
*/

/* ---------- 9 ---------- */
/*
 * Respecto a predicados auxiliares no-inversibles:
 * No se presentaron predicados auxiliares no-inversibles. No obstante, un posible motivo de
 * un predicado auxiliar que no sea inversible, es debido a que las variables que maneja dentro
 * del predicado en cuestión, son unificadas en el predicado principal a priori, en donde
 * el predicado auxiliar es invocado. También tiene que ver con la sobre-generación innecesaria
 * de Variables, puesto que el fin de un predicado auxiliar puede ser meramente de una consulta,
 * sin necesidad de generar dicha variable.
 * 
 * Respecto a las decisiones tomadas en el modelado de información:
 * La información del rol, quien mató a quien y el pais de origen de un tripulante, nos lo es aportado
 * por la consigna. En particular, para este último (pais de origen), se sabe que el capitán, todos
 * los marineros y todos los asistentes eran de Inglaterra, por lo que se ha optado en acoplar
 * paisOrigen/2 con esIngles/1, el cual dicho acoplamiento nos permite evitar la declaración de
 * tripulantes por extensión, sino mediante comprensión.
 * Para rol/2 se ha optado, en caso de que sea un asistente, modelarlo mediante un functor asistirA/1 en
 * donde el único argumento que maneja es un Rol, y no un Tripulante en sí (nombre en particular). En caso
 * de que sea un marinero, se lo ha representado mediante el functor marinero/1, en donde el único argumento
 * que maneja representa las funciones que cumplía como marinero en el barco.
 * Respecto al modelado de quién mató a quién, se lo ha incluido a la base de conocimiento por extensión,
 * puesto que la consigna no nos aportaba ningún requerimiento en donde se mencione una generalización
 * para las relaciones pertinentes.
*/

/* ---------- Notas ---------- */
/*
U = {x / "x es tripulante del barco"}
p(x, y): "x mato a y"
q(x): "x es traidor"

Sabiendo que x está particularizado (unificado):
existe un x pert. U, para todo y pert. U: p(x, y) => q(y)
p(robert, Alguien) => q(Alguien)
        F          => _
                   V => robert es inocente
-------------------------------------------------------
p(robin, Alguien) => q(Alguien)
        F         => _
                  V => robin es inocente
-------------------------------------------------------
p(lewis, Alguien = robin) => q(Alguien = robin)
        V                  => F
                           F
^
p(lewis, Alguien = george) => q(Alguien = george)
        V                  => V
                           V => lewis No es inocente
*/