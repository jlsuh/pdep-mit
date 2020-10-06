herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

/* ---------- 1 ---------- */
cazafantasma(egon, aspiradora(200)).
cazafantasma(egon, trapeador).
cazafantasma(peter, trapeador).
cazafantasma(winston, varitaDeNeutrones).
% cazafantasma(joel, aspiradora(400)).
% cazafantasma(joel, trapeador).
% cazafantasma(joel, plumero).

/* ---------- 2 ---------- */
disponeHerramientaRequerida(Integrante, aspiradora(PotenciaRequerida)):-
  cazafantasma(Integrante, aspiradora(PotenciaAspiradoraIntegrante)),
  PotenciaAspiradoraIntegrante >= PotenciaRequerida.
disponeHerramientaRequerida(Integrante, Herramienta):-
  cazafantasma(Integrante, Herramienta),
  Herramienta \= aspiradora(_).

/* ---------- 3 ---------- */
puedeRealizarTarea(Integrante, NombreTarea):-
  cazafantasma(Integrante, varitaDeNeutrones),
  herramientasRequeridas(NombreTarea, _).
puedeRealizarTarea(Integrante, NombreTarea):-
  cazafantasma(Integrante, _),
  herramientasRequeridas(NombreTarea, ListaHerramientas),
  forall(member(Herramienta, ListaHerramientas), disponeHerramientaRequerida(Integrante, Herramienta)).

/* ---------- 4 ---------- */
% tareaPedida(Cliente, TareaPedida, MetrosCuadrados).
tareaPedida(???, ???, ???).

%precio(TareaPedida, PrecioPorMetroCuadrado).
precio(???, ???).

precioACobrar(Cliente, Pedido, PrecioTotal):-
  tareaPedida(Cliente, _, _),
  findall(
    PrecioPorMetroCuadrado * Metroscuadrados,
    (tareaPedida(Cliente, Tarea, Metroscuadrados), member(Tarea, Pedido), precio(Tarea, PrecioPorMetroCuadrado)),
    ListaDePrecios
    ),
  sum_list(ListaDePrecios, PrecioTotal).
  
/* ---------- 5 ---------- */
estaDispuestoAAceptarlo(peter, _).
estaDispuestoAAceptarlo(ray, Pedido):-
  forall(member(Tarea, Pedido), Tarea \= limpiarTecho).
estaDispuestoAAceptarlo(winston, Pedido):-
  precioACobrar(_, Pedido, PrecioTotal),
  PrecioTotal > 500.
estaDispuestoAAceptarlo(egon, Pedido):-
  not(tieneTareasComplejas(Pedido)).

tieneTareasComplejas(Pedido):-
  member(limpiarTecho, Pedido).
tieneTareasComplejas(Pedido):-
  member(Tarea, Pedido),
  herramientasRequeridas(Tarea, ListaHerramientasRequeridas),
  member(UnaHerramienta, ListaHerramientasRequeridas),
  member(OtraHerramienta, ListaHerramientasRequeridas),
  UnaHerramienta \= OtraHerramienta.

quienesAceptarianPedido(Cliente, Integrante):-
  tareaPedida(Cliente, _, _),
  forall(
    tareaPedida(Cliente, NombreTarea, _),
    (puedeRealizarTarea(Integrante, NombreTarea), estaDispuestoAAceptarlo(Integrante, NombreTarea))
    ).

/* ---------- 6 ---------- */
/* me dio pereza */