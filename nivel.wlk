import wollok.game.*
import juego.*
import personaje.*
import textos.*

// =====================================================================
//  NIVEL
// =====================================================================

class Nivel {
  const mapa
  const property numero
  const property siguienteNivel
  const property fantasmas = []

  method iniciar() {
    game.clear()
    fantasmas.clear()
    juego.nivelActual(self)
    personaje.empezarNivel()

    self.dibujarMapa()
    game.addVisual(personaje)
    game.addVisual(textoEnergia)

    juego.configurarTeclado()
  }

  // Recorre el mapa y le pide a cada letra que se dibuje en su lugar.
  // La primera fila del mapa es la de arriba del tablero.
  method dibujarMapa() {
    var y = mapa.size() - 1
    var x = 0
    mapa.forEach({ fila =>
      fila.forEach({ celda =>
        celda.decode(x, y, self)
        x += 1
      })
      y -= 1
      x = 0
    })
  }

  method agregarFantasma(fantasma) { fantasmas.add(fantasma) }

  method moverFantasmas() {
    fantasmas.forEach({ fantasma => fantasma.mover() })
  }
}

// Cuando se completa el último nivel, su "siguiente nivel" es la victoria
object victoria {
  method iniciar() {
    juego.terminar("Has Escapado!!!")
  }
}
