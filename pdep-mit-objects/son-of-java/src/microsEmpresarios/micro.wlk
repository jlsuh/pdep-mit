class Micro {

	const property maximoParados
	const property maximoSentados
	const property volumen
	var parados = 0
	var sentados = 0

	method parados() {
		return parados
	}

	method sentados() {
		return sentados
	}

	method sePuedeIrParado() {
		return maximoParados - parados > 0
	}

	method sePuedeIrSentado() {
		return maximoSentados - sentados > 0
	}

	method lugaresLibres() {
		return self.maximoParados() + self.maximoSentados() - self.parados() + self.sentados()
	}

	method puedeSubirse(unaPersona) {
		return self.lugaresLibres() > 0 && unaPersona.aceptaSubirse(self)
	}

	method estaVacio() {
		return parados == 0 && sentados == 0
	}

	// TODO: He creado un monstruo que juré destruir
	method subir(unaPersona) {
		if (self.puedeSubirse(unaPersona)) {
			if (self.sePuedeIrSentado()) {
				sentados += 1
				unaPersona.estaEnMicro(true)
				unaPersona.vaSentado(true)
			} else if (self.sePuedeIrParado()) {
				parados += 1
				unaPersona.estaEnMicro(true)
			}
		} else {
			self.error("Micro lleno")
		}
	}

	method bajar(unaPersona) {
		if (self.estaVacio()) {
			self.error("Micro vacío")
		} else {
			if (unaPersona.estaEnMicro()) {
				if (unaPersona.vaSentado()) {
					sentados -= 1
					unaPersona.estaEnMicro(false)
					unaPersona.vaSentado(false)
				} else {
					parados -= 1
					unaPersona.estaEnMicro(false)
				}
			} else {
				self.error("Persona no está en micro")
			}
		}
	}

}

