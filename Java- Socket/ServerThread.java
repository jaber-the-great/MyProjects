import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileReader;


public class ServerThread extends Thread
    {
        String line=null;
        BufferedReader  is = null;
        PrintWriter os=null;
        Socket s=null;




        public ServerThread(Socket s){
            this.s=s;
        }

        public void run() {

            String fileName = "registered.txt";
            String classStd = "list.txt";
            try{

                //just to create the file
               /* try {
                    BufferedWriter out = new BufferedWriter(
                            new FileWriter(classStd));
                    out.write("9325893,Jaber Daneshamooz\n");
                    out.close();
                }
                catch (IOException e) {
                    System.out.println("Exception Occurred" + e);
                }*/


                // Let us print modified file









                is= new BufferedReader(new InputStreamReader(s.getInputStream()));
                os=new PrintWriter(s.getOutputStream(),true);



            Students[] stds = new Students[10];
            stds[0]= new Students("jaber","daneshamooz",9325893);
            os.println("you are successfully connected, enter your student number to register:");

                while(true)
                    {

                        line = is.readLine();
                        System.out.println(line);
                        if (!line.matches("[0-9]+") || line.length()!=7)
                        {
                            os.println("input is not valid");
                            continue;
                        }

                        String registeredStd = findInFile(classStd,line);

                        if(registeredStd != null)
                            {
                                String temp = "Dear ";
                                temp=temp.concat(registeredStd.substring(registeredStd.indexOf(',' )+1));
                                temp=temp.concat(", you have successfully registered. Good Bye");
                                os.println(temp);
                                appendStrToFile(fileName,registeredStd);

                            }
                        else
                            {
                                os.println("please enter a valid student number");
                            }
                        System.out.println("Response to Client  :  " + line);
                        System.out.println(line);


                    }

                }
            catch (IOException e) {

                line=this.getName(); //reused String line for getting thread name
                System.out.println("IO Error/ Client "+line+" terminated abruptly");
            }
            catch(NullPointerException e){
                line=this.getName(); //reused String line for getting thread name
                System.out.println("Client "+line+" Closed");
            }

            finally{
                try{
                    System.out.println("Connection Closing..");
                    if (is!=null){
                        is.close();
                        System.out.println(" Socket Input Stream Closed");
                    }

                    if(os!=null){
                        os.close();
                        System.out.println("Socket Out Closed");
                    }
                    if (s!=null){
                        s.close();
                        System.out.println("Socket Closed");
                    }

                }
                catch(IOException ie){
                    System.out.println("Socket Close Error");
                }
            }//end finally
        }


        ///////////////////

        public static void appendStrToFile(String fileName,
                                           String str)
            {
                if(findInFile(fileName,str)!=null)
                    {
                        return;
                    }
                try {

                    // Open given file in append mode.
                    BufferedWriter out = new BufferedWriter(
                            new FileWriter(fileName, true));
                    str=str.concat("\n");
                    out.write(str);
                    out.close();
                }
                catch (IOException e) {
                    System.out.println("exception occoured" + e);
                }
            }


        ////////////////

        public static String findInFile(String NameOfFile,String str)
            {
                String std=null;
                try {
                    BufferedReader in = new BufferedReader(
                            new FileReader(NameOfFile));

                    String mystring=null;
                    while ((mystring = in.readLine()) != null) {

                        if(mystring.contains(str))
                            {
                                std=mystring;
                                return std;
                            }

                    }
                }
                catch (IOException e) {
                    System.out.println("Exception Occurred" + e);
                }
                return std;
            }


    }


