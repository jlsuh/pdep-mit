import habitantes.*

object casa {

	var property caramelos = 100
	var property caos = 0
	var property quienAbreLaPuerta = azucena

	method image() = "casa.png"

	method estaEnOrden() {
		return caos < 3
	}

	method abrirleA(alguien) {
		caramelos = (caramelos - alguien.pedirCaramelos(quienAbreLaPuerta)).max(0)
		caos += alguien.hacerBullicio()
	}

	method cerrarLaPuerta() {
		quienAbreLaPuerta.luegoDeCerrarLaPuerta(self)
	}

	method saludo() {
		if (self.seTerminoLaDiversion()) {
			return "¡Suficiente por hoy! Nos vamos a dormir."
		}
		return quienAbreLaPuerta.saludo()
	}

	method seTerminoLaDiversion() {
		return caramelos == 0 || caos > 20
	}

	// El saludador va a ser el juego cuando se corra el programa de esa forma.
	// Desde los tests puede ser lo que más nos sirva para validar el funcionamiento del programa :D
	method teVisita(alguien, saludador) {
		self.abrirleA(alguien)
		saludador.say(self, self.saludo())
		self.cerrarLaPuerta()
	}

}

