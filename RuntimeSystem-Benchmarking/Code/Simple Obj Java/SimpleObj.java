public class SimpleObj {
    public static void main(String[] args)
    {
        parent p = new parent(3,4);
        int arr[] = {1,2,3,4,5,6,7,8,9,10,11};
        parent.rangeFunc(arr);
        p.multiplyer(7);
        System.out.println(p.sec);
        System.out.println(parent.sec);


    }
}
