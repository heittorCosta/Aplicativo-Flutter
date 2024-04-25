import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
_login(){
  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
          ],
        ),
      ),
      ),
    );
  }
}