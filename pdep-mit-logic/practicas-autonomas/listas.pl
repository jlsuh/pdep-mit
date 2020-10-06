head([Head | _], Head).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% padre(homero,bart).
% padre(homero,maggie). 
% padre(homero,lisa). 
% padre(juan, fede). 
% padre(nico, julieta).

% cantidadDeHijos(Padre, Cantidad):-
%   padre(Padre, _),
%   findall(Hijo, padre(Padre, Hijo), Hijos),
%   length(Hijos, Cantidad).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jugoCon(tobias, pelota, 15).
jugoCon(tobias, bloques, 20).
jugoCon(tobias, rasti, 15).
jugoCon(tobias, dakis, 5).
jugoCon(tobias, casita, 10).
jugoCon(cata, muniecas, 30).
jugoCon(cata, rasti, 20).
jugoCon(luna, muniecas, 10).

unNene(Nene):-
  jugoCon(Nene, _, _).

minutosJugados(Nene, MinutosJugados):-
  unNene(Nene),
  findall(Minuto, jugoCon(Nene, _, Minuto), Minutos),
  sumlist(Minutos, MinutosJugados).

juegosQueJugo(Nene, CantidadJuegos):-
  unNene(Nene),
  findall(Juego, jugoCon(Nene, Juego, _), ListaJuegos),
  list_to_set(ListaJuegos, ListaJuegosNoRepetidos),
  length(ListaJuegosNoRepetidos, CantidadJuegos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puntaje(rojo, 5).
puntaje(azul, 2).
puntaje(violeta, 6).
puntaje(negro, 1).

equipo(Equipo):-
  puntaje(Equipo, _).

tablero(Equipo, Puntaje):-
  equipo(Equipo),
  findall(puntos(Equipo, Puntaje), puntaje(Equipo, Puntaje), Puntaje).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tiene(juan, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(juan, foto([juan], 1977)).
tiene(juan, libro(saramago, "Ensayo sobre la ceguera")).
tiene(juan, bebida(whisky)).
tiene(valeria, libro(borges, "Ficciones")).
tiene(lucas, bebida(cusenier)).
tiene(pedro, foto([juan, hugo, pedro, lorena, laura], 1988)).
tiene(pedro, foto([pedro], 2010)). % -> Pedro no es coleccionista justamente por esto
tiene(pedro, libro(octavioPaz, "Salamandra")).
 
premioNobel(octavioPaz).
premioNobel(saramago).

/*
Observaciones:
2) candidato/1 es innecesaria en coleccionista/1, pues se puede utilizar directamente tiene/2.
candidato/1 no se utiliza en ningún otro lugar, más que en coleccionista/1
*/
/*
candidato(Candidato):-
  tiene(Candidato, _).
*/

coleccionista(Candidato):-
%  candidato(Candidato),          (2)
  tiene(Candidato, _),          % (2)
  forall(tiene(Candidato, Elemento), esValioso(Elemento)).

/*
Observaciones: 
1) autor/1 en esValioso/1 es innecesaria, pues ya se conoce quiénes conforman el dominio de los PremiosNobel
*/
/*
autor(Autor):-
  tiene(_, libro(Autor, _)).
*/

esValioso(libro(Autor, _)):-
%  autor(Autor),                  (1)
  premioNobel(Autor).
esValioso(foto(ListaIntegrantes, _)):-
  length(ListaIntegrantes, CantidadIntegrantes),
  CantidadIntegrantes > 3.
esValioso(foto(_, Anio)):-
  Anio < 1990.
esValioso(bebida(whisky)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ingreso(roque,enero,2300).
ingreso(roque,febrero,3500).
ingreso(roque,marzo,1200).
ingreso(luisa,enero,2500).
ingreso(luisa,febrero,850).
ingreso(homero,febrero,500).
ingreso(bart,febrero,250).
ingreso(lisa,febrero,250).
ingreso(maggie,febrero,1000).

esMes(Mes):-
  ingreso(_, Mes, _).

mesFilial(Persona, Mes):-
  unaPersona(Persona),
  esMes(Mes),
  padre(Hijo, Padre),
  ingreso(Hijo, Mes, IngresoHijo),
  ingreso(Padre, Mes, IngresoPadre),
  IngresoHijo > IngresoPadre.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unaPersona(Persona):-
  ingreso(Persona, _, _).

ingresoTotal(Persona, IngresoTotalEnUnAnio):-
  unaPersona(Persona),
  findall(IngresoMensual, ingreso(Persona, _, IngresoMensual), IngresoTotal),
  sum_list(IngresoTotal, IngresoTotalEnUnAnio).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
padre(roque, luisa).
padre(bart, homero).
padre(lisa, homero).
padre(maggie, homero).

persona(Persona):-
  ingresoTotal(Persona, _).

% ingresoFamiliar(Persona, IngresoFamiliar):-
% %  persona(Persona),
%   ingresoTotal(Persona, IngresoPersona),
%   findall(Hijo, padre(Hijo, Persona), ListaHijos),
%   ingresoDeLosHijos(ListaHijos, IngresoDeHijos),
%   IngresoFamiliar is IngresoDeHijos + IngresoPersona.

% ingresoDeLosHijos([], 0).
% ingresoDeLosHijos([Hijo|RestoDeHijos], IngresoDeHijos):-
%   ingresoTotal(Hijo, IngresoHijo),
%   ingresoDeLosHijos(RestoDeHijos, IngresoRestoDeHijos),
%   IngresoDeHijos is IngresoHijo + IngresoRestoDeHijos.

ingresoFamiliar(Persona, IngresoFamiliar):-
  ingresoTotal(Persona, IngresoPersona),
  ingresosDeHijos(Persona, IngresosDeHijos),
  IngresoFamiliar is IngresosDeHijos + IngresoPersona.

ingresosDeHijos(Persona, IngresosDeHijos):-
  findall(Hijo, padre(Hijo, Persona), ListaHijos),
  maplist(ingresoTotal, ListaHijos, ListaConIngresoDeHijos),
  sum_list(ListaConIngresoDeHijos, IngresosDeHijos).