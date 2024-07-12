import 'package:flutter/material.dart';
import 'package:word/model/word.dart';
import '../model/player.dart';
import 'package:word/pages/home_page.dart';
import 'package:word/components/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word/model/db.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

class RememberVocab extends StatefulWidget {
  final SharedPreferences? prefs;

  const RememberVocab({Key? key, this.prefs}) : super(key: key);

  @override
  RememberVocabState createState() {
    return RememberVocabState();
  }
}

class RememberVocabState extends State<RememberVocab>
    with SingleTickerProviderStateMixin {
  DBClient? client;
  int? currentIndex;
  bool? next;
  Word? currentItem;
  List list = [];
  List stuiedWords = [];
  AnimationController? controller;
  late Animation<Offset> animation;
  TextDirection? direction;
  Future? _future;
  var a;
  var t;
  String? right_one;
  String? wr1, wr2, wr3, wr4;
  final _random = Random();
  final padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0);

  final box = const Border(
    right: BorderSide(width: 2.0, color: Colors.black12),
    left: BorderSide(width: 2.0, color: Colors.black12),
    top: BorderSide(width: 3.0, color: Colors.black12),
    bottom: BorderSide(width: 3.0, color: Colors.black12),
  );

  final snackBar = const SnackBar(
    content: Text(
      '已完成今日学习计划',
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    duration: Duration(milliseconds: 3000),
    behavior: SnackBarBehavior.fixed,
  );

  @override
  initState() {
    super.initState();
    _future = getlist();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(
        CurvedAnimation(parent: controller!.view, curve: Curves.easeInOut))
      ..addStatusListener(statusListener);
    setState(() {
      currentIndex = 0;
      next = false;
      direction = TextDirection.rtl;
    });
  }

  @override
  void dispose() {
    animation.removeStatusListener(statusListener);
    controller?.dispose();
    super.dispose();
  }

  statusListener(status) {
    print(status);
    if (status == AnimationStatus.completed && mounted) {
      setState(() {
        if (next == true && mounted) {
          currentIndex =
              ((currentIndex ?? 0) + 1) == (widget.prefs?.getInt('count') ?? 0)
                  ? currentIndex
                  : (currentIndex ?? 0) + 1;
          setState(() {
            next = false;
          });
        }
      });
      controller?.reverse();
    }
  }

  Future<int> getLevel() async {
    client = DBClient();
    final int level = widget.prefs?.getInt('level') ?? 1;
    return level;
  }

  Widget _getPlayer() {
    if (widget.prefs?.getBool('en_ph') == true) {
      return Column(
        children: <Widget>[
          Player(
              text: currentItem?.ph_en,
              src: currentItem?.ph_en_mp3,
              color: Colors.blueGrey,
              autoplay: widget.prefs?.getBool('autoplay') ?? false),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Future<List> getlist() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final int level = await getLevel();
    List? stuiedWords = await client?.queryAll();
    final wholeList = await Word().getList(level);
    List lastWords;
    if (stuiedWords != null) {
      lastWords = wholeList.where((item) {
        return !stuiedWords.contains(item['word']);
      }).toList();
    } else {
      lastWords = wholeList;
    }
    int count = widget.prefs?.getInt('count') ?? 0;
    int len = count > lastWords.length ? lastWords.length : count;
    return lastWords.sublist(0, len);
  }

  _checkIsFinish(BuildContext context, int index, bool know) async {
    if (index == widget.prefs?.getInt('count')) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
      _remind();
    } else if (mounted) {
      if (know) {
        setState(() {
          direction = TextDirection.ltr;
          next = true;
        });
        if (currentItem != null) {
          await client?.insert(currentItem!);
        }
      } else {
        setState(() {
          direction = TextDirection.rtl;
          next = true;
        });
      }
      controller?.forward();
    }
  }

  _remind() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Little Tip'),
            content: const Text('今日学习任务已完成！！！\n'
                '是否继续学习？？？'),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                child: const Text(
                  '确认',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (Context) => HomePage()));
                },
              ),
              FlatButton(
                color: Colors.blue,
                child: const Text(
                  '退出',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  _feedback(bool acc) {
    final snackBar = SnackBar(
      content: Text(
        acc ? 'right!!' : 'wrong!!!',
        style: const TextStyle(color: Colors.blue),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 500),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
  }

  int _randome(int min, int max) {
    var result = min + _random.nextInt(max - min);
    return result;
  }

  Widget _builder(context, snapshot) {
    if (snapshot.hasData) {
      list = snapshot.data;
      t = snapshot.data;
      List tempList = [currentIndex];
      for (; tempList.length < 5;) {
        var b = _randome(0, list.length);
        if (!tempList.contains(b)) tempList.add(b);
      }
      print(tempList);
      currentItem = Word().getDetail(list[currentIndex ?? 0]);
      right_one = currentItem?.cn_mean?[0]['means'][0];

      var temp1 = Word().getDetail(list[tempList[1]]);
      wr1 = temp1.cn_mean?[0]['means'][0];
      var temp2 = Word().getDetail(list[tempList[2]]);
      wr2 = temp2.cn_mean?[0]['means'][0];
      var temp3 = Word().getDetail(list[tempList[3]]);
      wr3 = temp3.cn_mean?[0]['means'][0];
      var temp4 = Word().getDetail(list[tempList[4]]);
      wr4 = temp4.cn_mean?[0]['means'][0];
      print(right_one);

      a = Random().nextInt(4);
      print('a:$a');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
              currentItem?.text ?? '',
              style: const TextStyle(fontSize: 28.0, color: Colors.blueAccent),
            ),
          ),
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                child: _getPlayer(),
              ),
              const Padding(padding: EdgeInsets.only(top: 0.0)),
              Means(currentItem: currentItem, prefs: widget.prefs),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: BoxDecoration(
                      border: box,
                    ),
                    child: Padding(
                      padding: padding,
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              _feedback(0 == a);
                              _checkIsFinish(
                                  context, (currentIndex ?? 0) + 1, 0 == a);
                            },
                            child: Text(
                              0 == a ? right_one ?? '' : wr1 ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: BoxDecoration(border: box),
                    child: Padding(
                      padding: padding,
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              _feedback(1 == a);
                              _checkIsFinish(
                                  context, (currentIndex ?? 0) + 1, 1 == a);
                            },
                            child: Text(
                              1 == a ? right_one ?? '' : wr2 ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: BoxDecoration(
                      border: box,
                    ),
                    child: Padding(
                      padding: padding,
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              _feedback(2 == a);
                              _checkIsFinish(
                                  context, (currentIndex ?? 0) + 1, 2 == a);
                            },
                            child: Text(
                              2 == a ? right_one ?? '' : wr3 ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    decoration: BoxDecoration(
                      border: box,
                    ),
                    child: Padding(
                      padding: padding,
                      child: Center(
                        child: GestureDetector(
                            onTap: () {
                              _feedback(3 == a);
                              _checkIsFinish(
                                  context, (currentIndex ?? 0) + 1, 3 == a);
                            },
                            child: Text(
                              3 == a ? right_one ?? '' : wr4 ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            )),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ],
          )),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
//        elevation: 0.0,
        title: const Text('四级词汇'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SlideTransition(
                position: animation,
                textDirection: direction,
                child: GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    width: 380.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset.zero,
                            blurRadius: 5.0,
                            spreadRadius: 0.1)
                      ],
                    ),
                    child: FutureBuilder(
                      future: _future,
                      builder: _builder,
                      initialData: null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
