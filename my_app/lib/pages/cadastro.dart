import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cadastrocliente extends StatefulWidget {
  @override
  State<Cadastrocliente> createState() => _CadastroclienteState();
}

class _CadastroclienteState extends State<Cadastrocliente> {
  TextEditingController user_n = TextEditingController();
  TextEditingController senha_n = TextEditingController();
  bool exibir = false;

  _cadastrarusuario() {
    Map<String, dynamic> users = {
      "id": user_n.text,
      "login": user_n.text,
      "senha": senha_n.text,
    };
    String url = "http://192.168.0.23:3000/usuarios";
    http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(users));
    print("Cliente cadastrado");
    user_n.text = "";
    senha_n.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 150,
              //   height: 150,
              //   child: Image.asset("images/login2.png"), // Coloque a imagem do login aqui
              // ),
              SizedBox(height: 20),
              TextFormField(
                controller: user_n,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.white70, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Digite seu nome",
                  labelText: "Nome",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: senha_n,
                obscureText: exibir,
                style: TextStyle(color: Colors.white70, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Digite sua senha",
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  suffixIcon: IconButton(
                    icon: Icon(exibir ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        exibir = !exibir;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _cadastrarusuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,  // Cor de fundo do botão
                  foregroundColor: Colors.deepPurple, // Cor do texto do botão
                ),
                child: Text("Cadastrar", style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Voltar para a tela de login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,  // Cor de fundo do botão
                  foregroundColor: Colors.deepPurple, // Cor do texto do botão
                ),
                child: Text("Voltar", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
