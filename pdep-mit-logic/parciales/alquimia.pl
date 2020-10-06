% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.
herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

/* ---------- 1 ---------- */
tiene(ana, agua).
tiene(ana, vapor).
tiene(ana, tierra).
tiene(ana, hierro).
tiene(beto, agua).
tiene(beto, vapor).
tiene(beto, tierra).
tiene(beto, hierro).
tiene(cata, fuego).
tiene(cata, tierra).
tiene(cata, agua).
tiene(cata, aire).

elemento(pasto, agua).
elemento(pasto, tierra).
elemento(hierro, fuego).
elemento(hierro, agua).
elemento(hierro, tierra).
elemento(huesos, pasto).
elemento(huesos, agua).
elemento(vapor, agua).
elemento(vapor, fuego).
elemento(presion, hierro).
elemento(presion, vapor).
elemento(playStation, silicio).
elemento(playStation, hierro).
elemento(playStation, plastico).
elemento(silicio, tierra).
elemento(plastico, huesos).
elemento(plastico, presion).

/* ---------- 2 ---------- */
tieneIngredientesPara(UnJugador, UnElemento):-
  tiene(UnJugador, _),
  elemento(UnElemento, _),
  forall(elemento(UnElemento, Ingrediente), tiene(UnJugador, Ingrediente)).

/* ---------- 3 ---------- */
estaVivo(agua).
estaVivo(fuego).
estaVivo(UnElemento):-
  elemento(UnElemento, OtroElemento),
  estaVivo(OtroElemento).
estaVivo(UnElemento):-
  elemento(UnElemento, OtroElemento),
  elementoVivo(OtroElemento).

elementoVivo(agua).
elementoVivo(fuego).

/* ---------- 4 ---------- */
puedeConstruir(UnaPersona, UnElemento):-
  tieneIngredientesPara(UnaPersona, UnElemento),
  herramienta(UnaPersona, Herramienta),
  sirveParaConstruir(Herramienta, UnElemento).

sirveParaConstruir(libro(vida), UnElemento):-
  estaVivo(UnElemento).
sirveParaConstruir(libro(inerte), UnElemento):-
  not(estaVivo(UnElemento)).
sirveParaConstruir(cuchara(LongitudEnCentimetros), UnElemento):-
  cantidadIngredientes(UnElemento, CantidadIngredientes),
  CantidadIngredientes =< LongitudEnCentimetros / 10.
sirveParaConstruir(circulo(DiametroEnCentimetros, CantidadNiveles), UnElemento):-
  cantidadIngredientes(UnElemento, CantidadIngredientes),
  CantidadIngredientes =< (DiametroEnCentimetros / 100) * CantidadNiveles.

cantidadIngredientes(UnElemento, CantidadIngredientes):-
  findall(Componente, elemento(UnElemento, Componente), ComponentesDelElemento),
  length(ComponentesDelElemento, CantidadIngredientes).

/* ---------- 5 ---------- */
todoPoderoso(UnaPersona):-
  tieneTodosLosElementosPrimitivos(UnaPersona),
  tieneParaConstruirLoQueNoTiene(UnaPersona).
  
tieneTodosLosElementosPrimitivos(UnaPersona):-
  tiene(UnaPersona, _),
  forall(elementoPrimitivo(Elemento), tiene(UnaPersona, Elemento)).

tieneParaConstruirLoQueNoTiene(UnaPersona):-
  tiene(UnaPersona, _),
  forall(not(tiene(UnaPersona, ElementoAusente)), sirveParaConstruir(_, ElementoAusente)).

elementoPrimitivo(UnElemento):-
  tiene(_, UnElemento),
  not(elemento(UnElemento, _)).

/* ---------- 6 ---------- */
quienGana(UnaPersona):-
  cantidadDeCosasQuePuedeConstruir(UnaPersona, CantidadDeCosas),
  forall(
    (cantidadDeCosasQuePuedeConstruir(OtraPersona, OtraCantidadDeCosas), OtraPersona \= UnaPersona),
    CantidadDeCosas > OtraCantidadDeCosas
  ).

cantidadDeCosasQuePuedeConstruir(UnaPersona, CantidadDeCosas):-
  tiene(UnaPersona, _),
  findall(Elemento, distinct(Elemento, puedeConstruir(UnaPersona, Elemento)), ListaElementos),
  length(ListaElementos, CantidadDeCosas).

/* ---------- 7 ---------- */
/*
Se aplicó el concepto de universo cerrado al momento de definir la base de conocimientos, en el párrafo dos de la consigna:
citando textualmente: "...Cata tiene fuego, tierra, agua y aire, pero no tiene vapor...".
Se aplicó el concepto de universo cerrado omitiendo esta información y directamente no definiéndola como otro hecho en la base de conocimientos.
*/

/* ---------- 8 ---------- */
puedeLlegarATener(Persona, Elemento):-
  tiene(Persona, Elemento).
puedeLlegarATener(Persona, Elemento):-
  herramienta(Persona, Herramienta),
  sirveParaConstruir(Herramienta, Elemento),
  forall(ingredienteNecesario(Elemento, Ingrediente), puedeLlegarATener(Persona, Ingrediente)).

ingredienteNecesario(Elemento, Ingrediente):-
  elemento(Elemento, Ingrediente).