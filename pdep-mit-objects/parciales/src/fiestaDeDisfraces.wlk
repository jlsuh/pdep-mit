class Fiesta {

	var property asistentes = []
	const property fecha
	const property lugar

	// fiesta.putanejDisfraz(unaPersona)
	method puntajeDisfraz(unaPersona) {
		self.validarInvitadoALaFiesta(unaPersona)
		return unaPersona.puntajeDisfraz(self)
	}

	method estaEnLaFiesta(unaPersona) = asistentes.contains(unaPersona)

	// fiesta.esUnBodrio()
	method esUnBodrio() = asistentes.all{ asistente => !asistente.estaConformeConSuDisfraz(self) }

	// fiesta.mejorDisfrazDeLaFiesta()
	method mejorDisfrazDeLaFiesta() = asistentes.max{ asistente => self.puntajeDisfraz(asistente) }.disfraz()

	// fiesta.intercambiarTrajes(unAsistente, otroAsistente)
	method intercambiarTrajes(unAsistente, otroAsistente) {
		self.validarInvitadoALaFiesta(unAsistente)
		self.validarInvitadoALaFiesta(otroAsistente)
		return self.algunoEstaDisconformeConSuDisfraz(unAsistente, otroAsistente) && self.pasarianAEstarConformesAlCambiarDeDisfraz(unAsistente, otroAsistente)
	}

	method pasarianAEstarConformesAlCambiarDeDisfraz(unAsistente, otroAsistente) = unAsistente.pasariaAEstarConformeConDisfraz(self, otroAsistente.disfraz()) && otroAsistente.pasariaAEstarConformeConDisfraz(self, unAsistente.disfraz())

	method algunoEstaDisconformeConSuDisfraz(unAsistente, otroAsistente) = !unAsistente.estaConformeConSuDisfraz(self) || !otroAsistente.estaConformeConSuDisfraz(self)

	method validarInvitadoALaFiesta(unAsistente) {
		if (!self.estaEnLaFiesta(unAsistente)) {
			throw new PersonaNoInvitadaALaFiesta(message = "La persona no fue invitada a la fiesta")
		}
	}

	// fiesta.agregarAsistente()
	method agregarAsistente(nuevoAsistente) {
		if (!nuevoAsistente.tieneDisfraz() || self.estaEnLaFiesta(nuevoAsistente)) {
			throw new NoSePuedeAgregarNuevoAsistenteALaFiestaException(message = "El asistente no cumple los requisitos para agregarlo a la fiesta")
		}
		asistentes.add(nuevoAsistente)
	}

	// fiesta.esFiestaInolvidable()
	method esFiestaInolvidable() = asistentes.all{ asistente => asistente.esSexy() && asistente.estaConformeConSuDisfraz(self) }

}

class Persona {

	var property disfraz
	var property edad = 0
	var property personalidad

	method puntajeDisfraz(unaFiesta) = disfraz.puntaje(unaFiesta, self)

	method esMayorDe(edadPretendida) = edad > edadPretendida

	method esSexy() = personalidad.esSexy(self)

	method estaConformeConSuDisfraz(unaFiesta) = self.puntajeDisfraz(unaFiesta) > 10

	method pasariaAEstarConformeConDisfraz(unaFiesta, unDisfraz) {
		const personaConNuevoDisfraz = new Persona(disfraz = unDisfraz, edad = edad, personalidad = personalidad)
		return personaConNuevoDisfraz.estaConformeConSuDisfraz(unaFiesta)
	}

	method tieneDisfraz() = disfraz != sinDisfraz

}

class Caprichoso inherits Persona {

	override method estaConformeConSuDisfraz(unaFiesta) = super(unaFiesta) && disfraz.nombreTieneCantidadParDeLetras()

}

class Pretencioso inherits Persona {

	override method estaConformeConSuDisfraz(unaFiesta) = super(unaFiesta) && disfraz.confeccionadoHaceMenosDeCiertosDias(unaFiesta)

}

class Numerologo inherits Persona {

	var cifraQueDetermina

	override method estaConformeConSuDisfraz(unaFiesta) = super(unaFiesta) && self.puntajeDisfraz(unaFiesta) == cifraQueDetermina

}

object alegre {

	method esSexy(unaPersona) = false

}

object taciturna {

	method esSexy(unaPersona) = unaPersona.edad() < 30

}

object cambiante {

	method esSexy(unaPersona) = if (0.randomUpTo(2).roundUp() > 1) taciturna.esSexy(unaPersona) else alegre.esSexy(unaPersona)

}

object sinDisfraz {

}

class Disfraz {

	const property nombre
	var property caracteristicas = #{}
	const property fechaConfeccionada

	method puntaje(unaFiesta, unaPersona) {
		if (caracteristicas.size() > 0) {
			caracteristicas.sum{ caracteristica => caracteristica.puntosQueAporta(unaFiesta, unaPersona)}
		}
		return 0
	}

	method nombreTieneCantidadParDeLetras() = nombre.size().even()

	method confeccionadoHaceMenosDeCiertosDias(unaFiesta) = fechaConfeccionada.plusDays(30) > unaFiesta.fecha()

}

class Gracioso {

	const property nivelDeGracia

	method puntosQueAporta(unaFiesta, unaPersona) = nivelDeGracia * if(unaPersona.esMayorDe(50)) 3 else 1

}

class Tobara {

	const property diaEnQueFueComprado

	method puntosQueAporta(unaFiesta, unaPersona) {
		diaEnQueFueComprado.plusDays(2)
		return if (diaEnQueFueComprado <= unaFiesta.fecha()) 5 else 3
	}

}

class Careta {

	const property personajeRealQueSimula

	method puntosQueAporta(unaFiesta, unaPersona) = personajeRealQueSimula.puntosQueAporta()

}

object sexy {

	method puntosQueAporta(unaFiesta, unaPersona) = if (unaPersona.esSexy()) 15 else 2

}

class PersonajeReal {

	const property puntosQueAporta

}

class PersonaNoInvitadaALaFiesta inherits DomainException {

}

class NoSePuedeAgregarNuevoAsistenteALaFiestaException inherits DomainException {

}

