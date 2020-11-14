object pruebita {

	const property listaConstProperty = []	// no puede modificar su referencia + entiende el mensaje listaConstProperty() 
	var property listaVarProperty = []	// puede modificar su referencia + entiende el mensaje listaVarProperty()
	const listaConst = []	// no puede modificar su referencia + no entiende el mensaje listaConst()
	
	// const | const property | Preguntarse: ¿necesita un cierto observador conocer la lista o no?

	method agregarListaCP(elemento) {
		listaConstProperty.add(elemento)
	}

	method agregarListaVP(elemento) {
		listaVarProperty.add(elemento)
	}

	method agregarListaC(elemento) {
		listaConst.add(elemento)
	}

}

