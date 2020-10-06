/* ---------- 1 ---------- */
frecuenta(Agente, Lugar):-
  tarea(Agente, _, Lugar).
frecuenta(_, buenosAires).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):-
  tarea(Agente, vigilar(ListaDeNegocios), _),
  member(negocioAlfajores, ListaDeNegocios).

/* ---------- 2 ---------- */
lugarInaccesible(Lugar):-
  ubicacion(Lugar),
  not(frecuenta(_, Lugar)).

/* ---------- 3 ---------- */
afincado(Agente):-
  tarea(Agente, _, UnaUbicacion),
  forall(tarea(Agente, _, OtraUbicacion), mismaUbicacion(UnaUbicacion, OtraUbicacion)).

mismaUbicacion(Ubicacion, Ubicacion).

/* ---------- 4 ---------- */
cadenaDeMando([Primero, Segundo]):-
  jefe(Primero, Segundo).
cadenaDeMando([Primero, Segundo | Resto]):-
  jefe(Primero, Segundo),
  cadenaDeMando([Segundo | Resto]).

/* ---------- 5 ---------- */
agente(Agente):-
  tarea(Agente,_,_).

agentePremiado(AgenteConMejorPuntuacion):-
  puntosDelAgente(AgenteConMejorPuntuacion, MejoresPuntos),
  forall((puntosDelAgente(OtroAgente, OtroPunto), AgenteConMejorPuntuacion \= OtroAgente),
          MejoresPuntos > OtroPunto).

puntosDelAgente(Agente, PuntosTotales):-
  agente(Agente),
  findall(Punto,
          (tarea(Agente, Tarea, _), puntoDeLaTarea(Tarea, Punto)),
          PuntosDelAgente
          ),
  sum_list(PuntosDelAgente, PuntosTotales).

puntoDeLaTarea(vigilar(Negocios), Punto):-
  length(Negocios, CantidadNegocios),
  Punto is 5 * CantidadNegocios.
puntoDeLaTarea(ingerir(_, Tamanio, Cantidad), Punto):-
  Unidad is Tamanio * Cantidad,
  Punto is (-10) * Unidad.
puntoDeLaTarea(apresar(_, Recompensa), Punto):-
  Punto is Recompensa / 2.
puntoDeLaTarea(asuntosInternos(AgenteQueInvestiga), Punto):-
  puntosDelAgente(AgenteQueInvestiga, PuntosDelQueInvestiga),
  Punto is 2 * PuntosDelQueInvestiga.

/* ---------- 6 ---------- */
/*
Se ha aplicado polimorfismo en el predicado puntoDeLaTarea/2, en el cual, dependiendo de qué tipo de
tarea se trate, hace el cálculo para la misma.
El polimorfismo sobre los predicados, nos permite evitar la repetición de lógica, aplicando el concepto de
que cualquier individuo, sea compuesto o simple, es visto bajo la mira de una cosa que la engloba a mayor nivel,
a la vez que se aprovecha el concepto de pattern matching, para definir cuándo queremos que la consulta se
satisfaga mediante patrones.

Se ha aplicado orden superior en puntosDelAgente/2 mediante el uso del findall/3, específicamente
en el segundo argumento. El findall/3, es un predicado de orden superior por naturaleza;
agentePremiado/1 y afincado/1 utiliza también un predicado de orden superior por naturaleza,
siendo el caso del forall/2.
El predicado lugarInaccesible/1 utiliza el predicado de orden superior not/1, en el cual su único
argumento es frecuenta/2, no siendo la misma de orden superior.
Se hace la aclaración de que un predicado de orden superior, es aquel predicado en el cual tiene como
argumento a otro predicado, sea o no este último de orden superior.

Las cláusulas utilizadas para definir la base de conocimiento -tarea/3, ubicacion/1 y jefe/2 son inversibles,
pues son hechos que definen a mi base de conocimiento.
Se ha optado que el predicado puntosDelAgente/2 sea inversible, pues de lo contrario implicaría la
generaciónd de Variables, en este caso el AgenteConMejorPuntuación previo a la llegada del forall/2,
y OtroAgente, que de no ser inversible puntosDelAgente/2, no se podía garantizar que la OtroAgente sea
un agente.
*/

/* ---------- 7 ---------- */
%tarea(agente, tarea, ubicacion)
%tareas:
% ingerir(descripcion, tamaño, cantidad)
% apresar(malviviente, recompensa)
% asuntosInternos(agenteInvestigado)
% vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),                       laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]),               barracas).
tarea(canaBoton,          asuntosInternos(vigilanteDelBarrio),          barracas).
tarea(sargentoGarcia,     vigilar([pulperia, haciendaDeLaVega, plaza]), puebloDeLosAngeles).
tarea(sargentoGarcia,     ingerir(vino, 0.5, 5),                        puebloDeLosAngeles).
tarea(sargentoGarcia,     apresar(elzorro, 100),                        puebloDeLosAngeles). 
tarea(vega,               apresar(neneCarrizo,50),                      avellaneda).
tarea(jefeSupremo,        vigilar([congreso,casaRosada,tribunales]),    laBoca).

/* ----- Agregado ----- */
tarea(joel,               vigilar(canaBoton),                           utn).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

/* ----- Agregado ----- */
ubicacion(utn).

% jefe(jefe, subordinado)
jefe(jefeSupremo, vega).
jefe(vega,        vigilanteDelBarrio).
jefe(vega,        canaBoton).
jefe(jefeSupremo, sargentoGarcia).

/* ----- Agregado ----- */
jefe(joel, joel).