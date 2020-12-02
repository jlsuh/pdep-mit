/*
 * Nombre: Suh, Joel
 * Legajo: 167231-9
 */

object academia {

	var property experienciaMaximaParaComidasConCalidadPobre = 0
	var property estudiantes = #{}
	const recetario = #{}

	// Punto 5) academia.entrenarEstudiantes()
	method entrenarEstudiantes() {
		estudiantes.forEach{ estudiante => estudiante.prepararRecetaQueMasExperienciaAporte(recetario)}
	}

}

class Cocinero {

	const property comidasPreparadas = #{}
	var property nivelAprendizaje // principiante, experimentado, chef

	// Punto 1) cocinero.experienciaAdquirida()
	method experienciaAdquirida() = comidasPreparadas.sum{ comida => comida.experienciaQueAporta() }

	// Punto 2) cocinero.superoNivelDeAprendizaje()
	method superoNivelDeAprendizaje() = nivelAprendizaje.cocineroLoSupera(self)

	method preparoMasDeNComidasDificiles(enesimo) = comidasPreparadas.filter{ comida => comida.esDificilPrepararlo() }.size() > enesimo

	// Punto 3) cocinero.preparar(unaComida)
	method prepararComida(unaReceta) {
		if (!self.puedePrepararComida(unaReceta)) {
			throw new NoPuedePrepararLaComida(message = "El cocinero no tiene el suficiente nivel de aprendizaje")
		}
		const nuevaComida = nivelAprendizaje.calidadComidaQueProduce(unaReceta, self)
		self.registrarNuevaComidaPreparada(nuevaComida)
		if (self.superoNivelDeAprendizaje()) {
			nivelAprendizaje.irAlSiguienteNivelDeAprendizaje(self)
		}
	}

	method registrarNuevaComidaPreparada(nuevaComida) {
		comidasPreparadas.add(nuevaComida)
	}

	method puedePrepararComida(unaReceta) = nivelAprendizaje.puedePrepararlo(self, unaReceta)

	method comidasSimilaresALaReceta(unaReceta) = comidasPreparadas.filter{ comidaPreparada => comidaPreparada.suRecetaTieneMismoIngrediente(unaReceta) || comidaPreparada.diferencialDeExperienciaEnesima(1, unaReceta) }

	method cantidadComidasSimilaresALaReceta(unaReceta) = self.comidasSimilaresALaReceta(unaReceta).size()

	method loPreparoAntes(unaReceta) = self.cantidadComidasSimilaresALaReceta(unaReceta) >= 1

	method logroPerfeccionar(unaReceta) = self.comidasSimilaresALaReceta(unaReceta).sum{ receta => receta.experienciaQueAporta() } >= self.experienciaRequeridaParaPerfeccionar(unaReceta)

	method experienciaRequeridaParaPerfeccionar(unaReceta) = 3 * unaReceta.experienciaQueAporta()

	method prepararRecetaQueMasExperienciaAporte(unRecetario) {
		const recetaPreparableDeMayorExperiencia = self.recetasQuePuedePrepararAPartirDeUnRecetario(unRecetario).max{ recetaPreparable => recetaPreparable.experienciaQueAporta() }
		self.prepararComida(recetaPreparableDeMayorExperiencia)
	}

	method recetasQuePuedePrepararAPartirDeUnRecetario(unRecetario) = unRecetario.filter{ unaReceta => self.puedePrepararComida(unaReceta) }

}

object principiante {

	method cocineroLoSupera(unCocinero) = unCocinero.experienciaAdquirida() > 100

	method puedePrepararlo(unCocinero, unaReceta) = !unaReceta.esDificilPrepararlo()

	method calidadComidaQueProduce(unaReceta, unCocinero) = if (unaReceta.cantidadIngredientes() < 4) new Comida(recetaAsociada = unaReceta) else new ComidaPobre(recetaAsociada = unaReceta)

	method irAlSiguienteNivelDeAprendizaje(unCocinero) = unCocinero.nivelAprendizaje(new Experimentado())

}

class Experimentado {

	method cocineroLoSupera(unCocinero) = unCocinero.preparoMasDeNComidasDificiles(5)

	method puedePrepararlo(unCocinero, unaReceta) = unCocinero.loPreparoAntes(unaReceta)

	method calidadComidaQueProduce(unaReceta, unCocinero) = if (unCocinero.logroPerfeccionar(unaReceta)) new ComidaSuperior(plusDePreparacion = unCocinero.cantidadComidasSimilaresALaReceta(unaReceta) / 10, recetaAsociada = unaReceta) else new Comida(recetaAsociada = unaReceta)

	method irAlSiguienteNivelDeAprendizaje(unCocinero) = unCocinero.nivelAprendizaje(chef)

}

object chef inherits Experimentado {

	override method cocineroLoSupera(unCocinero) = false

	override method puedePrepararlo(unCocinero, unaReceta) = true

}

class Comida {

	const property recetaAsociada

	method experienciaQueAporta() = recetaAsociada.experienciaQueAporta()

	method esDificilPrepararlo() = recetaAsociada.esDificilPrepararlo()

	method suRecetaTieneMismoIngrediente(unaReceta) = recetaAsociada.tieneMismoIngrediente(unaReceta)

	method diferencialDeExperienciaEnesima(enesimo, unaReceta) = recetaAsociada.diferencialDeExperienciaEnesima(enesimo, unaReceta)

}

class ComidaPobre inherits Comida {

	override method experienciaQueAporta() = super().min(academia.experienciaMaximaParaComidasConCalidadPobre())

}

class ComidaSuperior inherits Comida {

	const property plusDePreparacion

	override method experienciaQueAporta() = super() + plusDePreparacion

}

class Receta {

	var property ingredientes = #{}
	var property nivelDificultadPreparacion

	method cantidadIngredientes() = ingredientes.size()

	method experienciaQueAporta() = self.cantidadIngredientes() * nivelDificultadPreparacion

	method esDificilPrepararlo() = nivelDificultadPreparacion > 5 || self.cantidadIngredientes() > 10

	method tieneMismoIngrediente(unaReceta) = ingredientes.all{ ingrediente => unaReceta.esUnMismoIngredienteSuyo(ingrediente) }

	// ingredientes == unaReceta.ingredientes()
	method esUnMismoIngredienteSuyo(unIngrediente) = ingredientes.contains(unIngrediente)

	method diferencialDeExperienciaEnesima(enesimo, unaReceta) {
		const experiencia = unaReceta.nivelDificultadPreparacion()
		return self.experienciaQueAporta() - enesimo <= experiencia && self.experienciaQueAporta() + enesimo >= experiencia
	}

}

// Punto 4) 
class RecetaGourmet inherits Receta {

	override method experienciaQueAporta() = 2 * super()

	override method esDificilPrepararlo() = true

}

class NoPuedePrepararLaComida inherits DomainException {

}

// Fin parcial
