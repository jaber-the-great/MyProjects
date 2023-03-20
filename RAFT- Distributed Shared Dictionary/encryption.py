import rsa

def enc(msg, public_key):
    return rsa.encrypt(msg.encode('utf-8'),public_key)

def dec(cipher,private_key):
    return rsa.decrypt(cipher, private_key).decode('utf-8')

def readPublicKeysFromFile():
    pubKeys = {}
    mystr = "ABCDE"
    for client in mystr:
        pubKeys[client] = readPublic(client)
    return pubKeys

def readPublic(clientName):
    with open(clientName + "_Public.pem", "rb") as keyFile:
        PublicKey = rsa.PublicKey.load_pkcs1(keyFile.read())
    return PublicKey

def readPrivate(clientName):
    with open(clientName + "_Private.pem", "rb") as keyFile:
        PrivateKey = rsa.PrivateKey.load_pkcs1(keyFile.read())
    return PrivateKey

def generateKeyForDictionary():
    return rsa.newkeys(2048)

def generateAndStoreKeys():
    mystr = "ABCDE"
    for item in mystr:
        pub, pri = rsa.newkeys(2048)
        file1 = open(item + "_Public.pem", "w")
        file2 = open(item +"_Private.pem" ,"w")
        file1.write(pub.save_pkcs1().decode('utf8'))
        file2.write(pri.save_pkcs1().decode('utf8'))
        file1.close()
        file2.close()