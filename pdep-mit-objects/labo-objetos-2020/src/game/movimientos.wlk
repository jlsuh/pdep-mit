import gameConfiguration.*
import wollok.game.Position

/*
 * Acá se define cómo se mueven los personajes cuando se usan las flechitas.
 * Las posiciones son objetos inmutables, pero los personajes controlados pueden 
 * moverse setteándose la nueva posición cuando sea necesario.
 */
object movimiento {

	method mover(personajeLibre, direccion) {
		const nuevaPosicion = direccion.posicionSiguiente(personajeLibre.position())
		personajeLibre.position(nuevaPosicion)
	}

}

object haciaArriba {

	method posicionSiguiente(posicion) {
		if (posicion.y() < config.alturaSuelo()) {
			return posicion.up(1)
		}
		return posicion
	}

}

object haciaAbajo {

	method posicionSiguiente(posicion) {
		if (posicion.y() > 0) {
			return posicion.down(1)
		}
		return posicion
	}

}

object haciaLaDerecha {

	method posicionSiguiente(posicion) {
		if (posicion.x() == config.anchoMaximo() - 1) {
			return new Position(x = 0, y = posicion.y())
		}
		return posicion.right(1)
	}

}

object haciaLaIzquierda {

	method posicionSiguiente(posicion) {
		if (posicion.x() == 0) {
			return new Position(x = config.anchoMaximo() - 1, y = posicion.y())
		}
		return posicion.left(1)
	}

}

