class Mafioso {

	var property rango
	var property estaConVida
	var property estaHerido
	var property armas = []
	var property lealtad
	var property familia
	var property traicion

	// mafioso.duermeConLosPeces()
	method duermeConLosPeces() = estaConVida == 0

	method cantidadDeArmas() = armas.size()

	method ganarArma(nuevoArma) {
		armas.add(nuevoArma)
	}

	// mafioso.sabeDespacharElegantemente()
	method sabeDespacharElegantemente() = rango.sabeDespacharElegantemente(self)

	method trabajar(otraFamilia) {
		const elMasPeligrosoDeLaOtraFamilia = otraFamilia.peligroso()
		rango.realizarTrabajo(self, elMasPeligrosoDeLaOtraFamilia)
	}

	method tieneArmaSutil() = armas.any{ arma => arma.esSutil() }

	method armaMasAMano() = armas.first()

	method otroArmaDisponible(ultimoArmaEmpleado) = armas.findOrElse({ arma => arma != ultimoArmaEmpleado }, throw new NoHayArmasDisponiblesException(message = "No hay armas disponibles"))

	method responderAReorganizacion() = rango.reorganizar(self)

	method volverseDon() {
		if (familia.yaTieneUnDonVivo()) {
			throw new YaHayUnDonEnLaFamiliaException(message = "Ya existe un don de la familia y está vivo")
		}
		rango = don
	}

	method esDon() = rango == don

	method aumentarLealtadAFamilia(porcentaje) {
		lealtad += lealtad * porcentaje
	}

	// mafioso.iniciarTraicion()
	method iniciarTraicion(nuevaFamilia) {
		const victima = familia.miembrosVivos().anyOne()
		traicion = new Traicion(victimas = #{ victima }, fechaTentativa = new Date(), familiaDestino = nuevaFamilia)
	}

	method seComplicaLaSituacion() {
		traicion.cambiarFechaTentativa(new Date())
		const victima = familia.miembrosVivos().filter{ miembro => !traicion.yaEsVictima(miembro) }
		traicion.listarNuevaVictima(victima)
	}

	method intentarRealizarTraicion() {
		traicion.intentarConcretarse(familia, self)
	}

	method concretarTraicion(victimas) {
		victimas.forEach{ victima => rango.realizarTrabajo(self, victima)}
		familia.recordarTraicion(self)
		familia = traicion.familiaDestino()
		rango = new Soldado()
		familia.agregarMiembro(self)
	}

}

class Soldado {

	// method tieneArmaSutil() = armas.any{ arma => arma.esSutil() }
	method sabeDespacharElegantemente(mafioso) = mafioso.tieneArmaSutil()

	method realizarTrabajo(mafioso, mafiosoEnemigo) {
		mafioso.armaMasAMano().utilizar(mafiosoEnemigo)
	}

	method reorganizar(mafioso) {
		if (mafioso.cantidadDeArmas() > 5) {
			mafioso.rango(new SubJefe(ultimoArmaEmpleado = mafioso.armaMasAMano()))
		}
	}

}

class SubJefe {

	var property subordinados = #{}
	var property ultimoArmaEmpleado

	method sabeDespacharElegantemente(mafioso) = subordinados.any{ subordinado => subordinado.sabeDespacharElegantemente() }

	method realizarTrabajo(mafioso, mafiosoEnemigo) {
		const armaCandidata = mafioso.otroArmaDisponible(ultimoArmaEmpleado)
		armaCandidata.utilizar(mafiosoEnemigo)
	}

	method reorganizar(mafioso) {
	}

}

object don inherits SubJefe {

	override method sabeDespacharElegantemente(mafioso) = true

	override method realizarTrabajo(mafioso, mafiosoEnemigo) {
		self.lavarseLasManos(mafiosoEnemigo)
	}

	method subordinadoDisponible() {
		return subordinados.findOrElse({ subordinado => !subordinado.duermeConLosPeces() }, throw new NoHayIntegrantesConVidaException(message = "No hay subordinados con vida disponibles"))
	}

	method lavarseLasManos(mafioso) {
		const subordinadoElecto = self.subordinadoDisponible()
		2.times{ n => subordinadoElecto.trabajar()}
	}

}

class Familia {

	var property integrantes = #{}
	var property don
	var property traidores = #{}

	// familia.peligroso()
	method peligroso() = self.elMasArmado(self.miembrosVivos())

	method elMasArmado(mafiosos) = mafiosos.max{ mafioso => mafioso.cantidadDeArmas() }

	method miembrosVivos() = integrantes.filter{ miembro => !miembro.duermeConLosPeces() }

	// familia.elQueQuieraEstarArmadoQueAndeArmado()
	method elQueQuieraEstarArmadoQueAndeArmado() {
		const revolverConSeisBalas = new Revolver(balas = 6)
		integrantes.forEach{ integrante => integrante.ganarArma(revolverConSeisBalas)}
	}

	// familia.atacar(otraFamilia)
	method atacar(otraFamilia) {
		integrantes.forEach{ integrante =>
			if (otraFamilia.cantidadMiembrosVivos() == 0) {
				throw new NoHayIntegrantesConVidaException(message = "Todos los de la otra familia duermen con los peces")
			}
			integrante.trabajar(otraFamilia)
		}
		if (otraFamilia.cantidadMiembrosVivos() > 0) {
			self.atacar(otraFamilia)
		}
	}

	method cantidadMiembrosVivos() = self.miembrosVivos().size()

	// familia.luto()
	method luto() {
		integrantes.forEach{ integrante => integrante.responderAReorganizacion()}
		const nuevoDon = self.elNuevoDon()
		don = nuevoDon
		nuevoDon.volverseDon()
		integrantes.forEach{ integrante => integrante.aumentarLealtadAFamilia(0.1)}
	}

	method elNuevoDon() = self.miembrosVivos().filter{ integrante => integrante.sabeDespacharElegantemente() }.max{ integrante => integrante.lealtad() }

	method yaTieneUnDonVivo() = self.miembrosVivos().filter{ integrante => integrante.esDon() }.size() > 0

	method lealtadPromedio() = self.miembrosVivos().sum{ integrante => integrante.lealtad() } / self.cantidadMiembrosVivos()

	method ajusticiar(traidor) {
		traidor.estaConVida(false) // no especifica el cómo se lo ajusticia
		self.recordarTraicion(traidor)
	}

	method agregarMiembro(nuevoMiembro) {
		integrantes.add(nuevoMiembro)
	}

	method recordarTraicion(traidor) {
		traidores.add(traidor)
	}

}

class Revolver {

	var property balas

	method esSutil() = balas == 1

	method utilizar(mafioso) {
		if (balas > 0) {
			mafioso.estaConVida(false)
			balas -= 1
		} else {
			throw new NoHayBalasException(message = "El revolver se quedó sin balas")
		}
	}

}

class Escopeta {

	method utilizar(mafioso) {
		if (!mafioso.estaHerido()) {
			mafioso.estaHerido(true)
		} else {
			mafioso.estaVivo(false)
		}
	}

}

class CuerdasDePiano {

	const property calidad

	method esSutil() = true

	method utilizar(mafioso) {
		if (calidad == "buena") {
			mafioso.estaVivo(false)
		} else {
			mafioso.estaHerido(true)
		}
	}

}

class Traicion {

	var property fechaTentativa
	var property victimas = #{}
	var property familiaDestino

	method yaEsVictima(miembro) = victimas.contains(miembro)

	method listarNuevaVictima(victima) {
		victimas.add(victima)
	}

	method cambiarFechaTentativa(nuevaFecha) {
		fechaTentativa = nuevaFecha
	}

	method intentarConcretarse(familia, traidor) {
		if (familia.lealtadPromedio() > traidor.lealtad() * 2) {
			familia.ajusticiar(traidor)
		} else {
			traidor.concretarTraicion(victimas)
		}
	}

}

class NoHayIntegrantesConVidaException inherits DomainException {

}

class NoHayBalasException inherits DomainException {

}

class NoHayArmasDisponiblesException inherits DomainException {

}

class YaHayUnDonEnLaFamiliaException inherits DomainException {

}

