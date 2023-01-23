import org.apache.commons.math3.stat.regression.SimpleRegression;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LinearRegression {
    public static void main(String[] args) {
        double[][] data = new double[30][2];
        int cnt = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("Salary_Data.csv"))) {
            String line = br.readLine();

            while ((line = br.readLine()) != null) {
                String[] arrOfStr = line.split(",", 2);
                data[cnt][0] = Double.parseDouble(arrOfStr[0]);
                data[cnt][1] = Double.parseDouble(arrOfStr[1]);
                cnt++;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        for (int i =0; i<30;i++){
            System.out.println(data[i][0]);
            System.out.println(data[i][1]);
        }


        LinearRegression test = new LinearRegression();
        test.calculate(data);
    }

    public void calculate(double[][] data) {
        SimpleRegression regressoin = new SimpleRegression();
        regressoin.addData(data);
        System.out.println(regressoin.getIntercept());
        System.out.println(regressoin.getSlope());
        System.out.println(regressoin.getSlopeStdErr());

    }
}

