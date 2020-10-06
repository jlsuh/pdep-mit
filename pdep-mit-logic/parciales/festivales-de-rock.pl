anioActual(2015).

%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).

%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).

entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

/* ---------- 1 ---------- */
%banda(nombre, año, nacionalidad, popularidad).

estaDeModa(NombreBanda):-
  banda(NombreBanda,AnioConformacion,_,Popularidad),
  anioActual(AnioActual),
  Diferencia is AnioActual - AnioConformacion,
  Diferencia =< 5,
  Popularidad > 70.

/* ---------- 2 ---------- */
%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).

esFestival(NombreFestival):-
  festival(NombreFestival, _, _, _).

esCareta(NombreFestival):-
  esFestival(NombreFestival),
  estaDeModa(Banda),
  estaDeModa(OtraBanda),
  Banda \= OtraBanda.
esCareta(NombreFestival):-
  esFestival(NombreFestival),
  not(entradaRazonable(NombreFestival, _)).
esCareta(NombreFestival):-
  festival(NombreFestival, _, Bandas, _),
  member(miranda, Bandas).

/* ---------- 3 ---------- */
entradaRazonable(Festival, Entrada):-
  precioEntrada(Entrada, Festival, PrecioEntrada),
  condicionDeRazonable(Entrada, Festival, PrecioEntrada).

precioEntrada(campo, Festival, PrecioEntrada):-
  festival(Festival, _, _, PrecioEntrada).
precioEntrada(plateaNumerada(NumeroFila), Festival, PrecioEntrada):-
  filasDisponibles(Festival, NumeroFila),
  festival(Festival, _, _, PrecioBase),
  PrecioEntrada is PrecioBase + 200 / NumeroFila.
precioEntrada(plateaGeneral(NumeroZona), Festival, PrecioEntrada):-
  festival(Festival, lugar(NombreDelLugar, _), _, PrecioBase),
  plusZona(NombreDelLugar, NumeroZona, PlusDeZona),
  PrecioEntrada is PrecioBase + PlusDeZona.

filasDisponibles(Festival, NumeroFila):-
  entradasVendidas(Festival, plateaNumerada(NumeroFila), _).

condicionDeRazonable(plateaGeneral(NumeroZona), Festival, PrecioEntrada):-
  festival(Festival, lugar(NombreDelLugar, _), _, _),
  plusZona(NombreDelLugar, NumeroZona, PlusDeZona),
  PlusDeZona < 0.1 * PrecioEntrada.

condicionDeRazonable(campo, Festival, PrecioEntrada):-
  popularidadTotal(Festival, PopularidadTotalFestival),
  PrecioEntrada < PopularidadTotalFestival.

condicionDeRazonable(plateaNumerada(_), Festival, PrecioEntrada):-
  festival(Festival, _, Bandas, _),
  not((member(NombreBanda, Bandas), estaDeModa(NombreBanda))),
  PrecioEntrada < 750.
condicionDeRazonable(plateaNumerada(_), Festival, PrecioEntrada):-
  festival(Festival, lugar(_, CapacidadEstadio), Bandas, _),
  forall(member(NombreBanda, Bandas), estaDeModa(NombreBanda)),
  popularidadTotal(Festival, PopularidadTotalFestival),
  PrecioEntrada < CapacidadEstadio / PopularidadTotalFestival.

popularidadTotal(Festival, PopularidadTotalFestival):-
  festival(Festival, _, ListaBandas, _),
  findall(Popularidad, (member(NombreBanda, ListaBandas), banda(NombreBanda, _, _, Popularidad)), Popularidades),
  sum_list(Popularidades, PopularidadTotalFestival).

/* ---------- 4 ---------- */
nacanpop(Festival):-
  festival(Festival, _, Bandas, _),
  forall(member(NombreBanda, Bandas), banda(NombreBanda, _, ar, _)),
  entradaRazonable(Festival, _).

/* ---------- 5 ---------- */
recaudacion(Festival, RecaudacionTotal):-
  festival(Festival, _, _, _),
  findall(
    CantidadVendida * PrecioEntrada,
    (entradasVendidas(Festival, Entrada, CantidadVendida), precioEntrada(Entrada, Festival, PrecioEntrada)),
    Recaudaciones
    ),
  sum_list(Recaudaciones, RecaudacionTotal).

/* ---------- 6 ---------- */
estaBienPlaneado(Festival):-
  festival(Festival, _, Bandas, _),
  creciendoEnPopularidad(Bandas),
  last(Bandas, UltimaBanda),
  esLegendaria(UltimaBanda, Bandas).

creciendoEnPopularidad([UnaBanda, OtraBanda]):-
  banda(UnaBanda, _, _, UnaPopularidad),
  banda(OtraBanda, _, _, OtraPopularidad),
  OtraPopularidad > UnaPopularidad.
creciendoEnPopularidad([UnaBanda, OtraBanda | RestoDeBandas]):-
  banda(UnaBanda, _, _, UnaPopularidad),
  banda(OtraBanda, _, _, OtraPopularidad),
  OtraPopularidad > UnaPopularidad,
  creciendoEnPopularidad([OtraBanda | RestoDeBandas]).

esLegendaria(UnaBanda, Bandas):-
  banda(UnaBanda, AnioConformacion, Nacionalidad, UnaPopularidad),
  AnioConformacion < 1980,
  Nacionalidad \= ar,
  forall((member(OtraBanda, Bandas), UnaBanda \= OtraBanda),
          (banda(OtraBanda, _, _, OtraPopularidad), UnaPopularidad > OtraPopularidad)
          ).