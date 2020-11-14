/* Notas:
 * - La necesidad de definir una superclase nace de poder compartir un mismo comportamiento
 * - Las delegaciones deben tener sentido
 * 
 */

class Pirata {

	var property monedas = 0
	var property items = [] // Por ejemplo: el pirata Barbanegra tiene una brújula, dos cuchillos, un diente de oro y tres botellas de grogXD
	var property ebriedad

	method tiene(unItem) = items.contains(unItem)

	method cantidadItems() = items.size()

	method pasadoDeGrogXD() = ebriedad >= 90

	method puedePagar(precio) = precio <= monedas

	method tomarTragoGrogXD(ciudadCostera) {
		ebriedad += 5
		self.gastar(ciudadCostera)
	}

	method gastar(ciudadCostera) {
		if (self.puedePagar(ciudadCostera.precioTragoGrogXD())) {
			monedas -= ciudadCostera.precioTragoGrogXD()
		} else {
			self.error("PirataNoPoseeSuficientesMonedasException")
		}
	}

	method seAnimaASaquearA(unaVictima) = unaVictima.puedeSerSaqueadoPor(self)

}

const brujula = "brujula"

const mapa = "mapa"

const botellaGrogXD = "botella grogXD"

const llaveDeCofre = "llave de cofre"

const permisoDeLaCorona = "permiso de la corona"

class EspiraDeLaCorona inherits Pirata {

	override method pasadoDeGrogXD() = false

	override method seAnimaASaquearA(unaVictima) = super(unaVictima) && self.tiene(permisoDeLaCorona)

}

class Mision {

	method leEsUtil(unPirata)

	method puedeSerRealizadaPor(unBarco) = unBarco.superaPorcentajeDeCapacidad(90) && self.cumpleCondicionesParaRealizarla(unBarco)
											// Justo acá se puede ver que todas las misiones deben cumplir que tengan el 90% de tripulación que su tripulación máxima
											
	method cumpleCondicionesParaRealizarla(unBarco) = true

}

class BusquedaDelTesoro inherits Mision {

	const itemsUtiles = #{ brujula, mapa, botellaGrogXD }

	override method leEsUtil(unPirata) = itemsUtiles.any{ itemUtil => unPirata.tiene(itemUtil) } && unPirata.monedas() <= 5

	override method cumpleCondicionesParaRealizarla(unBarco) = unBarco.tripulacion().any{ tripulante => tripulante.tiene(llaveDeCofre) }

}

class ConvertirseEnLeyenda inherits Mision {

	const property itemObligatorio

	override method leEsUtil(unPirata) = unPirata.cantidadItems() >= 10 && unPirata.tiene(itemObligatorio)

}

object configuracionSaqueo {

	var property dineroMaximo = 0

}

class Saqueo inherits Mision {

	const property victima

	method dineroMaximo() = configuracionSaqueo.dineroMaximo()

	override method leEsUtil(unPirata) = unPirata.monedas() < self.dineroMaximo() && victima.puedeSerSaqueadoPor(unPirata)

	override method cumpleCondicionesParaRealizarla(unBarco) = victima.esVulnerableA(unBarco)

}

/* Observación:
 * Se podría pensar que BarcoPirata y CiudadCostera hereden una superclase llamada VictimaSaqueo. No obstante, como ambas no comparten ninguna lógica en común,
 * basta con que ambas sean polimórficas -léase "entiendan el mismo mensaje"-.
 */
class BarcoPirata {

	var property mision
	const property capacidadMaxima
	var property tripulacion = #{}

	method puedeSerSaqueadoPor(unPirata) = unPirata.pasadoDeGrogXD()

	method tamanioTripulacion() = tripulacion.size()

	method puedeFormarParteDeTripulacion(unPirata) = self.tamanioTripulacion() < capacidadMaxima && mision.leEsUtil(unPirata)

	method incorporarATripulacionA(unPirata) {
		if (self.puedeFormarParteDeTripulacion(unPirata)) {
			tripulacion.add(unPirata)
		} else {
			self.error("PirataNoPuedeFormarParteDeTripulacionException")
		}
	}

	method cambiarMision(nuevaMision) {
		mision = nuevaMision
		const piratasInservibles = tripulacion.filter{ pirata => !mision.leEsUtil(pirata) }
		tripulacion.removeAll(piratasInservibles)
	}

	method tripulantesUtilesParaMisionAsignada() = tripulacion.filter{ pirata => mision.leEsUtil(pirata) }.size()

	method esTemible() = self.puedeRealizarMisionAsignada() && self.tripulantesUtilesParaMisionAsignada() >= 5

	method puedeRealizarMisionAsignada() = mision.puedeSerRealizadaPor(self)

	method superaPorcentajeDeCapacidad(porcentaje) = self.tamanioTripulacion() * 100 / capacidadMaxima >= porcentaje

	method esVulnerableA(unBarco) = capacidadMaxima <= unBarco.tamanioTripulacion() / 2

	method itemsTripulacion() = tripulacion.flatMap{ tripulante => tripulante.items() }

	method itemMasRaro() = self.itemsTripulacion().min{ item => self.cantidadTripulantesQueTiene(item) }

	method cantidadTripulantesQueTiene(item) = tripulacion.count{ tripulante => tripulante.tiene(item) }

	method elMasEbrio() = tripulacion.max{ tripulante => tripulante.ebriedad() }

	method anclarEn(ciudadCostera) {
		tripulacion.filter{ tripulante => tripulante.puedePagar(ciudadCostera.precioTragoGrogXD())}.forEach{ tripulante => tripulante.tomarTragoGrogXD(ciudadCostera)}
		tripulacion.remove(self.elMasEbrio())
		ciudadCostera.quedarConUnHabitanteMas()
	}

}

class CiudadCostera {

	var property habitantes
	var property precioTragoGrogXD

	method puedeSerSaqueadoPor(unPirata) = unPirata.ebriedad() >= 50

	method esVulnerableA(unBarco) = unBarco.tamanioTripulacion() >= habitantes * 0.4 || unBarco.tripulacion().all{ pirata => pirata.pasadoDeGrogXD() }

	method quedarConUnHabitanteMas() {
		habitantes += 1
	}

}

