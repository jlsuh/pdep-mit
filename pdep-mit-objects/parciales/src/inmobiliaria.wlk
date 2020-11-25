/* Organizar empleados
 * Gerencia de venta nos contact
 * 
 * Hay:
 * - EMPLEADOS
 * 
 * - OPERACIONES
 * 	 pueden ser VENTAS o ALQUILERES de un INMUEBLE
 * 
 * El empleado cobra una COMISION para una OPERACION conretada
 * - Polimorfismo en comisiones
 * 
 * OPERACIONES PARA QUE SE LA PUBLICA un INMUEBLE debe ser composite:
 * - VENTA o ALQUILER
 * 
 * ZONA debe ser composite: tiene un valor plus asociado
 * 
 * OPERACION debe tener asociado una propiedad y un cliente 
 * 
 * empleado.realizarReserva(propiedad, cliente)
 * empleado.concretarOperacionPublicada(operacion, )
 * 
 */
object inmobiliaria {

	const property operaciones = []
	const property empleados = []

	method operacionesConcretadas() = operaciones.findOrElse({ operacion => operacion.fueConcretada() }, throw new NoHayOperacionesConcretadasException(message = "La inmobiliaria no concretó ninguna operación"))

	method esOperacionConcretada(unaOperacion) = self.operacionesConcretadas().contains(unaOperacion)

	method esEmpleado(unEmpleado) = empleados.contains(unEmpleado)

	// inmobiliaria.comision(unaOperacion)
	method comision(unaOperacion) {
		if (!self.esOperacionConcretada(unaOperacion)) {
			throw new NoEsUnaOperacionConcretadaException(message = "La operación no es una operación concretada")
		}
		return unaOperacion.comision()
	}

	// inmobiliaria.mejorEmpleadoSegunTotalComisionesQueLeCorrespondePorOperacionesCerradas()
	// delegar en tres objetos
	method mejorEmpleadoSegun(unCriterio) = unCriterio.criterioAMaximizar(empleados)

	// method mejorEmpleadoSegunTotalComisionesQueLeCorrespondePorOperacionesCerradas() = empleados.max{ empleado => empleado.comisionPorOperacionesConcretadas() }
	// method mejorEmpleadoSegunCantidadOperacionesCerradas() = empleados.max{ empleado => empleado.cantidadOperacionesCerradas() }
	// method mejorEmpleadoSegunCantidadDeReservas() = empleados.max{ empleado => empleado.cantidadDeReservasSobreInmuebles() }
	// inmobiliaria.tendrianProblemas(unEmpleado, otroEmpleado)
	method tendrianProblemas(unEmpleado, otroEmpleado) {
		if (!self.esEmpleado(unEmpleado) || !self.esEmpleado(otroEmpleado)) {
			throw new NoEsEmpleadoException(message = "No es un empleado")
		}
		return unEmpleado.tendraUnProblemaCon(otroEmpleado)
	}

	method aniadirNuevaOperacion(nuevaOperacion) {
		operaciones.add(nuevaOperacion)
	}

}

object criterioMejorEmpleadoSegunTotalComisionesCerradas {

	method criterioAMaximizar(empleados) = empleados.max{ empleado => empleado.comisionPorOperacionesConcretadas() }

}

object criterioMejorEmpleadoSegunCantidadOperacionesCerradas {

	method criterioAMaximizar(empleados) = empleados.max{ empleado => empleado.cantidadOperacionesCerradas() }

}

object criterioMejorEmpleadoSegunCantidadDeReservas {

	method criterioAMaximizar(empleados) = empleados.max{ empleado => empleado.cantidadDeReservasSobreInmuebles() }

}

//class Cliente {
//
//	// cliente.solicitarReserva(empleado, unaPropiedad)
//	method solicitarReserva(unEmpleado, unaPropiedad) {
//		unEmpleado.realizarReserva(self, unaPropiedad)
//	}
//
//	// cliente.solicitarConcretacionOperacionPublicada(unEmpleado, unaOperacion)
//	method solicitarConcretacionOperacionPublicada(unEmpleado, unaOperacion) {
//		unEmpleado.concretarOperacionPublicada(self, unaOperacion)
//	}
//
//}
class Empleado {

	var property comisionesPorOperacionesConcretadas = 0
	const property operacionesEnQueSeInvolucro = []

	method operacionesConcretadas() = operacionesEnQueSeInvolucro.filter{ operacion => operacion.fueConcretada() }

	method cantidadOperacionesCerradas() = self.operacionesConcretadas().size()

	// method comisionPorOperacionesConcretadas() = self.operacionesConcretadas().sum{ operacion => operacion.comision() }
	method operacionesReservadas() = operacionesEnQueSeInvolucro.filter{ operacion => operacion.inmuebleAsociadoEstaReservado() }

	method cantidadDeReservasSobreInmuebles() = self.operacionesReservadas().size()

	method tendraUnProblemaCon(otroEmpleado) = self.cerroOperacionesEnLaMismaZonaQue(otroEmpleado) && (self.concretoUnaOperacionReservadaPor(otroEmpleado) || otroEmpleado.concretoUnaOperacionReservadaPor(self))

	method zonasEnDondeConcretoOperaciones() = self.operacionesConcretadas().map{ operacion => operacion.zonaAsociada() }

	method cerroOperacionesEnLaMismaZonaQue(otroEmpleado) {
		const zonasEnDondeCerroOperacionesElOtroEmpleado = otroEmpleado.zonasEnDondeConcretoOperaciones()
		return zonasEnDondeCerroOperacionesElOtroEmpleado.any{ unaZona => self.zonasEnDondeConcretoOperaciones().contains(unaZona) }
	}

	method concretoUnaOperacionReservadaPor(otroEmpleado) {
		const operacionesReservadas = otroEmpleado.operacionesReservadas()
		return operacionesReservadas.any{ operacionReservada => self.operacionesConcretadas().contains(operacionReservada) }
	}

	// empleado.realizarReserva(unaPropiedad)
	method realizarReserva(unCliente, unaPropiedad) {
		if (unaPropiedad.estaReservado()) {
			throw new LaPropiedadYaEstaReservadaException(message = "No se puede realizar la reserva sobre una propiedad ya reservada")
		}
		const nuevaOperacion = new Operacion(inmueble = unaPropiedad, tipoOperacion = unaPropiedad.operacionParaLaQueSeLaPublica())
		self.verificarQueLaOperacionDeseadaSeaPosible(nuevaOperacion, unaPropiedad)
		self.concretarReserva(unCliente, unaPropiedad, nuevaOperacion)
	}

	method concretarReserva(unCliente, unaPropiedad, nuevaOperacion) {
		unaPropiedad.reservarPropiedad(unCliente)
		inmobiliaria.aniadirNuevaOperacion(nuevaOperacion)
		self.involucrarEnNuevaOperacion(nuevaOperacion)
	}

	method verificarQueLaOperacionDeseadaSeaPosible(nuevaOperacion, unaPropiedad) {
		if (nuevaOperacion.esUnaVenta() && !unaPropiedad.puedeVenderse()) {
			throw new PropiedadNoSePuedeVender(message = "La propiedad no es posible venderse")
		}
	// puede escalar en más verificaciones, como por ejemplo, si es que surge un nuevo requisito sobre los alquileres
	}

	method involucrarEnNuevaOperacion(nuevaOperacion) {
		operacionesEnQueSeInvolucro.add(nuevaOperacion)
	}

	// empleado.concretarOperacionPublicada()
	method concretarOperacionPublicada(unCliente, unaOperacion) {
		if (!unaOperacion.esClienteAsociado(unCliente)) {
			throw new NoEsElMismoClienteQueRealizoLaReserva(message = "El cliente no es el quien realizó la reserva originalmente")
		}
		self.verificarQueLaOperacionDeseadaSeaPosible(unaOperacion, unaOperacion.inmueble())
		self.concretarOperacion(unaOperacion)
	}

	method concretarOperacion(unaOperacion) {
		self.cobrarComision(unaOperacion.comisionAsociada())
		unaOperacion.concretarse()
	}

	method cobrarComision(nuevaComision) {
		comisionesPorOperacionesConcretadas += nuevaComision
	}

}

// Operación suele solapar requisitos
class Operacion {

	var property fueConcretada = false
	const property inmueble
	const property tipoOperacion

	method comision() = tipoOperacion.comision(inmueble)

	method inmuebleAsociadoEstaReservado() = inmueble.estaReservado()

	method zonaAsociada() = inmueble.zona()

	method esClienteAsociado(unCliente) = inmueble.esClienteAsociado(unCliente)

	method comisionAsociada() = inmueble.comision()

	method concretarse() {
		fueConcretada = true
	}

	method esUnaVenta() = tipoOperacion == venta

}

class Alquiler {

	const property cantidadDeMesesContrato = 0

	method comision(unInmueble) = cantidadDeMesesContrato * unInmueble.valorInmueble() / 50000

}

object venta {

	const porcentajeValorInmueble = 1.5

	method comision(unInmueble) = porcentajeValorInmueble * unInmueble.valorInmueble() / 100

}

class Inmueble {

	var property metrosCuadrados
	const property cantidadAmbientes
	var property operacionParaLaQueSeLaPublica
	const property tipoInmueble
	var property cliente
	var property zona

	method estaReservado() = cliente != libreDeReserva

	method valorInmueble() = tipoInmueble.valorInmueble(self) + zona.plusZona()

	method reservarInmueble(nuevoCliente) {
		cliente = nuevoCliente
	}

	method esClienteAsociado(unCliente) = cliente == unCliente

	method puedeVenderse() = tipoInmueble.puedeVenderse()

	method puedeAlquilarse() = tipoInmueble.puedeAlquilarse()

}

object libreDeReserva {

}

class Zona {

	const property nombre
	var property plusZona

}

class TipoInmueble {

	method puedeVenderse() = true

	method puedeAlquilarse() = true

	method valorInmueble(unInmueble)

}

class Casa inherits TipoInmueble {

	const property valorParticular

	override method valorInmueble(unInmueble) = valorParticular

}

class PH inherits TipoInmueble {

	override method valorInmueble(unInmueble) = (14000 * unInmueble.metrosCuadrados()).max(500000)

}

class Departamento inherits TipoInmueble {

	override method valorInmueble(unInmueble) = 350000 * unInmueble.cantidadAmbientes()

}

class Local inherits Casa {

	var property tipoLocal

	override method valorInmueble(unInmueble) = tipoLocal.valorInmueble(unInmueble)

	override method puedeVenderse() = false

}

object galpon {

	method valorInmueble(unInmueble) = unInmueble.valorInmueble() / 2

}

object aLaCalle {

	const montoFijo = 0

	method valorInmueble(unInmueble) = montoFijo

}

class NoHayOperacionesConcretadasException inherits DomainException {

}

class NoEsUnaOperacionConcretadaException inherits DomainException {

}

class NoEsEmpleadoException inherits DomainException {

}

class LaPropiedadYaEstaReservadaException inherits DomainException {

}

class NoEsElMismoClienteQueRealizoLaReserva inherits DomainException {

}

class PropiedadNoSePuedeVender inherits DomainException {

}

