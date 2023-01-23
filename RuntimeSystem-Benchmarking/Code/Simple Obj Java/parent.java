
import java.util.Arrays;
public class parent {
    static int first;
    static int sec = 4;
    double third = 10;
    double forth;

    // The constructor for instance variables
    public parent(double third, double forth){
        this.third = third;
        this.forth = forth;
    }
    public static int[] rangeFunc(int[] x ){
        if(x.length < 10){
            System.out.println("Not in the range");
            return null ;
        }
        return Arrays.copyOfRange(x,3,9);
    }
    public void multiplyer(int x ){
        System.out.println(x * third);
    }
}
