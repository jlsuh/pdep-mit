class Item {

	const property danioQueProduce = 0

}

object sistemaDeVuelo inherits Item {

}

object hacha inherits Item(danioQueProduce = 30) {

}

object masa inherits Item(danioQueProduce = 100) {

}

class Comestible inherits Item {

	const property nivelDeHambreQueBaja = 0

}

class Vikingo {

	var property peso
	var property velocidad = 0
	var property barbarosidad
	// suponiendo que el 100% equivale a 1, pues se utiliza los porcentajes con cifras: [0, +inf) en los Reales
	var property nivelHambre = 0
	var property item

	method kilosDePescadoQuePuedeCargar() = 0.5 * peso + 2 * barbarosidad

	method danioQueProduce() = barbarosidad + item.danioQueProduce()

	// suponiendo que el 100% equivale a 1, pues se utiliza los porcentajes con cifras: [0, +inf) en los Reales
	method puedeInscribirse(unaPosta) = nivelHambre + self.diferencialNivelHambre(unaPosta) >= self.porcentajeDeHambreMaximaTolerable()

	method porcentajeDeHambreMaximaTolerable() = 1

	method diferencialNivelHambre(unaPosta) = nivelHambre * unaPosta.porcentajeDeHambreQueDariaLaPosta(self)

	method incrementarHambre(unaPosta) {
		nivelHambre += self.diferencialNivelHambre(unaPosta)
	}

	// vikingo.puedeMontar(unDragon)
	method puedeMontar(unDragon) = unDragon.cumpleRequisitoParaSerMontado(self)

	method tieneItem(itemRequerido) = item == itemRequerido

	// vikingo.obtenerJinete(unDragon)
	method obtenerJinete(unDragon) {
		if (!self.puedeMontar(unDragon)) {
			throw new VikingoNoPuedeMontarADragonException(message = "El vikingo no puede montar al dragón")
		}
		return new Jinete(vikingo = self, dragon = unDragon)
	}

	// vikingo.comoLeConvieneParticipar()
	method comoLeConvieneParticipar(dragonesCandidatos, unaPosta) {
		const dragonesQuePuedeMontar = dragonesCandidatos.filter{ dragon => self.puedeMontar(dragon) }
		return unaPosta.mejorVersionComoCompetidor(self, dragonesQuePuedeMontar)
	}

	method seAnotoComoJinete() = false

}

class Jinete {

	var property vikingo
	var property dragon

	method seAnotoComoJinete() = true

	method kilosDePescadoQuePuedeCargar() = vikingo.peso() - dragon.pesoQuePuedeCargar()

	method danioQueProduce() = vikingo.danioQueProduce() + dragon.danioQueProduce()

	method velocidad() = dragon.velocidad() - vikingo.peso()

	method incrementarHambre(unaPosta) {
		vikingo.incrementarHambre(postaModoJinete)
	}

}

class Dragon {

	var property peso
	var property extraRequisito
	const property inteligencia
	const property danioQueProduce

	method cumpleRequisitoParaSerMontado(unVikingo) = self.cumpleRequisitoBasico(unVikingo) && self.requisitoExtra(unVikingo)

	method cumpleRequisitoBasico(unVikingo) = self.pesoQuePuedeCargar() >= unVikingo.peso()

	method pesoQuePuedeCargar() = peso * 0.2

	method requisitoExtra(unVikingo) = extraRequisito.cumpleRequisitoExtra(unVikingo)

	method velocidad() = self.velocidadBase() - peso

	method velocidadBase() = 60

}

class FuriaNocturna inherits Dragon {

	override method velocidad() = 3 * super()

}

class NadderMortifero inherits Dragon {

	override method danioQueProduce() = 150

	override method cumpleRequisitoBasico(unVikingo) = super(unVikingo) && self.cumpleSegundaRestriccionBasica(unVikingo)

	method cumpleSegundaRestriccionBasica(unVikingo) = inteligencia > unVikingo.inteligencia()

}

class Gronckle inherits Dragon {

	override method velocidadBase() = super() / 2

	override method danioQueProduce() = 5 * peso

}

class BarbarosidadMinima {

	const property barbarosidadMinima

	method cumpleRequisitoExtra(unVikingo) = unVikingo.barbarosidad() > barbarosidadMinima

}

class ItemEnParticular {

	const property itemRequerido

	method cumpleRequisitoExtra(unVikingo) = unVikingo.tieneItem(itemRequerido)

}

object hipo inherits Vikingo(item = sistemaDeVuelo) {

}

object astrid inherits Vikingo(item = hacha) {

}

object patan inherits Vikingo(item = masa) {

}

object patapez inherits Vikingo(item = new Comestible()) {

	override method porcentajeDeHambreMaximaTolerable() = 0.5

	override method incrementarHambre(unaPosta) {
		nivelHambre += (2 * self.diferencialNivelHambre(unaPosta) - item.nivelDeHambreQueBaja()).max(0)
	}

}

object torneo {

	const postas = []
	const property competidores = #{}
	const property dragonesDisponibles = #{}

	// torneo.jugar()
	method jugar() {
		postas.forEach{ posta =>
			posta.serJugada(self)
			posta.registrarResultado()
			posta.finalizarPosta()
		}
	}

	method inscribirParticipantes(unaPosta) {
		competidores.forEach{ participante =>
			if (!participante.puedeInscribirse(unaPosta)) {
				throw new CompetidorNoPuedeParticiparException(message = "Su hambre alcanzaría los 100%")
			}
			const nuevoParticipante = participante.comoLeConvieneParticipar(dragonesDisponibles, unaPosta)
			if (nuevoParticipante.seAnotoComoJinete()) {
				self.ocuparDragon(nuevoParticipante)
			}
			unaPosta.aniadirParticipante(nuevoParticipante)
		}
	}

	method ocuparDragon(unJinete) {
		dragonesDisponibles.remove(unJinete.dragon())
	}

}

class Posta {

	const property tipo
	var property participantes = #{}

	// posta.esMejor(unVikingo, otroVikingo)
	method esMejor(unVikingo, otroVikingo) = tipo.esMejor(unVikingo, otroVikingo)

	method serJugada(unTorneo) {
		unTorneo.inscribirParticipantes(self)
	}

	method registrarResultado() {
		participantes = participantes.sortedBy{ unParticipante , otroParticipante => self.esMejor(unParticipante, otroParticipante) } // no sé si esto anda pero la idea está xd
	}

	method finalizarPosta() {
		participantes.forEach{ participante => participante.incrementarHambre(self)}
	}

	method porcentajeDeHambreQueDariaLaPosta(unVikingo) = tipo.porcentajeHambre()

	method aniadirParticipante(participante) {
		participantes.add(participante)
	}

	method mejorVersionComoCompetidor(unVikingo, dragonesMontables) {
		const versionJinetesConElVikingo = dragonesMontables.forEach{ dragon => unVikingo.obtenerJinete(dragon) }
			// se ha realizado el filter previamente de los dragonesMontables para que no tire nunca una exception,
			// pues de lo contrario frenaría el curso de conseguir versiones del jinete
		const postaEmulada = new Posta(tipo = tipo, participantes = unVikingo + versionJinetesConElVikingo)
		postaEmulada.registrarResultado()
		return postaEmulada.first()
	}

}

object postaModoJinete {

	method porcentajeHambre() = 0.05

}

object pesca {

	method esMejor(unVikingo, otroVikingo) = unVikingo.kilosDePescadoQuePuedeCargar() > otroVikingo.kilosDePescadoQuePuedeCargar()

	method porcentajeHambre() = 0.05

}

object combate {

	method esMejor(unVikingo, otroVikingo) = unVikingo.danioQueProduce() > otroVikingo.danioQueProduce()

	method porcentajeHambre() = 0.1

}

class Carrera {

	const property kilometroDeCarrera

	method esMejor(unVikingo, otroVikingo) = unVikingo.velocidad() > otroVikingo.velocidad()

	method porcentajeHambre() = 0.01 * kilometroDeCarrera

}

class CompetidorNoPuedeParticiparException inherits DomainException {

}

class VikingoNoPuedeMontarADragonException inherits DomainException {

}

