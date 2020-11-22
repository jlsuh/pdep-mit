class Jugador {

	const property color
	const property mochila = []
	var property nivelSospecha = 40
	var property tareas = []
	var property personalidad
	const property rolQueCumple

	// jugador.esSospechoso()
	method esSospechoso() = nivelSospecha > 50

	// jugador.buscarItem()
	method buscarItem(itemBuscado) {
		mochila.add(itemBuscado)
	}

	// jugador.completoTodasSusTareas()
	method completoTodasSusTareas() = rolQueCumple.completoTodasSusTareas(tareas)

	// jugador.realizarTareaPendiente()
	method realizarTareaPendiente() = rolQueCumple.realizarTareaPendiente(tareas)

	method tieneItem(item) = mochila.contains(item)

	method aumentarNivelSospecha(nivelAAumentar) {
		nivelSospecha += nivelAAumentar
	}

	method disminuirNivelSospecha(nivelADecrementar) {
		nivelSospecha -= nivelADecrementar
	}

	method desligarItem(itemARemover) {
		mochila.remove(itemARemover)
	}

	// jugador.llamarReunionDeEmergencia()
	method llamarReunionDeEmergencia() {
		const votacion = new Votacion()
		votacion.iniciarVotacion()
	}

	method votar(unaVotacion) = rolQueCumple.votar(unaVotacion, personalidad)

	method tieneMochilaVacia() = mochila.size() == 0

	method votarEnEnProximaReunion() {
		personalidad = impugnado
	}

	method esImpostor()

}

class Impostor {

	method completoTodasSusTareas(tareas) = true

	method realizarTareaPendiente(tareas) {
	}

	// impostor.realizarSabotaje()
	method realizarSabotaje(unSabotaje) {
		unSabotaje.serRealizadoPor(self)
	}

	method votar(unaVotacion, personalidad) {
		const jugador = nave.algunJugador()
		unaVotacion.aportarVoto(jugador)
	}

	method esImpostor() = true

}

class Tripulante {

	method completoTodasSusTareas(tareas) = tareas.all{ tarea => tarea.estaCompleta() }

	method tareaPendienteRealizable(tareas) = tareas.find{ tarea => !tarea.estaCompleta() && tarea.cumpleRestriccion(self) }

	method realizarTareaPendiente(tareas) {
		const tarea = self.tareaPendienteRealizable(tareas)
		tarea.realizarse(self)
		nave.serInformadaDeUnaTareaCompleta()
	}

	method votar(unaVotacion, personalidad) {
		try {
			const jugador = personalidad.criterioDeVoto()
			unaVotacion.aportarVoto(jugador)
		} catch e : CriterioNoSePudoSatisfacerException {
			unaVotacion.aportarVoto("blanco")
		}
	}

	method esImpostor() = false

}

object impugnado {

	method criterioDeVoto() = "blanco"

}

object troll {

	method criterioDeVoto() = nave.jugadorNoSospechoso()

}

object detective {

	method criterioDeVoto() = nave.jugadorConMayorSospecha()

}

object materialista {

	method criterioDeVoto() = nave.jugadorConMochilaVacia()

}

class Votacion {

	var property votos = []

	method iniciarVotacion() {
		nave.llevarACaboVotacion(self)
		self.determinarVotacion()
	}

	method aportarVoto(unVoto) {
		votos.add(unVoto)
	}

	method determinarVotacion() {
		const resultadoVotacion = self.elMasVotado()
		if (resultadoVotacion != "blanco") {
			nave.expulsar(resultadoVotacion)
			nave.actualizarJugadores()
		} else {
			throw new VotoEnBlancoException(message = "Nadie fue expulsado de la nave") // no lo pedía pero bueno xd
		}
	}

	method elMasVotado() = votos.max{ voto => votos.occurrencesOf(voto) }

}

object nave {

	const property jugadores = #{}
	var property nivelOxigeno = 100
	var property impostoresPresentes = 0
	var property tripulantesPresentes = 0

	method serInformadaDeUnaTareaCompleta() {
		self.todosLosJugadoresCompletaronTodasSusTareas()
	}

	method todosLosJugadoresCompletaronTodasSusTareas() {
		if (jugadores.all{ jugador => jugador.completoTodasSusTareas() }) {
			throw new VictoriaTripulantesException(message = "Ganaron los tripulantes")
		}
	}

	method aumentarNivelOxigeno(oxigenoAAumentar) {
		nivelOxigeno += oxigenoAAumentar
	}

	method disminuirNivelOxigeno(oxigenoADecrementar) {
		nivelOxigeno -= oxigenoADecrementar
	}

	method alguienTiene(item) = jugadores.any{ jugador => jugador.tieneItem(item) }

	method algunJugador() = jugadores.anyOne()

	method llevarACaboVotacion(unaVotacion) {
		jugadores.forEach{ jugador => jugador.votar(unaVotacion)}
	}

	method jugadorNoSospechoso() = jugadores.findOrElse({ jugador => !jugador.esSospechoso() }, throw new CriterioNoSePudoSatisfacerException(message = "Todos son sospechosos"))

	method jugadorConMayorSospecha() = jugadores.max{ jugador => jugador.nivelSospecha() }

	method jugadorConMochilaVacia() = jugadores.findOrElse({ jugador => jugador.tieneMochilaVacia() }, throw new CriterioNoSePudoSatisfacerException(message = "Todos tienen algo en la mochila"))

	method expulsar(jugador) {
		jugadores.remove(jugador)
		self.verificarSiHayGanador()
	}

	method actualizarJugadores() {
		impostoresPresentes = self.cantidadImpostores()
		tripulantesPresentes = self.cantidadTripulantes()
	}

	method cantidadImpostores() = jugadores.count{ jugador => jugador.esImpostor() }

	method cantidadTripulantes() = jugadores.count{ jugador => !jugador.esImpostor() }

	method verificarSiHayGanador() {
		if (self.noHayImpostoresPresentes()) {
			throw new VictoriaTripulantesException(message = "Todos los impostores fueron expulsados de la nave")
		} else if (impostoresPresentes == tripulantesPresentes) {
			throw new VictoriaImpostoresException(message = "Queda una misma cantidad de impostores que tripulantes")
		}
	}

	method noHayImpostoresPresentes() = impostoresPresentes == 0

}

class Sabotaje {

	method serRealizadoPor(unImpostor) {
		unImpostor.aumentarNivelSospecha(5)
	}

}

class ReducirOxigeno inherits Sabotaje {

	override method serRealizadoPor(unImpostor) {
		super(unImpostor)
		if (!nave.alguienTiene("tubo de oxigeno")) {
			nave.disminuirNivelOxigeno(10)
		}
		if (nave.nivelOxigeno() == 0) {
			throw new VictoriaImpostoresException(message = "Ganaron los impostores")
		}
	}

}

class ImpugnarJugador inherits Sabotaje {

	override method serRealizadoPor(unImpostor) {
		super(unImpostor)
		const jugadorImpugnado = nave.algunJugador()
		jugadorImpugnado.votarEnBlancoEnProximaReunion()
	// Es uno de los motivos por el cual una personalidad no es solamente de los Tripulantes, sino de un Jugador en sí
	// Pues según se interpreta de la consigna, que un Impostor también puede obligar a otro impostor a que vote en blanco
	// en la próxima reunión
	}

}

class Tarea {

	var property estaCompleta

	method cumpleRestriccion(unJugador)

	method realizarse(unJugador) {
		estaCompleta = true
	}

}

class VentilarNave inherits Tarea {

	override method cumpleRestriccion(unJugador) = true

	override method realizarse(unJugador) {
		super(unJugador)
		nave.aumentarNivelOxigeno(5)
	}

}

class SacarBasura inherits Tarea {

	override method cumpleRestriccion(unJugador) = unJugador.tieneItem("escoba") && unJugador.tieneItem("bolsa de consorcio")

	override method realizarse(unJugador) {
		super(unJugador)
		unJugador.disminuirNivelSospecha(4)
		unJugador.desligarItem("escoba")
		unJugador.desligarItem("bolsa de consorcio")
	}

}

class ArreglarTableroElectrico inherits Tarea {

	override method cumpleRestriccion(unJugador) = unJugador.tieneItem("llave inglesa")

	override method realizarse(unJugador) {
		super(unJugador)
		unJugador.aumentarNivelSospecha(10)
		unJugador.desligarItem("llave inglesa")
	}

}

class VictoriaTripulantesException inherits DomainException {

}

class VictoriaImpostoresException inherits DomainException {

}

class CriterioNoSePudoSatisfacerException inherits DomainException {

}

class VotoEnBlancoException inherits DomainException {

}

