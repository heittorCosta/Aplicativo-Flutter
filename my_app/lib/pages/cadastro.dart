import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // pacote para fazer requisições http get, post, delete, put
import 'dart:convert'; // converter arquivo json

class Cadastrocliente extends StatefulWidget {
  

  @override
  State<Cadastrocliente> createState() => _CadastroclienteState();
}

class _CadastroclienteState extends State<Cadastrocliente> {
  TextEditingController user_n = TextEditingController();
  TextEditingController senha_n = TextEditingController();
  bool exibir = false;
  _cadastrarusuario(){
    Map<String,dynamic> users={
      "id": user_n.text,
      "login": user_n.text,
      "senha": senha_n.text,
      

    };
    String url = "http://10.109.79.4:3000/usuarios";
    http.post(Uri.parse(url),
    headers:<String,String>{
      'Content-type': 'application/json; charset=UTF-8',
    } ,
    body: jsonEncode(users)
    );
    print("Cliente  cadastrado");
    user_n.text ="";
    senha_n.text = "";
    
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Cadastro"),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name, // define o tipo de entrada do teclado
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(Icons.people_alt_outlined),iconColor: Colors.blue,
                      hintText: "Digite seu nome"
                      
                      ),
                      controller: user_n,
                      
                        
                        
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name, // define o tipo de entrada do teclado
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(Icons.key),iconColor: Colors.blue,
                      hintText: "Digite sua senha",
                      suffixIcon: IconButton(icon: Icon(exibir? Icons.visibility:Icons.visibility_off,
                       ),onPressed: (){
                        setState(() {
                          exibir =!exibir;
                        });
                      },
                       
                       ),                  
                      ),
                      obscureText: exibir ,
                      obscuringCharacter: "*",
                      controller: senha_n,
                      
                        
                        
                    ),
                  ),
      
                ],
              ),
      
            ),
           ElevatedButton(onPressed: _cadastrarusuario, child: Text("Cadastrar")),
            ElevatedButton(onPressed: (){
              http.delete(Uri.parse('http://10.109.79.4:3000/usuarios${user_n.text}'));
              user_n.text = "";
            }, child: Text("Deletar")),
          ],
         
        ),
      ),
    );
  }
}