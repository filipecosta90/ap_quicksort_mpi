#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <mpi.h>

#define SIZE 100000000

int* array;

void choose_key(int size, int *i, int *j, int* sub_array){
  //quicksort vars
  int i=0,j=size-1,h;
  int x=sub_array[size/2];
  do
  {    
    while(sub_array[i]<x) {
      i++;
    }
    while(sub_array[j]>x) {
      j--;
    }
    if(i<=j)
    {
      h=sub_array[i]; sub_array[i]=sub_array[j]; sub_array[j]=h;
      i++; j--;
    }
  } while(i<=j);
}

void quicksort(int lo, int hi)
{
  int i=lo,j=hi,h;
  int x=array[(lo+hi)/2];

  //partition
  do
  {    
    while(array[i]<x) {
      i++;
    }
    while(array[j]>x) {
      j--;
    }
    if(i<=j)
    {
      h=array[i]; array[i]=array[j]; array[j]=h;
      i++; j--;
    }
  } while(i<=j);

  //recursion
  if(lo<j) quicksort(lo,j);
  if(i<hi) quicksort(i,hi);
}

void initialize() {
  array = (int *) malloc(SIZE*sizeof(int));

  srand(0);

  for(int i=0; i<SIZE; i++) {
    array[i]=rand();
  }
}

void validate() {
  int error=0;
  for(int i=0;i<SIZE&&!error;i++)
    if(array[i-1]>array[i]) error=1;

  if(error) printf("Error\n");
  else printf("Ok\n");
}


int main( int argc, char* argv[] ) {
  int i,myid, numprocs = 4;
  int num_elements_per_proc = SIZE / numprocs;
  int source,count,dummy;
  // buffer for pivots
  int buffer[numprocs*3];
  MPI_Status status;
  MPI_Request request;

  MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
  MPI_Comm_rank(MPI_COMM_WORLD,&myid);



  // Create a random array of elements on the root process.
  if (myid == 0) {
    initialize();
  }

  int* sub_nums = (int *)malloc(sizeof(int) * num_elements_per_proc);

  MPI_Scatter(array, num_elements_per_proc, MPI_INT, subnums,
      num_elements_per_proc, MPI_INT, 0, MPI_COMM_WORLD);

  int my_i,my_j;
  double time = omp_get_wtime();
  choose_key(num_elements_per_proc, &my_i, &my_j, subnums);
  printf("Time=%f\n", omp_get_wtime()-time);
  //quicksort(0,SIZE-1);

  MPI_Finalize();

  validate();

}

