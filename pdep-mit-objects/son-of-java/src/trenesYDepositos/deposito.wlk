class Deposito {

	var property formaciones = []
	var property locomotorasSinUso = []

	method agregarFormacion(unaFormacion) {
		formaciones.add(unaFormacion)
	}

	method vagonMasPesadoDeCadaFormacion() = formaciones.map{ formacion => formacion.vagones().max{ vagon => vagon.pesoMaximo()} }

	method necesitaConductorExperimentado() = formaciones.any{ formacion => formacion.esCompleja() }

	method agregarLocomotoraParaQueSeMueva(unaFormacion) {
		if (!unaFormacion.sePuedeMover()) {
			const locomotorasLibres = locomotorasSinUso.map{ locomotora => formaciones.all{ formacion => not formacion.contains(locomotora) } && (locomotora.arrastreUtil() >= unaFormacion.kilosDeEmpujeQueFaltaParaMoverse() ) }
			if (locomotorasLibres.size() > 0) {
				const unaLocomotora = locomotorasLibres.get(0)
				unaFormacion.agregarLocomotora(unaLocomotora)
				locomotorasSinUso.remove(unaLocomotora)
			}
		}
	}

}

