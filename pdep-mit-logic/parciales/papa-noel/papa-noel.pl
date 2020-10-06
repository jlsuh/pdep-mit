% persona(Nombre, Edad)
persona(laura, 24).
persona(federico, 31).
persona(maria, 23).
persona(jacobo, 45).
persona(enrique, 49).
persona(andrea, 38).
persona(gabriela, 4).
persona(gonzalo, 23).
persona(alejo, 20).
persona(andres, 11).
persona(ricardo, 39).
persona(ana, 7).
persona(juana, 15).

% quiere(Quién, Quiere)
quiere(andres, juguete(maxSteel, 150)).
quiere(andres, bloques([piezaT, piezaL, cubo, piezaChata])).
quiere(maria, bloques([piezaT, piezaT])).
quiere(alejo, bloques([piezaT])).
quiere(juana, juguete(barbie, 175)).
quiere(federico, abrazo).
quiere(enrique, abrazo).
quiere(gabriela, juguete(gabeneitor2000, 5000)).
quiere(laura, abrazo).
quiere(gonzalo, abrazo).

% presupuesto(Quién, Presupuesto).
presupuesto(jacobo, 20).
presupuesto(enrique, 2311).
presupuesto(ricardo, 154).
presupuesto(andrea, 100).
presupuesto(laura, 2000).

% accion(Quién, Hizo).
accion(andres, travesura(3)).
accion(andres, ayudar(ana)).
accion(ana, golpear(andres)).
accion(ana, travesura(1)).
accion(maria, ayudar(federico)).
accion(maria, favor(juana)).
accion(juana, favor(maria)).
accion(federico, golpear(enrique)).
accion(gonzalo, golpear(alejo)).
accion(alejo, travesura(4)).

% padre(Padre o Madre, Hijo o Hija)
padre(jacobo, ana).
padre(jacobo, juana).
padre(enrique, federico).
padre(ricardo, maria).
padre(andrea, andres).
padre(laura, gabriela).

/* ---------- prefacio ---------- */
creeEnPapaNoel(federico).
creeEnPapaNoel(Alguien):-
  persona(Alguien, Edad),
  Edad < 13.

/* ---------- 1 ---------- */
buenaAccion(favor(_)).
buenaAccion(ayudar(_)).
buenaAccion(travesura(NivelTravesura)):-
  NivelTravesura =< 3.

/* ---------- 2 ---------- */
sePortoBien(Alguien):-
  accion(Alguien, _),
  forall(accion(Alguien, Accion), buenaAccion(Accion)).

/* ---------- 3 ---------- */
malcriador(Tutor):-
  padre(Tutor, _),
  forall(padre(Tutor, Hijo), malcriado(Hijo)).

malcriado(Alguien):-
  accion(Alguien, _),
  not((accion(Alguien, Accion), buenaAccion(Accion))).
malcriado(Alguien):-
  accion(Alguien, _),
  not(creeEnPapaNoel(Alguien)).

/* ---------- 4 ---------- */
puedeCostear(Tutor, Hijo):-
  padre(Tutor, _),
  findall(
    Precio,
    (padre(Tutor, Hijo), quiere(Hijo, Regalo), precioRegalo(Regalo, Precio)),
    ListaPrecios
  ),
  sum_list(ListaPrecios, TotalAPagar),
  presupuesto(Tutor, Presupuesto),
  Presupuesto >= TotalAPagar.

precioRegalo(juguete(_, Precio), Precio).
precioRegalo(bloques(ListaDePartes), Precio):-
  length(ListaDePartes, Precio).
precioRegalo(abrazo, 0).

/* ---------- 5 ---------- */
regaloCandidatoPara(Regalo, Persona):-
  sePortoBien(Persona),
  puedeCostear(_, Persona),
  quiere(Persona, Regalo),
  creeEnPapaNoel(Persona).

/* ---------- 6 ---------- */
regalosQueRecibe(Persona, ListaDeRegalosEnNavidad):-
  persona(Persona, _),
  padre(Tutor, Persona),
  puedeCostear(Tutor, Persona),
  findall(Regalo, quiere(Persona, Regalo), ListaDeRegalosEnNavidad).
regalosQueRecibe(Persona, ListaDeRegalosEnNavidad):-
  persona(Persona, _),
  padre(Tutor, Persona),
  not(puedeCostear(Tutor, Persona)),
  regalosPrecarios(Persona, ListaDeRegalosEnNavidad).

regalosPrecarios(Persona, [parDeMedias(gris, blanco)]):-
  sePortoBien(Persona).
regalosPrecarios(Persona, [carbon]):-
  accion(Persona, UnaMalaAccion),
  accion(Persona, OtraMalaAccion),
  not((buenaAccion(UnaMalaAccion), buenaAccion(OtraMalaAccion))),
  UnaMalaAccion \= OtraMalaAccion.

sugaDaddy(Padre):-
  padre(Padre, _),
  forall((padre(Padre, Hijo), quiere(Hijo, Regalo)), regaloCaro(Regalo)).
sugaDaddy(Padre):-
  padre(Padre, _),
  forall((padre(Padre, Hijo), quiere(Hijo, Regalo)), valeLaPena(Regalo)).

regaloCaro(Regalo):-
  precioRegalo(Regalo, Precio),
  Precio > 500.

valeLaPena(juguete(buzz, _)).
valeLaPena(juguete(woody, _)).
valeLaPena(bloques(ListaPiezas)):-
  member(cubo, ListaPiezas).