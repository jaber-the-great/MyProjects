import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.*;
import java.math.BigInteger;
import java.net.Socket;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.RSAPublicKeySpec;
import java.util.Arrays;
import java.util.Scanner;

public class client
    {
        public static void main(String[] args)
            {

                Scanner input = new Scanner(System.in);

                        try
                            {
        //creating and connecting socket and reader writer , input output stream
        Socket client = new Socket("localhost", 1234);
        PrintWriter out = new PrintWriter(client.getOutputStream(), true);
        BufferedReader in = new BufferedReader(new InputStreamReader(client.getInputStream()));
        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        DataOutputStream cdout = new DataOutputStream(client.getOutputStream());
        DataInputStream cdin = new DataInputStream(client.getInputStream());


                    // generating  public and private key of client
                    KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
                    kpg.initialize(1024);
                    KeyPair kp = kpg.genKeyPair();
                    PublicKey publicKey = kp.getPublic();
                    PrivateKey privateKey = kp.getPrivate();
                    String message;


                                //separation on module and exponent of keys
                                KeyFactory fact = KeyFactory.getInstance("RSA");
                                RSAPublicKeySpec pub = fact.getKeySpec(kp.getPublic(), RSAPublicKeySpec.class);
                                RSAPrivateKeySpec pri = fact.getKeySpec(kp.getPrivate(), RSAPrivateKeySpec.class);


                                        //getting register information from user
                                        System.out.println("enter the username to register:(if u have registered, enter dummy)");
                                        String myUsername = input.nextLine();
                                        System.out.println("enter the password to register:(if u have registered, enter dummy)");
                                        String myPassword = input.nextLine();


        //sending register information to servver
        out.println(myUsername);
        out.println(myPassword);
        out.println(pub.getModulus());
        out.println(pub.getPublicExponent());


                //getting server public key
                BigInteger sm = new BigInteger(in.readLine());
                BigInteger se = new BigInteger(in.readLine());


                            //making the public key of server from what we received
                            RSAPublicKeySpec reverseSpec = new RSAPublicKeySpec(sm, se);
                            KeyFactory reverseFact = KeyFactory.getInstance("RSA");
                            PublicKey serverPublic = reverseFact.generatePublic(reverseSpec);


                                            //client self termination
                                            System.out.println("do you want to close connection? y/(other char)");
                                            String temp = input.nextLine();
                                            if (temp.charAt(0) == 'y')
                                                {
                                                    out.println("close connection");
                                                    out.println("Thank You");
                                                    client.close();
                                                    System.exit(1);

                                                }
                                            else{
                                                out.println("keep connection");
                                                out.println("keep connection");

                                            }


                                //data transfer between client and server
                                while (true)
                                    {
            //getting  login information and message to hash
            System.out.println("please enter the username for login :");
            String loginName = input.nextLine();
            System.out.println("please enter the password to login:");
            String loginPass = input.nextLine();
            System.out.println("please enter your message ( to be hashed by server) :");
            message = input.nextLine();
            String data = loginName + "-" + loginPass + "-" + message;

                        //encryption of message with server public key
                        Cipher cipher = Cipher.getInstance("RSA");
                        cipher.init(Cipher.ENCRYPT_MODE, serverPublic);
                        byte[] encrypted = cipher.doFinal(data.getBytes());
                        cdout.writeInt(encrypted.length);
                        cdout.write(encrypted);


                                    //checking successful logging
                                    String status = in.readLine();
                                    if (status.equals("logged in successfully"))
                                        {
                                            System.out.println("successful login");
                                            break;

                                        } else if (status.equals("wrong username or password"))
                                        {
                                            System.out.println("wrong username or password, please enter again ...");
                                        }

                                    }


                                //client hash of the message
                                MessageDigest md = MessageDigest.getInstance("SHA-256");
                                byte[] messageToHash = message.getBytes("UTF-8");
                                byte[] myHash = md.digest(messageToHash);

                                            //server hash decryption
                                            int length = cdin.readInt();
                                            byte[] rcvEncryptedHash = new byte[length];
                                            cdin.readFully(rcvEncryptedHash, 0, rcvEncryptedHash.length);
                                            Cipher hashCipher = Cipher.getInstance("RSA");
                                            hashCipher.init(Cipher.DECRYPT_MODE, privateKey);
                                            byte[] rcvHash = hashCipher.doFinal(rcvEncryptedHash);

                //checking hash
                if (Arrays.equals(rcvHash, myHash))
                    {
                        System.out.println("hash successful");
                        out.println("Thank You");
                    }
                else
                    {
                        System.out.println("hash was not correct");
                    }
                                //termination of connection
                                client.close();
                                System.exit(1);


                            } catch (IOException ioe)
                            {
                                System.err.println("some error occurred in client side");
                            } catch (NoSuchAlgorithmException e)
                            {
                                e.printStackTrace();
                            } catch (InvalidKeySpecException e)
                            {
                                e.printStackTrace();
                            } catch (InvalidKeyException e)
                            {
                                e.printStackTrace();
                            } catch (NoSuchPaddingException e)
                            {
                                e.printStackTrace();
                            } catch (BadPaddingException e)
                            {
                                e.printStackTrace();
                            } catch (IllegalBlockSizeException e)
                            {
                                e.printStackTrace();
                            }

                    }

    }
