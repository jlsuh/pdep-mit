class E1 inherits DomainException {

}

class E2 inherits DomainException {

}

class E3 inherits DomainException {

}

class TsarBomba {

	var property explota

	method m3() {
		throw new E1(message = "En m3")
	}

	method m2() {
		try {
			self.m3()
		} catch e : E1 {
			throw new E2(message = "En m2")
		}
	}

	method m1() {
		self.m2()
		if (explota) {
			throw new E3(message = "En m1")
		}
	}

}

