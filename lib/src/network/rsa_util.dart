import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'package:craft_dynamic/src/util/logger_util.dart';

class RSAUtil {
  static Future<String?> readCertificate(String pem) async {
    final publicKey =
        pem.replaceAll(RegExp(r'-----(BEGIN|END) CERTIFICATE-----'), '');
    return publicKey;
  }

  static RSAPublicKey? parsePublicKeyFromPem(String publicKey) {
    RSAPublicKey? rsaPublicKey;
    try {
      Uint8List publicKeyBytes = base64.decode(
          "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqO5uXE1g0Dviu35LYowEwUPUGPy31pHO5dPeBUXmSOYPl4wqcSpjQT0Us5BuZDGJI1hOxFxdhzf0STfQueK9l4EjqDJuDTQPoJcJxxzyPO2Qd3fWLh4Mh1eoqT7nEbK12Zvxy663+xP3pb0VqjVgAI8wI8CA2GHzhBACFtANu7N2z6hsCudM9t4tmFY4NtHlNbSBQQa5bnkcNu57SUPk23Vw1Em/6W6a4X9rxyxRqERiZgywuDvgLWEOYt9rlhBBwN8u+jOlxyqPux+yOLTp0z6h1fmc9hAENOw2amWNjngaUP6f6lmU4PrNg30msbzNk9f3SuTuUEsz5QLBOGbLuQIDAQAB");

      ASN1Parser asn1Parser = ASN1Parser(publicKeyBytes);
      ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
      debugPrint("sequence elements.....${topLevelSeq.elements}");
      ASN1Sequence publicKeySequence = topLevelSeq.elements[0] as ASN1Sequence;

      // Convert the modulus and exponent to BigInt values
      final modulusValue =
          (publicKeySequence.elements[1] as ASN1Integer).valueAsBigInteger;
      debugPrint(
          "Reached here>>>>>>>>>>>>>>>>Modulus:: $modulusValue>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      final exponentValue = (ASN1Integer(BigInt.from(65537))).valueAsBigInteger;

      rsaPublicKey = RSAPublicKey(
          modulusValue ?? BigInt.zero, exponentValue ?? BigInt.zero);
      debugPrint(rsaPublicKey.toString());
    } catch (e) {
      AppLogger.appLogE(
          tag: "Base64 to RSAPublicKey error", message: e.toString());
    }
    return rsaPublicKey;
  }
}
