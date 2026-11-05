import wollok.game.*
import niveles.*
import personaje.*
import textos.*
import tablero.*

// =====================================================================
//  MENÚ Y FLUJO DEL JUEGO
// =====================================================================

object juego {
  var property nivelActual = nivel1

  // Esto es lo único que hay que llamar desde el programa
  method iniciar() {
    game.title("Laberinto")
    game.width(tablero.ancho())
    game.height(tablero.alto() + 1)   // fila extra arriba para el texto
    game.cellSize(50)
    self.menu()
    game.start()
  }

  method menu() {
    game.clear()
    textoEstado.mostrar("Presioná ENTER para jugar")
    game.addVisual(textoEstado)
    keyboard.enter().onPressDo({ self.jugar() })
  }

  method jugar() {
    personaje.reiniciar()
    nivel1.iniciar()
  }

  method configurarTeclado() {
    keyboard.up().onPressDo({ personaje.moverse(0, 1) })
    keyboard.down().onPressDo({ personaje.moverse(0, -1) })
    keyboard.left().onPressDo({ personaje.moverse(-1, 0) })
    keyboard.right().onPressDo({ personaje.moverse(1, 0) })

    game.onTick(500, "fantasmas", { nivelActual.moverFantasmas() })
  }

  // Cada nivel sabe cuál es el siguiente (el último apunta a la victoria)
  method nivelCompletado() {
    nivelActual.siguienteNivel().iniciar()
  }

  // Al terminar (gane o pierda) muestra el mensaje y vuelve al menú
  method terminar(mensaje) {
    game.clear()
    textoEstado.mostrar(mensaje)
    game.addVisual(textoEstado)
    game.schedule(2000, { self.menu() })
  }
}
