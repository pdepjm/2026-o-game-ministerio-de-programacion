import wollok.game.*

object personaje {
  var posicion = game.at(1, 1)
  var energia = 100
  var vida = 3
  var llave = false

//posicion del personaje
    method position() = posicion
    method position(nuevaPosicion) {
      posicion = nuevaPosicion
      }

  method mover(nuevaPosicion) {
        posicion = nuevaPosicion
        energia = (energia - 2).max(0)
    }

    //imagen de personaje
    method image() = "personaje.png"

    method tieneLlave() = llave
    method agarrarLlave() { 
      llave = true 
      }

  method perderVida() {
    vida = (vida - 1).max(0)
    //para la prox entrega se podria agregar mensaje de game over si la vida llega a 0
  }
}

