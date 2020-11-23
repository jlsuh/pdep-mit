// contenido.totalRecaudado()
class Contenido {

	var property titulo
	var property estrategiaDeMonetizacion
	var property vistas
	var property esOfensiva = false
	const property tipo

	// TODO: Cuando cambia la forma de monetizar, se debe perder todo lo recaudado hasta ahora por el contenido
	// esto permite que al cambiar, no deba modificarse lo recaudado hasta ahora en contenido, sino que solamente
	// el monto recaudado hasta ahora depende de las estrategias de monetización
	method totalRecaudado() = estrategiaDeMonetizacion.recaudacion(self)

	method plusPopularidad() = if (self.esPopular()) 2000 else 0
	
//	private int plusPopularidad() {
//		return this.esPopular() ? 2000 : 0;
//	}

	method esPopular() = tipo.esPopular(self)

	method maximoRecaudableConPublicidad() = tipo.maximoRecaudableConPublicidad()

	method donacionAlAutor(monto) {
		estrategiaDeMonetizacion.donacionAlAutor(monto, self)
	}

	method descargarContenido() {
		estrategiaDeMonetizacion.descargar(self)
	}

	method validarMonetizabilidad(unaEstrategia) {
		if (!unaEstrategia.esMonetizable(self)) {
			throw new ContenidoNoMonetizable(message = "El contenido no cumple las restricciones para la estrategia")
		}
	}

}

class Imagen {

	var property tags

	method esPopular(unContenido) = self.marcadaConTodosLosTagsDeModa()

	method marcadaConTodosLosTagsDeModa() = tags.contains(plataforma.tagsTrending())

	method maximoRecaudableConPublicidad() = 4000

}

object video {

	method esPopular(unContenido) = unContenido.vistas() > 10000

	method maximoRecaudableConPublicidad() = 10000

}

class Donacion {

	var property donaciones = 0

	method recaudacion(unContenido) = donaciones

	method donacionAlAutor(monto, unContenido) {
		// unContenido.estrategiaDeMonetizacion(new Donacion(donaciones = donaciones + monto))
		donaciones += 1
	}

	method descargar(unContenido) {
		throw new ContenidoNoDescargableException(message = "No se puede descargar el contenido")
	}

	method esMonetizable(unContenido) = true

}

class VentaDescarga {

	const property precioFijo
	var property cantidadesVendidas = 0

	method precioMinimo() = 5

	method recaudacion(unContenido) = cantidadesVendidas * precioFijo.max(self.precioMinimo())

	method donacionAlAutor(monto) {
		throw new NoSeAdmitenDonaciones(message = "No se admiten donaciones")
	}

	method descargar(unContenido) {
		// unContenido.estrategiaDeMonetizacion(new VentaDescarga(cantidadesVendidas = cantidadesVendidas + 1, precioFijo = precioFijo))
		cantidadesVendidas += 1
	}

	method esMonetizable(unContenido) = unContenido.esPopular()

}

class Alquiler inherits VentaDescarga {

	const property fechaDeAutodestruccion

	override method precioMinimo() = 1

	override method esMonetizable(unContenido) = super(unContenido) && unContenido.tipo() == video

}

object publicidad {

	method recaudacion(unContenido) = self.acotacionMaximoRecaudable(unContenido, 0.05 * unContenido.vistas() + unContenido.plusPopularidad())

	method acotacionMaximoRecaudable(unContenido, unaRecaudacion) = unContenido.maximoRecaudableConPublicidad().min(unaRecaudacion)

	method donacionAlAutor(monto) {
		throw new NoSeAdmitenDonaciones(message = "No se admiten donaciones")
	}

	method descargar(unContenido) {
		throw new ContenidoNoDescargableException(message = "No se puede descargar el contenido")
	}

	method esMonetizable(unContenido) = !unContenido.esOfensiva()

}

class Usuario {

	var property contenidos = #{}
	var property esVerificado
	var property email
	var property nombre

	// usuario.saldoTotal()
	method saldoTotal() = contenidos.sum{ contenido => contenido.totalRecaudado() }

	method esSuperUsuario() = contenidos.filter{ contenido => contenido.esPopular() }.size() >= 10

	method publicarNuevoContenido(unContenido, unaEstrategia) {
		plataforma.publicarNuevoContenido(unContenido, unaEstrategia, self)
	}

	method aniadirAContenidos(unContenido) {
		contenidos.add(unContenido)
	}

}

object plataforma {

	var property contenidos = #{}
	var property usuarios = #{}
	const property tagsTrending = []

	method totalRecaudado(unContenido) = unContenido.totalRecaudado()

	method saldoTotalUsuario(unUsuario) = unUsuario.saldoTotal()

	method emailsDeCienUsuariosVerificadosConMayorSaldoTotal() = self.top100UsuariosConMayorSaldoYVerificados()

	method top100UsuariosConMayorSaldoYVerificados() = usuarios.sortedBy{ u1 , u2 => self.saldoTotalUsuario(u1) > self.saldoTotalUsuario(u2) && u1.esVerificado() && u2.esVerificado() }.take(100).map{ u => u.email() }

	method cantidadSuperUsuarios() = usuarios.filter{ usuario => usuario.esSuperUsuario() }

	method publicarNuevoContenido(unContenido, unaEstrategia, unUsuario) {
		unContenido.validarMonetizabilidad(unaEstrategia)
		unContenido.estrategiaDeMonetizacion(unaEstrategia)
		unUsuario.aniadirAContenidos(unContenido)
	}

}

class NoSeAdmitenDonaciones inherits DomainException {

}

class ContenidoNoDescargableException inherits DomainException {

}

class ContenidoNoMonetizable inherits DomainException {

}

/* 5a) ¿Cuáles de los siguientes requerimientos te parece que sería el más fácil y cuál el más difícil de implementar
 * en la solución que modelaste? Responder relacionando cada caso con conceptos del paradigma.
 * i. Agregar un nuevo tipo de contenido.
 * ii. Permitir cambiar el tipo de un contenido (e.j.: convertir un video a imagen).
 * iii. Agregar un nuevo estado “verificación fallida” a los usuarios, que no les permita cargar ningún nuevo contenido.
 * 
 * i) Sería muy fácil para agregar un nuevo tipo de contenido, pues solamente haría falta que implementen la interfaz de
 * un tipo de contenido, en donde la misma debe implementar los métodos: esPopular(unContenido) y maximoRecaudableConPublicidad()
 * Solamente se debe implementar una interfaz, pues se optó por el modelado mediante la composición.
 * 
 * ii) Sería muy fácil cambiar el tipo de contenido, pues se optó el modelo mediante la composición. Solamente se debería cambiar
 * de const property tipo, a var property tipo
 * 
 * iii) Sería muy fácil, pues solamente se debería verificar previamente mediante un chequeo condicional, si el usuario posee
 * el estado de "verificación fallida". En caso de que así sea, no se le debería permitir cargar un nuevo contenido mediante
 * una excepción.
 * 
 * 5b)
 * Se está aprovechando el polimorfismo en los tipos de contenido y las estrategias de cotizaciones. Para el caso de los tipos de contenido
 * se debe a que manejan la misma interfaz, haciendo que al momento de delegar en el tipo de contenido, los mismos sepan responder en forma
 * indistinta, con solamente saber que es un tipo de contenido.
 * Para las estrategias de cotizaciones, se debe a que todos saben cómo calcular el monto recaudado actualmente, verificando su estado interno
 * como así también delegando en el contenido.
 * 
 */
