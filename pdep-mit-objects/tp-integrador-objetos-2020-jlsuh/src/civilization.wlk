// ---------------------------------------- Imperio ---------------------------------------- //
class Imperio {

	var property dinero
	var property ciudades = []

	method agregarCiudad(nuevaCiudad) { // para facilitar los tests
		ciudades.add(nuevaCiudad)
	}

	method estaEndeudado() = dinero < 0

	method esMasPoderosoQue(otroImperio) = self.cantidadCiudadesGrosas() > otroImperio.cantidadCiudadesGrosas()

	method cantidadCiudadesGrosas() = ciudades.filter{ ciudad => ciudad.esGrosa() }.size()

	method seEndeudariaAlConstruir(ciudad, unEdificio) = dinero - unEdificio.costoConstruccion(ciudad) < 0

	method gastarPepines(pepines) {
		dinero -= pepines
	}

	method evolucionar() {
		ciudades.forEach{ ciudad => ciudad.responderAEvolucion()}
	}

	method ganarPepines(pepines) {
		dinero += pepines
	}

}

// ---------------------------------------- Ciudad ---------------------------------------- //
class Ciudad {

	const property imperio // se decidió realizar la bilateralidad, pues de lo contrario una ciudad nunca sabrá si el imperio en el cual se encuentra está endeudado o no
	var property habitantes
	var property edificios = []
	var property sistemaImpositivo
	var property unidadesMilitares

	method agregarEdificio(nuevoEdificio) {
		edificios.add(nuevoEdificio)
	}

	method esFeliz() = if (imperio.estaEndeudado()) false else self.tranquilidadTotal() > self.disconformidadHabitantes()

	method tranquilidadTotal() = edificios.sum{ edificio => edificio.tranquilidad() }

	method disconformidadHabitantes() = habitantes.div(10000) + self.unidadesMilitaresApostadas().min(30)

	method unidadesMilitaresApostadas() = edificios.sum{ edificio => edificio.unidadesMilitaresQueOtorga() }

	method esGrosa() = habitantes > 1000000 || (edificios.size() >= 20 && self.unidadesMilitaresApostadas() > 10)

	method construirEdificio(nuevoEdificio) {
		if (imperio.seEndeudariaAlConstruir(self, nuevoEdificio)) {
			throw new ImperioSeEndeudariaException(message = "El imperio se endeudaría si construye este edificio en una de sus ciudades")
		}
		if (!nuevoEdificio.cumpleRestricciones(self)) {
			throw new CiudadNoCumpleRestriccionesParaEdificioException(message = "La ciudad no cumple con las restricciones necesarias para el edificio")
		}
		imperio.gastarPepines(nuevoEdificio.costoConstruccion(self))
		self.agregarEdificio(nuevoEdificio)
	}

	method aumentarPoblacion(poblacionAdicional) {
		habitantes += poblacionAdicional
	}

	method responderAEvolucion() {
		if (self.esFeliz()) {
			self.aumentarPoblacion(habitantes * 0.02)
		}
		edificios.forEach{ edificio =>
			imperio.gastarPepines(edificio.costoMantenimiento(self))
			edificio.responderAEvolucion(self)
		}
	}

	method ganarUnidadesMilitares(unidades) {
		unidadesMilitares += unidades
	}

	method gastosExtras(edificio) = sistemaImpositivo.gastosExtras(self, edificio)

	method aportarPepinesAlImperio(pepines) {
		imperio.ganarPepines(pepines)
	}

}

// ---------------------------------------- Edificios ---------------------------------------- //
class Edificio {

	const property costoConstruccionBase

	method costoConstruccion(ciudad) = costoConstruccionBase + ciudad.gastosExtras(self)

	method tranquilidad()

	method cumpleRestricciones(ciudad) = true

	method costoMantenimiento(ciudad) = self.costoConstruccion(ciudad) * 0.01

	method responderAEvolucion(ciudad)

	method culturaQueIrradia() = 0

}

class Economico inherits Edificio {

	const property dineroQueGenera

	override method tranquilidad() = 3

	// method culturaQueIrradia() = 0
	method unidadesMilitaresQueOtorga() = 0

	override method responderAEvolucion(ciudad) {
		ciudad.aportarPepinesAlImperio(dineroQueGenera)
	// ciudad.imperio().ganarPepines(dineroQueGenera)
	}

}

class Cultural inherits Edificio {

	const property culturaQueIrradia

	override method tranquilidad() = culturaQueIrradia * 3

	override method culturaQueIrradia() = culturaQueIrradia

	override method responderAEvolucion(ciudad) {
	}

	method unidadesMilitaresQueOtorga() = 0

}

class Militar inherits Edificio {

	const property unidadesMilitaresQueOtorga

	override method tranquilidad() = 0

	// method culturaQueIrradia() = 0
	override method cumpleRestricciones(ciudad) = ciudad.habitantes() > 20000

	override method responderAEvolucion(ciudad) {
		ciudad.ganarUnidadesMilitares(unidadesMilitaresQueOtorga)
	}

}

// ---------------------------------------- Sistemas impositivos ---------------------------------------- //
object citadino {

	method gastosExtras(ciudad, edificio) = edificio.costoConstruccionBase() * 0.05 * (ciudad.habitantes().div(25000))

}

object incentivoCultural {

	method gastosExtras(ciudad, edificio) = edificio.culturaQueIrradia() / -3

}

class Apaciguador {

	const property porcentaje

	method gastosExtras(ciudad, edificio) = if (ciudad.esFeliz()) edificio.costoConstruccionBase() * porcentaje else -1 * edificio.tranquilidad()

}

// ---------------------------------------- Excepciones ---------------------------------------- //
class ImperioSeEndeudariaException inherits DomainException {

}

class CiudadNoCumpleRestriccionesParaEdificioException inherits DomainException {

}

// ---------------------------------------- Puntos de entrada de requerimientos ---------------------------------------- //
/* Punto de entrada ejercicio 1)
 * Para poder saber si una ciudad es feliz, se lleva a cabo el pasaje del mensaje: ciudad.esFeliz()
 * Posterior a ello la ciudad consulta al imperio, en donde cumple el papel de ciudad, si el imperio está endeudado o no mediante
 * el pasaje del mensaje: imperio.estaEndeudado().
 * Para poder saber la disconformidad de los habitantes, una ciudad se autodelega en el método disconformidadHabitantes() y
 * se autodelega también para saber la tranquilidad total en el método tranquilidadTotal()
 * 
 * Punto de entrada ejercicio 2)
 * El punto de entrada de este requerimiento se realiza en un Imperio mediante el pasaje del mensaje: esMasPoderosoQue(otroImperio).
 * Este método delega a su vez en ambos imperios que están siendo comparados mediante el mensaje cantidadCiudadesGrosas().
 * cantidadCiudadesGrosas() delega en cada ciudad el método de consulta esGrosa(), con la finalidad de que cada ciudad pueda
 * decirnos si son grosas o no.
 * 
 * Punto de entrada ejercicio 3)
 * Para saber el costo de construcción del edificio, en una cierta ciudad, el punto de partida comienza desde un edificio mediante el
 * pasaje del mensaje: edificio.costoConstruccion(ciudad). Posteriormente, el edificio se delega a sí mismo en ciudad.gastosExtras(self)
 * para que la ciudad, que fue pasada por parámetro, pueda encargarse de consultar a su sistema impositivo, el cual se basa en la ciudad y el tipo de edificio.
 * 
 * Para poder construir un cierto edificio en una ciudad, se debe comenzar mediante el pasaje del mensaje: ciudad.construirEdificio(nuevoEdificio)
 * El mismo debe poder gastar los pepines del imperio en base al costo de construcción del edificio, y agregar el edificio a la ciudad.
 * Para esto se realiza una delegación en imperio: imperio.gastarPepines(nuevoEdificio.costoConstruccion()), y para poder añadir el edificio
 * a la ciudad, mediante una autodelegación: self.agregarEdificio(nuevoEdificio). No obstante, previamente se debe verificar si el edificio
 * no endeudaría al imperio en caso de que se lo construya y que la ciudad cumpla las restricciones para poder construir el edificio. Esto
 * es posible mediante el pasaje del mensaje: imperio.seEndeudariaAlConstruir(self, nuevoEdificio), delegando en el imperio, y nuevoEdificio.cumpleRestricciones(self),
 * delegando en el nuevo edificio a construir.
 * 
 * Punto de entrada ejercicio 4)
 * Para poder evolucionar un imperio, la cumplimentación requerimiento comienza mediante: imperio.evolucionar(). Este delgación, realizada
 * en imperio, delega a su vez en cada ciudad el mensaje responderAEvolucion(), en donde cada ciudad se ve encargada en verificar si es feliz,
 * producir un efecto sobre imperio en base a los costos de mantenimientos de los edificios que posee, y que cada tipo de edificio haga su
 * gracia a la hora de responder a la evolución del imperio.
 * Para saber si una ciudad es feliz, se autodelega, como en el punto de entrada del ejercicio 1), mediante el pasaje del mensaje: self.esFeliz().
 * Para poder producir un efecto sobre los pepines del imperio, una ciudad delega en imperio de la forma: imperio.gastarPepines(edificio.costoMantenimiento()),
 * siendo el imperio el responsable en gastar dichos pepines, en donde la cantidad de pepines se ve especificada mediante el costo de mantenimiento de cada edificio
 * en cada ciudad pertinente.
 * Como último paso de este requerimiento, los edificios son los encargados de hacer su gracia a la hora de responder a la revolución del imperio. El punto
 * de partida es mediante el pasaje del mensaje: edificio.responderAEvolucion(self).
 */
