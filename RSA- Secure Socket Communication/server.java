import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.*;
import java.math.BigInteger;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.RSAPublicKeySpec;

public class server
    {

    public static void main(String[] args)
        {
            String cUser="";
            String cPass="";
            int cnt = 0;

            while (true)
                {
                    try
                        {
                            cnt++;//


        //creating socket listener
        ServerSocket s = new ServerSocket(1234);
        Socket jaber = s.accept();


                //reader writer and input output stream creation
                PrintWriter out = new PrintWriter(jaber.getOutputStream(), true);
                BufferedReader in = new BufferedReader(new InputStreamReader(jaber.getInputStream()));
                DataOutputStream dout = new DataOutputStream(jaber.getOutputStream());
                DataInputStream din = new DataInputStream(jaber.getInputStream());

                        // generating key pair and public and private key for server
                        KeyPairGenerator skpg = KeyPairGenerator.getInstance("RSA");
                        skpg.initialize(1024);
                        KeyPair skp = skpg.genKeyPair();
                        PublicKey spublicKey = skp.getPublic();
                        PrivateKey sprivateKey = skp.getPrivate();


                                //separation of module and exponent of keys
                                KeyFactory fact = KeyFactory.getInstance("RSA");
                                RSAPublicKeySpec spub = fact.getKeySpec(skp.getPublic(), RSAPublicKeySpec.class);
                                RSAPrivateKeySpec spri = fact.getKeySpec(skp.getPrivate(), RSAPrivateKeySpec.class);


        //getting user register information and public kye of user
        System.out.println(cnt);
        if(cnt==1)
            {
                 cUser = in.readLine();
                 cPass = in.readLine();
            }
        else
            {
                String dummy = in.readLine();
                dummy = in.readLine();
            }
        BigInteger clientKeyModule = new BigInteger(in.readLine());
        BigInteger clientKeyExpon = new BigInteger(in.readLine());


                    //sending server public key to user
                    out.println(spub.getModulus());
                    out.println(spub.getPublicExponent());


                                //rebuilding client public key
                                RSAPublicKeySpec reverseSpec = new RSAPublicKeySpec(clientKeyModule, clientKeyExpon);
                                KeyFactory reverseFact = KeyFactory.getInstance("RSA");
                                PublicKey clientPublic = reverseFact.generatePublic(reverseSpec);


                            //exchanging safe message with client
                            while (true)
                                {

        //reaction to client self termination
        String temp = in.readLine();
        if(temp.equals("close connection"))
            {
                System.out.println("connection closed successfully by client means ");
                break;
            }


                                    //getting user user + pass + message encrypted with server public
                                    int length = din.readInt();
                                    byte[] rcv = new byte[length];
                                    din.readFully(rcv, 0, rcv.length);

                                    //decryption of user data
                                    Cipher cipher = Cipher.getInstance("RSA");
                                    cipher.init(Cipher.DECRYPT_MODE, sprivateKey);
                                    String decrypt = new String(cipher.doFinal(rcv));
                                    System.out.println(decrypt);

                                    //splitting the user data(user + pass + message)
                                    String[] output = decrypt.split("-");

                                    //checking user authentication
                                    if (output[0].equals(cUser) && output[1].equals(cPass))
                                        {
                                            System.out.println("successful login");
                                            out.println("logged in successfully");

                                            //hashing the message part of user data
                                            MessageDigest md = MessageDigest.getInstance("SHA-256");
                                            byte[] bytesToHash = output[2].getBytes("UTF-8");
                                            byte[] hashByte = md.digest(bytesToHash);

                                            //encrypting hash with user public key
                                            Cipher hashCipher = Cipher.getInstance("RSA");
                                            hashCipher.init(Cipher.ENCRYPT_MODE, clientPublic);
                                            byte[] hashEncrypted = hashCipher.doFinal(hashByte);

                                            //sending encrypted hash of message to user
                                            dout.writeInt(hashEncrypted.length);
                                            dout.write(hashEncrypted);
                                            break;

                                        } else
                                        {
                                            out.println("wrong username or password");
                                        }
                                }

                            //waiting for termination message
                            while (!in.readLine().equals("Thank You"))
                                {
                                    //nothing
                                }

                            //terminate current connection
                            jaber.close();
                            s.close();


                        } catch (IOException ioe)
                        {
                            System.err.println("some error occurred in server side");
                        } catch (NoSuchAlgorithmException e)
                        {
                            e.printStackTrace();
                        } catch (InvalidKeySpecException e)
                        {
                            e.printStackTrace();
                        } catch (NoSuchPaddingException e)
                        {
                            e.printStackTrace();
                        } catch (InvalidKeyException e)
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
}
