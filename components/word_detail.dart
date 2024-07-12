import 'package:flutter/material.dart';
import 'package:word/model/word.dart';
import '../model/player.dart';
import 'detail_means.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordDetail extends StatefulWidget {
  final Word? item;
  final SharedPreferences? prefs;
  const WordDetail({Key? key,this.item,this.prefs}) : super(key:key);

  @override
  WordDetailState createState() =>  WordDetailState();
}

class WordDetailState extends State<WordDetail> {
  bool showCn = false;
  bool showCollins=false;
  bool showSentence=false;

  @override
  void initState(){
    super.initState();
    setState(() {
      showCn = widget.prefs?.getBool('showCn')??false;
      showCollins = widget.prefs?.getBool('showcollins')??false;
      showSentence = widget.prefs?.getBool('sentence')??false;
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  Widget _getPlayer(){
    if(widget.prefs?.getBool('en_ph') == true){
      if(widget.item?.ph_en_mp3.toString().isEmpty == true){
        return  const Text('无法获取发音');
      }
      return  Column(
        children: <Widget>[
           Player(
              text: widget.item?.ph_en,
              src: widget.item?.ph_en_mp3,
              color: Colors.blueGrey,
              autoplay: false
          ),
           const Text('英音',style:  TextStyle(color: Colors.blueGrey,fontSize: 12.0))
        ],
      );
    }else{
      return const SizedBox();
    }
  }

  Widget _generateWidget(){
    final word = widget.item;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
         Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child:  Text(word?.text??'',style:  const TextStyle(fontSize: 22.0,color: Colors.blueGrey),),
        ),
        _getPlayer(),
         const Padding(padding: EdgeInsets.only(top:10.0)),
         DetailMeans(word: word,showCn:showCn,showCollins:showCollins,showSentence:showSentence)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text(widget.item?.text??''),
        elevation: 0.0,
      ),
      body: _generateWidget(),
    );
  }
}