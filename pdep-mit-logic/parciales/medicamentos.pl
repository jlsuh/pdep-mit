vende(laGondoriana, trancosin, 35).
vende(laGondoriana, sanaSam, 35).

/* incluye(Producto,Droga).
Indica la composición de cada medicamento; hay medicamentos que incluyen más de una droga.*/
incluye(trancosin, athelas).
incluye(trancosin, cenizaBoromireana).

/*efecto(Droga,Efecto) cada droga puede servir para curar una o varias enfermedades,
pero también puede potenciar otras enfermedades; por lo tanto el efecto va a ser
un functor cura/1 o potencia/1.*/
efecto(athelas, cura(desazon)).
efecto(athelas, cura(heridaDeOrco)).
efecto(cenizaBoromireana, cura(gripeA)).
efecto(cenizaBoromireana, potencia(deseoDePoder)).

estaEnfermo(eomer, heridaDeOrco). % eomer es varon
estaEnfermo(eomer, deseoDePoder).
estaEnfermo(eomund, desazon).
estaEnfermo(eowyn, heridaDeOrco). % eowyn es mujer

padre(eomund, eomer).

actividad(eomer, fecha(15,6,3014), compro(trancosin, laGondoriana)).
actividad(eomer, fecha(15,8,3014), preguntoPor(sanaSam, laGondoriana)).
actividad(eowyn, fecha(14,9,3014), preguntoPor(sanaSam, laGondoriana)).

/* ---------- 1 ---------- */
medicamentoUtil(Persona, Medicamento):-
  curaAlgunaEnfermedad(Persona, Medicamento),
  noPotenciaNingunaEnfermedad(Persona, Medicamento).
  % forall((estaEnfermo(Persona, OtraEnfermedad), incluye(Medicamento, OtraDroga)),
  %         not(efecto(OtraDroga, potencia(OtraEnfermedad)))
  %         ).

curaAlgunaEnfermedad(Persona, Medicamento):-
  estaEnfermo(Persona, Enfermedad),
  incluye(Medicamento, Droga),
  efecto(Droga, cura(Enfermedad)).

noPotenciaNingunaEnfermedad(Persona, Medicamento):-
  forall((estaEnfermo(Persona, Enfermedad), incluye(Medicamento, Droga)),
          not(efecto(Droga, potencia(Enfermedad)))
          ).

/* ---------- 2 ---------- */
persona(Persona):-
  estaEnfermo(Persona, _).

medicamentoMilagroso(Persona, Medicamento):-
  persona(Persona),
  incluye(Medicamento, Droga),
  forall(estaEnfermo(Persona, Enfermedad), efecto(Droga, cura(Enfermedad))),
  noPotenciaNingunaEnfermedad(Persona, Medicamento).

/* ---------- 3 ---------- */
drogaSimpatica(Droga):-
  incluye(Medicamento, Droga),
  findall(Enfermedad, efecto(Droga, cura(Enfermedad)), ListaEnfermedades),
  length(ListaEnfermedades, CantidadEnfermedades),
  persona(Persona),
  noPotenciaNingunaEnfermedad(Persona, Medicamento),
  CantidadEnfermedades >= 4.
drogaSimpatica(Droga):-
/* - Eomer - */
  incluye(_, Droga),
  estaEnfermo(eomer, UnaEnfermedadEomer),
  efecto(Droga, cura(UnaEnfermedadEomer)),
/* - Eowyn - */
  estaEnfermo(_, OtraEnfermedad),
  estaEnfermo(eowyn, UnaEnfermedadEowyn),
  efecto(Droga, cura(OtraEnfermedad)),
  OtraEnfermedad \= UnaEnfermedadEowyn.
drogaSimpatica(Droga):-
  incluye(Medicamento, Droga),
  vende(_, Medicamento, _),
  not((vende(_, Medicamento, PrecioMedicamento), PrecioMedicamento > 10)).

/* ---------- 4 ---------- */
tipoSuicida(Persona):-
  actividad(Persona, _, compro(Medicamento, _)),
  not(curaAlgunaEnfermedad(Persona, Medicamento)),
  incluye(Medicamento, Droga),
  estaEnfermo(Persona, Enfermedad),
  efecto(Droga, potencia(Enfermedad)).

/* ---------- 5 ---------- */
farmacia(Farmacia):-
  vende(Farmacia,_,_).

tipoAhorrativo(Persona):-
  actividad(Persona,_,compro(_,_)),
  forall(medicamentoQueCompro(Persona, Medicamento), (comproEnUnaYPreguntoEnOtra(Medicamento, Precio, OtroPrecio), Precio < OtroPrecio)).

medicamentoQueCompro(Persona, Medicamento):-
  actividad(Persona,_,compro(Medicamento, _)).

comproEnUnaYPreguntoEnOtra(Medicamento, Precio, OtroPrecio):-
  vende(Farmacia, Medicamento, Precio),
  vende(OtraFarmacia, Medicamento, OtroPrecio),
  actividad(Persona,_,compro(Medicamento, Farmacia)),
  actividad(Persona,_,preguntoPor(Medicamento, OtraFarmacia)),
  Farmacia \= OtraFarmacia.

/* ---------- 6 ---------- */
/* ----- a ----- */
tipoActivoEn(Persona,Mes,Anio):-
  actividad(Persona, fecha(_,Mes,Anio), _).

/* ----- b ----- */
fecha(Fecha):-
  actividad(_, Fecha, _).

diaProductivo(Fecha):-
  fecha(Fecha),
  forall(actividad(_, Fecha, Actividad), esCompra(Actividad)).
diaProductivo(Fecha):-
  fecha(Fecha),
  persona(Persona),
  actividad(Persona, Fecha, preguntoPor(_, _)),
  forall(actividad(Persona, Fecha, preguntoPor(Medicamento, _)), medicamentoUtil(Persona, Medicamento)).

esCompra(compro(_,_)).

/* ---------- 7 ---------- */
gastoTotal(Persona, Plata):-
  persona(Persona),
  findall(Precio,
          precioDeMedicamento(Persona, Precio),
          ListaPrecios
          ),
  sum_list(ListaPrecios, Plata).

precioDeMedicamento(Persona, Precio):-
  actividad(Persona, _, compro(Medicamento, Farmacia)),
  vende(Farmacia, Medicamento, Precio).

/* ---------- 8 ---------- */
zafoDe(Persona,Enfermedad):-
  persona(Persona),
  ancestro(Ancestro, Persona),
  estaEnfermo(Ancestro, Enfermedad),
  not(estaEnfermo(Persona, Enfermedad)).

ancestro(Ancestro, Persona):-
  padre(Ancestro, Persona).
ancestro(Ancestro, Persona):-
  padre(Padre, Persona),
  ancestro(Ancestro, Padre).