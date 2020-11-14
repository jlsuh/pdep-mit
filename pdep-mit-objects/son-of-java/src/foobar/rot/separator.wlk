object separator {

	method splitIntoSingles(stream) {
		return stream.split("").copyWithout(" ")
	}

}

