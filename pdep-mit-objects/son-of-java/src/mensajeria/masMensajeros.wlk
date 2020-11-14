object mensajeria {

	const property empleados = []
	var property pendientes = []

	method contratar(nuevoEmpleado) = empleados.add(nuevoEmpleado)

	method despedir(empleado) = empleados.remove(empleado)

	method despedirATodos() = empleados.forEach{ empleado => self.despedir(empleado) }

	method esGrande() = empleados.size() > 2

	method loEntregaElPrimero() = paquete.puedeSerEntregadoPor(empleados.first())

	method pesoDelUltimo() = empleados.last().peso()

	method algunoPuedeEntregar(paquete) = empleados.any{ empleado => paquete.puedeSerEntregadoPor(empleado) }

	method candidatosPara(paquete) = empleados.filter{ empleado => paquete.puedeSerEntregadoPor(empleado) }

	method tieneSobrepeso() = empleados.sum{ empleado => empleado.peso() } / empleados.size() > 500

	method enviar(paquete) {
		if (!self.algunoPuedeEntregar(paquete)) {
			pendientes.add(paquete)
		}
	}

	method enviarTodos(listaPaquetes) = listaPaquetes.forEach{ paquete => self.enviar(paquete) }

	method enviarPendienteCaro() {
		const paqueteMasCaro = pendientes.max{ paquete => paquete.precio() }
		if (self.algunoPuedeEntregar(paqueteMasCaro)) {
			pendientes.remove(paqueteMasCaro)
		}
	}

}

object paqueton {

	const precioPorDestino = 100
	var property destinos = []
	var pagoParcial = 0

	method precio() = destinos.size() * precioPorDestino

	method pagar(importe) {
		pagoParcial += importe
	}

	method estaPago() = pagoParcial >= self.precio()

	method puedeSerEntregadoPor(mensajero) = destinos.all{ destino => destino.dejaEntrar(mensajero) } && self.estaPago()

}

object paquete {

	var property destino = laMatrix
	var property estaPago = false
	const property precio = 50

	method pagar() {
		estaPago = true
	}

	method puedeSerEntregadoPor(mensajero) = destino.dejaEntrar(mensajero) && self.estaPago()

}

object paquetito {

	var property destino = laMatrix
	var property estaPago = true
	const property precio = 0

	method pagar() {
		estaPago = true
	}

	method puedeSerEntregadoPor(mensajero) = true

}

object chuck {

	const property peso = 900
	const property puedeRealizarUnaLlamada = true

}

object bicicleta {

	const property peso = 1

}

class Acoplado {

	const property peso = 500

}

object camion {

	const property acoplados = []

	method peso() = acoplados.sum{ acoplado => acoplado.peso() }

	method agregarAcoplado(acoplado) = acoplados.add(acoplado)

}

object roberto {

	const pesoPropio = 90
	var property maneja = bicicleta
	const property puedeRealizarUnaLlamada = false

	method peso() {
		return pesoPropio + maneja.peso()
	}

}

object prueba {

	method robertoTieneBici() {
		roberto.maneja(bicicleta)
	}

	method robertoTieneCamionCon1Acoplado() {
		camion.agregarAcoplado(new Acoplado())
		roberto.maneja(camion)
	}

	method unAcopladoMasParaElCamionDeRoberto() {
		camion.agregarAcoplado(new Acoplado())
	}

}

object laMatrix {

	method dejaEntrar(alguien) = alguien.puedeRealizarUnaLlamada()

}

object puenteDeBrooklyn {

	method dejaEntrar(alguien) = alguien.peso() < 1000

}

object neo {

	const property peso = 0
	var property credito = 7
	const creditoPorLlamada = 5

	method puedeRealizarUnaLlamada() = credito >= creditoPorLlamada

	method llamar() {
		// if (self.puedeRealizarUnaLlamada()) {
		credito -= creditoPorLlamada
	// }
	}

}

