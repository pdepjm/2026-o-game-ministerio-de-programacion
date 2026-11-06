import wollok.game.*
import tablero.*
import personaje.*

// =====================================================================
//  FANTASMAS
// =====================================================================

// Van y vienen; si chocan contra un muro cambian de sentido.
// Si tocan al personaje, le sacan una vida.
class Fantasma {
  var property position
  var sentido = 1

  method image() = "character.png"
  method esObstaculo() = false
  method efecto(personaje) { personaje.perderVida() }

  // por defecto se mueve en horizontal
  method siguientePosicion() = game.at(position.x() + sentido, position.y())

  method mover() {
    const siguiente = self.siguientePosicion()
    if (tablero.puedeIrA(siguiente)) {
      position = siguiente
    } else {
      sentido = -sentido
    }
    if (personaje.position() == position) {
      self.efecto(personaje)
    }
  }
}

class FantasmaVertical inherits Fantasma {
  override method siguientePosicion() = game.at(position.x(), position.y() + sentido)
}
