import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=375a6d79";

void main() async{

  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amberAccent,
      primaryColor: Colors.amberAccent,
      inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent))
      )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;
  
  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }
  void _refresh(){
    setState(() {
      realController.text = "";
      dollarController.text = "";
      euroController.text = "";
    });
  }

  void _realChanged(String text){
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(3);
    euroController.text = (real/euro).toStringAsFixed(3);
  }
    void _dollarChanged(String text){
      if (text.isEmpty) {
      _clearAll();
      return;
      }
      double dollar = double.parse(text);
      realController.text = (dollar * this.dollar).toStringAsFixed(3);
      euroController.text = (dollar * this.dollar/euro).toStringAsFixed(3);
  }
    void _euroChanged(String text){
      if (text.isEmpty) {
      _clearAll();
      return;
      }
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(3);
      dollarController.text = (euro *this.euro/dollar).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de moedas"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25.0),
                textAlign: TextAlign.center  ),
              );
              default:
              if (snapshot.hasError) {
                return Center(
                child: Text("Erro ao carregar dados...",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25.0),
                textAlign: TextAlign.center  ),
              );
              } else {
                 dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                 euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                 
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 130.0, color: Colors.amberAccent,),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dollar", "\$", dollarController, _dollarChanged),
                      Divider(),
                      buildTextField("Euros", "€", euroController, _euroChanged),
                      Divider(),
                      
                    ],
                  ),
                );
              }
          }

        }
      )
    );
  }
}

Future<Map> getData() async {

  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String label, String prefix, TextEditingController coin, Function change) {

  return TextField(
    controller: coin,
    decoration: InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.amberAccent),
    border: OutlineInputBorder(),
    prefixText: prefix
    ),
  style: TextStyle(color: Colors.grey, fontSize: 24.0),
  onChanged: change,
  keyboardType: TextInputType.number,
  );
}