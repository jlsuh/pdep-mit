% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).
% … y muchos más también
jugador(joel, 1600, argentinos).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
% … y muchos más también
tiene(joel, unidad(samurai, 199)).
tiene(joel, unidad(espadachin, 10)).
tiene(joel, unidad(granjero, 10)).
tiene(joel, recurso(800, 300, 100)).
tiene(joel, edificio(casa, 40)).
tiene(joel, edificio(castillo, 1)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).
% … y muchos más tipos pertenecientes a estas categorías.

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).
% … y muchos más también

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).
% … y muchos más también

/* ---------- 1 ---------- */
esUnAfano(UnJugador, OtroJugador):-
  diferenciaDeRating(UnJugador, OtroJugador, DiferenciaRating),
  DiferenciaRating > 500.

diferenciaDeRating(UnJugador, OtroJugador, DiferenciaRating):-
  jugador(UnJugador,UnRating,_), jugador(OtroJugador,OtroRating,_),
  DiferenciaRating is UnRating - OtroRating.

/* ---------- 2 ---------- */
esEfectivo(samurai, OtraUnidad):-
  militar(OtraUnidad, _, unica).
esEfectivo(UnaUnidad, OtraUnidad):-
  militar(UnaUnidad, _, UnaCategoria),
  militar(OtraUnidad, _, OtraCategoria),
  leGana(UnaCategoria, OtraCategoria).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).

/* ---------- 3 ---------- */
jugadorQueTieneAlgo(Jugador):-
  tiene(Jugador, _).

alarico(Jugador):-
  jugadorQueTieneAlgo(Jugador),
  soloTieneComoUnidad(Jugador, infanteria).

soloTieneComoUnidad(Jugador, Categoria):-
  forall(tiene(Jugador, unidad(TipoUnidad, _)),
          militar(TipoUnidad, _, Categoria)
          ).
/* ---------- 4 ---------- */
leonidas(Jugador):-
  jugadorQueTieneAlgo(Jugador), % -> observar que se establece el dominio en jugadores que tienen algo
  soloTieneComoUnidad(Jugador, piquero).

/* ---------- 5 ---------- */
jugador(Jugador):-
  jugador(Jugador,_,_).

nomada(Jugador):-
  jugador(Jugador), % -> observar que se establece el dominio en el universo de jugadores, indistintamente si tienen algo o no
  not(tiene(Jugador, edificio(casa, _))).

/* ---------- 6 ---------- */
cuantoCuesta(TipoUnidad, Costo):-
  militar(TipoUnidad, Costo, _).
cuantoCuesta(TipoEdificio, Costo):-
  edificio(TipoEdificio, Costo).
cuantoCuesta(TipoUnidad, costo(0, 50, 0)):-
  aldeano(TipoUnidad,_).
cuantoCuesta(TipoUnidad, costo(100, 0, 50)):-
  unidadDeReaprovisionamiento(TipoUnidad).

unidadDeReaprovisionamiento(carreta).
unidadDeReaprovisionamiento(urnaMercante).

/* ---------- 7 ---------- */
produccion(TipoUnidad, ProduccionPorMinuto):-
  aldeano(TipoUnidad, ProduccionPorMinuto).
produccion(TipoUnidad, produce(0, 0, 32)):-
  unidadDeReaprovisionamiento(TipoUnidad).
produccion(keshik, produce(0, 0, 10)).

/* ---------- 8 ---------- */
produccionTotal(Jugador, CiertoRecurso, ProduccionPorMinuto):-
  jugador(Jugador),
  produccionPorMinuto(_, CiertoRecurso, _),
  findall(ProduccionDeCiertoRecursoPorMinuto,
          produccionJugador(Jugador, CiertoRecurso, ProduccionDeCiertoRecursoPorMinuto),
          ProduccionesPorMinutoDeUnidadDeCiertoRecurso
          ),
  sum_list(ProduccionesPorMinutoDeUnidadDeCiertoRecurso, ProduccionPorMinuto).

produccionJugador(Jugador, CiertoRecurso, ProduccionDeCiertoRecursoPorMinuto):-
  tiene(Jugador, unidad(TipoUnidad, _)),
  produccionUnidad(TipoUnidad, CiertoRecurso, ProduccionDeCiertoRecursoPorMinuto).

produccionUnidad(TipoUnidad, CiertoRecurso, ProduccionDeCiertoRecursoPorMinuto):-
  produccion(TipoUnidad, ProduccionPorMinuto),
  produccionPorMinuto(ProduccionPorMinuto, CiertoRecurso, ProduccionDeCiertoRecursoPorMinuto).

produccionPorMinuto(produce(Produccion,_,_), madera, Produccion).
produccionPorMinuto(produce(_,Produccion,_), alimento, Produccion).
produccionPorMinuto(produce(_,_,Produccion), oro, Produccion).

/* ---------- 9 ---------- */
estaPeleado(UnJugador, OtroJugador):-
  tiene(UnJugador, _), tiene(OtroJugador, _),
  noEsAfanoParaNinguno(UnJugador, OtroJugador),
  tienenLaMismaCantidadDeUnidades(UnJugador, OtroJugador),
  diferenciaDeRecursos(UnJugador, OtroJugador, DiferenciaProduccion),
  forall(member(Diferencia, DiferenciaProduccion), Diferencia < 100),
  UnJugador \= OtroJugador.

diferenciaDeRecursos(UnJugador, OtroJugador, produce(DiferenciaMadera, DiferenciaAlimento, DiferenciaOro)):-
  produccionDeCadaRecurso(UnJugador, ProduccionMadera, ProduccionAlimento, ProduccionOro),
  produccionDeCadaRecurso(OtroJugador, OtraProduccionMadera, OtraProduccionAlimento, OtraProduccionOro),
  diferenciaAbsoluta(ProduccionMadera, OtraProduccionMadera, 3, DiferenciaMadera),
  diferenciaAbsoluta(ProduccionAlimento, OtraProduccionAlimento, 2, DiferenciaAlimento),
  diferenciaAbsoluta(ProduccionOro, OtraProduccionOro, 5, DiferenciaOro).

diferenciaAbsoluta(Componente, OtraComponente, Factor, DiferenciaAbsoluta):-
  DiferenciaAbsoluta is abs(Factor * Componente - Factor * OtraComponente).

produccionDeCadaRecurso(UnJugador, ProduccionMadera, ProduccionAlimento, ProduccionOro):-
  produccionTotal(UnJugador, madera, ProduccionMadera),
  produccionTotal(UnJugador, alimento, ProduccionAlimento),
  produccionTotal(UnJugador, oro, ProduccionOro).

tienenLaMismaCantidadDeUnidades(UnJugador, OtroJugador):- 
  forall(tiene(UnJugador, Unidad), tiene(OtroJugador, Unidad)).

noEsAfanoParaNinguno(UnJugador, OtroJugador):-
  not(esUnAfano(UnJugador, OtroJugador)),
  not(esUnAfano(OtroJugador, UnJugador)).

/* ---------- 10 ---------- */
avanzaA(UnJugador, edadMedia):-
  tiene(UnJugador, _).
avanzaA(UnJugador, edadFeudal):-
  tiene(UnJugador, recurso(_,CantidadAlimento,_)),
  tieneEdificio(UnJugador, casa),
  CantidadAlimento >= 500.
avanzaA(UnJugador, edadCastillo):-
  tiene(UnJugador, recurso(_, CantidadAlimento, CantidadOro)),
  tieneEdificio(UnJugador, Edificio),
  esEdificiosParaEdadCastillo(Edificio),
  CantidadAlimento >= 800, CantidadOro >= 200.
avanzaA(UnJugador, edadImperial):-
  tiene(UnJugador, recurso(_, CantidadAlimento, CantidadOro)),
  tieneEdificio(UnJugador, castillo),
  tieneEdificio(UnJugador, universidad),
  CantidadAlimento >= 1000, CantidadOro >= 800.

tieneEdificio(UnJugador, Edificio):-
  tiene(UnJugador, edificio(Edificio, _)).
/*
Se supone siempre que en la base de conocimientos no estará definida casos como:
edificio(casa, 0).
En caso de que el jugador no posea el edificio, por universo cerrado se supondrá que se evitó definir
el edificio que no tiene como parte de la base de conocimientos.
*/

esEdificiosParaEdadCastillo(herreria).
esEdificiosParaEdadCastillo(establo).
esEdificiosParaEdadCastillo(galeriaDeTiro).