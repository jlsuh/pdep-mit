% jugadores
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% cartas
% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
% hechizo(Nombre, FunctorEfecto, CostoMana)

% efectos
% daño(CantidadDaño)
% cura(CantidadCura)

% jugador(jugador(joel, 30, 10, [criatura(deathwing, 10, 10, 10)], [criatura(sylvannas, 5, 10, 6)], [criatura(yeti, 4, 5, 4)])).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
danio(criatura(_,Danio,_,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

/* ---------- 1 ---------- */
esJugador(jugador(_,_,_,_,_,_)).

tieneCarta(UnJugador, UnaCarta):-
  esJugador(UnJugador),
  cartasDeUnJugador(UnJugador, CartasDeUnJugador),
  member(UnaCarta, CartasDeUnJugador).

cartasDeUnJugador(UnJugador, SusCartas):-
  cartasMano(UnJugador, CartasEnMano),
  cartasMazo(UnJugador, CartasEnMazo),
  cartasCampo(UnJugador, CartasEnCampo),
  append(CartasEnMano, CartasEnCampo, CartasEnJuego),
  append(CartasEnJuego, CartasEnMazo, SusCartas).

/* ---------- 2 ---------- */
esCriatura(criatura(_,_,_,_)).

esGuerrero(UnJugador):-
  esJugador(UnJugador),
  cartasDeUnJugador(UnJugador, CartasDeUnJugador),
  forall(member(UnaCarta, CartasDeUnJugador), esCriatura(UnaCarta)).

/* ---------- 3 ---------- */
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)
empezarTurno(jugador(Nombre, VidaActual, ManaActual, [TopeMazo | Mazo], CartasMano , CartasCampo),
             jugador(Nombre, VidaActual, ManaSiguienteTurno, Mazo, [TopeMazo | CartasMano], CartasCampo)):-
              manaSiguienteTurno(ManaActual, ManaSiguienteTurno).

manaSiguienteTurno(10, 10).
manaSiguienteTurno(PuntosMana, ManaSiguienteTurno):-
  PuntosMana < 10,
  ManaSiguienteTurno is PuntosMana + 1.

/* ---------- 4 ---------- */
/* ----- a ----- */
puedeJugarCarta(UnJugador, UnaCarta):-
  mana(UnJugador, ManaDelJugador),
  mana(UnaCarta, CostoMana),
  ManaDelJugador >= CostoMana.

/* ----- b ----- */
estaEnSuMano(UnaCarta, UnJugador):-
  cartasMano(UnJugador, CartasEnMano),
  member(UnaCarta, CartasEnMano).

puedeJugarloEnProximoTurno(UnJugador, CartasJugablesEnProximoTurno):-
  empezarTurno(UnJugador, JugadorEnProximoTurno),
  findall(UnaCarta, (estaEnSuMano(UnaCarta, JugadorEnProximoTurno), puedeJugarCarta(JugadorEnProximoTurno, UnaCarta)), CartasJugablesEnProximoTurno).

/* ---------- 5 ---------- */
/*
Conocer, de un jugador, todas las posibles jugadas que puede hacer en el próximo turno, esto es,
el conjunto de cartas que podrá jugar al mismo tiempo sin que su maná quede negativo.
Nota: Se puede asumir que existe el predicado jugar/3 como se indica en el punto 7.b.
No hace falta implementarlo para resolver este punto. Importante: También hay formas de resolver este punto sin usar jugar/3. 
Tip: Pensar en explosión combinatoria.
*/

posiblesJugadas(???, ???).

% jugar(UnaCarta, JugadorAnterior, JugadorPosterior)

/*
  esJugador(UnJugador),
  cartasMano(UnJugador, CartasEnMano),
  maplist(puedeJugarloEnProximoTurno(UnJugador), CartasEnMano).
*/

/* ---------- 6 ---------- */
cartaMasDanina(UnJugador, CartaMasDanina):-
  tieneCarta(UnJugador, CartaMasDanina),
  danio(CartaMasDanina, DanioCartaMasDanina),

/* Versión forall */
  forall( (tieneCarta(UnJugador, OtraCarta), CartaMasDanina \= OtraCarta),
          (danio(OtraCarta, DanioDeOtraCarta), DanioCartaMasDanina > DanioDeOtraCarta)
        ).
/* Versión not */
% not((tieneCarta(UnJugador, OtraCarta), danio(OtraCarta, OtroDanio), OtroDanio > DanioCartaMasDanina)).

/* ---------- 7 ---------- */
/* ----- a ----- */
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)
jugarContra(hechizo(_,danio(Danio),_),
            jugador(Nombre, PuntosDeVida, PuntosMana, CartasMazo, CartasMano, CartasCampo),
            jugador(Nombre, PuntosDeVidaPosterior, PuntosMana, CartasMazo, CartasMano, CartasCampo)
            ):-
              PuntosDeVidaPosterior is PuntosDeVida - Danio.

/* ----- b ----- BONUS */
esHechizoDeCura(hechizo(_,curar(_),_)).

jugar(UnaCarta, UnJugador, jugador(NombreJugador, PuntosDeVidaPosterior, PuntosDeManaPosterior, CartasMazo, CartasManoPosterior, CartasCampoPosterior)):-
  nombre(UnJugador, NombreJugador),
  vida(UnJugador, PuntosDeVida),
  mana(UnJugador, PuntosDeMana),
  cartasMazo(UnJugador, CartasMazo),
  cartasMano(UnJugador, CartasMano),
  cartasCampo(UnJugador, CartasCampo),

  estaEnSuMano(UnaCarta, UnJugador),
  puedeJugarCarta(UnJugador, UnaCarta),
  
  vidaQueCuraUnaCarta(UnaCarta, VidaQueCuraLaCarta),
  PuntosDeVidaPosterior is PuntosDeVida + VidaQueCuraLaCarta,

  mana(UnaCarta, ManaDeLaCarta),
  PuntosDeManaPosterior is PuntosDeMana - ManaDeLaCarta,

  findall(Carta, (member(Carta, CartasMano), Carta \= UnaCarta), CartasManoPosterior),
  invocarEnCampoSiEsCriatura(UnaCarta, CartasCampo, CartasCampoPosterior).

vidaQueCuraUnaCarta(hechizo(_,curar(Vida),_), Vida).
vidaQueCuraUnaCarta(hechizo(_,danio(_),_), 0).
vidaQueCuraUnaCarta(criatura(_,_,_,_), 0).

invocarEnCampoSiEsCriatura(hechizo(_,_,_), CartasCampo, CartasCampo).
invocarEnCampoSiEsCriatura(UnaCarta, CartasCampo, [UnaCarta | CartasCampo]):-
  esCriatura(UnaCarta).
