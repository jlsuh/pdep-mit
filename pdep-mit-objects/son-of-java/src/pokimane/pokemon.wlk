class Pokemon {

	const property vidaMaxima = 100 // solo lo inicializo para quitar un warning xd
	var property vidaActual
	var property movimientos = #{}
	var property condicionEspecial = normal

	method grositud() = vidaMaxima * self.poderMovimientos()

	method poderMovimientos() = movimientos.sum{ movimiento => movimiento.poder() }

	method curar(curacion) {
		vidaActual += curacion.min(vidaMaxima - vidaActual)
	}

	method recibirDanio(danio) {
		vidaActual -= danio
	}

	method emplearMovimiento(movimiento, otroPokemon) {
		movimiento.decrementarUsoDisponible()
		movimiento.aplicarEfecto(self, otroPokemon)
	}

	method luchar(otroPokemon) {
		self.validarMovimientoPermitido(self)
		self.emplearMovimiento(self.movimientoAUtilizar(), otroPokemon)
	}

	method estaVivo() = vidaActual > 0

	method validarMovimientoPermitido(pokemon) {
		if (!self.estaVivo()) {
			throw new PokemonConVidaException(message = "El pokemon no se encuentra con vida")
		} else if (!condicionEspecial.permiteMovimiento(pokemon)) {
			throw new MovimientoPorCondicionEspecialException(message = "La condición especial no permite el movimiento")
		}
	}

	method tieneAlgunMovimientoDisponible() = movimientos.any{ movimiento => movimiento.estaDisponible() }

	method movimientoAUtilizar() {
		if (!self.tieneAlgunMovimientoDisponible()) {
			throw new MovimientoDisponibleException(message = "No hay movimientos disponibles")
		}
		return movimientos.anyOne()
	}

}

class Movimiento {

	var property usosDisponibles

	method decrementarUsoDisponible() {
		usosDisponibles -= 1
	}

	method poder()

	method aplicarEfecto(unPokemon, otroPokemon)

	method estaDisponible() = usosDisponibles > 0

}

class Curativo inherits Movimiento {

	const property curacion

	override method poder() = curacion

	override method aplicarEfecto(unPokemon, otroPokemon) {
		unPokemon.curar(curacion)
	}

}

class Danino inherits Movimiento {

	const property danio

	override method poder() = 2 * danio

	override method aplicarEfecto(unPokemon, otroPokemon) {
		otroPokemon.recibirDanio(danio)
	}

}

class Especial inherits Movimiento {

	const property condicionEspecial

	override method poder() = condicionEspecial.poder()

	override method aplicarEfecto(unPokemon, otroPokemon) {
		otroPokemon.condicionEspecial(condicionEspecial)
	}

}

class CondicionEspecial {

	method poder()

	method lograMoverse() = 0.randomUpTo(2).roundUp().even()

	method permiteMovimiento(pokemon) = self.lograMoverse()

	method normalizarCondicion(pokemon) {
		pokemon.condicionEspecial(normal)
	}

}

object normal inherits CondicionEspecial {

	override method poder() = 0

	override method permiteMovimiento(pokemon) = true

}

object dormido inherits CondicionEspecial {

	override method poder() = 50

	override method permiteMovimiento(pokemon) {
		if (super(pokemon)) {
			self.normalizarCondicion(pokemon)
			return true
		}
		return false
	}

}

object paralizado inherits CondicionEspecial {

	override method poder() = 30

}

class Confusion inherits CondicionEspecial {

	var property turnosVigentes

	override method poder() = 40 * turnosVigentes

	override method permiteMovimiento(pokemon) {
		if (turnosVigentes == 0) {
			self.normalizarCondicion(pokemon)
			return true
		}
		turnosVigentes -= 1
		if (!super(pokemon)) {
			pokemon.recibirDanio(20)
			return false
		}
		return true
	}

}

class PokemonConVidaException inherits DomainException {

}

class MovimientoException inherits DomainException {

}

class MovimientoPorCondicionEspecialException inherits MovimientoException {

}

class MovimientoDisponibleException inherits MovimientoException {

}

