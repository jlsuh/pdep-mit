import atencionDeAnimalesReducido.excepcionesComedero.*

class Bebedero {

	method atender(animal) {
		// if (self.esUtilParaAtender(animal)) {
		animal.beber()
//		}
	}

	method esUtilParaAtender(animal) = animal.tieneSed()

}

class Comedero {

	const property racionFija
	const property pesoTolerado

	method atender(animal) {
		if (self.esUtilParaAtender(animal)) {
			animal.comer(racionFija)
		} else {
			self.error("El animal es muy pesado") // <- pudo haber sido de esta forma nomás (simplificada)
			// throw new PesoNoToleradoException(message = "El animal es muy pesado") <- una excepción sería para un trycatch?
		}
	}

	method esUtilParaAtender(animal) {
		return animal.peso() < pesoTolerado
	}

}

