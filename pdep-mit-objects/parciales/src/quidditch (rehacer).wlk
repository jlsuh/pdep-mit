object quaffle {

// method puntosQueDa() = 10
}

object manosVacias {

}

class Equipo {

	const property integrantes = #{}
	var property puntos = 0

	method habilidadTotal() = integrantes.sum{ integrante => integrante.habilidad() }

	method cantidadIntegrantes() = integrantes.size()

	method habilidadPromedio() = self.habilidadTotal() / self.cantidadIntegrantes()

	// equipo.tieneJugadorEstrellaParaJugarEnContra(otroEquipo)
	method tieneJugadorEstrellaParaJugarEnContra(otroEquipo) = integrantes.any{ integrante => otroEquipo.integrantesEsInfimoAContrincante(integrante) }

	method integrantesEsInfimoAContrincante(contrincante) = integrantes.all{ integrante => contrincante.lePasaElTrapo(integrante) }

	// equipo.jugarEnContra(otroEquipo)
	method jugarEnContra(otroEquipo) {
		integrantes.forEach{ integrante => integrante.responderAlTurno(otroEquipo)}
	}

	method intentarBloquearTiroCazador(unCazador) {
		integrantes.forEach{ integrante =>
			if (integrante.puedeBloquear(unCazador)) {
				unCazador.perderSkills(2)
				integrante.ganarSkills(10)
				unCazador.perderQuaffle(self)
				throw new TiroBloqueadoException(message = "El tiro del cazador fue bloqueado e interrumpido")
			}
		}
	}

	method ganarPuntos(nuevosPuntos) {
		puntos += nuevosPuntos
	}

	method atraparQuafflePorCazadorMasRapido() {
		const elCazadorMasVeloz = self.cazadores().max{ cazador => cazador.velocidad() }
		elCazadorMasVeloz.atraparQuaffle()
	}

	method cazadores() = integrantes.filter{ integrante => integrante.esCazador() }

	method algunBlancoUtil() = integrantes.find{ integrante => integrante.esBlancoUtil() }

	method alguienTieneLaQuaffle() = integrantes.any{ integrante => integrante.tieneLaQuaffle() }

	method verseAfectadoPorGolpe(otroEquipo) {
		integrantes.forEach{ integrante => integrante.perderQuaffle(otroEquipo)}
		integrantes.forEach{ integrante => integrante.reiniciarBusqueda(otroEquipo)}
	}

}

class Jugador {

	const property equipoParaElQueJuega
	const property peso
	var property skills
	var property escobaQueUsa
	const property nivelPunteria = 0
	const property nivelFuerza
	const property nivelReflejos = 0
	const property nivelVision
	const property puesto
	var property pelota = manosVacias

	// jugador.nivelManejoDeEscoba()
	method nivelManejoDeEscoba() = skills / peso

	// jugador.velocidad()
	method velocidad() = escobaQueUsa.velocidad() * self.nivelManejoDeEscoba()

	// jugador.habilidad()
	method habilidad() = puesto.habilidad(self)

	// method habilidad() = self.velocidad() + skills
	// jugador.lePasaElTrapo()
	method lePasaElTrapo(otroJugador) = self.habilidad() > 2 * otroJugador.habilidad()

	// jugador.esGroso()
	method esGroso() = self.habilidad() > equipoParaElQueJuega.habilidadPromedio() && self.velocidad() > mercadoEscobas.estandarDeVelocidad()

	method responderAlTurno(otroEquipo) = puesto.responderAlTurno(self, otroEquipo)

	method tieneLaQuaffle() = pelota == quaffle

	method intentarMeterGol(otroEquipo) {
		otroEquipo.intentarBloquearTiroCazador(self)
		equipoParaElQueJuega.ganarPuntos(10)
		self.ganarSkills(5)
	}

	method puedeBloquear(unCazador) = puesto.puedeBloquear(self, unCazador)

	method ganarSkills(nuevosSkills) {
		skills += nuevosSkills
	}

	method perderSkills(skillsAPerder) {
		skills -= skillsAPerder
	}

	method perderQuaffle(otroEquipo) {
		pelota = manosVacias
		otroEquipo.atraparQuafflePorCazadorMasRapido()
	}

	method atraparQuaffle() {
		pelota = quaffle
	}

	method esCazador() = puesto == cazador

	method intentarObtenerLaSnitch(unJugador) {
		puesto.responderSegunEstadoBuscador(unJugador)
	}

	method aportarPuntosAEquipo(puntos) {
		equipoParaElQueJuega.ganarPuntos(puntos)
	}

	method elegirBlancoUtil(otroEquipo) = otroEquipo.algunBlancoUtil()

	method esBlancoUtil() = puesto.esBlancoUtil(self)

	method suEquipoNoTieneLaQuaffle() = !equipoParaElQueJuega.alguienTieneLaQuaffle()

	method puedeSerGolpeado(unGolpeador) = unGolpeador.nivelPunteria() > nivelReflejos || random.randomizar(1, 10) >= 8

	method serGolpeadoPorUnaBludger() {
		self.perderSkills(2)
		escobaQueUsa.recibirGolpe()
	}

	method afectarEquipo(otroEquipo) {
		equipoParaElQueJuega.verseAfectadoPorGolpe(otroEquipo)
	}

	method reiniciarBusqueda(otroEquipo) {
		puesto.reiniciarBusqueda()
	}

}

object mercadoEscobas {

	var property estandarDeVelocidad = 0

}

class Puesto {

	method habilidad(unJugador) = unJugador.velocidad() + unJugador.skills() // pudo haber estado en class Jugador

	method responderAlTurno(unJugador, otroEquipo)

	method puedeBloquear(unJugador, unCazador)

	method esBlancoUtil(unJugador)

	method reiniciarBusqueda() {
	}

}

object cazador inherits Puesto {

	override method habilidad(unJugador) = super(unJugador) + unJugador.nivelPunteria() * unJugador.nivelFuerza()

	override method responderAlTurno(unJugador, otroEquipo) {
		if (unJugador.tieneLaQuaffle()) {
			unJugador.intentarMeterGol(otroEquipo) // Delegación errónea. El cazador debería solamente ser capaz de intentar meter el gol
		}
	}

	override method puedeBloquear(unJugador, unCazador) = unJugador.lePasaElTrapo(unCazador)

	override method esBlancoUtil(unJugador) = unJugador.tieneLaQuaffle()

}

class Buscador inherits Puesto {

	var property estado	// tendría que comenzar buscando la snitch ni bien comienza el partido
	var property cantidadDeTurnosContinuosBuscandoLaSnitch = 0
	var property kilometrosRecorridos

	override method habilidad(unJugador) = super(unJugador) + unJugador.nivelReflejos() * unJugador.nivelVision()

	override method puedeBloquear(unJugador, unCazador) = false

	override method responderAlTurno(unJugador, otroEquipo) {
		unJugador.intentarObtenerLaSnitch(unJugador)
	}

	method responderSegunEstadoBuscador(unJugador) {
		estado.responderAlTurno(self, unJugador)
	}

	override method esBlancoUtil(unJugador) = estado == buscandoLaSnitch || self.kilometrosQueLeFaltan() < 1000

	method kilometrosQueLeFaltan() = persiguiendoLaSnitch.kilometrosARecorrer() - kilometrosRecorridos

	override method reiniciarBusqueda() {
		kilometrosRecorridos = 0
	}

}

class EstadoBuscador {

	method ganarRecompensaDeHaberEncontradoLaSnitch(unJugador) {
		unJugador.ganarSkills(10)
		unJugador.aportarPuntosAEquipo(150)
	}

	method responderAlTurno(estadoBuscador, unJugador)

}

object persiguiendoLaSnitch inherits EstadoBuscador {

	const property kilometrosARecorrer = 5000

	override method responderAlTurno(estadoBuscador, unJugador) {
		if (estadoBuscador.kilometrosRecorridos() == kilometrosARecorrer) {
			self.ganarRecompensaDeHaberEncontradoLaSnitch(unJugador)
		}
	}

}

object buscandoLaSnitch inherits EstadoBuscador {

	override method responderAlTurno(estadoBuscador, unJugador) {
		if (random.randomizar(1, 1000) < unJugador.habilidad() + estadoBuscador.cantidadDeTurnosContinuosBuscandoLaSnitch()) {
			self.ganarRecompensaDeHaberEncontradoLaSnitch(unJugador)
		}
	}

}

object golpeador inherits Puesto {

	override method habilidad(unJugador) = super(unJugador) + unJugador.nivelPunteria() + unJugador.nivelFuerza()

	override method puedeBloquear(unJugador, unCazador) = unJugador.esGroso()

	override method responderAlTurno(unGolpeador, otroEquipo) {
		const unBlancoUtil = unGolpeador.elegirBlancoUtil(otroEquipo)
		if (unBlancoUtil.puedeSerGolpeado(unGolpeador)) {
			unBlancoUtil.serGolpeadoPorUnaBludger()
			unGolpeador.ganarSkills(1)
			unGolpeador.afectarEquipo(otroEquipo)
			otroEquipo.verseAfectadoPorGolpe(otroEquipo)
		}
	}

	override method esBlancoUtil(unJugador) = false

}

object guardian inherits Puesto {

	override method habilidad(unJugador) = super(unJugador) + unJugador.nivelReflejos() + unJugador.nivelFuerza()

	override method puedeBloquear(unJugador, unCazador) = random.randomizar(1, 3) == 3

	override method esBlancoUtil(unJugador) = unJugador.suEquipoNoTieneLaQuaffle()

	override method responderAlTurno(unJugador, otroEquipo) {
	}

}

class Nimbus {

	var property porcentajeSalud
	const property anioFabricacion

	method velocidad() = (80 - self.aniosDesdeSuFabricacion()) * porcentajeSalud

	method aniosDesdeSuFabricacion() = anioFabricacion - new Date().year()

	method recibirGolpe() {
		porcentajeSalud -= 0.1 * porcentajeSalud
	}

}

object saetaDeFuego {

	method velocidad() = 100

	method recibirGolpe() {
	}

}

object random {

	method randomizar(inferior, superior) = inferior.randomUpTo(superior).roundUp()

}

class TiroBloqueadoException inherits DomainException {

}

