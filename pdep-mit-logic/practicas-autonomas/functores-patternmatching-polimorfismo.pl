valor(0, 1).
valor(0, "alguito").
valor(1, "algo").
valor(Incognita, Incognita).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elSegundo(Lista, Elemento):-
  nth1(2, Lista, Elemento).

head([Cabeza | _], Cabeza).
tail([_ | Cola], Cola).

esVacio([]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nacio(karla, fecha(22, 08, 1979)).
nacio(sergio, fecha(14, 10, 1986)).
nacio(osvaldo, fecha(23, 5, 1950)).
nacio(joel, fecha(23, 12, 1998)).

esPersona(UnaPersona):-
  nacio(UnaPersona, _).

nacioEntre(UnaPersona, CotaInferior, CotaSuperior):-
% esPersona(UnaPersona), -> sobre-generación?
  nacio(UnaPersona, fecha(_, _, Anio)),
  Anio >= CotaInferior, Anio =< CotaSuperior.

esBoomer(UnaPersona):-
  nacioEntre(UnaPersona, 1946, 1964).

esGeneracionX(UnaPersona):-
  nacioEntre(UnaPersona, 1965, 1979).

esMilennial(UnaPersona):-
  nacioEntre(UnaPersona, 1980, 1999).

esGeneracionZ(UnaPersona):-
  nacioEntre(UnaPersona, 2000, 2022).

perteneceAGeneracion(UnaPersona, boomer):-
  esBoomer(UnaPersona).
perteneceAGeneracion(UnaPersona, x):-
  esGeneracionX(UnaPersona).
perteneceAGeneracion(UnaPersona, milennial):-
  esMilennial(UnaPersona).
perteneceAGeneracion(UnaPersona, z):-
  esGeneracionZ(UnaPersona).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% natacion: estilos (lista), metros nadados, medallas
practica(ana, natacion([pecho, crawl], 1200, 10)).
practica(luis, natacion([perrito], 200, 0)).
practica(vicky, natacion([crawl, mariposa, pecho, espalda], 800, 0)).
% fútbol: medallas, goles marcados, veces que fue expulsado
practica(deby, futbol(2, 15, 5)).
practica(mati, futbol(1, 11, 7)).
% rugby: posición que ocupa, medallas
practica(zaffa, rugby(pilar, 0)).

/*
Aclaraciones:
1) para la natación sabemos los estilos que nada, la cantidad de metros diarios que recorre, y la cantidad de medallas que consiguió a lo largo de su carrera deportiva
2) para el fútbol primero conocemos las medallas, luego los goles convertidos y por último las veces que fue expulsado
3) para el rugby, queremos saber la posición que ocupa y luego la cantidad de medallas obtenidas
*/
esNadador(natacion(_, _, _)).
sonNadadores(UnaPersona):-
  practica(UnaPersona, UnDeporte),
  esNadador(UnDeporte).

cuantasMedallas(natacion(_, _, Medallas), Medallas).
cuantasMedallas(futbol(Medallas, _, _), Medallas).
cuantasMedallas(rugby(_, Medallas), Medallas).
medallas(UnaPersona, Medallas):-
  practica(UnaPersona, UnDeporte),
  cuantasMedallas(UnDeporte, Medallas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esBuenDeportista(UnaPersona):-
  practica(UnaPersona, UnDeporte),
  seDistingueEn(UnDeporte).

seDistingueEn(natacion(Estilos, _, _)):-
  length(Estilos, CantidadEstilos),
  CantidadEstilos > 3.
seDistingueEn(natacion(_, MetrosNadados, _)):-
  MetrosNadados > 1000.
seDistingueEn(futbol(_, GolesMarcados, VecesExpulsado)):-
  Diferencia is GolesMarcados - VecesExpulsado,
  Diferencia > 5.
seDistingueEn(rugby(wing, _)).
seDistingueEn(rugby(pilar, _)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
personaje(sansa, stark(15, mujer)).
personaje(tyrion, lannister(30, hombre)).

unaCasa(stark(UnaEdad, _), UnaEdad).
unaCasa(lannister(UnaEdad, _), UnaEdad).

esAdulto(UnaCasa):-
  unaCasa(UnaCasa, UnaEdad),
  UnaEdad > 15.

personajeAdulto(UnNombre):-
  personaje(UnNombre, UnaCasa),
  esAdulto(UnaCasa).

% esAdulto(stark(Edad, _)):-Edad > 15.
% esAdulto(lannister(Edad, _)):-Edad > 15.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esPeligroso(UnNombre):-
  personaje(UnNombre, UnaCasa),
  esPersonajePeligroso(UnaCasa).

esPersonajePeligroso(lannister(CantidadMonedas)):-
  CantidadMonedas >= 300.
esPersonajePeligroso(stark(_, _)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esPersonajePeligroso(nightwatch(_, lobo(_))).

