/*
Una agencia de viajes lleva un registro con todos los vuelos que maneja de la siguiente manera:
vuelo(Codigo de vuelo, capacidad en toneladas, [lista de destinos] ).

Esta lista de destinos está compuesta de la siguiente manera:
escala(ciudad, tiempo de espera)
tramo(tiempo en vuelo)

Siempre se comienza de una ciudad (escala) y se termina en otra (no puede terminar en el aire al vuelo), con tiempo de vuelo entre medio de las ciudades. Considerar que los viajes son de ida y de vuelta por la misma ruta.
*/

vuelo(arg845, 30, [escala(rosario,0), tramo(2), escala(buenosAires,0)]).
vuelo(mh101, 95, [escala(kualaLumpur,0), tramo(9), escala(capeTown,2), tramo(15), escala(buenosAires,0)]).
vuelo(dlh470, 60, [escala(berlin,0), tramo(9), escala(washington,2), tramo(2), escala(nuevaYork,0)]).
vuelo(aal1803, 250, [escala(nuevaYork,0), tramo(1), escala(washington,2),tramo(3), escala(ottawa,3), tramo(15), escala(londres,4), tramo(1), escala(paris,0)]).
vuelo(ble849, 175, [escala(paris,0), tramo(2), escala(berlin,1), tramo(3), escala(kiev,2), tramo(2), escala(moscu,4), tramo(5), escala(seul,2), tramo(3), escala(tokyo,0)]).
vuelo(npo556, 150, [escala(kiev,0), tramo(1), escala(moscu,3), tramo(5), escala(nuevaDelhi,6), tramo(2), escala(hongKong,4), tramo(2),escala(shanghai,5), tramo(3), escala(tokyo,0)]).
vuelo(dsm3450, 75, [escala(santiagoDeChile,0), tramo(1), escala(buenosAires,2), tramo(7), escala(washington,4), tramo(15), escala(berlin,3), tramo(15), escala(tokyo,0)]).

/*
Definir los siguientes predicados; en todos vamos a identificar cada vuelo por su código:
*/
esVuelo(CodigoVuelo):-
  vuelo(CodigoVuelo, _, _).
/*
tiempoTotalVuelo/2: que relaciona un vuelo con el tiempo que lleva en total, contando las esperas en las escalas (y eventualmente en el origen y/o destino) más el tiempo de vuelo.
*/
tiempoTotalVuelo(CodigoVuelo, TiempoDeVueloTotal):-
  vuelo(CodigoVuelo, _, Trayectos),
  duracionEscalas(Trayectos, TotalDuracionesEscalas),
  duracionTramos(Trayectos, TotalDuracionesTramos),
  TiempoDeVueloTotal is TotalDuracionesEscalas + TotalDuracionesTramos.

duracion(escala(_, DuracionEscala), DuracionEscala).
duracion(tramo(DuracionTramo), DuracionTramo).

duracionEscalas(ListaDeTrayectos, DuracionTotal):-
  escalasDeUnVuelo(ListaDeTrayectos, ListaDeEscalas),
  maplist(duracion, ListaDeEscalas, Duraciones),
  sum_list(Duraciones, DuracionTotal).
duracionTramos(ListaDeTrayectos, DuracionTotal):-
  tramosDeUnVuelo(ListaDeTrayectos, ListaDeTramos),
  maplist(duracion, ListaDeTramos, Duraciones),
  sum_list(Duraciones, DuracionTotal).

% escalasDeUnVuelo(ListaDeTrayectos, Escalas):-
%   findall(Escala, nth1(Escala, ListaDeTrayectos, escala(_, _)), Escalas).

/*
escalasDeUnVuelo(ListaDeTrayectos, Escalas):-
  findall(escala(Destino, Duracion), nth1(_, ListaDeTrayectos, escala(Destino, Duracion)), Escalas).
*/

escalasDeUnVuelo(ListaDeTrayectos, Escalas):-
  findall(escala(Destino, Duracion), member(escala(Destino, Duracion), ListaDeTrayectos), Escalas).
tramosDeUnVuelo(ListaDeTrayectos, Tramos):-
  findall(tramo(Duracion), member(tramo(Duracion), ListaDeTrayectos), Tramos).
/*
escalaAburrida/2: Relaciona un vuelo con cada una de sus escalas aburridas; una escala es aburrida si hay que esperar mas de 3 horas.
*/
% escalaAburrida(CodigoVuelo, EscalasAburridas):-
%   vuelo(CodigoVuelo,_, ListaDeTrayectos),
%   escalasDeUnVuelo(ListaDeTrayectos, ListaDeEscalas),
%   obtenerEscalasAburridas(ListaDeEscalas, EscalasAburridas).

% esAburrida([E | Es], EscalasAburridas):-
%   findall(escala(_, Duracion), , EscalasAburridas).
/*
esEscala(Escala):-
  vuelo(_, _, ListaDeTrayectoria),
  escalasDeUnVuelo(ListaDeTrayectoria, Escalas),
  member(Escala, Escalas).
*/

/*
escalaAburrida(CodigoVuelo, EscalasAburridas):-
  vuelo(CodigoVuelo, _, ListaDeTrayectos),
  escalasDeUnVuelo(ListaDeTrayectos, ListaDeEscalas),
  findall(UnaEscala,
          (member(UnaEscala, ListaDeEscalas), esAburrida(UnaEscala)),
          EscalasAburridas).
*/

escalaAburrida(_, escala(_, DuracionDeLaEscala)):-
  duracion(_, DuracionDeLaEscala), 
  DuracionDeLaEscala > 3.

/*
esAburrida(UnaEscala):-
  duracion(UnaEscala, DuracionDeLaEscala), 
  DuracionDeLaEscala > 3.
*/

% >>>>>>>>>>>>>>>  forall(member(UnaEscala, ListaDeEscalas), (duracion(UnaEscala, DuracionEscala), DuracionEscala > 3)). <<<<<<<<<<<<<<<<<<<<

% escalasAburridas(ListaDeTrayectos, EscalasQueSonAburridas):-
%   findall(Duracion, escalasDeUnVuelo(ListaDeTrayectos, ), )

% escalaAburrida(CodigoVuelo, EscalasAburridas):-
%   vuelo(CodigoVuelo, _, ListaDeTrayectos),
%   findall(Escala, )

/*
vueloLargo/1: Si un vuelo pasa 10 o más horas en el aire, entonces es un vuelo largo. OJO que dice "en el aire", en este punto no hay que contar las esperas en tierra.
*/
vueloLargo(CodigoVuelo):-
  vuelo(CodigoVuelo, _, ListaDeTrayectos),
  duracionTramos(ListaDeTrayectos, DuracionTotal),
  DuracionTotal >= 10.

/*
conectados/2: Relaciona 2 vuelos si tienen al menos una ciudad en común.
*/
ciudad(escala(Ciudad, _), Ciudad).

conectados(UnVuelo, OtroVuelo):-
  vuelo(UnVuelo, _, UnaListaDeTrayectos),
  vuelo(OtroVuelo, _, OtraListaDeTrayectos),
  compartenCiudadEnComun(UnaListaDeTrayectos, OtraListaDeTrayectos),
  UnVuelo \= OtroVuelo.
  
compartenCiudadEnComun(UnaListaDeTrayectos, OtraListaDeTrayectos):-
  escalasDeUnVuelo(UnaListaDeTrayectos, UnasEscalas),
  escalasDeUnVuelo(OtraListaDeTrayectos, OtrasEscalas),
  member(escala(Ciudad, _), UnasEscalas),
  member(escala(Ciudad, _), OtrasEscalas).

/*
bandaDeTres/3: relaciona 3 vuelos si están conectados, el primero con el segundo, y el segundo con el tercero.
*/
esUnVuelo(UnVuelo):-
  vuelo(UnVuelo, _, _).

bandaDeTres(VueloA, VueloB, VueloC):-
  esUnVuelo(VueloA), esUnVuelo(VueloB), esUnVuelo(VueloC),
  conectados(VueloA, VueloB),
  conectados(VueloB, VueloC),
  VueloA \= VueloB, VueloB \= VueloC, VueloA \= VueloC.

/*
distanciaEnEscalas/3: relaciona dos ciudades que son escalas del mismo vuelo y la cantidad de escalas entre las mismas; si no hay escalas intermedias la distancia es 1. No importa de qué vuelo, lo que tiene que pasar es que haya algún vuelo que tenga como escalas a ambas ciudades. Por ejemplo:
  -> París y Berlín están a distancia 1 (por el vuelo BLE849)
  -> Berlín y Seúl están a distancia 3 (por el mismo vuelo).
*/

/*        1                     2                   3                 4                 5
[escala(nuevaYork,0), escala(washington,2), escala(ottawa,3), escala(londres,4), escala(paris,0)]
*/

distanciaEnEscalas(CiudadUno, CiudadDos, CantidadEscalasIntermedias):-
  vuelo(_, _, ListaDeTrayectoria),
  escalasDeUnVuelo(ListaDeTrayectoria, ListaDeEscalas),
  member(escala(CiudadUno, _), ListaDeEscalas),
  member(escala(CiudadDos, _), ListaDeEscalas),
  calcularDesplazamiento(CantidadEscalasIntermedias, ListaDeEscalas, CiudadUno, CiudadDos),
  CiudadUno \= CiudadDos.

calcularDesplazamiento(Desplazamiento, ListaDeEscalas, CiudadUno, CiudadDos):-
  nth1(IndiceA, ListaDeEscalas, escala(CiudadUno, _)),
  nth1(IndiceB, ListaDeEscalas, escala(CiudadDos, _)),
  Desplazamiento is abs(IndiceA - IndiceB).

/*
vueloLento/1: Un vuelo es lento si no es largo, y además cada escala es aburrida.
*/
vueloLento(CodigoVuelo):-
  vuelo(CodigoVuelo, _, ListaDeTrayectos),
  not(vueloLargo(CodigoVuelo)),
  escalasDeUnVuelo(ListaDeTrayectos, ListaDeEscalas),
  forall(member(UnaEscala, ListaDeEscalas), escalaAburrida(CodigoVuelo, UnaEscala)).

/*
escalaAburrida(CodigoVuelo, escala(_, DuracionEscala)):-
  duracion(UnaEscala, DuracionDeLaEscala), 
  DuracionDeLaEscala > 3.
*/