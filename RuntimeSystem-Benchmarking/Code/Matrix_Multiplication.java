import java.util.Random;
public class MatrixJava {
    public static void main(String[] args) {
        // Size of the n*n matrix
        int size = 100;
        Random rd = new Random();
        // The max value for range of random double values
        double max = 100;
        // The min value for range of random double values
        double min = 0;
        double matrix1[][] = new double[size][size];
        double matrix2[][] = new double[size][size];
        double res[][] = new double[size][size];
        // Initializing matrix with random values
        for (int i=0; i < size; i++){
            for (int j = 0; j < size; j++){
                matrix1[i][j] = rd.nextDouble()*(max - min) + min;
                matrix2[i][j] = rd.nextDouble()*(max - min) + min;
            }
        }

        // Matrix multiplication
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                res[i][j] = 0;
                for (int k = 0; k < size; k++) {
                    res[i][j] += matrix1[i][k] * matrix2[k][j];
                }//end of k loop
            }

        }
    }
}