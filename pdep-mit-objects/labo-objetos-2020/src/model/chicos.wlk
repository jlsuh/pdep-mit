import wollok.game.*
import disfraces.*
import game.gameConfiguration.config

object rolo {

	var property position = game.origin()

	method image() = "rolo.png"

	method pedirCaramelos(unHabitante) {
		return 0
	}

	method hacerBullicio() {
		return 5
	}

	method cuantosCaramelosPuedeConseguir(unHabitante) {
		return 1
	}

}

object juanita {

	var property disfraz = superheroe

	method pedirCaramelos(unHabitante) {
		return self.cuantosCaramelosPuedeConseguir(unHabitante) + unHabitante.caramelosQueDa(disfraz)
	}

	method hacerBullicio() {
		return 0
	}

	method position() {
		var x = tito.position().x()
		const y = tito.position().y()
		if (tito.position().x() == 0) {
			x = config.anchoMaximo()
		}
		return game.at(x - 1, y)
	}

	method image() {
		return "juanita-" + disfraz.image()
	}

	method cuantosCaramelosPuedeConseguir(unHabitante) {
		return unHabitante.caramelosQueDa(disfraz) + 2
	}

}

object tito {

	var property position = game.at(2, 0)
	var property disfraz = superheroe

	method pedirCaramelos(unHabitante) {
		return self.cuantosCaramelosPuedeConseguir(unHabitante) + unHabitante.caramelosQueDa(disfraz)
	}

	method hacerBullicio() {
		return 1
	}

	method image() {
		return "tito-" + disfraz.image()
	}

	method cuantosCaramelosPuedeConseguir(unHabitante) {
		if (disfraz == juanita.disfraz()) {
			return juanita.cuantosCaramelosPuedeConseguir(unHabitante)
		}
		return unHabitante.caramelosQueDa(disfraz)
	}

}

