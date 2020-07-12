import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Flutter Go Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: MyHomePage(title: 'GoのAPIServerを叩く'),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  var _txtController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: TextField(
        controller: _txtController,
        decoration: InputDecoration(labelText: 'API Value',),
      ),
      floatingActionButton: FloatingActionButton(
        // 画面下の追加ボタンを押下した時のイベント
        onPressed: () => _request(),
        child: Icon(Icons.library_add),
      ),
    );
  }

  Future<String> _getText() async
  {
    // get
    http.get(new Uri.http("192.168.11.4:8000", "/clinic/main"));
    const url = 'http://192.168.11.4:8000/clinic/login';
    http.get(url).then((response)
    {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      setState(()
      {
        Map map = json.decode(response.body);
        _txtController.text = map['クリニック名'];
      });
    });
  }

  void _request() async
  {
    // とりあえずクエリパラメータで送信
    const url = 'http://192.168.11.4:8000/clinic/login';
    Map<String, String> headers = {'content-type': 'application/json'};
    http.Response resp = await http.post(url, headers: headers);

    if (resp.statusCode != 200)
    {
      setState(()
      {
        int statusCode = resp.statusCode;
        _txtController.text = "Failed to post $statusCode";
      });
      return;
    }
    setState(()
    {
      Map map = json.decode(resp.body);
      _txtController.text = map['sample'];
    });
  }

  @override
  void initState()
  {
    _txtController.text = '';
    _getText();
    super.initState();
  }
}