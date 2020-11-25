class Pocion {

	const ingredientes = []

	method hacerEfecto(unaPersona) {
		ingredientes.forEach{ ingrediente => ingrediente.hacerEfecto(unaPersona, self)}
	}

	method cantidadIngredientes() = ingredientes.size()

}

class Grog {

	method hacerEfecto(unaPersona, unaPocion) {
		unaPersona.aumentarFuerza(unaPersona.fuerza() * unaPocion.cantidadIngredientes())
	}

}

object grogXD inherits Grog {

	override method hacerEfecto(unaPersona, unaPocion) {
		super(unaPersona, unaPocion)
		unaPersona.aumentarResistencia(2 * unaPersona.resistencia())
	}

}

object puniadoDeHongosSilvestres {

	const cantidadHongos = 0

	method hacerEfecto(unaPersona, unaPocion) {
		unaPersona.aumentarFuerza(cantidadHongos)
		if (cantidadHongos > 5) {
			unaPersona.disminuirResistencia(unaPersona.resistencia() / 2)
		}
	}

}

object dulceDeLeche {

	method hacerEfecto(unaPersona, unaPocion) {
		unaPersona.aumentarFuerza(10)
		if (unaPersona.estaFueraDeCombate()) {
			unaPersona.estaFueraDeCombate(false)
			unaPersona.aumentarResistencia(2)
		}
	}

}

class Ejercito {

	const property integrantes = #{}

	method cantidadQueVanAdelante() = 10

	method poder() = self.integrantesQueEstanEnCombate().sum{ integrante => integrante.fuerza() }

	method integrantesQueEstanEnCombate() = integrantes.filter{ integrante => !integrante.estaFueraDeCombate() }

	// ejercito.recibirDanio(danio)
	method recibirDanio(danio) {
		const losNQueVanAdelante = self.losNMasPoderosos(self.cantidadQueVanAdelante())
		const danioEquitativo = danio / losNQueVanAdelante.size()
		losNQueVanAdelante.forEach{ integrante => integrante.recibirDanio(danioEquitativo)}
	}

	method losNMasPoderosos(enesimo) {
		if (self.cantidadIntegrantes() < enesimo) {
			return integrantes
		}
		return self.ordenarIntegrantesDescendenteSegunPoder()
	}

	method ordenarIntegrantesDescendenteSegunPoder() = integrantes.sortedBy{ unIntegrante , otroIntegrante => unIntegrante.poder() > otroIntegrante.poder() }

	method cantidadIntegrantes() = integrantes.size()

	method pelearEnContra(enemigo) {
		if (self.integrantesQueEstanEnCombate().size() == 0) {
			throw new ElEquipoTieneATodosSusIntegrantesFueraDeCombateException(message = "Todos los integrantes están fuera de combate")
		}
		const elMenosPoderoso = self.ordenarIntegrantesDescendenteSegunPoder().last()
		const diferencialDePoder = self.poder() - enemigo.poder()
		elMenosPoderoso.recibirDanio(diferencialDePoder)
	}

}

class Legion inherits Ejercito {

	var property formacion
	// En caso de que el dominio deba contemplar el agregado o quitado de integrantes, entonces no se reflejaría en consonancia
	// el poder actual
	const suEjercitoAsociado = new Ejercito(integrantes = self.integrantes())
	const property poderMinimoPreestablecido

	// Cuando baja el ascensor
	// Si uso super() en alguno de estos, entraría en un loop delegando indefinidamente en formacion
	override method poder() = formacion.poder(self)

	override method recibirDanio(danio) {
		formacion.recibirDanio(danio, self)
		self.verificarSiDebeCambiarAFormacionTortuga()
	}

	method verificarSiDebeCambiarAFormacionTortuga() {
		if (self.poder() < poderMinimoPreestablecido) {
			formacion = formacionTortuga
		}
	}

	override method cantidadQueVanAdelante() = formacion.cantidadQueVanAdelante(self)

	// Cuando sube el ascensor
	method poderDeEjercitoAsociado() = suEjercitoAsociado.poder()

	method recibirDanioComoEjercitoAsociado(danio) {
		suEjercitoAsociado.recibirDanio(danio)
	}

	method cantidadQueVanAdelanteEnSuEjercitoAsociado() = suEjercitoAsociado.cantidadQueVanAdelante()

	method cambiarFormacion(nuevaFormacion) {
		formacion = nuevaFormacion
	}

}

object formacionTortuga {

	method poder(unaLegion) = 0

	method recibirDanio(danio, unaLegion) {
	}

	method cantidadQueVanAdelante(unaLegion) = unaLegion.cantidadQueVanAdelanteEnSuEjercitoAsociado()

}

class FormacionEnCuadro {

	const property cantidadQueVanAdelante

	method poder(unaLegion) = unaLegion.poderDeEjercitoAsociado()

	method recibirDanio(danio, unaLegion) {
		unaLegion.recibirDanioComoEjercitoAsociado(danio)
	}

	method cantidadQueVanAdelante(unaLegion) = cantidadQueVanAdelante

}

object frontemAllargate {

	method poder(unaLegion) = unaLegion.poderDeEjercitoAsociado() + 0.1 * unaLegion.poderDeEjercitoAsociado()

	method recibirDanio(danio, unaLegion) {
		unaLegion.recibirDanioComoEjercitoAsociado(danio * 2)
	}

	method cantidadQueVanAdelante(unaLegion) = unaLegion.cantidadQueVanAdelanteEnSuEjercitoAsociado() / 2

}

class Persona {

	var property fuerza = 0
	var property resistencia = 0
	var property estaFueraDeCombate = false

	// persona.poder()
	method poder() = fuerza * resistencia

	// persona.recibirDanio(danio)
	method recibirDanio(danio) {
		resistencia = (resistencia - danio).max(0)
		self.actualizarSiSigueEnCombate()
	}

	method actualizarSiSigueEnCombate() {
		if (resistencia == 0) {
			estaFueraDeCombate = true
		}
	}

	// persona.tomarPocionMagica(pocionMagica)
	method tomarPocionMagica(pocionMagica) {
		pocionMagica.hacerEfecto(self)
	}

	method aumentarFuerza(fuerzaAumentada) {
		fuerza += fuerzaAumentada
	}

	method aumentarResistencia(resistenciaAumentada) {
		resistencia += resistenciaAumentada
	}

	method disminuirResistencia(resistenciaDisminuida) {
		resistencia -= resistenciaDisminuida
	}

}

const legionConFormacionEnCuadroQueManda20GuerrerosAdelante = new Legion(formacion = new FormacionEnCuadro(cantidadQueVanAdelante = 20), poderMinimoPreestablecido = 10)

class ElEquipoTieneATodosSusIntegrantesFueraDeCombateException inherits DomainException {

}

