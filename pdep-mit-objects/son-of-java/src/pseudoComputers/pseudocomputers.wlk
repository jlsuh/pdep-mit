class SuperComputadora {

	const equipos = []
	var totalComplejidad = 0

	method equiposActivos() = equipos.filter{ e => e.estaActivo() }

	method capacidadComputo() = equipos.sum{ e => e.capacidadComputo() }

	method consumo() = equipos.sum{ e => e.consumo() }

	method malConfigurada() {
		const equipoConMayorConsumo = equipos.max{ e => e.consumo() }
		const equipoQueMasComputa = equipos.max{ e => e.capacidadComputo() }
		return equipoConMayorConsumo != equipoQueMasComputa
	}

	method computarProblema(complejidadN) {
		const complejidadSubproblema = complejidadN / self.equiposActivos().size()
		self.equiposActivos().forEach{ ea => ea.computarProblema(complejidadSubproblema)}
		totalComplejidad += complejidadN
	}

}

class SuperComputadoraPequenia inherits SuperComputadora {

	method estaActivo() = true

}

object standard {

	method consumoNeto(equipo) = equipo.consumoBase()

	method capacidadComputoNeto(equipo) = equipo.unidadesComputoBase()

	method responderAlComputo(equipo) {
	}

	method validarComputabilidad(equipo) {
	}

}

class Overclock {

	var property usosDisponibles

	method consumoNeto(equipo) = 2 * equipo.consumoBase()

	method capacidadComputoNeto(equipo) = equipo.unidadesComputoBase() + equipo.capacidadComputoEnOverclock()

	method responderAlComputo(equipo) {
		if (usosDisponibles == 1) {
			equipo.estaQuemado(true)
		}
		equipo.modoFuncionamiento(new Overclock(usosDisponibles = usosDisponibles - 1))
	}

	method validarComputabilidad(equipo) {
		if (equipo.estaQuemado()) {
			throw new EquipoEstaQuemadoException(message = "El equipo está quemado")
		}
	}

}

class AhorroDeEnergia {

	var intentos

	method intentosPermitidos() = 17

	method consumoNeto(equipo) = 200

	method capacidadComputoNeto(equipo) {
		const perdidaEnergia = (equipo.consumoBase() - self.consumoNeto(equipo)).max(0)
		const porcentajePerdida = perdidaEnergia / equipo.consumoBase()
		return equipo.unidadesComputoBase() - equipo.unidadesComputoBase() * porcentajePerdida
	}

	method responderAlComputo(equipo) {
		equipo.modoFuncionamiento(new AhorroDeEnergia(intentos = intentos + 1))
	}

	method validarComputabilidad(equipo) {
		if (intentos == self.intentosPermitidos()) {
			equipo.modoFuncionamiento(new AhorroDeEnergia(intentos = 0))
			throw new MonitorDeConsumoException(message = "Se está corriendo el monitor de consumo")
		}
	}

}

class APruebaDeFallos inherits AhorroDeEnergia {

	override method capacidadComputoNeto(equipo) = super(equipo) / 2

	override method intentosPermitidos() = 100

}

class Equipo {

	var property estaQuemado
	var property modoFuncionamiento

	method estaActivo() = !self.estaQuemado() && self.capacidadComputo() > 0

	method consumoBase()

	method consumo() = modoFuncionamiento.consumoNeto(self)

	method unidadesComputoBase()

	method capacidadComputo() = modoFuncionamiento.capacidadComputoNeto(self)

	method capacidadComputoEnOverclock()

	method computar() {
		modoFuncionamiento.responderAlComputo(self)
	}

	method computarProblema(complejidadN) {
		self.validarComputabilidad(complejidadN)
		self.computar()
		modoFuncionamiento.validarComputabilidad(self)
	}

	method validarComputabilidad(complejidadN) {
		if (self.capacidadComputo() < complejidadN) {
			throw new EquipoNoPoseeSuficienteCapacidadDeComputoException(message = "El equipo no posee la capacidad de cómputo suficiente")
		}
	}

}

class A105 inherits Equipo {

	override method unidadesComputoBase() = 600

	override method consumoBase() = 300

	override method capacidadComputoEnOverclock() = self.unidadesComputoBase() * 0.3

	override method validarComputabilidad(complejidadN) {
		if (complejidadN < 5) {
			throw new EquipoTipoA105NoPuedeComputarProblemaSimple(message = "El equipo de tipo A105 no puede computar un problema de coplejidad menor que 5")
		}
		super(complejidadN)
	}

}

class B2 inherits Equipo {

	var property microChipsInstalados

	override method unidadesComputoBase() = (100 * microChipsInstalados).min(800)

	override method consumoBase() = 50 * microChipsInstalados + 10

	override method capacidadComputoEnOverclock() = 20 * microChipsInstalados

}

class EquipoNoPoseeSuficienteCapacidadDeComputoException inherits DomainException {

}

class EquipoTipoA105NoPuedeComputarProblemaSimple inherits DomainException {

}

class EquipoEstaQuemadoException inherits DomainException {

}

class MonitorDeConsumoException inherits DomainException {

}

