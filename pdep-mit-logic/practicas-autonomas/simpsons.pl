padreDe(abe, abbie).
padreDe(abe, homero).
padreDe(abe, herbert).
padreDe(clancy, marge).
padreDe(clancy, patty).
padreDe(clancy, selma).
padreDe(homero, bart).
padreDe(homero, hugo).
padreDe(homero, lisa).
padreDe(homero, maggie).

madreDe(edwina, abbie).
madreDe(mona, homero).
madreDe(gaby, herbert).
madreDe(jacqueline, marge).
madreDe(jacqueline, patty).
madreDe(jacqueline, selma).
madreDe(marge, bart).
madreDe(marge, hugo).
madreDe(marge, lisa).
madreDe(marge,maggie).
madreDe(selma, ling).

tieneHijo(Predecesor):-
  padreDe(Predecesor, Hije).
tieneHijo(Predecesor):-
  madreDe(Predecesor, Hije).

compartenPadre(UnPersonaje, OtroPersonaje):-
  padreDe(Padre, UnPersonaje),
  padreDe(Padre, OtroPersonaje),
  UnPersonaje \= OtroPersonaje.
compartenMadre(UnPersonaje, OtroPersonaje):-
  madreDe(Madre, UnPersonaje),
  madreDe(Madre, OtroPersonaje),
  UnPersonaje \= OtroPersonaje.

hermanos(Hermano1, Hermano2):-
  compartenPadre(Hermano1, Hermano2),
  compartenMadre(Hermano1, Hermano2).

medioHermano(Hermano1, Hermano2):-
  compartenPadre(Hermano1, Hermano2).
medioHermano(Hermano1, Hermano2):-
  compartenMadre(Hermano1, Hermano2).

tioDe(Personaje, Sobrino):-
  hermanos(Personaje, Padre),
  padreDe(Padre, Sobrino).
tioDe(Personaje, Sobrino):-
  hermanos(Personaje, Madre),
  madreDe(Madre, Sobrino).
tioDe(Personaje, Sobrino):-
  medioHermano(Personaje, Padre),
  padreDe(Padre, Sobrino).
tioDe(Personaje, Sobrino):-
  medioHermano(Personaje, Madre),
  madreDe(Madre, Sobrino).
  
descendiente(Predecesor, Descendiente):-
  padreDe(Predecesor, Descendiente).
descendiente(Predecesor, Descendiente):-
  madreDe(Predecesor, Descendiente).
descendiente(Predecesor, Descendiente):-
  padreDe(Predecesor, Tutor),
  padreDe(Tutor, Descendiente).
descendiente(Predecesor, Descendiente):-
  padreDe(Predecesor, Tutor),
  madreDe(Tutor, Descendiente).
descendiente(Predecesor, Descendiente):-
  madreDe(Predecesor, Tutor),
  padreDe(Tutor, Descendiente).
descendiente(Predecesor, Descendiente):-
  madreDe(Predecesor, Tutor),
  madreDe(Tutor, Descendiente).

abueloMultiple(Predecesor):-
  descendiente(Predecesor, Tutor),
  descendiente(Tutor, Descendiente1),
  descendiente(Tutor, Descendiente2).
abueloMultiple(Predecesor):-
  descendiente(Predecesor, Tutor1),
  descendiente(Predecesor, Tutor2),
  descendiente(Tutor1, Descendiente1),
  descendiente(Tutor2, Descendiente2).