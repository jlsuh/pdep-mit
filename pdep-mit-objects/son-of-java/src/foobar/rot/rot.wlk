object rot {

	method rotStream(stream, shiftValue) {
		return stream.forEach{ char => char + shiftValue }
	}

}

