%% persona(Nombre, JuegaA, TieneManos).
persona(juanManuel).
persona(barboNoTieneManos).
persona(joel).

%% esEstudiante(Nombre, Facultad).
esEstudiante(juanManuel, utn).
esEstudiante(barboNoTieneManos, utn).
esEstudiante(joel, utn).

%% juegaA(Nombre, Juego, TieneManos).
juegaA(juanManuel, lol).
juegaA(barboNoTieneManos, lol).
juegaA(joel, lol).

%% tieneManos(Alguien).
tieneManos(juanManuel).
tieneManos(joel).

%% esManco(Nombre).
esManco(Alguien):-
  not(tieneManos(Alguien)).

%% loCarreaEnLeague(Carreador, Carreado).
loCarreaEnLeague(Carreador, _):-
  persona(Carreador),
  esEstudiante(Carreador, utn),
  not(esManco(Carreador)),
  juegaA(Carreador, lol).