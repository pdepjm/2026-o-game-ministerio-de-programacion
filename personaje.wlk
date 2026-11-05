import wollok.game.*
import tablero.*
import juego.*

// =====================================================================
//  PERSONAJE
// =====================================================================

// Formas de caminar: cada una sabe cuánta energía cuesta un paso
object pasoNormal {
  method costo() = 2
  method darPaso(personaje) { }
}

class PasoLento {
  var pasosRestantes = 5

  method costo() = 4
  method darPaso(personaje) {
    pasosRestantes -= 1
    if (pasosRestantes == 0) {
      personaje.volverAPasoNormal()
    }
  }
}

object personaje {
  var posicionInicial = game.at(0, 0)
  var position = posicionInicial
  var energia = 100
  var vida = 3
  var llave = false
  var paso = pasoNormal

  method energia() = energia
  method vida() = vida
  method paso() = paso
  method position() = position
  method position(nuevaPosition) { position = nuevaPosition }
  method image() = "personaje.png"
  method esObstaculo() = false

  // al empezar una partida nueva
  method reiniciar() {
    vida = 3
    self.empezarNivel()
  }

  // al pasar de nivel se conservan las vidas
  method empezarNivel() {
    energia = 100
    llave = false
    paso = pasoNormal
  }

  method ubicarEnInicio(pos) {
    posicionInicial = pos
    position = pos
  }

  // ---------- Movimiento ----------
  method moverse(dx, dy) {
    const siguiente = game.at(position.x() + dx, position.y() + dy)
    if (tablero.puedeIrA(siguiente)) {
      self.mover(siguiente)
      self.interactuarConElementosDe(position)
    }
  }

  method mover(nuevaPosition) {
    position = nuevaPosition
    self.perderEnergia(paso.costo())
    paso.darPaso(self)
  }

  method interactuarConElementosDe(pos) {
    self.elementosEn(pos).forEach({ elemento => elemento.efecto(self) })
  }

  // todo lo que hay en la posición, excepto yo mismo
  method elementosEn(pos) =
    tablero.objetosEn(pos).filter({ elemento => elemento != self })

  method ralentizar() { paso = new PasoLento() }
  method volverAPasoNormal() { paso = pasoNormal }

  // ---------- Llave ----------
  method tieneLlave() = llave
  method agarrarLlave() { llave = true }

  // ---------- Energía y vidas ----------
  method recuperarEnergia(cantidad) {
    energia = (energia + cantidad).min(100)
  }

  method perderEnergia(cantidad) {
    energia = (energia - cantidad).max(0)
    if (energia == 0) {
      juego.terminar("Game Over: te quedaste sin energía")
    }
  }

  method perderVida() {
    vida = (vida - 1).max(0)
    if (vida == 0) {
      juego.terminar("Game Over: te quedaste sin vidas")
    }else{
      position = posicionInicial
    }
  }
}
