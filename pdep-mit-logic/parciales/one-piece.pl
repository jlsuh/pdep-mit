% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% tripulante(joel, riachuelistas).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).

impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).

impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).

impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).

impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).

impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo, sabaody, 500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).

impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

/* ---------- 1 ---------- */
participaronDelMismo(UnaTripulacion, OtraTripulacion, Evento):-
  participoTripulante(UnaTripulacion, Evento),
  participoTripulante(OtraTripulacion, Evento),
  UnaTripulacion \= OtraTripulacion.

participoTripulante(UnaTripulacion, Evento):-
  tripulante(Pirata, UnaTripulacion),
  impactoEnRecompensa(Pirata, Evento, _).

/* Observaciones
1- Hubiese estado bueno tener el nombre de participaronDelMismoEvento/3
2- participoTripulante, es menos expresivo que participoDeEvento/2
*/

/* ---------- 2 ---------- */
elMasDestacado(Pirata, Evento):-
  montoCapturaPorEvento(Pirata, Evento, MontoCaptura),
  forall((montoCapturaPorEvento(OtroPirata, Evento, OtroMontoCaptura), Pirata \= OtroPirata),
          MontoCaptura > OtroMontoCaptura
          ).
  /* @ Es la forma correcta, pues para el caso límite >, hay que asegurar que no sea el mismo pirata, pues de lo contrario siempre da falso */

montoCapturaPorEvento(Pirata, Evento, MontoCaptura):-
  tripulante(Pirata, _),
  impactoEnRecompensa(Pirata, Evento, MontoCaptura).

/*
elMasDestacado(Pirata, Evento):-
  montoCapturaPorEvento(Pirata, Evento, MontoCaptura),
  forall(montoCapturaPorEvento(_, Evento, OtroMontoCaptura),
          MontoCaptura > OtroMontoCaptura
          ).
  
  @ De esta forma siempre hubiera dado falso, pues en algún punto Pirata es la variable anónima

  elMasDestacado(Pirata, Evento):-
  montoCapturaPorEvento(Pirata, Evento, MontoCaptura),
  forall(montoCapturaPorEvento(_, Evento, OtroMontoCaptura),
          MontoCaptura >= OtroMontoCaptura
          ).

  @ Esta es la forma correcta, para el caso en que la variable sea anónima
*/

/* Observaciones
1- elMasDestacado, puede ser mejor expresivo con pirataMasDestacado
2- Observaciones más arriba
*/
/* ---------- 3 ---------- */
pasoDesapercibido(Pirata, Evento):-
  tripulante(Pirata, Tripulacion),
  participoTripulante(Tripulacion, Evento),
  not(impactoEnRecompensa(Pirata, Evento, _)).

/* Correctísimo */
/* ---------- 4 ---------- */
recompensaTotal(Tripulacion, RecompensaTotal):-
  tripulante(_, Tripulacion),
  findall(Recompensa , (tripulante(Pirata, Tripulacion), recompensaActual(Pirata, Recompensa)), ListaRecompensas),
  sum_list(ListaRecompensas, RecompensaTotal).

/*Correctísimo*/
/* ---------- 5 ---------- */
recompensaActual(Pirata, RecompensaTotal):-
  tripulante(Pirata, _),
  findall(Recompensa, impactoEnRecompensa(Pirata, _, Recompensa), ListaRecompensas),
  sum_list(ListaRecompensas, RecompensaTotal).

/* Hubiese estado bueno darse cuenta desde el ejercicio 4 que se puede definir un predicado recompensaActual/2, por el modelado de dominio*/

esTemible(Tripulacion):-
  tripulante(_, Tripulacion),
  forall(tripulante(Pirata, Tripulacion), esUnPeligro(Pirata)).
esTemible(Tripulacion):-
  recompensaTotal(Tripulacion, RecompensaTotal),
  RecompensaTotal > 500000000.

esUnPeligro(Pirata):-
  recompensaActual(Pirata, RecompensaTotal),
  RecompensaTotal > 100000000.

/* ---------- 6 ---------- */
/* ----- a ----- */
esUnPeligro(Persona):-
  seComio(Persona, Fruta),
  frutaPeligrosa(Fruta).

/* Observación
-Los predicados que cumplen el papel de patrones solamente nunca son inversibles
*/
frutaPeligrosa(logia(_,_)).
frutaPeligrosa(paramecia(opeope)).
frutaPeligrosa(zoan(_,EspecieDeAnimal)):-
  esFeroz(EspecieDeAnimal).

esFeroz(lobo).
esFeroz(leopardo).
esFeroz(anaconda).

seComio(luffy, paramecia(gomugomu)).
seComio(buggy, paramecia(barabara)).
seComio(law, paramecia(opeope)).
seComio(chopper, zoan(hitohito, humano)).
seComio(lucci, zoan(nekoneko, leopardo)).
seComio(smoker, logia(mokumoku, humo)).

% seComio(Persona, NombreDeFruta, TipoDeFruta(AspectoOEfecto)).
/*
Observación:
-Está mal delegar la responsabilidad del nombre de la fruta en el predicado seComio, pues es más oportuno representarlo mediante
el functor que aclara el tipo de fruta, y delegar la responsabilidad de saber si la fruta es peligrosa o no en otro predicado, frutaPeligrosa/1.

seComio(luffy, gomugomu, paramecia(noPeligrosa)).
seComio(buggy, barabara, paramecia(noPeligrosa)).
seComio(law, opeope, paramecia(peligrosa)).
seComio(chopper, hitohito, zoan(humano)).
seComio(lucci, nekoneko, zoan(leopardo)).
seComio(smoker, mokumoku, logia(humo)).
*/

% seComio(joel, salchipapa, paramecia(peligrosa)).

/* ----- b ----- */
/*
Se optó en modelar a la base de conocimiento de quiénes comieron una fruta peligrosa, mediante
el hecho seComio/2, siendo el primer argumento la persona quien la haya consumido y el segundo argumento
modelada mediante los functores: paramecia/1, zoan/2 y logia/2, que contienen el NombreDeFruta, y respectivamente
de qué tipo sean tendrán distintos aspectos o efectos sobre el pirata.
Se ha optado en aprovechar el polimorfismo en frutaPeligrosa/1, con la simple manipulación de los functores
que modelan los tipos de frutas, especificando solamente cuándo se considera peligrosa (universo cerrado).
--->esFeroz/1 especifica cuándo se satisface la variable EspecieDeAnimal para el predicado frutaPeligrosa/1, que solamente
ocurre al momento de considerar una fruta de tipo zoan.<--- Se puede omitir, pues no es relevante su justificación
El nuevo requerimiento sobre la condición de si un pirata es peligroso o no respecto al consumo de frutas fue de
fácil definición, puesto que solamente se requirió verificar si la persona comió una fruta, y a su vez que dicha fruta
sea peligrosa.
*/

/* ---------- 7 ---------- */
piratasDeAsfalto(Tripulacion):-
  tripulante(_, Tripulacion),
  forall(tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata))).
  /*not((tripulante(Pirata, Tripulacion), puedeNadar(Pirata))).*/

puedeNadar(Pirata):-
  not(seComio(Pirata, _)).