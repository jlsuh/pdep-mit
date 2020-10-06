/*
Nombre: Suh, Joel
Legajo: 167231-9
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Código Inicial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% anterior(FechaAnterior, Fecha)
anterior(fecha(_, _, AnioAnterior), fecha(_, _ , Anio)):-
  AnioAnterior < Anio.
anterior(fecha(_, MesAnterior, Anio), fecha(_, Mes, Anio)):-
  MesAnterior < Mes.
anterior(fecha(DiaAnterior, Mes, Anio), fecha(Dia, Mes, Anio)):-
  DiaAnterior < Dia.

% categoriaDisfraz(Disfraz, Categoria)
categoriaDisfraz(slash, musica).
categoriaDisfraz(madonna, musica).
categoriaDisfraz(madonna, sexy).
categoriaDisfraz(sailorMoon, anime).
categoriaDisfraz(hulk, cine).
categoriaDisfraz(hulk, superheroes).
categoriaDisfraz(samara, cine).
categoriaDisfraz(samara, terror).
categoriaDisfraz(elefanteRosado, llamativo).

% eligioDisfraz(Fiesta, Persona, DisfrazElegido)
% Persona: alguien que asistió a la fiesta
eligioDisfraz(cumpleLuli2042, jochirock, slash).
eligioDisfraz(cumpleLuli2042, jacinta2020, sailorMoon).
eligioDisfraz(jochiween42, jochirock, madonna).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Punto 1

%% Implementar aquí...

fiesta(cumpleLuli2042, fecha(27,8,2042), luli47, cumpleanios(hulk, 13)).
fiesta(jochiween42, fecha(1,11,2042), jochirock, halloween).

/* ---------- 1 ---------- */
esDisfraz(UnDisfraz):-
  categoriaDisfraz(UnDisfraz, _).

esPersona(UnaPersona):-
  eligioDisfraz(_, UnaPersona, _).

podriaInteresarle(UnaPersona, UnDisfraz):-
  esDisfraz(UnDisfraz),
  esPersona(UnaPersona),
  forall(
    eligioDisfraz(_, UnaPersona, OtroDisfraz),
    UnDisfraz \= OtroDisfraz
  ),
  eligioDisfraz(_, UnaPersona, DisfrazElegido),
  esSimilar(UnDisfraz, DisfrazElegido).

esSimilar(UnDisfraz, OtroDisfraz):-
  categoriaDisfraz(UnDisfraz, Categoria),
  categoriaDisfraz(OtroDisfraz, Categoria).

/* ---------- 2 ---------- */
esFiesta(UnaFiesta):-
  fiesta(UnaFiesta, _, _, _).

estaDeModa(UnDisfraz, UnAnio):-
  fueMuyUsado(UnDisfraz, UnAnio),
  not(fueMuyUsado(UnDisfraz, UnAnio - 1)).

fueMuyUsado(UnDisfraz, UnAnio):-
  esFiesta(UnaFiesta),
  forall(
    fiesta(UnaFiesta, fecha(_, _, UnAnio), _, _),
    eligioDisfraz(UnaFiesta, _, UnDisfraz)
  ).

/* ---------- 3 ---------- */
esApropiado(UnDisfraz, halloween):-
  categoriaDisfraz(UnDisfraz, CategoriaDisfraz),
  categoriasApropiadasParaFiestasHalloween(CategoriaDisfraz).
esApropiado(UnDisfraz, cumpleanios(DisfrazCumpleaniero, AniosCumple)):-
  esDisfraz(UnDisfraz),
  esDisfraz(DisfrazCumpleaniero),
  not(opacaElDisfraz(UnDisfraz, DisfrazCumpleaniero)),
  esAdecuado(UnDisfraz, AniosCumple).

categoriasApropiadasParaFiestasHalloween(terror).
categoriasApropiadasParaFiestasHalloween(sexy).

opacaElDisfraz(UnDisfraz, OtroDisfraz):-
  categoriaDisfraz(UnDisfraz, sexy),
  not(categoriaDisfraz(OtroDisfraz, sexy)).
opacaElDisfraz(UnDisfraz, OtroDisfraz):-
  categoriaDisfraz(UnDisfraz, llamativo),
  categoriaDisfraz(OtroDisfraz, _).

esAdecuado(UnDisfraz, Anios):-
  not(categoriaDisfraz(UnDisfraz, sexy)),
  menorEdad(Anios).
esAdecuado(UnDisfraz, Anios):-
  categoriaDisfraz(UnDisfraz, _),
  not(menorEdad(Anios)).

menorEdad(Anios):-
  Anios < 18.

/* ---------- 4 ---------- */
seLePuedeSugerir(UnDisfraz, UnaPersona, UnaFiesta):-
  esDisfraz(UnDisfraz),
  not(eligioDisfraz(_, UnaPersona, UnDisfraz)),
  fiesta(UnaFiesta, _, _, TipoFiesta),
  podriaInteresarle(UnaPersona, UnDisfraz),
  esApropiado(UnDisfraz, TipoFiesta).
seLePuedeSugerir(UnDisfraz, UnaPersona, UnaFiesta):-
  esDisfraz(UnDisfraz),
  not(eligioDisfraz(_, UnaPersona, UnDisfraz)),
  fiesta(UnaFiesta, fecha(_, _, AnioFiesta), _, TipoFiesta),
  estaDeModa(UnDisfraz, AnioFiesta),
  esApropiado(UnDisfraz, TipoFiesta).

/* ---------- 5 ---------- */
cuantosAsistieron(UnaFiesta, CantidadQueAsistieron):-
  esFiesta(UnaFiesta),
  findall(
    Persona,
    distinct(Persona, (eligioDisfraz(UnaFiesta, Persona, UnDisfraz), categoriaDisfraz(UnDisfraz, _))),
    ListaAsistidos
  ),
  length(ListaAsistidos, CantidadQueAsistieron).

/* ---------- 6 ---------- */
fueExitosa(UnaFiesta):-
  fiesta(UnaFiesta, _, _, TipoFiesta),
  forall(
    eligioDisfraz(UnaFiesta, _, UnDisfraz),
    esApropiado(UnDisfraz, TipoFiesta)
  ),
  huboBuenNumeroAsistentes(UnaFiesta).

/* En caso de primer fiesta */
huboBuenNumeroAsistentes(UnaFiesta):-
  fiesta(UnaFiesta, _, Organizador, _),
  primeraFiesta(UnaFiesta, Organizador),
  cuantosAsistieron(UnaFiesta, CantidadQueAsistieronEnPrimerFiesta),
  CantidadQueAsistieronEnPrimerFiesta >= 10.
/* Resto de casos en que no sea primer fiesta */
huboBuenNumeroAsistentes(UnaFiesta):-
  fiesta(UnaFiesta, FechaTemprana, UnOrganizador, _),
  fiesta(FiestaPrevia, FechaTardia, UnOrganizador, _),
  anterior(FechaTemprana, FechaTardia),
  primeraFiesta(PrimeraFiesta, UnOrganizador),
  seLlevanDeDiferenciaEnAsistidos(UnaFiesta, FiestaPrevia, 3),
  UnaFiesta \= PrimeraFiesta,
  FiestaPrevia \= PrimeraFiesta.

seLlevanDeDiferenciaEnAsistidos(UnaFiesta, OtraFiesta, Diferencia):-
  cuantosAsistieron(UnaFiesta, CantidadAsistidos),
  cuantosAsistieron(OtraFiesta, OtraCantidadAsistidos),
  CantidadAsistidos is OtraCantidadAsistidos + Diferencia.

primeraFiesta(PrimeraFiesta, UnOrganizador):-
  fiesta(PrimeraFiesta, FechaTardia, UnOrganizador, _),
  forall(
    (fiesta(OtraFiesta, FechaTemprana, UnOrganizador, _), PrimeraFiesta \= OtraFiesta),
    anterior(FechaTardia, FechaTemprana)
  ).

/* ---------- 7 ---------- */
/*
Para incorporar un tipo de fiesta distinto a las actuales, tenemos que tener en cuenta que al agregar un nuevo hecho de la siguiente forma:
fiesta(noFerpaNoParty, fecha(23,12,2042), ferPalacios, electronica).

se deberá también especificar cuándo se considera que un disfraz, para una fiesta electrónica, se considera apropiado:
esApropiado(Disfraz, electronica):-
  categoriaDisfraz(Disfraz, categoriaDisfraz),
  categoriasApropiadasParaFiestasElectronicas(categoriaDisfraz).

debido al acoplamiento entre esApropiado/2 y categoriasApropiadasParaFiestasElectronicas/1, se deben definir, polimórficamente, cuándo
una categoría se considera apropiada para una fiesta electrónica:
categoriasApropiadasParaFiestasElectronicas(llamativo).
categoriasApropiadasParaFiestasElectronicas(sexy).

de esta forma resulta efectiva a la hora de considerar un nuevo tipo de disfraz para una fiesta electrónica:
categoriasApropiadasParaFiestasElectronicas(hipster).

debido a que esApropiado/2 está acoplado a categoriaDisfraz/2, se tendrá que agregar un nuevo hecho a nuestra base de conocimiento ilustrado
de la siguiente forma:
categoriaDisfraz(andyWarhol, hipster).

pues de lo contrario no se verificaría nunca para el caso en que alguien vaya vestido a una fiesta electrónica de andyWarhol.
*/

/* Fin */