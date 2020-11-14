class Formacion {

	var property locomotoras = []
	var property vagones = []

	method agregarVagon(unVagon) {
		vagones.add(unVagon)
	}

	method agregarLocomotora(unaLocomotora) {
		locomotoras.add(unaLocomotora)
	}

	method totalDePasajerosQuePuedeTransportar() = vagones.sum{ vagon => vagon.cantidadPasajerosQuePuedeTransportar() }

	method cantidadVagonesLivianos() = vagones.count{ vagon => vagon.esLiviano() }

	method velocidadMaxima() = locomotoras.min{ locomotora => locomotora.velocidadMaxima() }.velocidadMaxima()

	method esEficiente() = locomotoras.all{ locomotora => locomotora.pesoQuePuedeArrastrar() >= 5 * locomotora.peso() }

	method pesoMaximoVagones() = vagones.sum{ vagon => vagon.pesoMaximo() }

	method pesoTotalLocomotoras() = locomotoras.sum{ locomotora => locomotora.peso() }

	method pesoTotalFormacion() = self.pesoMaximoVagones() + self.pesoTotalLocomotoras()

	method arrastreUtilTotal() = locomotoras.sum{ locomotora => locomotora.arrastreUtil() }

	method sePuedeMover() = self.arrastreUtilTotal() >= self.pesoMaximoVagones()

	method kilosDeEmpujeQueFaltaParaMoverse() = if (self.sePuedeMover()) 0 else self.pesoMaximoVagones() - self.arrastreUtilTotal()

	method cantidadVagones() = vagones.size()

	method cantidadLocomotoras() = locomotoras.size()

	method cantidadUnidades() = self.cantidadVagones() + self.cantidadLocomotoras()

	method esCompleja() = self.cantidadUnidades() > 20 || self.pesoTotalFormacion() > 10000

}

