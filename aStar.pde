// Pathfinding simulator based on A* algorithm. Iñigo Lara, 21-02-2018

// Se utilizará la distancia Manhattan

/* Es importante implementar distancias diagonales, pues si no cualquier camino será equivalente (propiedad de la distancia Manhattan) */

boolean empezar = false; // para controlar la ventana de bienvenida
boolean barrido = false;

PFont myFont1;
PFont myFont2;

int fil = 30;
int col = 30;
int tam = 20; // tamaño del pixel
int n = fil*col; // número de pixeles
int current = 0;  // última posición en que se ha guardado
int elementos = 0;  // lleva la cuenta del número de elemntos que hay en la lista, para saber cuando se ha vaciado
int pmax = fil + col + 5000; // un valor mucho más grande que cualquier distancia posible
int dfinal = 100; // distancia a end, para saber cuando se ha alcanzado una solución. 100 es arbitrario
int ejecutado = 0;  // para saber cuando se ha ejecutado y cuando no

/* La gestión de la lista se hará añadiendo nuevos términos sucesivamente. Cada vez que haya que elegir un nuevo píxel por el que seguir, se buscará en la lista el píxel con menor peso */

Listas[] lista = new Listas[n];  // lista con los elementos a ser visitados
Pixeles[][] pixel = new Pixeles[fil][col];
Pixeles start;
Pixeles end;
Pixeles actual = new Pixeles(0, 0, tam);  // píxel actual. No importa qué parametros tome

/////////////////////////////////////////////////////// PROGRAMA ///////////////////////////////////////////////////////

void setup(){
  size(600, 600);
  
  for(int i = 0; i<fil; i++){
    for(int j = 0; j<col; j++){
       pixel[i][j] = new Pixeles(i, j, tam); // [y][x]
    }  
  }
  
  for(int i = 0; i<fil; i++){
    pixel[i][0].cambiarColor(100, 100, 100); 
    pixel[i][0].bloquear();  
    pixel[i][col-1].cambiarColor(100, 100, 100);
    pixel[i][col-1].bloquear();  
  }
  for(int i = 1; i<col-1; i++){
    pixel[0][i].cambiarColor(100, 100, 100);
    pixel[0][i].bloquear(); 
    pixel[fil-1][i].cambiarColor(100, 100, 100);
    pixel[fil-1][i].bloquear();
  } 
  
  pixel[1][1].cambiarColor(0, 255, 0);  // START (verde)
  pixel[1][1].bloquear();

  start = pixel[1][1];
  start.bloquear();
  
  pixel[fil-2][col-2].cambiarColor(255, 0, 0);  // END (rojo)
  pixel[fil-2][col-2].bloquear();
  
  end = pixel[fil-2][col-2];
  end.bloquear(); 
}


void draw(){
  if(empezar == false){
    background(255, 226, 0);

    fill(255, 0, 0);
    myFont1 = createFont("Georgia", 60);
    myFont2 = createFont("Zapfino", 20);
    textFont(myFont1);
    textAlign(CENTER, CENTER);
    text("Algoritmo A*", width/2, height/2-60);
    textSize(20);
    text("Pulsar 'barra espaciadora' para ejecutar y 'a' para reiniciar", width/2, height/2+100);
    text("Pulsar 'b' para cambiar entre barrido y modo preciso", width/2, height/2+120);
    
    textFont(myFont2);
    text("En búsqueda de una IA. Psi", width/2, height/2+200);    
  }
}

void inicio(){  // tras la ventana de bienvenida. Inicializa todas las variables
  for(int i=1; i<fil-1; i++){  // se borran los píxeles del centro
    for(int j=1; j<col-1; j++){
      pixel[i][j] = new Pixeles(i, j, tam);     
    }
  }
  
  pixel[1][1].cambiarColor(0, 255, 0);  // START (verde)
  pixel[1][1].bloquear();

  start = pixel[1][1];
  start.bloquear();
  
  pixel[fil-2][col-2].cambiarColor(255, 0, 0);  // END (rojo)
  pixel[fil-2][col-2].bloquear();
  
  end = pixel[fil-2][col-2];
  end.bloquear();
  
  pintar(); 
  
  ejecutado = 0;
}

void mousePressed(){
  if(mouseX < 600 && mouseY < 600 && mouseX > 0 && mouseY > 0){
    if(barrido == false){
      if(ejecutado == 0){
  
        int xpos = floor(mouseX/tam);
        int ypos = floor(mouseY/tam);
        pixel[ypos][xpos].hacerObstaculo();
        pixel[ypos][xpos].display();
      }
    }
  }
} 
  


void mouseDragged(){  // configurar tablero
  if(mouseX<600 && mouseY <600 && mouseX > 0 && mouseY > 0){
    if(barrido == true){
      if(ejecutado == 0){
        int xpos = floor(mouseX/tam);
        int ypos = floor(mouseY/tam);
        pixel[ypos][xpos].hacerObstaculo();
        pixel[ypos][xpos].display();
      }
    }
  }
}

void keyReleased(){
  if(key == ' '){ //  al pulsar espacio, comienza el algoritmo
    aStar();
  }
  if(key == 'a'){
    empezar = true;
    inicio();
  }
  if(key == 'b'){
    if(barrido){
      barrido = false;
    }
    else{
      barrido = true;
    }    
  }
  
}

void pintar(){
  for(int i = 0; i<fil; i++){
    for(int j = 0; j<col; j++){
       pixel[i][j].display();;
    }  
  }
}

/////////////////////////////////////   A estrella     ////////////////////////////////////////////

void aStar(){
  current = 0;
  elementos = 0;
  dfinal = 100;
  ejecutado = 1; 
    
  for(int i = 0; i < n; i++){  // Vaciar la lista entera
    lista[i] = new Listas(pmax);
    lista[i].vaciar();
  }
  
  start.calcularPeso(end, 0, 0);  // es como si viniera de un píxel negativo
  pixel[1][1] = start;
  lista[current].anadir(start);
  elementos++;
  current++;
  //for(int i = 0; i<30; i++){
  while((elementos != 0) && (dfinal != 1)){  // si sigue habiendo elementos en la lista ó no ha encontrado aún la solución
    
    seleccionar();
    dfinal = actual.manhattan(end);
    explorar(actual);
    print(dfinal);
    print(" ");
    actual.cambiarColor(255, 132, 0);
    actual.display();
  }
  if(elementos == 0){
    print("No hay solución");
  }
  if(dfinal == 0){
    print("¡¡Solución hallada!!");
  }
}

// Funciones de gestión de lista

void seleccionar(){
  int auxPos = 0; // variable que guarda la posición en la lista del elemento con menor peso
  int auxPeso = pmax; // se inicia en un valor superior al que puede tener ningún píxel
  
  for(int i=0; i<n; i++){
    if(lista[i].darPeso() < auxPeso){
      auxPeso = lista[i].darPeso();
      auxPos = i;
    }  
  }
  actual = pixel[lista[auxPos].darPosicion()[0]][lista[auxPos].darPosicion()[1]]; 
  actual.display();
  lista[auxPos].vaciar();
  elementos--;  

}
  
 
void explorar(Pixeles iactual){
  int i, j, auxd;  // i, j, y distancia manhattan de actual a start

  i = iactual.darPosicion()[0];
  j = iactual.darPosicion()[1];
  auxd = iactual.dard();

  // Cruz:
    
  if(pixel[i+1][j].noObst()){
    pixel[i+1][j].calcularPeso(end, auxd, 10);
    lista[current].anadir(pixel[i+1][j]);
    elementos++;
    current++;
    pixel[i+1][j].hacerObstaculo();
    pixel[i+1][j].cambiarColor(245, 237, 148);
    pixel[i+1][j].display();
  }
  
  if(pixel[i][j+1].noObst()){
    pixel[i][j+1].calcularPeso(end, auxd, 10);
    lista[current].anadir(pixel[i][j+1]);
    elementos++;
    current++;
    pixel[i][j+1].hacerObstaculo();
    pixel[i][j+1].cambiarColor(245, 237, 148);
    pixel[i][j+1].display();
  }  
  
  if(pixel[i-1][j].noObst()){
    pixel[i-1][j].calcularPeso(end, auxd, 10);
    lista[current].anadir(pixel[i-1][j]);
    elementos++;
    current++;
    pixel[i-1][j].hacerObstaculo();
    pixel[i-1][j].cambiarColor(245, 237, 148);
    pixel[i-1][j].display();
  }

  if(pixel[i][j-1].noObst()){
    pixel[i][j-1].calcularPeso(end, auxd, 10);
    lista[current].anadir(pixel[i][j-1]);
    elementos++;
    current++;
    pixel[i][j-1].hacerObstaculo();
    pixel[i][j-1].cambiarColor(245, 237, 148);
    pixel[i][j-1].display();
  }
  
  // Vértices:
   
  if(pixel[i+1][j+1].noObst()){
    pixel[i+1][j+1].calcularPeso(end, auxd, 14);
    lista[current].anadir(pixel[i+1][j+1]);
    elementos++;
    current++;
    pixel[i+1][j+1].hacerObstaculo();
    pixel[i+1][j+1].cambiarColor(245, 237, 148);
    pixel[i+1][j+1].display();
  }
  
  if(pixel[i-1][j+1].noObst()){
    pixel[i-1][j+1].calcularPeso(end, auxd, 14);
    lista[current].anadir(pixel[i-1][j+1]);
    elementos++;
    current++;
    pixel[i-1][j+1].hacerObstaculo();
    pixel[i-1][j+1].cambiarColor(245, 237, 148);
    pixel[i-1][j+1].display();
  }  
  
  if(pixel[i-1][j-1].noObst()){
    pixel[i-1][j-1].calcularPeso(end, auxd, 14);
    lista[current].anadir(pixel[i-1][j-1]);
    elementos++;
    current++;
    pixel[i-1][j-1].hacerObstaculo();
    pixel[i-1][j-1].cambiarColor(245, 237, 148);
    pixel[i-1][j-1].display();
  }

  if(pixel[i+1][j-1].noObst()){
    pixel[i+1][j-1].calcularPeso(end, auxd, 14);
    lista[current].anadir(pixel[i+1][j-1]);
    elementos++;
    current++;
    pixel[i+1][j-1].hacerObstaculo();
    pixel[i+1][j-1].cambiarColor(245, 237, 148);
    pixel[i+1][j-1].display();
  }
}