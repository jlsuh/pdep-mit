class Presidente {

	var property actosDeGobierno
	const property anioDefusion

	method imagenPositiva() {
		const imagenPositivaBase = actosDeGobierno.sum{ acto => acto.impacto() }
		const anioActual = new Date().year()
		return imagenPositivaBase + imagenPositivaBase * 0.01 * (anioActual - anioDefusion)
	}

}

class ActoDeGobierno {

	const property poblacionImplicada
	const property importancia

	method impacto() = poblacionImplicada * importancia

	method estaCumplida() = true

	method cumplir() {
	}

}

class InauguracionDeObra inherits ActoDeGobierno {

	const property naturaleza

	override method impacto() {
		const impactoBase = super()
		return impactoBase + impactoBase * naturaleza
	}

}

class Discurso inherits ActoDeGobierno {

	const property intensidadAplauso

	override method impacto() = super() * intensidadAplauso

}

class Promesa inherits Discurso {

	var property estaCumplida

	override method impacto() {
		if (estaCumplida) {
			return super() * 2
		}
		return super() * -1
	}

	override method cumplir() {
		estaCumplida = true
	}

}

class DenunciaDeCorrupcionPorTV inherits ActoDeGobierno {

	const property denunciante

	override method impacto() {
		return -1 * super() * denunciante.magnitud(poblacionImplicada)
	}

}

class Denunciante {

	method magnitud(poblacionImplicada)

}

class Periodista inherits Denunciante {

	override method magnitud(audiencia) = audiencia / 2

}

class Politico inherits Denunciante {

	var property seguidoresEnRedesSociales

	override method magnitud(audiencia) = seguidoresEnRedesSociales.min(audiencia)

}

// presidentes //
const presidentes = [ domingoFaustinoSarmiento, macriGato ]

// Domingo Faustino Sarmiento //
const poblacion1870 = 1830214

const domingoFaustinoSarmiento = new Presidente(actosDeGobierno = [ instalacionOficinasMeteorologicas, fundacionColegioMilitar, fundacionColegioNaval, creacionJardinZoologico, guerraDelParaguay ], anioDefusion = 1888)

const instalacionOficinasMeteorologicas = new InauguracionDeObra(importancia = 50, naturaleza = 0.7 /*tecnológica*/ , poblacionImplicada = poblacion1870)

const fundacionColegioMilitar = new InauguracionDeObra(importancia = 10, naturaleza = 0.3 /*militar*/ , poblacionImplicada = poblacion1870)

const fundacionColegioNaval = new InauguracionDeObra(importancia = 10, naturaleza = 0.3 /*militar*/ , poblacionImplicada = poblacion1870)

const creacionJardinZoologico = new InauguracionDeObra(importancia = 5, naturaleza = 0.1 /*fauna*/ , poblacionImplicada = poblacion1870)

const guerraDelParaguay = new Promesa(estaCumplida = true, intensidadAplauso = 200, poblacionImplicada = poblacion1870, importancia = 1)

// Mauricio Macri //
const poblacion2018 = 44494500

const macriGato = new Presidente(actosDeGobierno = [ pasaronCosas, metroBus ], anioDefusion = 2020)

const pasaronCosas = new Promesa(intensidadAplauso = 10, poblacionImplicada = poblacion2018, importancia = 1, estaCumplida = false)

const metroBus = new InauguracionDeObra(naturaleza = 0.1 /*viales*/ , poblacionImplicada = poblacion2018, importancia = 2)

