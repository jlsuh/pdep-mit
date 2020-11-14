class Apurade {

	var property jefe
	var property estaEnMicro = false
	var property vaSentado = false

	method aceptaSubirse(unMicro) {
		return true
	}

}

class Claustrofobique {

	var property jefe
	var property estaEnMicro = false
	var property vaSentado = false

	method aceptaSubirse(unMicro) {
		return unMicro.volumen() > 120
	}

}

class Fiaca {

	var property jefe
	var property estaEnMicro = false
	var property vaSentado = false

	method aceptaSubirse(unMicro) {
		return unMicro.sePuedeIrSentado()
	}

}

class Moderade {

	var property jefe
	var property estaEnMicro = false
	var property vaSentado = false
	const property minimosLugaresLibres

	method aceptaSubirse(unMicro) {
		return unMicro.lugaresLibres() >= minimosLugaresLibres
	}

}

class Obsecuente {

	var property jefe
	var property estaEnMicro = false
	var property vaSentado = false

	method aceptaSubirse(unMicro) {
		return jefe.aceptaSubirse(unMicro)
	}

}

