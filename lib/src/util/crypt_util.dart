part of craft_dynamic;

class CryptLib {
  static String toSHA256(String key, int length) {
    var bytes1 = utf8.encode(key); // data being hashed
    var digest1 = sha256.convert(bytes1);
    var digestBytes = digest1.bytes;
    var hex = HEX.encode(digestBytes);
    if (length > hex.toString().length) {
      return hex.toString();
    } else {
      return hex.toString().substring(0, length);
    }
  }

  static Future<String> oldDecrypt(String response) async {
    var localDevice = await _sharedPref.getLocalDevice();
    var localIV = await _sharedPref.getLocalIv();
    return utf8.decode(base64.decode(CryptLib.decrypt(
        base64.normalize(response),
        CryptLib.toSHA256(localDevice, 32),
        localIV)));
  }

  static String decrypt(
      String ciphertext, String decryptKey, String decryptIv) {
    String decrypted = "";
    try {
      final key = encryptcrpto.Key.fromUtf8(decryptKey);
      final iv = encryptcrpto.IV.fromUtf8(decryptIv);

      final encrypter = encryptcrpto.Encrypter(
          encryptcrpto.AES(key, mode: encryptcrpto.AESMode.cbc));
      encryptcrpto.Encrypted enBase64 =
          encryptcrpto.Encrypted.from64(ciphertext);
      decrypted = encrypter.decrypt(enBase64, iv: iv);
    } catch (e) {
      AppLogger.appLogE(
          tag: "DECRYPT ERROR", message: "Unable to decrypt data:::$e");
    }
    return decrypted;
  }

  static String encrypt(String plainText, String encryptKey, String encryptIv) {
    final key = encryptcrpto.Key.fromUtf8(toSHA256(encryptKey, 32));
    final iv = encryptcrpto.IV.fromUtf8(encryptIv);
    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(key, mode: encryptcrpto.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String encryptField(String plainText) {
    final hashKey =
        encryptcrpto.Key.fromUtf8(toSHA256(APIService.staticLogKeyValue, 32));
    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(hashKey, mode: encryptcrpto.AESMode.cbc));
    final encryptedText = encrypter.encrypt(plainText,
        iv: encryptcrpto.IV.fromUtf8(APIService.staticEncryptIv));
    return encryptedText.base64;
  }

  static String decryptField({encrypted}) {
    final hashKey =
        encryptcrpto.Key.fromUtf8(toSHA256(APIService.staticLogKeyValue, 32));

    final encrypter = encryptcrpto.Encrypter(
        encryptcrpto.AES(hashKey, mode: encryptcrpto.AESMode.cbc));
    encryptcrpto.Encrypted enBase64 = encryptcrpto.Encrypted.from64(encrypted);
    return encrypter.decrypt(enBase64,
        iv: encryptcrpto.IV.fromUtf8(APIService.staticEncryptIv));
  }

  static String encryptPayloadObj(
      String decryptedString, String keyvaltest, String serverIV) {
    String data = "";
    String key = toSHA256(keyvaltest, 32);
    data = encrypt(decryptedString, key, serverIV);
    data = data.replaceAll("\\r\\n|\\r|\\n", "");
    return data;
  }

  static String gzipDecompressStaticData(String gzippedString) {
    return utf8.decode(GZipDecoder().decodeBytes(base64.decode(gzippedString)));
  }

  static decryptResponse(String response) async {
    String decrypted = "";
    try {
      decrypted = await CryptLib.oldDecrypt(response);
    } catch (e) {
      AppLogger.appLogE(
          tag: "Decryption Error", message: "Unable to decrypt data!");
    }
    return decrypted;
  }
}
