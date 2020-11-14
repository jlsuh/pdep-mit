import randomizer.*
import sombrero.*

class JuegoDelSombrero {

	const sombreroUno = new Sombrero(numero = 1)
	const sombreroDos = new Sombrero(numero = 2)
	const sombreroTres = new Sombrero(numero = 3)
	var sombreros = [ sombreroUno, sombreroDos, sombreroTres ]
	var property dineroActual
	var property vecesGanadas = 0
	var property vecesPerdidas = 0
	var property apuestaMasAlta = 0

	method mezclarSombrero() {
		const numeroRandom = new Randomizer().generateNumberFromTo(0, 2)
		const target = sombreros.get(numeroRandom)
		const frontales = sombreros.take(numeroRandom)
		const posteriores = sombreros.drop(numeroRandom + 1)
		target.tieneLaMoneda(true)
		sombreros = frontales + [ target ] + posteriores
		console.println("¿Dónde está la moneda? [Sombreros: 1 | 2 | 3]")
	}

	method apostar(apuesta, numeroDeSombrero) {
		if (sombreros.get(numeroDeSombrero - 1).tieneLaMoneda()) {
			dineroActual += apuesta * 2
			vecesGanadas += 1
			console.println("Used ganó " + (apuesta * 2).toString() + " pesos")
		} else {
			dineroActual -= apuesta
			vecesPerdidas += 1
			console.println("Used perdió " + apuesta.toString() + " pesos")
		}
		apuestaMasAlta = apuestaMasAlta.max(apuesta)
		self.quitarMoneda()
	}

	method quitarMoneda() {
		sombreroUno.tieneLaMoneda(false)
		sombreroDos.tieneLaMoneda(false)
		sombreroTres.tieneLaMoneda(false)
	}

}

