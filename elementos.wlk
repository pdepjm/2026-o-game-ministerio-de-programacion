import wollok.game.*
import juego.*

// =====================================================================
//  ELEMENTOS DEL MAPA
// =====================================================================

// ---------- Superclase de los elementos del laberinto ----------
class ElementoMapa {
  const property position

  method image()                      // abstracto: cada subclase pone su imagen
  method esObstaculo() = false        // por defecto no bloquea
  method efecto(personaje) { }        // por defecto no hace nada
}

class Muro inherits ElementoMapa {
  override method image() = "muro1.png"
  override method esObstaculo() = true
}

class Pasillo inherits ElementoMapa {
  override method image() = "pasillo2.png"
}

// ---------- Elementos que se agarran y desaparecen ----------
class Consumible inherits ElementoMapa {
  override method efecto(personaje) {
    game.removeVisual(self)
  }
}

class Llave inherits Consumible {
  override method image() = "llave.png"
  override method efecto(personaje) {
    super(personaje)                  // desaparece del mapa
    personaje.agarrarLlave()
  }
}

class Pocion inherits Consumible {
  override method image() = "pocion.png"
  override method efecto(personaje) {
    super(personaje)
    personaje.recuperarEnergia(20)
  }
}

// ---------- Trampas ----------
class TrampaEnergia inherits ElementoMapa {
  override method image() = "trampaenergia.png"
  override method efecto(personaje) {
    personaje.perderEnergia(15)
  }
}

// Te pone lento por unos pasos
class TrampaVelocidad inherits ElementoMapa {
  override method image() = "trampavelocidad.png"
  override method efecto(personaje) {
    personaje.ralentizar()
  }
}

// La trampa que saca una vida
class Pinches inherits ElementoMapa {
  override method image() = "pinches.png"
  override method efecto(personaje) {
    personaje.perderVida()
  }
}

class Salida inherits ElementoMapa {
  override method image() = "salida.png"
  override method efecto(personaje) {
    if (personaje.tieneLlave()) {
      juego.nivelCompletado()
    }
  }
}
