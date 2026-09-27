import wollok.game.*

object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

object personaje {
  var position = game.at(0, 0)
  var energia = 100
  var vida = 3
  var llave = false

//posicion del personaje
method position() = position
method position(nuevaPosition) {
  position = nuevaPosition
}

method mover(nuevaPosition) {
  position = nuevaPosition
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

class Muro {
  const position
  method position() = position
  method image() = "muro1.png"
}

class Llave {
  const position
  method position() = position
  method image() = "llave.png"
}

class Pocion {
  const position
  method position() = position
  method image() = "pocion.png"
}

class TrampaVelocidad {
  const position
  method position() = position
  method image() = "trampavelocidad.png"
}

class TrampaEnergia {
  const position
  method position() = position
  method image() = "trampaenergia.png"
}

class Pasillo {
  const position
  method position() = position
  method image() = "pasillo2.png"
}

object nivel {
    method cargarMapa(matriz) {
        const alto = matriz.size()
        (0 .. (alto - 1)).forEach({ filaIdx => 
            const fila = matriz.get(filaIdx)
            const y = alto - 1 - filaIdx;
            (0 .. (fila.size() - 1)).forEach({ x => 
                const celda = fila.get(x)
                const pos = game.at(x, y)
                self.crearElemento(celda, pos)
            })
        })
    }

    method crearElemento(tipo, pos) {
        if (tipo == "M") {
            game.addVisual(new Muro(position = pos))
        } else {
            game.addVisual(new Pasillo(position = pos))
            
            if (tipo == "L") {
                game.addVisual(new Llave(position = pos))
            } else if (tipo == "O") {
                game.addVisual(new Pocion(position = pos))
            } else if (tipo == "V") {
                game.addVisual(new TrampaVelocidad(position = pos))
            } else if (tipo == "E") {
                game.addVisual(new TrampaEnergia(position = pos))
            }
        }
    }
}


