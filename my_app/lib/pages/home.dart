import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 166, 235),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Filmes", style: TextStyle(color: Colors.white), ),
      ),
      body: Container(
        child: Text("Olá"),
      ),
    );
  }
}

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {

_filmes() async {
  List Filmes = <Filme>[];
  String url = 'https://raw.githubusercontent.com/danielvieira95/DESM-2/master/filmes.json';
  http.Response response = await http.get(Uri.parse(url));
  Filmes = json.decode(response.body);
  print(Filmes);
}  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 166, 235),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Filmes", style: TextStyle(color: Colors.white), ),
      ),
      body: Container(
        child: ElevatedButton(onPressed: _filmes, child: Text("Filmes")),
        
        
      ),
    );
  }
}

class Filme{
  String nome;
  String imagem;
  String duracao;
  String anoLancamento;
  String nota;
   
   Filme(this.nome, this.imagem, this.duracao, this.anoLancamento, this.nota);

   factory Filme.fromJson(Map<String,dynamic> json){
    return Filme(json['nome'],json['imagem'],json['duração'],json['ano de lançamento'],json['nota']);
   }
}
