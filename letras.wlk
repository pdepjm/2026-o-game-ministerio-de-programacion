import wollok.game.*
import elementos.*
import fantasmas.*
import personaje.*

// =====================================================================
//  REPRESENTACIONES DEL MAPA
//  Cada letra es un objeto que sabe qué dibujar con decode(x, y, nivel).
// =====================================================================

// Pasillo
object _ {
  method decode(x, y, nivel) {
    game.addVisual(new Pasillo(position = game.at(x, y)))
  }
}

// Muro
object m {
  method decode(x, y, nivel) {
    game.addVisual(new Muro(position = game.at(x, y)))
  }
}

// Punto de inicio del personaje
object p {
  method decode(x, y, nivel) {
    _.decode(x, y, nivel)
    personaje.ubicarEnInicio(game.at(x, y))
  }
}

// Letras que ponen un pasillo y un elemento encima
class LetraConPasillo {
  method crear(posicion)              // abstracto: qué elemento pone

  method decode(x, y, nivel) {
    _.decode(x, y, nivel)
    self.agregar(self.crear(game.at(x, y)), nivel)
  }

  method agregar(elemento, nivel) {
    game.addVisual(elemento)
  }
}

// Además de mostrarse, el fantasma se anota en el nivel para moverse
class LetraFantasma inherits LetraConPasillo {
  override method agregar(fantasma, nivel) {
    super(fantasma, nivel)
    nivel.agregarFantasma(fantasma)
  }
}

// Llave
object l inherits LetraConPasillo {
  override method crear(posicion) = new Llave(position = posicion)
}

// Salida
object s inherits LetraConPasillo {
  override method crear(posicion) = new Salida(position = posicion)
}

// Poción
object o inherits LetraConPasillo {
  override method crear(posicion) = new Pocion(position = posicion)
}

// Trampa de energía
object e inherits LetraConPasillo {
  override method crear(posicion) = new TrampaEnergia(position = posicion)
}

// Trampa de velocidad
object v inherits LetraConPasillo {
  override method crear(posicion) = new TrampaVelocidad(position = posicion)
}

// Pinches
object x inherits LetraConPasillo {
  override method crear(posicion) = new Pinches(position = posicion)
}

// Fantasma horizontal
object f inherits LetraFantasma {
  override method crear(posicion) = new Fantasma(position = posicion)
}

// Fantasma vertical
object g inherits LetraFantasma {
  override method crear(posicion) = new FantasmaVertical(position = posicion)
}
