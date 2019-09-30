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
      primaryColor: Colors.amberAccent
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dollar;
  double euro;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de moedas"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(color: Colors.amberAccent),
                          border: OutlineInputBorder(),
                          prefixText: "R\$"
                        ),
                        style: TextStyle(color: Colors.amberAccent, fontSize: 24.0),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dollar",
                          labelStyle: TextStyle(color: Colors.amberAccent),
                          border: OutlineInputBorder(),
                          prefixText: "\$"
                        ),
                        style: TextStyle(color: Colors.amberAccent, fontSize: 24.0),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Euros",
                          labelStyle: TextStyle(color: Colors.amberAccent),
                          border: OutlineInputBorder(),
                          prefixText: "€"
                        ),
                        style: TextStyle(color: Colors.amberAccent, fontSize: 24.0),
                      ),
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