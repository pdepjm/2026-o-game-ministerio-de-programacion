import nivel.*
import letras.*

// =====================================================================
//  NIVELES INSTANCIADOS
//  Para agregar un nivel nuevo solo hay que tocar este archivo.
// =====================================================================

const nivel1 = new Nivel(
  numero = 1,
  mapa = [
    [m,m,m,m,m,m,m,m,m,m],
    [m,_,_,_,m,_,_,_,l,m],
    [m,_,m,_,m,_,m,m,_,m],
    [m,_,m,_,_,_,_,_,f,m],
    [m,o,m,m,m,m,_,m,e,m],
    [m,_,_,_,_,m,_,m,_,m],
    [m,m,m,_,_,v,_,m,_,m],
    [m,_,_,_,m,m,_,_,_,m],
    [m,_,m,g,e,_,_,m,s,m],
    [p,_,m,m,m,m,m,m,m,m]
  ],
  siguienteNivel = nivel2
)

const nivel2 = new Nivel(
  numero = 2,
  mapa = [
    [m,m,m,m,m,m,m,m,m,m],
    [m,s,_,_,x,_,_,_,l,m],
    [m,m,m,_,m,m,m,m,_,m],
    [m,_,_,_,_,_,_,_,f,m],
    [m,_,m,m,m,m,m,_,m,m],
    [m,_,_,o,m,_,_,_,x,m],
    [m,m,m,_,m,_,m,m,_,m],
    [m,_,e,_,x,_,_,_,_,m],
    [m,_,m,m,m,v,_,m,_,m],
    [m,p,_,_,_,g,_,_,_,m]
  ],
  siguienteNivel = nivel3
)

const nivel3 = new Nivel(
  numero = 3,
  mapa = [
    [m,m,m,m,m,m,m,m,m,m],
    [m,_,_,_,_,_,_,l,f,m],
    [m,_,m,m,m,m,m,x,m,m],
    [m,_,m,_,_,_,_,_,e,m],
    [m,_,m,_,m,m,_,_,_,m],
    [m,_,o,_,v,_,_,_,x,m],
    [m,m,m,_,m,m,_,m,m,m],
    [m,_,_,_,_,e,g,_,s,m],
    [m,_,m,m,m,m,m,m,x,m],
    [m,p,_,_,_,_,_,_,f,m]
  ],
  siguienteNivel = victoria
)
