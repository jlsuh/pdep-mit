class Vagon {

	method cantidadPasajerosQuePuedeTransportar() = 0

	method cargaMaximaQuePuedeTransportar() = 0

	method pesoMaximo()

	method esLiviano() = self.pesoMaximo() < 2500

}

class VagonDePasajeros inherits Vagon {

	const property largo
	const property anchoUtil

	override method cantidadPasajerosQuePuedeTransportar() = if (anchoUtil > 2.5) largo * 10 else largo * 8

	override method pesoMaximo() = self.cantidadPasajerosQuePuedeTransportar() * 80

}

class VagonDeCarga inherits Vagon {

	const property cargaMaxima

	override method cargaMaximaQuePuedeTransportar() = cargaMaxima

	override method pesoMaximo() = self.cargaMaximaQuePuedeTransportar() + 160

}

