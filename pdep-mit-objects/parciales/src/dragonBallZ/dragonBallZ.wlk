class Saiyan inherits Guerrero {

	var property superSaiyan

	override method potencialOfensivo() {
		if (superSaiyan) {
			return potencialOfensivo + potencialOfensivo * 0.5
		}
		return super()
	}

	override method porcentajeResistencia() {
		if (nivel == 1) {
			return 0.05
		} else if (nivel == 2) {
			return 0.07
		} else if (nivel == 3) {
			return 0.15
		}
		return super()
	}

	override method recibirGolpe(nuevoDiferencial) {
		diferencialEnergia = self.diferencialEnergia() - nuevoDiferencial * self.porcentajeResistencia()
		if (self.energia() < self.energiaOriginal() * 0.01) {
			self.volverEstadoOriginal()
		}
	}

	method volverEstadoOriginal() {
		superSaiyan = false
	}

	override method comer(semillaDelErmitanio) {
		super(semillaDelErmitanio)
		potencialOfensivo = potencialOfensivo + potencialOfensivo * 0.05
	}

}

class Guerrero {

	var property potencialOfensivo
	const property energiaOriginal
	var property diferencialEnergia = 0
	var property nivel = 0
	var property trajeActivo
	var property trajes = []

	method aniadirTraje(nuevoTraje) {
		trajes.add(nuevoTraje)
	}

	method removerTraje(traje) {
		trajes.remove(traje)
	}

	method cambiarTraje(traje) {
		if (!trajes.contains(traje)) {
			self.error("TrajeNoSeEncuentraEnListaDeTrajesException")
		}
		trajeActivo = traje
	}

	method porcentajeResistencia() = 0.1

	method energia() = energiaOriginal + diferencialEnergia

	method recibirGolpe(nuevoDiferencial) {
		diferencialEnergia = self.diferencialEnergia() - nuevoDiferencial
	}

	method atacar(otroGuerrero) {
		if (otroGuerrero.trajeActivo().estaDesgastado()) {
			otroGuerrero.recibirGolpe(potencialOfensivo * self.porcentajeResistencia())
		} else {
			otroGuerrero.recibirGolpe(otroGuerrero.trajeActivo().disminuirDanio(potencialOfensivo * self.porcentajeResistencia()))
		}
		otroGuerrero.nivel(otroGuerrero.trajeActivo().duplicarExperiencia(otroGuerrero.nivel() + 1))
		otroGuerrero.trajeActivo().desgastar(5)
	}

	method comer(semillaDelErmitanio) {
		semillaDelErmitanio.restaurarEnergia(self)
	}

}

class SemillaDelErmitanio {

	method restaurarEnergia(unGuerrero) {
		unGuerrero.diferencialEnergia(0)
	}

}

class Traje {

	var property desgaste = 0

	method disminuirDanio(danio) = danio - danio * self.porcentajeReduccionDanio() // esto en los tests hace que falle, pues self.porcentajeReduccionDanio() es 0.03.
	// Por algún motivo la consigna quiere que lo haga con 0.3, que realidad es 30%, y no como la consigna dice: 3% (que debería ser 0.03)

	method duplicarExperiencia(experiencia) = experiencia + experiencia * self.porcentajeBoostExperiencia()

	method porcentajeReduccionDanio() = 0

	method porcentajeBoostExperiencia() = 0

	method desgastar(razonDesgaste) {
		desgaste += razonDesgaste
	}

	method estaDesgastado() = desgaste >= 100

	method cantidadElementos() = 1

}

class TrajeComun inherits Traje {

	const property porcentajeReduccionDanio

	override method porcentajeReduccionDanio() = porcentajeReduccionDanio

}

class TrajeDeEntrenamiento inherits Traje {

	var property porcentajeBoostExperiencia

	override method porcentajeBoostExperiencia() = porcentajeBoostExperiencia

}

class TrajeModularizados inherits Traje {

	var property piezas = #{}

	override method disminuirDanio(danio) = danio - self.porcentajeReduccionDanio() * 100

	method piezasDesgastadas() = piezas.filter{ pieza => pieza.estaDesgastada() }

	override method porcentajeReduccionDanio() = piezas.filter{ pieza => !pieza.estaDesgastada() }.sum{ pieza => pieza.porcentajeResistencia() }

	override method porcentajeBoostExperiencia() = 1 - self.piezasDesgastadas().size() / piezas.size()

	override method estaDesgastado() = piezas.all{ pieza => pieza.estaDesgastada() }

	override method cantidadElementos() = piezas.size()

}

class Pieza {

	const property porcentajeResistencia
	var property desgaste

	method estaDesgastada() = desgaste >= 20

}

class Torneo {

	var property jugadores
	var property participantes
	const property iteraciones = 16
	var property modalidad

	method aniadirParticipante(participante) {
		participantes.add(participante)
	}

	method removerJugador(jugador) {
		jugadores.remove(jugador)
	}

	method seleccionarJugadores() {
		iteraciones.times{ n =>
			const jugadorElecto = modalidad.criterioEleccion(self)
			self.aniadirParticipante(jugadorElecto)
			self.removerJugador(jugadorElecto)
		}
	}

}

class Modalidad {

	method elegirJugador(torneo)

}

class PowerIsBest inherits Modalidad {

	override method elegirJugador(torneo) = torneo.jugadores().max{ jugador => jugador.potencialOfensivo() }

}

class Funny inherits Modalidad {

	override method elegirJugador(torneo) = torneo.jugadores().max{ jugador => jugador.trajes().sum{ traje => traje.cantidadElementos()} }

}

class Surprise inherits Modalidad {

	override method elegirJugador(torneo) = torneo.jugadores().anyOne()

}

