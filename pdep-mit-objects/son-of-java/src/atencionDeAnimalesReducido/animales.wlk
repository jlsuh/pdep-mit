class Vaca {

	var property peso
	var property tieneSed

	method comer(cantidadEnKg) {
		peso += cantidadEnKg / 3
		tieneSed = true
	}

	method beber() {
		tieneSed = false
		peso -= 0.5
	}

	method tieneHambre() = peso < 200

}

class Cerdo {

	var property peso
	var property tieneHambre
	var vecesQueComio = 0

	method comer(cantidadEnKg) {
		peso += (cantidadEnKg - 0.2).max(0)
		if (cantidadEnKg > 1) {
			tieneHambre = false
		}
		vecesQueComio++
	}

	method tieneSed() = vecesQueComio > 3

	/*
	 * 	method tieneSed() {
	 * var vecesQueComioSinBeber = 0
	 * var comioSinBeberMasDeTresVeces = false
	 * hizo.forEach{ elem =>
	 * 	if (elem == "comio") {
	 * 		vecesQueComioSinBeber++
	 * 	} else {
	 * 		vecesQueComioSinBeber = 0
	 * 	}
	 * 	if (vecesQueComioSinBeber == 4) {
	 * 		comioSinBeberMasDeTresVeces = true
	 * 	}
	 * }
	 * return comioSinBeberMasDeTresVeces
	 * 
	 * 	}
	 */
	method beber() {
		tieneHambre = true
		vecesQueComio = 0
	}

}

class Gallina {

	const property peso = 4
	const property tieneHambre = true
	const property tieneSed = false

	method comer(cantidadEnKg) {
	}

	method beber() {
	}

}

