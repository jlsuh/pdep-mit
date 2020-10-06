% rata(Nombre, DondeViven).
rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

% cocina(Nombre, Plato, ExperienciaPreparandoPlato).
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5). 
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

% cocina(joel, saludable, 10).
% trabajaEn(restauranteJoeleano, joel).

% trabajaEn(Restaurante, Nombre).
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

/* ---------- 1 ---------- */
restaurante(UnRestaurante):-
  trabajaEn(UnRestaurante, _).

inspeccionSatisfactoria(UnRestaurante):-
  restaurante(UnRestaurante),
  not(rata(_,UnRestaurante)).

/* ---------- 2 ---------- */
chef(Empleado, Restaurante):-
  trabajaEn(Restaurante, Empleado),
  cocina(Empleado, _, _).

/* ---------- 3 ---------- */
chefcito(Rata):-
  rata(Rata, Restaurante),
  trabajaEn(Restaurante, linguini).

/* ---------- 4 ---------- */
cocinaBien(remy, _).
cocinaBien(Persona, Plato):-
  cocina(Persona, Plato, ExperienciaPreparandoPlato),
  ExperienciaPreparandoPlato > 7.

/* ---------- 5 ---------- */
posibleEncargado(Encargado, Plato, Restaurante, Experiencia):-
  trabajaEn(Restaurante, Encargado),
  cocina(Encargado, Plato, Experiencia).

encargadoDe(Encargado, Plato, Restaurante):-
  posibleEncargado(Encargado, Plato, Restaurante, Experiencia),
  forall(posibleEncargado(_, Plato, Restaurante, OtraExperiencia),
          Experiencia >= OtraExperiencia
        ).

/* ---------- 6 ---------- */
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

% plato(saludable, entrada([zanahoria])).

saludable(NombrePlato):-
  plato(NombrePlato, postre(_)),
  grupo(NombrePlato).
saludable(NombrePlato):-
  plato(NombrePlato, Tipo),
  calorias(Tipo, Calorias),
  Calorias < 75.

calorias(entrada(ListaIngredientes), Calorias):-
  length(ListaIngredientes, CantidadIngredientes),
  Calorias is CantidadIngredientes * 15.
calorias(principal(Guarnicion, Minutos), Calorias):-
  caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
  Calorias is 5 * Minutos + CaloriasGuarnicion.
calorias(postre(Calorias), Calorias).

caloriasGuarnicion(papasFritas, 50).
caloriasGuarnicion(pure, 20).
caloriasGuarnicion(ensalada, 0).

grupo(chocotorta).
grupo(mousseDeDulceDeLeche).
grupo(frutillasConCrema). % <- para el ejemplo

/* ---------- 7 ---------- */
criticaPositiva(Restaurante, UnCritico):-
  restaurante(Restaurante),
  reseniaPositiva(UnCritico, Restaurante).

reseniaPositiva(antonEgo, Restaurante):-
  especialista(Restaurante, ratatouille).
reseniaPositiva(christophe, Restaurante):-
  trabajaEn(Restaurante, _),
  findall(Chef, chef(Chef, Restaurante), ListaChefs),
  length(ListaChefs, CantidadChefs),
  CantidadChefs > 3.
reseniaPositiva(cormillot, Restaurante):-
  chef(Chef, Restaurante),
  forall(cocina(Chef, Plato, _), saludable(Plato)),
  forall((cocina(Chef, Entrada, _), plato(Entrada, entrada(ListaIngredientes))),
          member(zanahoria, ListaIngredientes)
        ).

especialista(Restaurante, UnPlato):-
  restaurante(Restaurante),
  forall(chef(Chef, Restaurante), cocinaBien(Chef, UnPlato)).