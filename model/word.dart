import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class Word {
  final text;
  final ph_en;
  final ph_en_mp3;
  final origin;
  final explain;
  List? cn_mean;
  List? collins;
  Word({this.text,this.explain,this.ph_en,this.ph_en_mp3,this.cn_mean,this.collins,this.origin});

  Future<List> getList(level) async {
    String path = 'assets/json/ans_$level.json';
    final jsonstr = await rootBundle.loadString(path);
    return json.decode(jsonstr);
  }

  Word getDetail(item) {
    return  Word.fromJson(item);
  }

  Map toJson(Word word){
    Map<String, dynamic> map;
    try{
      map=  {
        'word': word.text,
        'ph_en': word.ph_en,
        'ph_en_mp3': word.ph_en_mp3,
        'parts': word.cn_mean,
        'collins': word.collins,
        'origin': word.origin
      };
    }catch(e){
      map = {
        'word': word.text,
        'explain': word.explain
      };
    }
    return map;
  }

  factory Word.fromJson(json){
    Word word;
    try{
      word =  Word(
        text: json['word'],
        ph_en: json['ph_en'],
        ph_en_mp3: json['ph_en_mp3'],
        cn_mean: json['parts'],
        collins: json['collins'],
        origin: json['origin']
      );
    }catch(e){
      print(e);
      word =  Word(
          text: json['word'],
          explain: json['explain'],
      );
    }
    return word;
  }
}