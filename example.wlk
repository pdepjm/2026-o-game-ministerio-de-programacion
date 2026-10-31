import wollok.game.*

// ---------- Superclase de los elementos del laberinto ----------
 class ElementoMapa {
  const property position

  method image()                      
  method esObstaculo() = false        
  method efecto(personaje) { }        
  method z() = 0   // CAPA 0: El piso y los muros van bien al fondo
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
    personaje.recuperarEnergia(70)
  }
}

// ---------- Trampas ----------
class TrampaEnergia inherits ElementoMapa {
  override method image() = "trampaenergia.png"
  override method efecto(personaje) {
    personaje.perderEnergia(100)
  }
}

class TrampaVelocidad inherits Consumible {
  override method image() = "trampavelocidad.png"
  override method efecto(personaje) {
    super(personaje) // Llama al código del padre para que desaparezca visualmente
    personaje.perderVida() // Luego aplica el daño
  }
}

class Salida inherits ElementoMapa {
  override method image() = "salida.png"
  override method efecto(personaje) {
    if (personaje.tieneLlave()) {
      personaje.salirDelLaberinto()
    }
  }
}

// ---------- Fantasmas ----------
// Van y vienen; si chocan contra un muro cambian de sentido.
// Si tocan al personaje, le sacan una vida.
class Fantasma {
  var property position
  var sentido = 1

  method z() = 2   // CAPA 2: El fantasma va por encima del mapa

  method image() = "character.png"
  method esObstaculo() = false
  method efecto(personaje) { personaje.perderVida() }

  method siguientePosicion() = game.at(position.x() + sentido, position.y())

  method mover() {
    const siguiente = self.siguientePosicion()
    if (personaje.puedeIrA(siguiente)) {
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
  override method image() = "character copy.png"
  override method siguientePosicion() = game.at(position.x(), position.y() + sentido)
}

// ---------- Personaje ----------
object personaje {
  const posicionInicial = game.at(0, 0)
  var position = posicionInicial
  var energia = 500
  var vida = 3
  var llave = false

  method z() = 3   // CAPA 3: La protagonista arriba de todos

  method energia() = energia
  method vida() = vida
  method position() = position
  method position(nuevaPosition) { position = nuevaPosition }
  method image() = "personaje.png"

  method reiniciar() {
    position = posicionInicial
    energia = 500
    vida = 3
    llave = false
  }

  method mover(nuevaPosition) {
    position = nuevaPosition
    self.perderEnergia(2)
  }

  method estaDentroDelTablero(pos) =
    pos.x() >= 0 and pos.x() < game.width() and
    pos.y() >= 0 and pos.y() < game.height()

  method hayObstaculoEn(pos) =
    self.elementosEn(pos).any({ e => e.esObstaculo() })

  method puedeIrA(pos) =
    self.estaDentroDelTablero(pos) and not self.hayObstaculoEn(pos)

  method interactuarConElementosDe(pos) {
    self.elementosEn(pos).forEach({ e => e.efecto(self) })
  }

  // todo lo que hay en la posición, excepto yo mismo
  method elementosEn(pos) =
    game.getObjectsIn(pos).filter({ e => e != self })

  method moverse(dx, dy) {
    const siguiente = game.at(position.x() + dx, position.y() + dy)
    if (self.energia() > 0 && !nivel.jugadorGano()) {
      if (self.puedeIrA(siguiente)) {
        self.mover(siguiente)
        self.interactuarConElementosDe(position)
      }
    }
  }

  method tieneLlave() = llave
  method agarrarLlave() { llave = true }

  method recuperarEnergia(cantidad) {
    energia = (energia + cantidad).min(500)
  }

  method perderEnergia(cantidad) {
    energia = (energia - cantidad).max(0)
    if (energia == 0) {
      juego.terminar("Game Over")
    }
  }
method perderVida() {
    vida = (vida - 1).max(0)
    if (vida == 0) {
      juego.terminar("Game Over")
    }
  }

  method salirDelLaberinto() {
    nivel.jugadorGano(true)
    juego.terminar("Has Escapado!!!")
  }
}

// ---------- Generación del mapa ----------
object nivel {
  var property jugadorGano = false
  // M muro · . pasillo · L llave · S salida · O poción
  // E trampa energía · V trampa velocidad · F fantasma horizontal · G fantasma vertical
  var property mapa = [
    ["M","M","M","M","M","M","M","M","M","M"],
    ["M",".",".",".","M",".",".",".","L","M"],
    ["M",".","M",".","M",".","M","M",".","M"],
    ["M",".","M",".",".",".","F",".",".","M"],
    ["M","O","M","M","M","M",".","M","E","M"],
    ["M",".",".","G",".","M",".","M",".","M"],
    ["M","M","M",".",".","V",".","M",".","M"],
    ["M",".",".",".","M","M",".",".",".","M"],
    ["M",".","M","E",".",".",".","M","S","M"],
    [".",".","M","M","M","M","M","M","M","M"]
  ]
  const property fantasmas = []

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
      } else if (tipo == "F") {
        self.agregarFantasma(new Fantasma(position = pos))
      } else if (tipo == "G") {
        self.agregarFantasma(new FantasmaVertical(position = pos))
      }
    }
  }


  method moverFantasmas() {
    fantasmas.forEach({ f => f.mover() })
  }

  method cargarMapa(matriz) {
    fantasmas.clear()
    const alto = matriz.size()
    (0 .. (alto - 1)).forEach({ filaIdx =>
      const fila = matriz.get(filaIdx)
      const y = (alto - 1) - (filaIdx)
      (0 .. (fila.size() - 1)).forEach({ x =>
        self.crearElemento(fila.get(x), game.at(x, y))
      })
    })
    
    // LA SOLUCIÓN: Una vez que todos los pasillos y muros ya se dibujaron,
    // recién ahora agregamos los fantasmas visualmente para que queden arriba de todo.
    fantasmas.forEach({ f => game.addVisual(f) })
  }

  method agregarFantasma(fantasma) {
    // Solo lo guardamos en la lista, pero NO lo dibujamos todavía.
    fantasmas.add(fantasma)
  }
}

// ---------- Menú y flujo del juego ----------
object juego {
  // Esto es lo único que hay que llamar desde el programa
  method iniciar() {
    game.title("Laberinto")
    game.width(10)
    game.height(10)
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
    game.clear()
    personaje.reiniciar()
    nivel.jugadorGano(false)
    nivel.cargarMapa(nivel.mapa())
    game.addVisual(personaje)
    game.addVisual(textoEnergia)

    keyboard.up().onPressDo({ personaje.moverse(0, 1) })
    keyboard.down().onPressDo({ personaje.moverse(0, -1) })
    keyboard.left().onPressDo({ personaje.moverse(-1, 0) })
    keyboard.right().onPressDo({ personaje.moverse(1, 0) })

    game.onTick(500, "fantasmas", { nivel.moverFantasmas() })
  }

  // Al terminar (gane o pierda) muestra el mensaje y vuelve al menú
  method terminar(mensaje) {
    game.clear()
    textoEstado.mostrar(mensaje)
    game.addVisual(textoEstado)
    game.schedule(2000, { self.menu() })
  }
}

object textoEnergia {
  method position() = game.at(1, 9)

  method text() =
    "Energía: " + personaje.energia().toString() +
    "  Vidas: " + personaje.vida().toString()

  method textColor() = "#FF0000"

  // está dentro del tablero, así que tiene que entender lo mismo que los elementos
  method esObstaculo() = false
  method efecto(personaje) { }
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

