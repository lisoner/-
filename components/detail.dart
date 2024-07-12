import 'package:flutter/material.dart';
import 'package:word/model/word.dart';
import 'detail_means.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Means extends StatefulWidget {
  final Word? currentItem;
  final SharedPreferences? prefs;

  const Means({Key? key, this.currentItem, this.prefs}) : super(key: key);

  @override
  MeansState createState() => MeansState();
}

class MeansState extends State<Means> {
  bool means = false;
  bool showCn= false;
  bool showCollins= false;
  bool showSentence= false;

  @override
  void initState() {
    super.initState();
    setState(() {
      means = false;
      showCn = widget.prefs?.getBool('showCn') ??false;
      showCollins = widget.prefs?.getBool('showcollins')??false;
      showSentence = widget.prefs?.getBool('sentence')??false;
    });
  }

  @override
  void didUpdateWidget(Means oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      setState(() {
        means = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getMeans() {
    if (means) {
      return DetailMeans(
        word: widget.currentItem,
        showCn: showCn,
        showCollins: showCollins,
        showSentence: showSentence,
      );
    } else {
      return const Expanded(child: Text(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: <Widget>[
        _getMeans(),
        InkWell(
          onTap: () {
            setState(() {
              means = !means;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              means ? '点击隐藏释义' : '点击显示释义',
              style: const TextStyle(color: Colors.blueGrey),
            ),
          ),
        )
      ],
    ));
  }
}
