import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;
public class Client
    {

        // A simple Client Server Protocol .. Client for Echo Server
            public static void main(String args[]) throws IOException{


                InetAddress address=InetAddress.getLocalHost();
                Socket s1=null;
                String line=null;
                BufferedReader ueinp=null;
                BufferedReader is=null;
                PrintWriter os=null;

                try {
                    s1=new Socket(address, 4445); // You can use static final constant PORT_NUM
                    ueinp= new BufferedReader(new InputStreamReader(System.in));
                    is=new BufferedReader(new InputStreamReader(s1.getInputStream()));
                    os= new PrintWriter(s1.getOutputStream(),true);
                }
                catch (IOException e){
                    e.printStackTrace();
                    System.err.print("IO Exception");
                }

                System.out.println("Client Address : "+address);
                System.out.println("Enter Student number ( Enter QUIT to end):");
                String response=null;
                response=is.readLine();
                System.out.println("Server Response : "+response);

                try{
                    line=ueinp.readLine();
                    while(line.compareTo("QUIT")!=0){
                        os.println(line);

                        response=is.readLine();
                        System.out.println("Server Response : "+response);
                        line=ueinp.readLine();

                    }



                }
                catch(IOException e){
                    e.printStackTrace();
                    System.out.println("Socket read Error");
                }
                finally{

                    is.close();os.close();ueinp.close();s1.close();
                    System.out.println("Connection Closed");

                }

            }
        }

