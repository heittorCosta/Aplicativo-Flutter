import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/listaAgendamentos.dart';
import 'dart:convert';
import 'cadastro.dart';
import 'agendamento_screen.dart'; // Atualizado para a nova página de agendamento

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController senha = TextEditingController();

  _cadastrar() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastrocliente()));
  }

  _login() async {
    if (user.text.isEmpty || senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos!"), duration: Duration(seconds: 2)),
      );
      return;
    }

    try {
      String url = "http://192.168.0.23:3000/usuarios";
      http.Response response = await http.get(Uri.parse(url));
      print(response.statusCode);

      if (response.statusCode == 200) {
        List clientes = json.decode(response.body);
        bool encuser = false;

        for (var cliente in clientes) {
          if (user.text == cliente["login"] && senha.text == cliente["senha"]) {
            encuser = true;
            break;
          }
        }

        if (encuser) {
          if (user.text == "admin" && senha.text == "admin") {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListaAgendamentoScreen()), // Atualizado para AgendamentoScreen
          );
          }
          else {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgendamentoScreen()), // Atualizado para AgendamentoScreen
          );
          }
          
          user.clear();
          senha.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário ou senha inválido"), duration: Duration(seconds: 2)),
          );
        }
      } else {
        throw Exception("Erro ao buscar usuários: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao conectar ao servidor"), duration: Duration(seconds: 2)),
      );
    }
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
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("images/login2.png"),
              ),
              TextFormField(
                controller: user,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white70, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Digite seu email",
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              TextFormField(
                controller: senha,
                obscureText: true,
                style: TextStyle(color: Colors.white70, fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Digite sua senha",
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: _login,
                child: Text("Entrar", style: TextStyle(color: Colors.deepPurple)),
              ),
              ElevatedButton(
                onPressed: _cadastrar,
                child: Text("Cadastrar", style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
