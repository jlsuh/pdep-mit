class Disfraz {

	var property ternura
	var property terror
	const property image

	method esAdorable() {
		return ternura > 6 && terror < 4
	}

	method esTerrorifico() {
		return terror >= 8
	}

	method masTiernoQueAterrador() {
		return ternura > terror
	}

}

const venom = new Disfraz(ternura = 0, terror = 8, image = "venom.png")

const superheroe = new Disfraz(ternura = 5, terror = 0, image = "superheroe.png")

const ironman = new Disfraz(ternura = 1, terror = 4, image = "ironman.png")

const harleyQuinn = new Disfraz(ternura = 9, terror = 2, image = "harleyquinn.png")

