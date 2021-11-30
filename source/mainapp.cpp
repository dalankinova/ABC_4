#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

enum Color { Red, Orange, Yellow, Green, Blue, BlueBlue, Violet } ; 
enum FigureType { Circle, Rect, Triangle } ;

struct Figure {
  int v1 ; //x  x1   x1
  int v2 ; //y  y1   y1
  int v3 ; //r  x2   x2
  int v4 ; //   y2   y2
  int v5 ; //        x3
  int v6 ; //        y3
  Color c ;
  FigureType t ;
} ;

const char* colors[] = { "red", "orange","yellow","green","blue","blueblue","violet" } ;

extern "C" void ProcSort(Figure * p, int size, int cnt) ;
extern "C" float calcSquareCircleS(Figure * p) ;
extern "C" float calcSquareRectS(Figure * p) ;
extern "C" float calcSquareTriangleS(Figure * p) ;

void fprintData(FILE * fo, Figure * data, int size) {
  for (int i=0; i<size; i++) {
    if (data[i].t==Circle)
      fprintf(fo,"%d Circle   S=%f [%d ; %d] R=%d",i+1,calcSquareCircleS(data+i),
        data[i].v1,data[i].v2,data[i].v3) ;
    if (data[i].t==Rect)
      fprintf(fo,"%d Rect     S=%f [%d ; %d] - [%d ; %d]",i+1,calcSquareRectS(data+i),
        data[i].v1,data[i].v2,data[i].v3,data[i].v4) ;
    if (data[i].t==Triangle)
      fprintf(fo,"%d Triangle S=%f [%d ; %d] - [%d ; %d] - [%d ; %d]",i+1,calcSquareTriangleS(data+i),
        data[i].v1,data[i].v2,data[i].v3,data[i].v4,data[i].v5,data[i].v6) ;    
    fprintf(fo," %s\n",colors[data[i].c]) ;
  }	 
}

int main(int argc, char * argv[]) {
	
  if (argc<3) { 
    printf("Arguments - input file, output file\n") ;
    return 1 ;
  }
	
  Figure * data = NULL ;

  int cnt ;
  char buf[255] ;  
  FILE * f = fopen(argv[1],"r") ;
  fscanf(f,"%s",buf) ;
  fscanf(f,"%d",&cnt) ;
  data = (Figure*)malloc(sizeof(Figure)*cnt) ;    
  if (!strcmp(buf,"data")) {
  for (int i=0; i<cnt; i++) {
    fscanf(f,"%s",buf) ;
    if (!strcmp(buf,"circle")) {
      data[i].t=Circle ;
      fscanf(f,"%d",&data[i].v1) ;
      fscanf(f,"%d",&data[i].v2) ;
      fscanf(f,"%d",&data[i].v3) ;            
    }
    if (!strcmp(buf,"rect")) {    
      data[i].t=Rect ;
      fscanf(f,"%d",&data[i].v1) ;
      fscanf(f,"%d",&data[i].v2) ;
      fscanf(f,"%d",&data[i].v3) ;            
      fscanf(f,"%d",&data[i].v4) ;            
    }
    if (!strcmp(buf,"triangle")) {    
      data[i].t=Triangle ;
      fscanf(f,"%d",&data[i].v1) ;
      fscanf(f,"%d",&data[i].v2) ;
      fscanf(f,"%d",&data[i].v3) ;            
      fscanf(f,"%d",&data[i].v4) ;            
      fscanf(f,"%d",&data[i].v5) ;            
      fscanf(f,"%d",&data[i].v6) ;            
    }    
    fscanf(f,"%s",buf) ;
    for (int c=Red; c<=Violet; c++)
      if (!strcmp(colors[c],buf)) data[i].c=(Color)c ;    
  }
  }
  else { // Random data
    int min ; int max ;
    fscanf(f,"%d",&min) ;
    fscanf(f,"%d",&max) ;      
    srand(time(NULL)) ;
    for (int i=0; i<cnt; i++) {
      data[i].t=(FigureType)(rand()%3);    
      data[i].c=(Color)(rand()%7);    
      data[i].v1=min+rand()%(max-min+1) ;
      data[i].v2=min+rand()%(max-min+1) ;      
      data[i].v3=min+rand()%(max-min+1) ;
      data[i].v4=min+rand()%(max-min+1) ;
      data[i].v5=min+rand()%(max-min+1) ;
      data[i].v6=min+rand()%(max-min+1) ;      
    }
  }
  fclose(f) ;
  
  FILE * fo = fopen(argv[2],"w") ;
  fprintf(fo,"Source array:\n") ;
  printf("Source array:\n") ;
  fprintData(fo,data,cnt) ;
  fprintData(stdout,data,cnt) ;
  
  ProcSort(data,sizeof(Figure),cnt) ;
    
  fprintf(fo,"Sorted array:\n") ;
  printf("Sorted array:\n") ;
  fprintData(fo,data,cnt) ;
  fprintData(stdout,data,cnt) ;
  fclose(fo) ;
  
  free(data) ;

  return 0 ;
}
