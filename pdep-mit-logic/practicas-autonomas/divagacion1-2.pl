pastas(ravioles).
pastas(fideos).
pastas(fusiles).

come(juan, ravioles).
come(melina, ravioles).
come(brenda, fideos).
come(juan, fideos).

%%%%
%% esMayorDeEdad(Persona, Edad)
esMayorDeEdad(Persona, Edad) :-
  Edad >= 18.

%%%%
progenitor(homero, bart).
progenitor(homero, lisa).
progenitor(homero, maggie).
progenitor(abe, homero).
progenitor(abe, jose).
progenitor(jose, pepe).
progenitor(mona, homero).
progenitor(jacqueline, marge).
progenitor(marge, bart).
progenitor(marge, lisa).
progenitor(marge, maggie).

hermano(Hermano1, Hermano2):-progenitor(Padre, Hermano1), progenitor(Padre, Hermano2).

tio(Tio, Sobrino):-hermano(Tio, Padre), progenitor(Padre, Sobrino).

/*
primo(Primo1, Primo2):-
  progenitor(Tio, Primo2),
  tio(Tio, Primo1).
*/
primo(Primo1, Primo2):-
  progenitor(Padre, Primo1),
  progenitor(Tio, Primo2),
  hermano(Padre, Tio).

abuelo(Abuelo, Nieto):-
  progenitor(Abuelo, Padre),
  progenitor(Padre, Nieto).

%%%%

hije(herbert, abraham).
hije(homero, abraham).
hije(homero, mona).
hije(marge, clancy).
hije(marge, jacqueline).
hije(patty, clancy).
hije(patty, jacqueline).
hije(selma, clancy).
hije(selma, jacqueline).
hije(bart, homero).
hije(bart, marge).
hije(lisa, homero).
hije(lisa, marge).
hije(maggie, homero).
hije(maggie, marge).
hije(ling, selma).

% hermanes/2 se cumple si ambas personas son hijas de una persona en común.
hermanes(Persona1, Persona2):-
	hije(Persona1, Padre),
	hije(Persona2, Padre),
	Persona2 \= Persona1.
