class Empleado {

	var property salud
	var property tipo
	var property habilidades = #{}

	method estaIncapacitado() = salud < tipo.saludCritica()

	method poseeHabilidad(habilidad) = habilidades.contains(habilidad)

	method puedeUtilizar(habilidad) = !self.estaIncapacitado() || self.poseeHabilidad(habilidad)

	method cumpleRequisitoDeHabilidades(habilidadesRequeridas) = habilidadesRequeridas.all{ habilidadRequerida => self.puedeUtilizar(habilidadRequerida) }

	method recibirDanio(danio) {
		salud -= danio
	}

	method estaVivo() = salud > 0

	method aprenderHabilidad(habilidad) {
		habilidades.add(habilidad)
	}

	method registrarMisionCumplida(mision) {
		if (self.estaVivo()) {
			tipo.recompensaMisionCumplida(self, mision.habilidadesRequeridas())	// Error: se rompió el encapsulamiento de misión
		}
	}

	method cumplirMision(mision) {
		if (!self.cumpleRequisitoDeHabilidades(mision.habilidadesRequeridas())) {	// Error 1: La responsabilidad de cumplir una misión debe recaer en la misión.
		// Notar que mision.habilidadesRequeridas(), las habilidades requeridas son algo propias de las misiones. No es responsabililidad del Empleado en controlarla.
		// Este error provocó en la repetición de lógica con Equipos
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

	method recompensaMisionCumplida(empleado, habilidades) {
		habilidades.forEach{ habilidad => empleado.aprenderHabilidad(habilidad)}
		// Error 2: El problema vendrá cuando el jefe tenga habilidades duplicadas por sus subordinados
	}

}

class Oficinista { // las estrellas no se comparten entre oficinistas

	var property cantidadEstrellas = 0

	method saludCritica() = 40 - 5 * cantidadEstrellas

	method recompensaMisionCumplida(empleado, habilidadesRequeridas) {
		cantidadEstrellas++
		if (cantidadEstrellas >= 3) {
			empleado.tipo(espia)	// Esto es correcto, pues debido a que Oficinista ya es un tipo de empleado, eso quiere decir que ya está acoplado
			// al tipo de empleado. Por ende, en este caso es válido romper el encapsulamiento.
		}
	}

}

class Mision {

	const property habilidadesRequeridas = #{}
	const property peligrosidad

}

class Equipo {

	var property miembros = #{}

	method cumpleRequisitoDeHabilidades(mision) = miembros.any{ miembro => miembro.cumpleRequisitoDeHabilidades(mision.habilidadesRequeridas()) }

	method recibirDanio(danio) {
		miembros.forEach{ miembro => miembro.recibirDanio(danio)}
	}

	method cumplirMision(mision) { // Repetición de lógica
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
