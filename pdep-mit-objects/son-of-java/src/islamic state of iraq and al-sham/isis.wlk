class Empleado {

	var property salud
	var property tipo
	var property habilidades = #{}

	method estaIncapacitado() = salud < tipo.saludCritica()

	method poseeHabilidad(habilidad) = habilidades.contains(habilidad)

	method puedeUtilizar(habilidad) = !self.estaIncapacitado() && self.poseeHabilidad(habilidad)

	method cumpleRequisitoDeHabilidades(mision) = mision.habilidadesRequeridas().all{ habilidadRequerida => self.puedeUtilizar(habilidadRequerida) }

	method recibirDanio(danio) {
		salud -= danio
	}

	method sobrevivioAMision() = salud > 0

	method aprenderHabilidad(mision) {
		habilidades.addAll(mision.habilidadesRequeridas()) // como es un set, no tendrá problemas de duplicado
	}

	method registrarMisionCumplida(mision) {
//		if (!self.sobrevivioAMision()) {
//			throw new EmpleadoNoSobrevivioAMisionException(message = "El empleado no pudo sobrevivir a la misión F")
//		}
		tipo.recompensaMisionCumplida(self, mision)
	}

	method cumplirMision(mision) {
		if (!self.cumpleRequisitoDeHabilidades(mision)) {
			throw new EmpleadoNoCumpleRequisitoDeHabilidadException(message = "El empleado no puede utilizar alguna habilidad requerida para la misión")
		}
		self.recibirDanio(mision.peligrosidad())
		self.registrarMisionCumplida(mision)
	}

}

class Jefe inherits Empleado {

	var property subordinados = #{}

	override method puedeUtilizar(habilidad) = super(habilidad) && self.subordinadosPoseenHabilidad(habilidad)

	method subordinadosPoseenHabilidad(habilidad) = subordinados.any{ subordinado => subordinado.puedeUtilizar(habilidad) }

}

object espia {

	method saludCritica() = 15

	method recompensaMisionCumplida(empleado, mision) {
		empleado.aprenderHabilidad(mision)
	}

}

class Oficinista { // las estrellas no se comparten entre oficinistas

	var property cantidadEstrellas = 0

	method saludCritica() = 40 - 5 * cantidadEstrellas

	method recompensaMisionCumplida(empleado, mision) {
		cantidadEstrellas++
		if (cantidadEstrellas >= 3) {
			empleado.tipo(espia)
		}
	}

}

class Mision {

	const property habilidadesRequeridas = #{}
	const property peligrosidad

}

class Equipo {

	var property miembros = #{}

	method cumpleRequisitoDeHabilidades(mision) = miembros.any{ miembro => miembro.cumpleRequisitoDeHabilidades(mision) }

	method recibirDanio(danio) {
		miembros.forEach{ miembro => miembro.recibirDanio(danio)}
	}

	method cumplirMision(mision) {
		if (!self.cumpleRequisitoDeHabilidades(mision)) {
			throw new EquipoNoCumpleRequisitoDeHabilidadException(message = "El equipo no posee a ningún miembro que pueda utilizar todas las habilidades requeridas en la misión")
		}
		self.recibirDanio(mision.peligrosidad() / 3)
		miembros.forEach{ miembro => miembro.registrarMisionCumplida(mision)}
	}

}

class RequisitoDeHabilidadException inherits DomainException {

}

class EmpleadoNoCumpleRequisitoDeHabilidadException inherits RequisitoDeHabilidadException {

}

class EquipoNoCumpleRequisitoDeHabilidadException inherits RequisitoDeHabilidadException {

}

//class EmpleadoNoSobrevivioAMisionException inherits DomainException {
//
//}
