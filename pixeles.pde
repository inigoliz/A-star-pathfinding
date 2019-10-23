class Pixeles{
  int tam ; // tamaño del pixel
  int[] pos = new int[2];  // posición [i,j] dentro del array del pixel
  int r, g, b; // color
  boolean obst;  // si es un obstáculo o no: false, no es obstáculo; true, es un obstáculo
  boolean bloqueado; //  los píxeles de las paredes no se pueden editar
  
  // Para A*:
  
  int[] origen = new int[2];  // origen del píxel, para rastrear el camino una  vez solucionado
  int d;  // distancia al origen
  int peso; // incluye distancias mahattan al destino, y distancia al origen

  Pixeles(int ii, int ij, int itam){  // se pasan como parámetros las posiciones de la matriz que representan
    pos[0] = ii;  // i
    pos[1] = ij;  // j
    d = 0;
    peso = 0;
    tam = itam;
    r = 255;
    g = 255;
    b = 255;
    bloqueado = false;  // en principio, ninguno es pared
    obst = false;  // en principio, ninguno es obstáculo
  }
  
  
  void cambiarColor(int ir, int ig, int ib){
    if(bloqueado == false){  // si se puede cambiar su estado
      r = ir;
      g = ig;
      b = ib;
    }
    else{
    }
  }
  
  
  void display(){
    fill(r, g, b);
    rect(pos[1]*tam, pos[0]*tam, tam, tam);
  }
  
  
  void hacerObstaculo(){
    if(bloqueado == false){  // si se puede cambiar su estado
      if(obst == false){  // libre
        obst = true; // obstaculizado
        r = 100;
        g = 100;
        b = 100;
      }
      else{  // obstáculo
         obst = false;
         r = 255;
         g = 255;
         b = 255;
      }
    }
    else{  // si es pared
    }
  }
  
  
  void bloquear(){ // solo sirve para bloquear
      bloqueado = true;
      obst = true;
  }
  
  void desbloquear(){
    bloqueado = false;
    obst = false;
  }
  
  
  int[] darPosicion(){  // devuelve la posición [i, j] del píxel consultado
    return pos;  // uso: pixel[29][2].posicion()[0]
  }
  
  
  void calcularPeso(Pixeles end, int dAnterior, int suma){
    d = dAnterior + suma;
    peso = d + 10*(abs(end.darPosicion()[1]-pos[1]) + abs(end.darPosicion()[0]-pos[0]));
  }
  
  int manhattan(Pixeles end){
    return (abs(end.darPosicion()[1]-pos[1]) + abs(end.darPosicion()[0]-pos[0]));
  }
  
  
  int darPeso(){
    return peso;
  }
  
  
  int dard(){  // devuelve la distancia del píxel a start
    return d;   
  }
  
  
  boolean noObst(){  // si es o no un obstáculo
    if(obst == true){
      return false;
    }
    else{
      return true;
    }    
  }

}