/* Correcciones a considerar:
 * - Se realizaron varias delegaciones que no son significativas
 * - Hubo un gran conflicto para definir responsabilidades
 * - Se debe mejorar cómo controlar los efectos no deseados sobre los objetos
 */

class Mision {

	method leEsUtil(unPirata)

	method puedeRealizarla(unBarco) = true

}

class BusquedaDelTesoro inherits Mision {

	const itemsUtiles = [ new Item(nombre = "brujula"), new Item(nombre = "mapa"), new Item(nombre = "botellaDeGrogXD") ]
	const dineroMaximo = 5

	override method leEsUtil(unPirata) {
		return unPirata.tieneItems(itemsUtiles) && unPirata.tieneMenosDineroQue(dineroMaximo)
	}

	override method puedeRealizarla(unBarco) = unBarco.alguienTiene(new Item(nombre = "llave de cofre"))

}

class ConvertirseEnLeyenda inherits Mision {

	const property itemObligatorio
	const cantidadMinimaItems = 10

	override method leEsUtil(unPirata) {
		return unPirata.superaAlMenosCantidadItems(cantidadMinimaItems) && unPirata.tieneItems([ itemObligatorio ])
	}

}

class Saqueo inherits Mision {

	const property victima
	var property dineroMaximo

	override method leEsUtil(unPirata) {
		return unPirata.tieneMenosDineroQue(dineroMaximo) && unPirata.seAnimaASaquear(victima)
	}

	override method puedeRealizarla(unBarco) {
		return victima.esVulnerableA(unBarco)
	}

}

class Pirata {

	var property items = []
	var property dinero = 0
	var property nivelEbriedad

	method esUtilPara(unaMision) = unaMision.leEsUtil(self)

	method seAnimaASaquear(victimaSaqueo) = victimaSaqueo.puedeSerSaqueadoPor(self)

	method pasadoDeGrogXD() = self.superaEbriedadDeNivel(90) && self.tieneItems([ new Item(nombre = "botellaDeGrogXD") ]) // items.contains("botellaDeGrogXD")

	method tieneItems(itemsNecesarios) {
		return items.any{ item => itemsNecesarios.any{ itemNecesario => item.nombre() == itemNecesario.nombre()} }
	}

	method cantidadItems() = items.size()

	method superaEbriedadDeNivel(nivel) = nivelEbriedad >= nivel

	method tieneMenosDineroQue(dineroMaximo) = dinero < dineroMaximo

	method superaAlMenosCantidadItems(cantidadMinima) = self.cantidadItems() >= cantidadMinima

	method puedeFormarParteDeTripulacion(unBarco) {
		return unBarco.tieneLugarParaUnoMas() && self.esUtilPara(unBarco.mision())
	}

	method emborracharse(unidades) {
		nivelEbriedad += unidades
	}

	method pagarTragoGrogXD(ciudadCostera) {
		const precioTrago = ciudadCostera.precioDeTragoGrogXD()
		if (precioTrago > dinero) {
			self.error("PirataNoPoseeDineroSuficienteException")
		}
		self.emborracharse(5)
		dinero -= precioTrago
	}

}

class EspiaDeLaCorona inherits Pirata {

	override method pasadoDeGrogXD() = false

	override method seAnimaASaquear(victimaSaqueo) = super(victimaSaqueo) && self.tieneItems([ new Item(nombre = "Permiso de la corona") ])

}

class Victima {

	method puedeSerSaqueadoPor(unPirata)

	method esVulnerableA(unBarco)

}

class BarcoPirata inherits Victima {

	var property mision
	const property tripulacionMaxima
	var property tripulacionActual = []

	override method puedeSerSaqueadoPor(unPirata) = unPirata.pasadoDeGrogXD()

	method tamanioTripulacion() = tripulacionActual.size()

	method tieneLugarParaUnoMas() = self.tamanioTripulacion() + 1 <= tripulacionMaxima

	method incorporarATripulacion(unPirata) {
		if (!self.tieneLugarParaUnoMas()) { // TODO: qué pasaría si el pirata ya es parte de la tripulación? Controlar o no?
			self.error("NoHayLugarParaUnoMasException")
		}
		tripulacionActual.add(unPirata)
	}

	method mision(nuevaMision) {
		mision = nuevaMision
		tripulacionActual.forEach{ tripulante =>
			if (!tripulante.esUtilPara(nuevaMision)) {
				tripulacionActual.remove(tripulante)
			}
		}
	}

	method cantidadDeTripulantesUtilesParaMisionActual() {
		return tripulacionActual.map{ tripulante => tripulante.esUtilPara(mision) }.size()
	}

	method esTemible() {
		return self.puedeRealizarMisionAsignada() && self.cantidadDeTripulantesUtilesParaMisionActual() >= 5
	}

	method tieneSuficienteTripulacion() {
		return self.tamanioTripulacion() >= tripulacionMaxima * 0.9
	}

	method puedeRealizarMisionAsignada() {
		return self.tieneSuficienteTripulacion() && mision.puedeRealizarla(self)
	}

	method alguienTiene(items) {
		return tripulacionActual.any{ tripulante => tripulante.tieneItems(items) }
	}

	override method esVulnerableA(otroBarco) {
		return tripulacionMaxima == otroBarco.tamanioTripulacion().div(2)
	}

	method todaTripulacionEstaPasadaDeGrogXD() {
		return tripulacionActual.all{ tripulante => tripulante.pasadoDeGrogXD() }
	}

	method itemMasRaro() {
		const itemsDeTodaLaTripulacion = tripulacionActual.flatMap{ tripulante => tripulante.items() }
		itemsDeTodaLaTripulacion.min{ item => itemsDeTodaLaTripulacion.occurrencesOf(item)}
	}

	method elMasEbrioDeEntreLaTripulacion() {
		return tripulacionActual.max{ tripulante => tripulante.nivelEbriedad() }
	}

	method anclarEn(ciudadCostera) {
		tripulacionActual.forEach{ tripulante => tripulante.pagarTragoGrogXD(ciudadCostera)}
		tripulacionActual.remove(self.elMasEbrioDeEntreLaTripulacion())
			// ciudadCostera.recibirAlMasEbrio()
		ciudadCostera.habitantes(ciudadCostera.habitantes() + 1) // TODO: Cuestionarse esto. Correcto uso del setter?
	}

}

class CiudadCostera inherits Victima {

	const ebriedadMinima = 50
	var property habitantes
	const property precioDeTragoGrogXD

	override method puedeSerSaqueadoPor(unPirata) = unPirata.superaEbriedadDeNivel(ebriedadMinima)

	override method esVulnerableA(barco) {
		return barco.tamanioTripulacion() >= habitantes * 0.4 || barco.todaTripulacionEstaPasadaDeGrogXD()
	}

//	method recibirAlMasEbrio() {
//		habitantes++
//	}
}

class Item {

	const property nombre

}

