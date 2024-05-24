import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/pages/cadastro.dart';
import 'package:my_app/pages/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

TextEditingController user = TextEditingController();
TextEditingController senha = TextEditingController();  

_cadastrar(){
  Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastrocliente()));
}
 
_login() async{
   bool encuser= false;
   List clientes = <Usuario>[];
    String url = "http://10.109.83.11:3000/usuarios";
    http.Response response = await http.get(Uri.parse(url));
    clientes = json.decode(response.body);
    print(clientes[1]['nome']);
    print(clientes[1]['senha']);
    for (int i=0; i<clientes.length; i++){
    if(user.text == clientes[i]["nome"] && senha.text == clientes[i]["senha"]){
      encuser =true;
      print("Usuario encontrado");
      break;
    }
    }
    if (encuser) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MoviesScreen()));
      encuser = false;
      user.text = '';
      senha.text = '';
    }
    else{
      print("Usuario nao encontrado, realize o cadastro");
       ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Usuário ou senha Inválido"),duration: Duration(seconds: 2),),);
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
              autofocus: false,
              controller: user,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white70, fontSize: 20),
              decoration: InputDecoration(
              //  icon: Icon(Icons.person),
                hintText: "Digite seu email",
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white, fontSize: 20)
              ),
            
            ),
            TextFormField(
              controller: senha,
              autofocus: false,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: TextStyle(color: Colors.white70, fontSize: 20),
              decoration: InputDecoration(
              //  icon: Icon(Icons.key_sharp),
                hintText: "Digite sua senha",
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.white, fontSize: 20)
                ),
            ),
            ElevatedButton(onPressed: _login,
              child: Text(
              "Entrar",
              style: TextStyle(color: Colors.deepPurple ),
              ),
              ),
            ElevatedButton(onPressed: _cadastrar,
              child: Text(
              "Cadastrar",
              style: TextStyle(color: Colors.deepPurple ),
              ),
              ),  
          ],
        ),
      ),
      ),
    );
  }
}

class Usuario{
  String id;
  String login;
  String senha;
  Usuario(this.id, this.login, this.senha);
  factory Usuario.fromJson(Map<String,dynamic> json){
    return Usuario(json["id"],json["login"],json["senha"]);
  }
  }