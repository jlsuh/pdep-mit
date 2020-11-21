/* La idea general está genial y en términos de encapsulamiento también lo veo bien. */

class Comensal {

	var property posicion
	var property elementosQueTieneCerca = []
	var property criterioElemento
	var property criterioAlimenticio
	var property comidasConsumidas = []

	method perdirle(elementoDeseado, otroComensal) {
		if (!otroComensal.tieneElemento(elementoDeseado)) {
			self.error("PersonaNoTieneElElementoCercaException")
		}
		otroComensal.reaccionarAPedidoDeElemento(elementoDeseado, otroComensal)
	}

	method tieneElemento(unElemento) = elementosQueTieneCerca.contains(unElemento)

	method loPrimeroQueTieneAMano() = elementosQueTieneCerca.first() // no habrá problemas con el first(), puesto que la exception en el método pedirle se encarga la modalidad mínima de 1 elemento

	/* Observaciones:
	 * responderSegunCriterioElemento no hay ningún motivo para que reciba por parámetro el comensalOrigen,
	 * al delegar a su criterio puede pasarse a sí mismo (self), lo cual evita que alguien
	 * le mande ese mensaje pasándole un comensal que no es él mismo.
	 */
	/* Observaciones:
	 * y por último, responderSegunCriterioElemento es un nombre que parece estar más asociado a cómo resuelve internamente lo pedido que cuál es la intención..
	 * es un poco difícil siendo que es muy abstractro y el enunciado no te da muchas ideas a partir de las cuales agarrarte,
	 * pero se me ocurre por ejemplo reaccionarAPedidoDeElemento
	 */
	method reaccionarAPedidoDeElemento(elementoDeseado, comensalOrigen) { // acá se modificó el 3er parámetro, tal que no sea posible pasarle otro
	// comensal que no tiene nada que ver en la relación bilateral
		criterioElemento.respuestaElemento(elementoDeseado, comensalOrigen, self) // de esta manera se asegura que sea el mismo objeto el cual recibe el elemento
	}

	/* Observaciones:
	 * yendo por la misma línea, que se intercambien el asiento es algo que podría definirse en Comensal,
	 * para poder usarlo desde el criterio cambiarPosicionDeMesa (y guarda, necesitás usar una variable local para no perder
	 * la posición del comensalOrigen luego de cambiarle su posición - recordá que son mutables!)
	 */
	method intercambiarPosicion(otroComensal) {
		const comensalOriginal = self
		self.posicion(otroComensal.posicion())
		otroComensal.posicion(comensalOriginal.posicion())
	}

	method recibirElemento(nuevoElemento) {
		elementosQueTieneCerca.add(nuevoElemento)
	}

	method distanciarDeElemento(elementoDeseado) {
		elementosQueTieneCerca.remove(elementoDeseado)
	}

	method consumirComida(nuevaComida) {
		comidasConsumidas.add(nuevaComida)
	}

	method comer(comida) {
		if (!criterioAlimenticio.quiereComer(comida)) {
			self.error("ComensalNoQuiereComerLaComidaException")
		}
		self.consumirComida(comida)
	}

	method estaPipon() = comidasConsumidas.any{ comida => comida.esPesada() }

	method comioAlgo() = comidasConsumidas.size() > 0

	method laEstaPasandoBien() = self.comioAlgo()

}

/* Observaciones:
 * por otro lado, no me queda claro para qué existe la clase Criterio (vacía) y la clase abstracta CriterioElemento
 * (sólo necesitás que sean polimórficos los distintos objetos que te representan criterios, no agrega nada tener esa clase)
 * 
 */
//class Criterio {
//
//}
/* Observaciones:
 * estaría bueno abstraer la idea de pasarle un elemento a un comensal en Comensal en vez de repetir
 * esa idea de que el comensal destino reciba el elemento y el comensal origen lo distancie.
 */
class CriterioElemento {

	method respuestaElemento(elemento, comensalOrigen, comensalDestino) {
		comensalDestino.recibirElemento(elemento)
		comensalOrigen.distanciarDeElemento(elemento)
	}

}

object sordo inherits CriterioElemento {

	override method respuestaElemento(elemento, comensalOrigen, comensalDestino) {
		super(comensalOrigen.loPrimeroQueTieneAMano(), comensalOrigen, comensalDestino)
	}

}

object pasaTodo inherits CriterioElemento {

	override method respuestaElemento(elemento, comensalOrigen, comensalDestino) {
		comensalOrigen.elementosQueTieneCerca().forEach{ elem => super(elem, comensalOrigen, comensalDestino)}
	}

}

object cambiaPosicionDeMesa inherits CriterioElemento {

	override method respuestaElemento(elemento, comensalOrigen, comensalDestino) {
		comensalOrigen.intercambiarPosicion(comensalDestino)
//		comensalOrigen.posicion(comensalDestino.posicion())
//		comensalDestino.posicion(comensalOrigen.posicion())
	}

/* Observaciones:
 * yendo por la misma línea, que se intercambien el asiento es algo que podría definirse en Comensal,
 * para poder usarlo desde el criterio cambiarPosicionDeMesa (y guarda, necesitás usar una variable local para no perder
 * la posición del comensalOrigen luego de cambiarle su posición - recordá que son mutables!)
 */
}

object coherente inherits CriterioElemento {

}

class Comida {

	const property nombre
	const property calorias
	const property esCarne

	method esPesada() = calorias > 500

}

class CriterioAlimenticio {

	method quiereComer(comida)

}

object vegetariano inherits CriterioAlimenticio {

	override method quiereComer(comida) = !comida.esCarne()

}

object oms {

	var property caloriaTope = 500

	method cumpleRecomendacion(comida) {
		return comida.calorias() < caloriaTope
	}

}

object dietetico inherits CriterioAlimenticio {

	override method quiereComer(comida) {
		return oms.cumpleRecomendacion(comida)
	}

}

object alternado inherits CriterioAlimenticio {

	var property habiaAceptado = false

	override method quiereComer(comida) {
		if (habiaAceptado) {
			habiaAceptado = false
		} else {
			habiaAceptado = true
		}
		return habiaAceptado
	}

}

class CombinacionCondiciones inherits CriterioAlimenticio {

	var property condiciones

	method aniadirCondicion(nuevaCondicion) {
		condiciones.add(nuevaCondicion)
	}

	method removerCondicion(condicion) {
		condiciones.remove(condicion)
	}

	override method quiereComer(comida) {
		return condiciones.all{ condicion => condicion.apply(comida) }
	}

/* 
 * >>> const condiciones = [ {n => if(n > 10) true else false}, {n => n < 20} ]
 * >>> condiciones.all{ condicion => condicion.apply(11)}
 * true
 */
}

object osky inherits Comensal {

}

object moni inherits Comensal {

	override method laEstaPasandoBien() = super() && posicion == "1@1"

}

object facu inherits Comensal {

	method comioCarne() = comidasConsumidas.any{ comida => comida.esCarne() }

	override method laEstaPasandoBien() = super() && self.comioCarne()

}

object vero inherits Comensal {

	override method laEstaPasandoBien() = super() && elementosQueTieneCerca.size() <= 3

}

/* Punto 5) */
/*
 * Polimorfismo)
 * Se aplicó el concepto de polimorfismo en los distintos tipos de criterios, tanto en los criterios de elementos como criterios alimenticios,
 * respecto de los comensales, pues todo comensal era capaz de preguntarle al criterio que manejaba, los elementos que le tenía que pasar a otro comensal,
 * o bien, si tenía que consumir la comida o no, respectivamente. El polimorfismo mencionado recae, específicamente, sobre el método respuestaElemento/3 y
 * quiereComer/1, respectivamente.
 * El polimorfismo permitió poder preguntarle a cada criterio, sin hacer distinción de qué tipo eran, el mismo mensaje de consulta -qué elemento le debe pasar
 * al comensal que peticiona, o bien, si debe consumir la comida o no, respectivamente-.
 * También se aplicó el concepto de polimorfismo sobre los distintos comensales, específicamente sobre el método laEstaPasandoBien(). El polimorfismo se
 * aplica sobre un tercero -léase "observador"-, que precisa a criterio propio saber si un comensal la está pasando bien o no.
 * Este polimorfismo permite al "observador" poder realizarle preguntas a los distintos comensales, sin importar de qué comensal se trate -léase indistintamente-.
 * 
 * Herencia)
 * Se ha aplicado el concepto de herencia sobre CriterioElemento y CriterioAlimenticio, respecto de Criterio. También se ha aplicado el concepto sobre
 * los distintos tipos de criterios respecto a CriterioElemento, o bien, CriterioAlimenticio, respectivamente.
 * Se ha aplicado el concepto de herencia sobre los distintos comensales presentes, respecto de la clase Comensal.
 * Esto permitió poder sobreescribir el mismo método laEstaPasandoBien/1 para cada, haciendo condición común a que cada comensal haya, por lo menos, consumido
 * alguna comida, y posteriormente permitió la particularización de la condición de si está pasándola bien por cada integrante, heredando el comportamiento general
 * de la clase Comensal -mediante el uso de super()-.
 * 
 * Composición)
 * Se aplicó el concepto de composición en Comensal, específicamente sobre los dos atributos, criterioElemento y criterioAlimenticio, en donde cada comensal conoce a
 * ambos criterios, permitiéndoles mandar mensajes de consulta a ambos según corresponda.
 * Las ventajas subyacen en poder realizar una efectiva delegación, respetando los principios de responsabilidad y encapsulamiento, en donde se puede observar que cada
 * objeto es partícipe de la situación, sabiendo las responsabilidad que debe cumplir en dicho ámbito.
 * 
 */
