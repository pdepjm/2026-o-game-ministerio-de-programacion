import wollok.game.*

// =====================================================================
//  TABLERO: responde qué hay en cada celda (lo usan personaje y fantasmas)
// =====================================================================

object tablero {
  const property ancho = 10
  const property alto = 10            // la fila de arriba (y = 10) es para el texto

  method estaDentro(pos) =
    pos.x().between(0, ancho - 1) and pos.y().between(0, alto - 1)

  method objetosEn(pos) = game.getObjectsIn(pos)

  method hayObstaculoEn(pos) =
    self.objetosEn(pos).any({ elemento => elemento.esObstaculo() })

  method puedeIrA(pos) =
    self.estaDentro(pos) and not self.hayObstaculoEn(pos)
}
