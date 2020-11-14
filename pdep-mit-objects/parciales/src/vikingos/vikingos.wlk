class Expedicion {

	var property participantes = []
	var property destinos = []

	method subir(vikingo) {
		if (vikingo.puedeIrAUnaExpedicion()) {
			participantes.add(vikingo)
		}
	}

	method cantidadParticipantes() = participantes.size()

	method valeLaPena() = destinos.all{ destino => destino.valeLaPena(self.cantidadParticipantes()) }

	method realizarExpedicion() {
		const botinTotalExpedicion = destinos.sum{ destino => destino.botin(self.cantidadParticipantes()) }
		destinos.forEach{ destino => destino.invadir(self.cantidadParticipantes())}
		const botinPerCapita = botinTotalExpedicion / self.cantidadParticipantes()
		participantes.forEach{ participante => participante.oro(participante.oro() + botinPerCapita)}
	}

}

class DestinoExpedicion {

	method valeLaPena(cantidadParticipantes)

	method botin(cantidadParticipantes)

	method invadir(cantidadParticipantes)

}

class Capital inherits DestinoExpedicion {

	const property factorRiquezaDeLaTierra
	var property defensores

	override method botin(cantidadParticipantes) {
		const botinQueConseguirian = cantidadParticipantes.min(defensores)
		return botinQueConseguirian + botinQueConseguirian * factorRiquezaDeLaTierra
	}

	override method valeLaPena(cantidadParticipantes) = self.botin(cantidadParticipantes) * 3 >= cantidadParticipantes

	override method invadir(cantidadParticipantes) {
		defensores = 0.max(defensores - cantidadParticipantes)
	}

}

class Aldea inherits DestinoExpedicion {

	var property iglesias = []

	override method botin(cantidadParticipantes) = iglesias.sum{ iglesia => iglesia.cantidadCrucifijos() }

	method saciaLaSedDeSaqueos(cantidadParticipantes) = self.botin(cantidadParticipantes) >= 15

	override method valeLaPena(cantidadParticipantes) = self.saciaLaSedDeSaqueos(cantidadParticipantes)

	override method invadir(cantidadParticipantes) {
		iglesias.forEach{ iglesia => iglesia.cantidadCrucifijos(0)}
	}

}

class AldeaAmurallada inherits Aldea {

	const property cantidadMinimaDeVikingosEnLaComitiva

	override method valeLaPena(cantidadParticipantes) = super(cantidadParticipantes) && cantidadParticipantes > cantidadMinimaDeVikingosEnLaComitiva

}

class Iglesia {

	var property cantidadCrucifijos

}

class Vikingo {

	var property casta
	var property oro

	method esProductivo()

	method puedeIrAUnaExpedicion() {
		if (casta.equals(jarl) && self.tieneArmas()) {
			self.error("JarlNoPuedeParticiparDeLaExpedicionException")
		}
		return self.esProductivo()
	}

	method tieneArmas() = false

	method ascenderSocialmente() {
		casta.ascensoSocial(self)
	}

	method ganarArmas(nuevasArmas)

	method ganarHijosYHectareas(nuevosDescendientes, nuevasHectareas)

}

class Soldado inherits Vikingo {

	var property vidasCobradas
	var property armas

	override method tieneArmas() = armas > 0

	override method esProductivo() {
		if (vidasCobradas <= 20 || !self.tieneArmas()) {
			self.error("SoldadoNoPuedeParticiparDeUnaExpedicionException")
		}
		return true
	}

	override method ganarArmas(nuevasArmas) {
		armas += nuevasArmas
	}

	override method ganarHijosYHectareas(nuevosDescendientes, nuevasHectareas) {
	}

}

class Granjero inherits Vikingo {

	var property descendientes
	var property hectareas

	override method esProductivo() {
		if (hectareas < 2 * descendientes) {
			self.error("GranjeroNoPuedeParticiparDeUnaExpedicionException")
		}
		return true
	}

	override method ganarArmas(nuevasArmas) {
	}

	override method ganarHijosYHectareas(nuevosDescendientes, nuevasHectareas) {
		descendientes += nuevosDescendientes
		hectareas += nuevasHectareas
	}

}

class CastaSocial {

	method ascensoSocial(vikingo)

}

object jarl inherits CastaSocial {

	override method ascensoSocial(vikingo) {
		vikingo.casta(karl)
		vikingo.ganarArmas(10)
		vikingo.ganarHijosYHectareas(2, 2)
	}

}

object karl inherits CastaSocial {

	override method ascensoSocial(vikingo) {
		vikingo.casta(thrall)
	}

}

object thrall inherits CastaSocial {

	override method ascensoSocial(vikingo) {
		vikingo.casta(self)
	}

}

/*
 * Teórico punto 4)
 * Para poder añadir a un castillo al conjunto de los destinos posibles para las invasiones, se tendría que solamente tener en cuenta
 * los 3 métodos de la clase abstracta DestinoExpedicion; posteriormente se tendría que tener en cuenta los distintos requerimientos
 * posibles que deban cumplir los castillos, para que los métodos sobreescritos no queden vacíos. La ilustración se realiza al siguiente:
 * class Castillo inherits DestinoExpedicion {
 *   override method valeLaPena(cantidadParticipantes) {
 * 	 }
 * 
 * 	 override method botin(cantidadParticipantes) {
 * 	 }
 * 
 * 	 override method invadir(cantidadParticipantes) {
 * 	 }
 * 
 * }
 */
