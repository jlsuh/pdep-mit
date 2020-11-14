class Vaca {

	var property peso
	var property tieneSed
	var property estaVacunada

	method comer(kilosComidos) {
		peso += kilosComidos / 3
		self.tieneSed(true)
	}

	method beber() {
		self.tieneSed(false)
		peso -= 0.5
	}

	method convieneVacunarle() {
		return not estaVacunada
	}

	method tieneHambre() {
		return peso < 200
	}

	method llevarlaACaminar() {
		peso -= 3
	}

}

class Cerdo {

	var property peso
	var property tieneHambre
	var laVezQueMasComio = 0
	var property tieneSed
	var property vecesQueComio = 0
	var property vecesQueBebio = 0
	const property convieneVacunarle = true
	var property estaVacunada

	// TODO: agregar tests que reflejen que un cerdo que no estaba
	// vacunado, pasa a estar vacunada
	method comer(kilosComidos) {
		peso += (kilosComidos - 0.2).max(0)
		if (kilosComidos > 1) {
			tieneHambre = false
		}
		laVezQueMasComio = laVezQueMasComio.max(kilosComidos)
		if (vecesQueComio > 3 && vecesQueBebio == 0) {
			tieneSed = true
		}
		vecesQueComio++
	}

	method laVezQueMasComio() {
		return laVezQueMasComio
	}

	method beber() {
		tieneSed = false
		tieneHambre = true
		vecesQueBebio++
	}

}

class Gallina {

	const property peso = 4
	const property tieneHambre = true
	const property tieneSed = false
	const property convieneVacunarle = false
	var property estaVacunada
	var property vecesQueComio = 0

	method comer(kilosComidos) {
		vecesQueComio++
	}

	method beber() {
	}

}

