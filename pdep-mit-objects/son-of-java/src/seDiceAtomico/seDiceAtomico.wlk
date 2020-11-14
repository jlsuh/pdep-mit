object laRegion {

	const ciudades = [ springfield, albuquerque ]

	method agregarCiudad(ciudad) = ciudades.add(ciudad)

	method principalCiudadProductora() = ciudades.max{ ciudad => ciudad.produccionEnergetica() }

	method principalesCentrales() = ciudades.flatMap{ ciudad => ciudad.centrales() }.max{ central => central.produccionEnergetica() }

}

object albuquerque {

	const property caudalRio = 150
	const property centrales = [ centralHidroelectrica ]

	method produccionEnergetica() = centrales.sum{ central => central.produccionEnergetica() }

}

object springfield {

	var property riquezaDeSuelo = 0.9
	var property velocidadViento = 10
	const property centrales = [ centralNuclear, centralCarbon, centralEolica ]
	var property necesidadEnergetica = 1

	method centralesContaminantes() = centrales.filter{ central => central.puedeContaminar() }

	method produccionEnergetica() = centrales.sum{ central => central.produccionEnergetica() }

	method cubreNecesidad() = self.produccionEnergetica() >= necesidadEnergetica

	method estaAlHorno() = self.centralesContaminantes().sum{ central => central.produccionEnergetica() } * 100 / self.produccionEnergetica() > 50

}

class Turbina {

	const property velocidadVientoCiudad
	const produccionBaseEnkWh = 0.2

	method produccionEnergetica() = produccionBaseEnkWh * velocidadVientoCiudad

}

object centralHidroelectrica {

	const produccionBaseEnkWh = 2

	method produccionEnergetica() = albuquerque.caudalRio() * produccionBaseEnkWh

}

object centralNuclear {

	var property varillasDeUranio = 200
	const produccionBaseEnkWh = 0.1

	method produccionEnergetica() = produccionBaseEnkWh * varillasDeUranio

	method puedeContaminar() = varillasDeUranio > 20

}

object centralCarbon {

	const produccionBaseEnkWh = 0.5
	var property capacidad = 1000
	const property puedeContaminar = true

	method produccionEnergetica() = produccionBaseEnkWh + capacidad * springfield.riquezaDeSuelo()

}

object centralEolica {

	const turbinas = [ new Turbina(velocidadVientoCiudad = springfield.velocidadViento()) ]
	const property puedeContaminar = false

	method produccionEnergetica() = turbinas.sum{ turbina => turbina.produccionEnergetica() }

}

