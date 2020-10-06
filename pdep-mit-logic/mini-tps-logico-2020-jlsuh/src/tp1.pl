% No cambies esta declaración del módulo tp1, ya que podría traer
% problemas para correr las pruebas del proyecto.
:- module(tp1, [leGusta/2, puedePedir/2]).

% ---------------------------------------------------------------------------- %

precio(asado,550).
precio(lomitoDeLaCasa,450).
precio(hamburguesa,350).
precio(papasFritas,220).
precio(ensalada,190).
precio(pizzetas, 250).
precio(polloALaPlancha, 320).
precio(tostadoVeggie, 150).

tieneCarne(asado).
tieneCarne(hamburguesa).
tieneCarne(lomitoDeLaCasa).
tieneCarne(polloALaPlancha).

% Cambiar la implementación para el predicado leGusta/2 de modo que relacione a una persona con una comida (en ese orden).

leGusta(juan, asado).
leGusta(juan, tostadoVeggie).
leGusta(gabriel, asado).
leGusta(gabriel, Comida):-
  precio(Comida, Precio),
  Precio < 300.
leGusta(soledad, Comida):-
  leGusta(gabriel, Comida),
  not(leGusta(juan, Comida)).
leGusta(tomas, Comida):-
  tieneCarne(Comida).
leGusta(celeste, Comida):-
  precio(Comida, _).
/* por universo cerrado no se ha aclarado que a caro no le gusta ninguna comida que ofrezca el bar. */

% Cambiar la implementación para el predicado puedePedir/2 de modo que relacione a una persona con una comida (en ese orden).

dispuestoAGastar(juan, UnaComida):-
  precio(UnaComida, UnPrecio),
  UnPrecio =< 500.
dispuestoAGastar(celeste, UnaComida):-
  precio(UnaComida, UnPrecio),
  UnPrecio =< 400.
dispuestoAGastar(tomas, UnaComida):-
  precio(UnaComida, UnPrecio),
  precio(hamburguesa, PrecioHamburguesa),
  UnPrecio =< PrecioHamburguesa.
dispuestoAGastar(soledad, ComidaSoledad):-
  dispuestoAGastar(tomas, ComidaTomas),
  precio(ComidaTomas, PrecioComidaTomas),
  precio(ComidaSoledad, PrecioComidaSoledad),
  PrecioComidaSoledad =< PrecioComidaTomas * 2.
/* si bien a caro no le gusta ninguna comida que ofrece el bar, sigue teniendo un criterio de cuánto está dispuesta a pagar.
el criterio de gabriel está acoplado al criterio de carolina. el criterio de carolina no puede desaparecer. */
dispuestoAGastar(carolina, UnaComida):-
  precio(UnaComida, UnPrecio),
  precio(papasFritas, PrecioPapasFritas),
  precio(asado, PrecioAsado),
  UnPrecio =< PrecioPapasFritas + PrecioAsado.
dispuestoAGastar(gabriel, ComidaGabriel):-
  dispuestoAGastar(carolina, ComidaCarolina),
  precio(ComidaCarolina, PrecioComidaCarolina),
  precio(ComidaGabriel, PrecioComidaGabriel),
  PrecioComidaGabriel =< PrecioComidaCarolina / 2.

puedePedir(UnaPersona, UnaComida):-
  leGusta(UnaPersona, UnaComida),
  dispuestoAGastar(UnaPersona, UnaComida).

% --------------------------------
% TESTS - NO TOCAR
% --------------------------------

:- begin_tests(tests_tp1_leGusta).

test(genteALaQueLeGustaElAsado, set(Persona == [juan, gabriel, celeste, tomas])):-
        leGusta(Persona, asado).

test(gustosDeJuan, set(Comida == [asado, tostadoVeggie])):-
        leGusta(juan, Comida).

test(gustosDeGabriel, set(Comida == [asado, papasFritas, ensalada, pizzetas, tostadoVeggie])):-
        leGusta(gabriel, Comida).

test(gustosDeSoledad, set(Comida == [papasFritas, ensalada, pizzetas])):-
        leGusta(soledad, Comida).

test(gustosDeTomas, set(Comida == [asado, hamburguesa, lomitoDeLaCasa, polloALaPlancha])):-
        leGusta(tomas, Comida).

test(gustosDeCeleste, set(Comida == [asado, lomitoDeLaCasa, hamburguesa, papasFritas, ensalada, pizzetas, polloALaPlancha, tostadoVeggie])):-
        leGusta(celeste, Comida).

test(aCarolinaNoLeGustaNada, fail):-
        leGusta(carolina, _).

:- end_tests(tests_tp1_leGusta).

:- begin_tests(tests_tp1_puedePedir).

test(genteQuePuedePedirHamburguesa, set(Persona == [celeste, tomas])):-
        puedePedir(Persona, hamburguesa).

test(nadiePuedePedirAsado, fail):-
        puedePedir(_, asado).

test(aCelesteNoLeAlcanzaParaPedirElLomito, fail):-
        puedePedir(celeste, lomitoDeLaCasa).

test(aCelesteLeAlcanzaParaPedirPollo, nondet):-
        puedePedir(celeste, polloALaPlancha).

test(comidasQuePuedePedirJuan, set(Comida == [tostadoVeggie])):-
        puedePedir(juan, Comida).

test(comidasQuePuedePedirSoledad, set(Comida == [papasFritas, ensalada, pizzetas])):-
        puedePedir(soledad, Comida).

test(comidasQuePuedePedirTomas, set(Comida == [hamburguesa, polloALaPlancha])):-
        puedePedir(tomas, Comida).

test(comidasQuePuedePedirGabriel, set(Comida == [papasFritas, ensalada, pizzetas, tostadoVeggie])):-
        puedePedir(gabriel, Comida).

test(carolinaNoPuedePedirNadaPorqueNoLeGustaLoQueHay, fail):-
        puedePedir(carolina, _).

:- end_tests(tests_tp1_puedePedir).