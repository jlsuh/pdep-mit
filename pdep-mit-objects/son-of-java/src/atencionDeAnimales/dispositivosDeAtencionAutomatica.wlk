class ComederoNormal {

	const property cantidadQueDaDeComer
	const property pesoTolerado
	var property racionesDisponibles

	method darDeComer(animal) {
		if (self.puedeAtender(animal)) {
			animal.comer(cantidadQueDaDeComer)
			racionesDisponibles -= cantidadQueDaDeComer
		}
	}

	method puedeAtender(animal) {
		return animal.peso() < pesoTolerado && racionesDisponibles > 0
	}

	method necesitaRecarga() {
		return racionesDisponibles < 10
	}

	method recargar() {
		racionesDisponibles += 30
	}

}

class ComederoInteligente {

	const property racionesMaximas
	var property racionesDisponibles

	method darDeComer(animal) {
		if (self.puedeAtender(animal)) {
			animal.comer(self.cantidadQueDaDeComer(animal))
			racionesDisponibles -= self.cantidadQueDaDeComer(animal)
		}
	}

	method cantidadQueDaDeComer(animal) {
		return animal.peso() / 100
	}

	method puedeAtender(animal) {
		return animal.tieneHambre() && racionesDisponibles > 0
	}

	method necesitaRecarga() {
		return racionesDisponibles < 15
	}

	method recargar() {
		racionesDisponibles = racionesMaximas
	}

}

class Bebedero {

	var property animalesAtendidos = 0

	method darDeBeber(animal) {
		if (self.puedeAtender(animal)) {
			animal.beber()
		}
	}

	method puedeAtender(animal) {
		return animal.tieneSed() && animalesAtendidos < 20
	}

	method necesitaRecarga() {
		return animalesAtendidos >= 20
	}

	method recargar() {
		animalesAtendidos = 0
	}

}

class Vacunatorio {

	var property vacunasDisponibles

	method vacunar(animal) {
		if (animal.convieneVacunarle()) {
			animal.estaVacunada(true)
			vacunasDisponibles--
		}
	}

	method puedeAtender(animal) {
		return animal.convieneVacunarle() && vacunasDisponibles > 0
	}

	method necesitaRecarga() {
		return vacunasDisponibles == 0
	}

	method recargar() {
		vacunasDisponibles += 50
	}

}

