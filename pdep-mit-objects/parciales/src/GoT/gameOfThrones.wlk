class Acompaniante {

	method patrimonio() = 0

	method esPeligroso() = true

}

class Personaje inherits Acompaniante {

	var property casa
	var property conyuges = #{}
	var property acompaniantes = #{}
	var property estaVivo = true

	method cantidadConyuges() = conyuges.size()

	method puedeCasarseCon(otroPersonaje) {
		return casa.admiteCasamiento(self, otroPersonaje) && otroPersonaje.casa().admiteCasamiento(otroPersonaje, self)
	}

	method aniadirConyuge(nuevoConyuge) {
		conyuges.add(nuevoConyuge)
	}

	method casar(otroPersonaje) {
		if (!self.puedeCasarseCon(otroPersonaje)) {
			self.error("PersonajesNoSePuedenCasarException")
		}
		self.aniadirConyuge(otroPersonaje)
		otroPersonaje.aniadirConyuge(self)
	}

	override method patrimonio() = casa.patrimonio() / casa.cantidadMiembros()

	method aniadirAcompaniante(nuevoAcompaniante) {
		acompaniantes.add(nuevoAcompaniante)
	}

	method cantidadAcompaniantes() = acompaniantes.size()

	method estaSole() = self.cantidadAcompaniantes() == 0

	method aliades() {
//		var aliades = acompaniantes + conyuges + casa.miembros()
//		aliades = aliades.asSet()	<- acá se necesitaba que sea var, puesto que comenzaba a referenciar un set
		const aliades = acompaniantes + conyuges + casa.miembros()
		aliades.remove(self) // acá no cambia la referencia, sino que el valor en dicha referencia
		return aliades
	}

	method dineroEntreSusAliados() = self.aliades().sum{ aliade => aliade.patrimonio() }

	override method esPeligroso() {
		if (estaVivo) {
			return self.dineroEntreSusAliados() >= 10000 || conyuges.all{ conyuge => conyuge.casa().esRica() } || self.aliades().any{ aliade => aliade.esPeligroso() }
		}
		return false
	}

	method estaSoltero() = conyuges.size() == 0

	method derrocharFortunaDeLaCasa(porcentajeDerroche) {
		const patrimonioOriginal = casa.patrimonio()
		casa.patrimonio(patrimonioOriginal - patrimonioOriginal * porcentajeDerroche)
	}

}

class Dragon inherits Acompaniante {

}

class Lobo inherits Acompaniante {

	const property tipo

	override method esPeligroso() = tipo == "Huargo"

}

class Casa {

	var property patrimonio
	const property ciudadProveniente
	var property miembros = []

	method aniadirMiembro(nuevoMiembro) {
		miembros.add(nuevoMiembro)
	}

	method admiteCasamiento(miembro, personaje) {
		if (miembro.casa() != self) {
			self.error("MiembroNoEsDeEstaCasaException")
		}
		return self.cumpleRestriccion(miembro, personaje)
	}

	method cumpleRestriccion(miembro, personaje)

	method esRica() = patrimonio > 1000

	method cantidadMiembros() = miembros.size()

}

object lannisterHouse inherits Casa(ciudadProveniente = "Casterly Rock") {

	override method cumpleRestriccion(miembro, personaje) {
		return miembro.cantidadConyuges() < 1
	}

}

object starkHouse inherits Casa(ciudadProveniente = "Winterfell") {

	override method cumpleRestriccion(miembro, personaje) {
		return personaje.casa() != self
	}

}

object theNightsWatch inherits Casa(ciudadProveniente = "The Wall") {

	override method cumpleRestriccion(miembro, personaje) = false

}

class Conspiracion {

	const property personajeObjetivo
	const property complotados
	var property conspiracionEjecutada = false

	constructor(_personajeObjetivo, _complotados) {
		if (!_personajeObjetivo.esPeligroso()) {
			self.error("PersonajeNoEsPeligrosoException")
		}
		personajeObjetivo = _personajeObjetivo
		complotados = _complotados
	}

	method cantidadTraidores() = complotados.size()

	method ejecutarConspiracion() {
		complotados.forEach{ conspirador => conspirador.conspirarEnContra(personajeObjetivo)}
		conspiracionEjecutada = true
	}

	method conspiracionCumplida() = conspiracionEjecutada && not personajeObjetivo.esPeligroso()

}

class Conspirador {

	method conspirarEnContra(personajeObjetivo)

}

class Sutil inherits Conspirador {

	const property casas = [ lannisterHouse, starkHouse, theNightsWatch ]

	override method conspirarEnContra(personajeObjetivo) {
		const candidatos = casas.min{ casa => casa.patrimonio() }.miembros().filter{ miembro => miembro.estaSoltero() && miembro.estaVivo() }
		if (candidatos.size() == 0) {
			self.error("NoHayCandidatosException")
		}
		personajeObjetivo.casar(candidatos.get(0))
	}

}

class Asesino inherits Conspirador {

	override method conspirarEnContra(personajeObjetivo) {
		personajeObjetivo.estaVivo(false)
	}

}

class AsesinoPrecavido inherits Asesino {

	override method conspirarEnContra(personajeObjetivo) {
		if (personajeObjetivo.estaSole()) {
			super(personajeObjetivo)
		}
	}

}

class Disipado inherits Conspirador {

	const property porcentajeDerroche

	override method conspirarEnContra(personajeObjetivo) {
		personajeObjetivo.derrocharFortunaDeLaCasa(porcentajeDerroche)
	}

}

class Miedoso inherits Conspirador {

	override method conspirarEnContra(personajeObjetivo) {
	}

}

