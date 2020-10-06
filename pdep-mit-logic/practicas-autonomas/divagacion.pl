costo(villavicencio, 2).
costo(cocacola, 4).
costo(trapiche, 50).
costo(malbec, 100).

esAgua(villavicencio).

esAlcoholica(trapiche).
esAlcoholica(malbec).

esNacional(trapiche).

esImportada(malbec).

esGaseosa(cocacola).

esParticular(luisa).

esComerciante(juanita).

recargo(UnRecargo, CostoBebida, UnPorcentaje):-
  UnRecargo is CostoBebida * UnPorcentaje.

precioTotal(UnPrecio, UnaBebida, UnPorcentaje):-
  costo(UnaBebida, CostoBebida),
  recargo(UnRecargo, CostoBebida, UnPorcentaje),
  UnPrecio is CostoBebida + UnRecargo.

calcularPrecio(UnCliente, UnaBebida, UnPrecio):-
  esParticular(UnCliente),
  precioParticulares(UnaBebida, UnPrecio).
calcularPrecio(UnCliente, UnaBebida, UnPrecio):-
  esComerciante(UnCliente),
  precioComerciantes(UnaBebida, UnPrecio).

precioComerciantes(UnaBebida, UnPrecio):-
  esAgua(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.25).
precioComerciantes(UnaBebida, UnPrecio):-
  esAlcoholica(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.30).
precioComerciantes(UnaBebida, UnPrecio):-
  esGaseosa(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0).

precioParticulares(UnaBebida, UnPrecio):-
  esAgua(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.30).
precioParticulares(UnaBebida, UnPrecio):-
  esGaseosa(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.40).
precioParticulares(UnaBebida, UnPrecio):-
  esAlcoholica(UnaBebida),
  esNacional(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.60).
precioParticulares(UnaBebida, UnPrecio):-
  esAlcoholica(UnaBebida),
  esImportada(UnaBebida),
  precioTotal(UnPrecio, UnaBebida, 0.70).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tipoDeAplicacion(CantidadParametros, ParametrosAplicados, parcial):-
  between(1, CantidadParametros, ParametrosAplicados),
  ParametrosAplicados < CantidadParametros.
tipoDeAplicacion(CantidadParametros, ParametrosAplicados, total):-
  CantidadParametros is ParametrosAplicados.
tipoDeAplicacion(_, ParametrosAplicados, sinAplicar):-
  ParametrosAplicados is 0.