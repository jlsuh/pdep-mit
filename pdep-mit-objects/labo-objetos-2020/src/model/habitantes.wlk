import casa.*

object azucena {

	method leGusta(disfraz) {
		return disfraz.esAdorable()
	}

	method caramelosQueDa(disfraz) {
		if (self.leGusta(disfraz)) {
			return disfraz.ternura()
		}
		return 5
	}

	method saludo() {
		return "¡Ay, qué miedo! Jaja"
	}

	method siguienteQueAbre() {
		return jorge
	}

	method luegoDeCerrarLaPuerta(casa) {
		if (casa.caramelos() >= 5) {
			casa.caramelos(casa.caramelos() - 1)
			casa.quienAbreLaPuerta(self.siguienteQueAbre())
		}
	}

}

object sandra {

	method leGusta(disfraz) {
		return disfraz.masTiernoQueAterrador()
	}

	method caramelosQueDa(disfraz) {
		if (casa.estaEnOrden()) {
			return 8
		}
		return 2
	}

	method saludo() {
		if (casa.estaEnOrden()) {
			return "¡Pasalo lindo y no hagas lío!"
		}
		return "¬¬"
	}

	method siguienteQueAbre() {
		return azucena
	}

	method luegoDeCerrarLaPuerta(casa) {
		casa.quienAbreLaPuerta(self.siguienteQueAbre())
	}

}

object jorge {

	method leGusta(disfraz) {
		return disfraz.esTerrorifico()
	}

	method caramelosQueDa(disfraz) {
		if (casa.caramelos() >= 50) {
			return 10
		}
		return 4
	}

	method saludo() {
		return "¡Feliz Navidad!"
	}

	method siguienteQueAbre() {
		return sandra
	}

	method luegoDeCerrarLaPuerta(casa) {
		casa.caos(casa.caos() - 2)
		casa.quienAbreLaPuerta(self.siguienteQueAbre())
	}

}

