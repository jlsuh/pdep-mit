%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchichas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).

compro(joel, salchichas(vienisima, 12), 2).
compro(joel, salchichas(granjaDelSol, 12), 2).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

/* ---------- 1 ---------- */
descuento(arroz(gallo), 1.50).
descuento(salchichas(Marca, Unidades), 1.50):-
  precioUnitario(salchichas(Marca, Unidades), _),
  Marca \= vienisima.
descuento(lacteo(Marca, leche), 2):-
  precioUnitario(lacteo(Marca, _), _).
descuento(lacteo(Marca, queso(TipoDeQueso)), 2):-
  precioUnitario(lacteo(Marca, queso(TipoDeQueso)), _),
  primeraMarca(Marca).
descuento(Producto, Descuento):-
  precioUnitario(Producto, PrecioUnitario),
  forall(
      (precioUnitario(OtroProducto, OtroPrecioUnitario), Producto \= OtroProducto),
      PrecioUnitario > OtroPrecioUnitario
    ),
  Descuento is 0.05 * PrecioUnitario.

/* ---------- 2 ---------- */
esCompulsivo(UnCliente):-
  compro(UnCliente, _, _),
  forall(
    (descuento(Producto, _), marca(Producto, Marca), primeraMarca(Marca)),
    compro(UnCliente, Producto, _)
  ).

marca(arroz(Marca), Marca).
marca(lacteo(Marca,_), Marca).
marca(salchichas(Marca,_), Marca).

/* ---------- 3 ---------- */
totalAPagar(Cliente, TotalDeCompra):-
  compro(Cliente, _, _),
  findall(
      Cantidad * PrecioUnitario - Descuento,
      (compro(Cliente, Producto, Cantidad), precioUnitario(Producto, PrecioUnitario), descuento(Producto, Descuento)),
      PreciosConDescuentos
    ),
  sum_list(PreciosConDescuentos, TotalDeCompra).

/* ---------- 4 ---------- */
clienteFiel(Cliente, Marca):-
  compro(Cliente, _, _),
  precioUnitario(Producto, _),
  marca(Producto, Marca),
  precioUnitario(OtroProducto, _),
  marca(OtroProducto, OtraMarca),
  mismoTipoProducto(Producto, OtroProducto),
  not(compro(Cliente, OtroProducto, _)),
  Marca \= OtraMarca.

mismoTipoProducto(arroz(_), arroz(_)).
mismoTipoProducto(lacteo(_, lecha), lacteo(_, lecha)).
mismoTipoProducto(lacteo(_, crema), lacteo(_, crema)).
mismoTipoProducto(lacteo(_, queso(Tipo)), lacteo(_, queso(Tipo))).
mismoTipoProducto(salchichas(_, Cantidad), salchichas(_, Cantidad)).

% forall(
  %   (precioUnitario(OtroProducto, _), marca(OtroProducto, OtraMarca), Marca \= OtraMarca),
  %   not(compro(Cliente, OtroProducto, _))
  % ).

/* ---------- 5 ---------- */
% Se agrega el predicado dueño que relaciona dos marcas siendo que la primera es dueña de la otra.
duenio(laSerenisima, gandara).
duenio(gandara, vacalin).

provee(Empresa, ListadoDeCosasQueProvee):-
  duenio(Empresa, _),
  findall(
    Producto,
    (precioUnitario(Producto, _), marca(Producto, Empresa)),
    ListadoDeCosasQueProvee
  ).
provee(Empresa, ListadoDeCosasQueProvee):-
  aCargo(OtraEmpresa, Empresa),
  findall(
    Producto,
    (precioUnitario(Producto, _), marca(Producto, OtraEmpresa)),
    ListadoDeCosasQueProvee
  ).

aCargo(OtraEmpresa, UnaEmpresa):-
  duenio(UnaEmpresa, OtraEmpresa).
aCargo(OtraEmpresa, UnaEmpresa):-
  duenio(UnaEmpresa, EmpresaIntermediaria),
  aCargo(OtraEmpresa, EmpresaIntermediaria).