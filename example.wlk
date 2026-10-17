import wollok.game.*

// ---------- Superclase de los elementos del laberinto ----------
class ElementoMapa {
  const property position

  method image()
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

class Llave inherits ElementoMapa {
  override method image() = "llave.png"
  override method efecto(personaje) {
    personaje.agarrarLlave()
    game.removeVisual(self)
  }
}

class Pocion inherits ElementoMapa {
  override method image() = "pocion.png"
  override method efecto(personaje) {
    personaje.recuperarEnergia(20)
    game.removeVisual(self)
  }
}

class TrampaEnergia inherits ElementoMapa {
  override method image() = "trampaenergia.png"
  override method efecto(personaje) {
    personaje.perderEnergia(15)
  }
}

class TrampaVelocidad inherits ElementoMapa {
  override method image() = "trampavelocidad.png"
  override method efecto(personaje) {
    // TODO: definir qué hace (ej: personaje.perderVida())
  }
}

class Salida inherits ElementoMapa {
  override method image() = "salida.png"
  override method efecto(personaje) {
    if(personaje.tieneLlave()){
      personaje.salirDelLaberinto()
    }
  }
}

// ---------- Personaje ----------
object personaje {
  var position = game.at(0, 0)
  var energia = 100
  var vida = 3
  var llave = false

  method energia() = energia
  method vida() = vida
  method position() = position
  method position(nuevaPosition) { position = nuevaPosition }
  method image() = "personaje.png"

  method mover(nuevaPosition) {
    position = nuevaPosition
    self.perderEnergia(2)
  }

  method estaDentroDelTablero(pos) =
    pos.x() >= 0 and pos.x() < game.width() and
    pos.y() >= 0 and pos.y() < game.height()

  method hayObstaculoEn(pos) =
    self.elementosEn(pos).any({ e => e.esObstaculo() })

  method interactuarConElementosDe(pos) {
    self.elementosEn(pos).forEach({ e => e.efecto(self) })
  }

  // todo lo que hay en la posición, excepto yo mismo
  method elementosEn(pos) =
    game.getObjectsIn(pos).filter({ e => e != self })

  method moverse(dx, dy) {
    const siguiente = game.at(position.x() + dx, position.y() + dy)      
    if(self.energia() > 0 && !nivel.jugadorGano()){
      if (self.estaDentroDelTablero(siguiente)) {
        if (not self.hayObstaculoEn(siguiente)) {
          self.mover(siguiente)
          self.interactuarConElementosDe(position)
        }
      }
    }
  }

  method tieneLlave() = llave
  method agarrarLlave() { llave = true }

  method recuperarEnergia(cantidad) {
    energia = (energia + cantidad).min(100)
  }

  method perderEnergia(cantidad) {
    energia = (energia - cantidad).max(0)
    if(energia == 0){
      textoEstado.alternarTexto("Game Over")
      textoEstado.alternarVisibilidad()
    }
  }
  method perderVida() {
    vida = (vida - 1).max(0)
    // próxima entrega: game over si vida == 0
  }

  method salirDelLaberinto(){
    textoEstado.alternarTexto("Has Escapado!!!")
    textoEstado.alternarVisibilidad()
    nivel.jugadorGano(true)
  }
}

// ---------- Generación del mapa ----------
object nivel {
  var property jugadorGano = false  

  method cargarMapa(matriz) {
    const alto = matriz.size()
    (0 .. (alto - 1)).forEach({ filaIdx =>
      const fila = matriz.get(filaIdx)
      const y = alto - 1 - filaIdx;
      (0 .. (fila.size() - 1)).forEach({ x =>
        self.crearElemento(fila.get(x), game.at(x, y))
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
      } else if (tipo == "S") {
        game.addVisual(new Salida(position = pos))
      }
    }
  }
}

object textoEnergia {
  method position() = game.at(1, 9)
  
  method text() = "Energía: " + personaje.energia().toString()

  method textColor() = "000000" // Texto en color rojo
}

object textoEstado {
  var property position = game.center()
  var visible = false
  var contenido = "A"

  // Si visible es false, no dibuja nada
  method text() = if (visible) contenido else "" 
    
  method alternarVisibilidad() {
      visible = !visible
  }

  method alternarTexto(nuevoTexto){
    contenido = nuevoTexto
  }

  method textColor() = "FF0000" // Texto en color rojo
}