import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
 void initState(){
    super.initState();
    leituradados();
  }
  List  dado =[];
 Future<void> leituradados() async{

    String url = "https://raw.githubusercontent.com/danielvieira95/DESM-2/master/filmes.json";
    http.Response resposta = await http.get(Uri.parse(url));
   
     if(resposta.statusCode ==200){
        setState(() {
      dado = jsonDecode(resposta.body)  as List<dynamic>;// conversao dos produtos para uma lista convertendo do formato json
    print(dado);
    });
     }

     else {
      print(resposta.statusCode);
      throw Exception('Falha ao consumir api');
    }
   
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes"),
      ),
      body: Center(
        child:       
          ListView.builder(
            itemCount: dado.length,
            
            itemBuilder:(context,index ){
            final item = dado[index];
            return ListTile(
            title: Text("Filme: ${item["nome"]}",style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            ),
            subtitle: Column(
              children: [
                Image.network(item["imagem"], width: 300, height: 200, scale: 1,),
                Text("Ano de lançamento ${item["ano de lançamento"]}",style: TextStyle(fontSize: 18),),
                Text("Nota ${item["nota"]}",style: TextStyle(fontSize: 18),),
                Text("Duração: ${item["duração"]}",style: TextStyle(fontSize: 18),),
              ],
            ),
            
            );
            } ),


      ),
      );
    
  }
}










class Produto_item{
  String id;
  String nome;
  String valor;
  String qtde;
  Produto_item(this.id, this.nome, this.valor, this.qtde);
  factory Produto_item.fromJson(Map<String, dynamic> json){
    return Produto_item(json['id'],json['nome'],json['valor'],json['qtde']);
  }
}