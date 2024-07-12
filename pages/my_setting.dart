import 'package:flutter/material.dart';
import 'package:word/components/book_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word/components/study_plan.dart';
import 'package:word/model/constant.dart';
import 'package:word/model/db.dart';
import 'package:word/model/word.dart';
import 'login_in.dart';

class Mine extends StatefulWidget {
  final SharedPreferences? prefs;

  const Mine({Key? key, this.prefs}) : super(key: key);

  @override
  MineState createState() => MineState();
}

class MineState extends State<Mine> {
  bool showColins = false;
  bool sentence = false;

  bool showCn = false;
  bool enPh = false;
  int? count;
  int? num;
  String name = 'NCAA';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _getLearnednum() async {
    final prefss = await _prefs;
    num = prefss.getInt(Constant.L_num.toString()) ?? 0;
    name = prefss.getString(Constant.uesrName.toString()) ?? 'CET4';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List wholeList = await Word().getList(widget.prefs?.getInt('level'));
      List studiedList = await DBClient().queryAll();
      List studied = wholeList.where((item) {
        return studiedList.contains(item['word']);
      }).toList();
      num = studied.length;
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      final prefss = await prefs;
      prefss.setInt(Constant.L_num.toString(), num ?? 0);
      setState(() {});
    });

    showColins = widget.prefs?.getBool('showcollins') ?? false;
    sentence = widget.prefs?.getBool('sentence') ?? false;
    showCn = widget.prefs?.getBool('showCn') ?? false;
    count = widget.prefs?.getInt('count') ?? 0;
    enPh = widget.prefs?.getBool('en_ph') ?? false;

    _getLearnednum();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/img/cet46.jpg'),
            )),
            padding:
                const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/img/background.jpeg'),
                      )),
                ),
                const Padding(padding: EdgeInsets.only(left: 12.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 50.0)),
                    Text(
                      name,
//                      'CET4',
                      style: const TextStyle(
                          fontSize: 26.0, color: Colors.black87),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
              child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                    width: 10.0, color: Color.fromRGBO(236, 236, 242, 1.0)),
                left: BorderSide(
                    width: 10.0, color: Color.fromRGBO(236, 236, 242, 1.0)),
                top: BorderSide(
                    width: 10.0, color: Color.fromRGBO(236, 236, 242, 1.0)),
                bottom: BorderSide(
                    width: 10.0, color: Color.fromRGBO(236, 236, 242, 1.0)),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
              child: Row(children: <Widget>[
                Text(
                  '学习单词: $num',
                  style: const TextStyle(
                    color: Colors.black, //设置字体颜色
                    fontSize: 20, //设置字体大小
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/img/礼花.png',
                    alignment: Alignment.topRight,
                    width: 50,
                    height: 50,
                  ),
                )
              ]),
            ),
          )),
          Flexible(
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelectBook(prefs: widget.prefs)));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text(
                            '切换单词书',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Icon(Icons.chevron_right,
                              size: 30.0, color: Colors.grey)
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangePlan(prefs: widget.prefs)));
                    setState(() {
                      count = widget.prefs?.getInt('count') ?? 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '当前复习计划：每天$count个单词',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const Icon(Icons.chevron_right,
                            size: 30.0, color: Colors.grey)
                      ],
                    ),
                  ),
                ),
                SwitchListTile(
                    activeColor: Colors.blueGrey,
                    title: const Text('开启词典翻译'),
                    value: showColins,
                    onChanged: (bool value) {
                      setState(() {
                        showColins = value;
                        widget.prefs?.setBool('showcollins', value);
                      });
                    }),
                SwitchListTile(
                    activeColor: Colors.blueGrey,
                    title: const Text('显示中文翻译'),
                    value: showCn,
                    onChanged: (bool value) {
                      setState(() {
                        showCn = value;
                        widget.prefs?.setBool('showCn', value);
                      });
                    }),
                SwitchListTile(
                    activeColor: Colors.blueGrey,
                    title: const Text('显示例句'),
                    value: sentence,
                    onChanged: (bool value) {
                      setState(() {
                        sentence = value;
                        widget.prefs?.setBool('sentence', value);
                      });
                    }),
              ],
            ),
          ),
          _exit(context),
        ],
      ),
//      ),
    );
  }

  Widget _exit(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: AlignmentDirectional.bottomCenter,
      child: ElevatedButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              const BorderSide(width: 1, color: Colors.white)), //边框
          shape: MaterialStateProperty.all(BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(8))), //圆角弧度
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (Context) => LogininPage()));
        },
        child: const Text(
          '退出',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
