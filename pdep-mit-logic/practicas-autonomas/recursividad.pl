padre(tatara, bisa).
padre(bisa, abu).
padre(abu, padre).
padre(padre, hijo).

ancestro(Padre, Persona):-
  padre(Padre, Persona).
ancestro(Ancestro, Persona):-
    padre(Padre, Persona),
    ancestro(Ancestro, Padre).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% distancia(Oriden, Destino, DistanciaEnKilometros).
distancia(buenosAires, puertoMadryn, 1300).
distancia(puertoMadryn, puertoDeseado, 732).
distancia(puertoDeseado, rioGallegos, 736).
distancia(puertoDeseado, calafate, 979).
distancia(rioGallegos, calafate, 304).
distancia(calafate, chalten, 213).

kilometrosDeViaje(Origen, Destino, Kilometros):-
  distancia(Origen, Destino, Kilometros).
kilometrosDeViaje(Origen, Destino, Kilometros):-
  distancia(Origen, Intermedio, KilometroIntermedio),
  kilometrosDeViaje(Intermedio, Destino, UnKilometraje),
  Kilometros is KilometroIntermedio + UnKilometraje.

/*
Suponiendo que desde el origen hasta el destino hay 3 saltos (osea 2 intermedios)
Ejemplo concreto: Buenos Aires a Río Gallegos.
Buenos Aires, Puerto Madryn
Puerto Madryn, Puerto Deseado
Puerto Deseado, Río Gallegos

kilometrosDeViaje(Origen, Destino, Kilometros):-
  distancia(Origen, Intermedio, KilometroIntermedio0),
  kilometrosDeViaje(Origen, Destino, UnKilometraje0):-
    distancia(Origen, Intermedio, KilometroIntermedio1),
      kilometrosDeViaje(Intermedio, Destino, UnKilometraje1),
    UnKilometraje0 is KilometroIntermedio1 + UnKilometraje1.
  Kilometros is KilometroIntermedio0 + UnKilometraje0.
    * En donde UnKilometraje0 es KilometroIntermedio1 + UnKilometraje1
    * Y queda: Kilometros is KilometroIntermedio0 + (KilometroIntermedio1 + UnKilometraje1).
*/

/*
Para poder garantizar que se pueda ir tanto de Buenos Aires a Río Gallegos, como de Río Gallegos
a Buenos Aires.
*/
totalKilometros(Origen, Destino, Kilometros):-
  kilometrosDeViaje(Origen, Destino, Kilometros).
totalKilometros(Origen, Destino, Kilometros):-
  kilometrosDeViaje(Destino, Origen, Kilometros).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enesimo(1, [Elemento|_], Elemento).
enesimo(Posicion, [_|Resto], Elemento):-
	enesimo(PosicionCola, Resto, Elemento),
	Posicion is PosicionCola + 1.

/*
enesimo(1, [Elemento|_], Elemento).
enesimo(Posicion, [_|Resto], Elemento):-
	enesimo(PosicionCola, Resto, Elemento),
	Posicion is PosicionCola + 1.

enesimo(Posicion, [1,2,4,3,5], 4).

enesimo(Posicion, [_ | 2,4,3,5], 4):-
	enesimo(PosicionCola, [2,4,3,5], 4),
	Posicion is PosicionCola + 1.

enesimo(PosicionCola, [2,4,3,5], 4):-
  enesimo(PosicionCola, [_ | 4,3,5], 4),
	Posicion is PosicionCola + 1.

% Hasta que llega al patrón en el que el elemento se encuentra en la Cabeza de la lista
y le adjudica a PosicionCola como 1:
enesimo(1, [4 | _], 4).

Luego, como se ha llegado a la base, comienza a subir de nuevo hacia arriba:

%%%%% ALTURA MÁXIMA ndeah %%%%%
enesimo(3, [1,2,4,3,5], 4).                 (5)

enesimo((1 + 1) + 1, [1,2,4,3,5], 4).       (4)

enesimo(Posicion, [_ | 2,4,3,5], 4):-
	enesimo(PosicionCola, [2,4,3,5], 4),
	Posicion is (1 + 1) + 1.                  (3)

enesimo(PosicionCola, [2,4,3,5], 4):-
  enesimo(PosicionCola, [_ | 4,3,5], 4),
	Posicion is 1 + 1.                        (2)

enesimo(1, [4 | _], 4).                     (1)
%%%%% COMENZANDO DE ACÁ ^ Y DESPEGA PARRIBA %%%%%

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
