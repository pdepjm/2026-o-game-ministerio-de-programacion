import wollok.game.*
import juego.*
import personaje.*
import tablero.*

// =====================================================================
//  TEXTOS
// =====================================================================

// Está en la fila de arriba, fuera del laberinto, así que nadie lo pisa
object textoEnergia {
  method position() = game.at(tablero.ancho() / 2, tablero.alto())

  method text() =
    "Nivel: " + juego.nivelActual().numero().toString() +
    "  Energía: " + personaje.energia().toString() +
    "  Vidas: " + personaje.vida().toString() +
    "  Llave: " + (if (personaje.tieneLlave()) "sí" else "no")

  method textColor() = "000000"
}

object textoEstado {
  var property position = game.center()
  var contenido = ""

  method text() = contenido

  method mostrar(nuevoTexto) {
    contenido = nuevoTexto
  }

  method textColor() = "FF0000"
}
