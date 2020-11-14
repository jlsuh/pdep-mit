class Maestro {

	var property habilidad

	method esGroso() = habilidad > 5 && self.poder() > 1000

	method poder()

}

object aang inherits Maestro(habilidad = 100) {

	var property mascota // esto da warning pero en la consigna no hacen referencia a ningún valor inicial para mascota

	override method poder() = mascota.poder() * habilidad

}

class Mascota {

	const property poder

}

object appa inherits Mascota(poder = 150) {

}

object momo inherits Mascota(poder = 15) {

}

class MaestroAgua inherits Maestro {

	override method poder() = habilidad * 100

	method esPeligroso() = self.poder() > 3000

}

class MaestroSangre inherits MaestroAgua {

	override method esPeligroso() = true

	override method poder() {
		return super() * 2
	}

}

class MaestroFuego inherits Maestro {

	var rabia
	var locura

	override method poder() = rabia / locura

}

