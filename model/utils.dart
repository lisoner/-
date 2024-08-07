import 'dart:convert';
import 'package:crypto/crypto.dart';

class Md5Util {
  /// md5 加密
  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return  digest.bytes.map((e) => e.toRadixString(16).padLeft(2,'0')).join();
    // return hex.encode(digest.bytes);
  }
}
