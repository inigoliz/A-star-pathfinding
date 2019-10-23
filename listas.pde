class Listas{
  // permite operar sobre los elementos de la lista de píxeles disponibles para seleccionar
  int[] posicion = new int[2]; // posición del póxel al que hace referencia cada elemento de la lista
  int peso; // incluye distancias mahattan al destino, y distancia al origen
  int d;  // distancia al origen
  int pmax;
  
  Listas(int ipmax){  
    posicion[0] = 0;
    posicion[1] = 0;
    d = 0;
    pmax = ipmax;  // valor inicial mayor que el que ningún píxel puede tener
  } 
  
  void vaciar(){
    peso = pmax;
  }
  
  void anadir(Pixeles ipixel){
    posicion = ipixel.darPosicion();
    d = ipixel.dard();
    peso = ipixel.darPeso();
  }
  
  int darPeso(){
    return peso;
  }
  
  int[] darPosicion(){
    return posicion; // sintaxis: lista[current].darPosicion()[1];
  }
   
}