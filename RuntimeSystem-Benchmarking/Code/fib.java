public class fib {
    public static void main(String[] args)
    {
        int n = 30;
        int previous_results[] = new int[n+2];

        previous_results[0] = 0;
        previous_results[1] = 1;

        for (int i = 2; i <= n; i++)
        {
            previous_results[i] = previous_results[i-1] + previous_results[i-2];
        }

        System.out.println(previous_results[n]);
    }
}
