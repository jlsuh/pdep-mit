personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(pumkin,    honeyBunny).

%trabajaPara(Empleador, Empleado).
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

/* ---------- 1 ---------- */
esPersonaje(UnPersonaje):-
  personaje(UnPersonaje, _).

esPeligroso(UnPersonaje):-
  esPersonaje(UnPersonaje),
  tieneEmpleadosPeligrosos(UnPersonaje).
esPeligroso(UnPersonaje):-
  personaje(UnPersonaje, Actividad),
  actividadPeligrosa(Actividad).

actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron([licorerias])).
actividadPeligrosa(ladron([licorerias | _])).
actividadPeligrosa(ladron([_ | Resto])):-
  actividadPeligrosa(ladron(Resto)).

/*
predicadoRecursivo(functor([elementoBuscado])).
predicadoRecursivo(functor([elementoBuscado | _])).
predicadoRecursivo(functor([_ | Cola])):-
  predicadoRecursivo(functor(Cola)).
*/

tieneEmpleadosPeligrosos(UnPersonaje):-
  trabajaPara(UnPersonaje, UnEmpleado),
  personaje(UnEmpleado, _),
  esPeligroso(UnEmpleado).

/* ---------- 2 ---------- */
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTemible(UnPersonaje, OtroPersonaje):-
  ambosSonPeligrosos(UnPersonaje, OtroPersonaje),
  sonCercanos(UnPersonaje,OtroPersonaje),
  UnPersonaje \= OtroPersonaje.

ambosSonPeligrosos(UnPersonaje, OtroPersonaje):- esPeligroso(UnPersonaje), esPeligroso(OtroPersonaje).

sonCercanos(UnPersonaje, OtroPersonaje):- pareja(UnPersonaje, OtroPersonaje).
sonCercanos(UnPersonaje, OtroPersonaje):- amigo(UnPersonaje, OtroPersonaje).

/* ---------- 3 ---------- */
%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(butch).
estaEnProblemas(UnPersonaje):-
  trabajaPara(SuJefe, UnPersonaje),
  esPeligroso(SuJefe),
  pareja(SuJefe, ParejaDelJefe),
  encargo(SuJefe, UnPersonaje, cuidar(ParejaDelJefe)).
estaEnProblemas(UnPersonaje):-
  encargo(_ , UnPersonaje, buscar(OtroPersonaje, _)),
  personaje(OtroPersonaje, boxeador).

/* ---------- 4 ---------- */
/*
Observaciones:
1) Notar que no está correcto establecernos en el dominio de los personajes, pues un personaje
puede no haber hecho ningún encargo nunca. 
El forall quedaría: F => _, satisfaciendo la consulta para valores que no tienen sentidosanCayetano(UnPersonaje):-
  personaje(UnPersonaje, _),        (1)         encargo(UnPersonaje, OtroPersonaje, _)
  forall( (tieneCerca(UnPersonaje, OtroPersonaje), UnPersonaje \= OtroPersonaje),
     ).
*/
sanCayetano(UnPersonaje):-
  encargo(UnPersonaje, _, _),
  forall( (tieneCerca(UnPersonaje, OtroPersonaje), UnPersonaje \= OtroPersonaje),
          encargo(UnPersonaje, OtroPersonaje, _)
        ).

tieneCerca(UnPersonaje, OtroPersonaje):- amigo(UnPersonaje, OtroPersonaje).
tieneCerca(UnPersonaje, OtroPersonaje):- trabajaPara(UnPersonaje, OtroPersonaje).

/* ---------- 5 ---------- */
masAtareado(UnPersonaje):-
  cantidadEncargosDeUnPersonaje(UnPersonaje, UnaCantidadDeEncargos),
  forall( (cantidadEncargosDeUnPersonaje(OtroPersonaje, OtraCantidadEncargos), UnPersonaje \= OtroPersonaje),
           UnaCantidadDeEncargos >= OtraCantidadEncargos
        ).

cantidadEncargosDeUnPersonaje(UnPersonaje, CantidadEncargos):-
  esPersonaje(UnPersonaje),
  findall(Encargo, encargo(_, UnPersonaje, Encargo), EncargosDeUnPersonaje),
  length(EncargosDeUnPersonaje, CantidadEncargos).

/* ---------- 6 ---------- */
personajesRespetables(ListaDePersonajesRespetables):-
  findall(UnPersonaje, esRespetable(UnPersonaje), ListaDePersonajesRespetables).

esRespetable(UnPersonaje):-
  personaje(UnPersonaje, UnaActividad),
  nivelDeActividad(UnaActividad, NivelDeRespeto),
  NivelDeRespeto > 9.

nivelDeActividad(actriz(ListaDePeliculas), NivelDeRespeto):-
  length(ListaDePeliculas, CantidadDePeliculas),
  NivelDeRespeto is 0.1 * CantidadDePeliculas.
nivelDeActividad(mafioso(resuelveProblemas), 10).
nivelDeActividad(mafioso(maton), 1).
nivelDeActividad(mafioso(capo), 20).

/* ---------- 7 ---------- */
hartoDe(UnPersonaje, OtroPersonaje):-
  esPersonaje(UnPersonaje),
  esPersonaje(OtroPersonaje),
  encargo(_, UnPersonaje, _),
  forall(encargo(_, UnPersonaje, Tarea), interactuarCon(OtroPersonaje, Tarea)).

interactuarCon(Personaje, cuidar(Personaje)).
interactuarCon(Personaje, buscar(Personaje)).
interactuarCon(Personaje, ayudar(Personaje)).
interactuarCon(Personaje, cuidar(AmigoDelOtroPersonaje)):-
  amigo(Personaje, AmigoDelOtroPersonaje).
interactuarCon(Personaje, buscar(AmigoDelOtroPersonaje)):-
  amigo(Personaje, AmigoDelOtroPersonaje).
interactuarCon(Personaje, ayudar(AmigoDelOtroPersonaje)):-
  amigo(Personaje, AmigoDelOtroPersonaje).

/* ---------- 8 ---------- */
caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(UnPersonaje, OtroPersonaje):-
  sonCercanos(UnPersonaje, OtroPersonaje),
  caracteristicas(UnPersonaje, UnaListaCaracteristicas),
  caracteristicas(OtroPersonaje, OtraListaCaracteristicas),
  member(UnaCaracteristica, UnaListaCaracteristicas),
  not(member(UnaCaracteristica, OtraListaCaracteristicas)).