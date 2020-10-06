vieneCon(p206, abs).
vieneCon(p206, levantavidrios).
vieneCon(p206, direccionAsistida).
vieneCon(kadisco, abs).
vieneCon(kadisco, mp3).
vieneCon(kadisco, tacometro).

quiere(carlos, abs).
quiere(carlos, mp3).
quiere(roque, abs).
quiere(roque, direccionAsistida).

/*
auto(UnAuto):-
  vieneCon(UnAuto, _).
persona(UnaPersona):-
  quiere(UnaPersona, _).
*/ /*Se podría describir a un auto y a una persona así*/

/*O definiéndolos por extensión específicamente*/
auto(p206).
auto(kadisco).
persona(carlos).
persona(roque).

vienePerfecto(UnAuto, UnaPersona):-
  auto(UnAuto),
  persona(UnaPersona),
  forall(quiere(UnaPersona, UnaCaracteristica), vieneCon(UnAuto, UnaCaracteristica)).
/*Para toda característica que le gusta a una persona, entonces esa característica viene con el auto*/

/*
vienePerfecto(UnAuto, UnaPersona):-
  auto(UnAuto),
  persona(UnaPersona),
  forall(vieneCon(UnAuto, UnaCaracteristica), quiere(UnaPersona, UnaCaracteristica)).
*/
/*Para toda característica que venga con un cierto auto, entonces esa persona debe de gustarle esa característica*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
incluido(A, B):-
  forall(member(X, A), member(X, B)).

disjuntos(A, B):-
  forall(member(X, A), not(member(X, B))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
materia(am1).
materia(sysop).
materia(pdp).

alumno(clara).
alumno(matias).
alumno(valeria).
alumno(adelmar).

estudio(clara, am1).
estudio(clara, sysop).
estudio(clara, pdp).
estudio(matias, pdp).
estudio(matias, am1).
estudio(valeria, pdp).

estudiosoVersionForall(UnAlumno):-
  alumno(UnAlumno),
  forall(materia(UnaMateria), estudio(UnAlumno, UnaMateria)).

estudiosoVersionNoExiste(UnAlumno):-
  alumno(UnAlumno),
  not((materia(UnaMateria), not(estudio(UnAlumno, UnaMateria)))).

alumnoDificil(UnAlumno):-
  alumno(UnAlumno),
  not(estudio(UnAlumno, _)).