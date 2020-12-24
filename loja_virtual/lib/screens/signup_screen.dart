import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
        centerTitle: true,

      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Nome Completo"
              ),

              validator:  (text){
                // ignore: missing_return
                if(text.isEmpty ) return "Nome inválido";
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "E-mail"
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                // ignore: missing_return
                if(text.isEmpty || !text.contains("@")) return "Email inválido";
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Senha"),
              obscureText: true,
              validator: (text){
                if(text.isEmpty || text.length<6) return "Senha inválida";
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Endereço"),
              validator: (text){
                if(text.isEmpty) return "Endereço inválido";
              },
            ),

            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 44.0,

              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                  "Criar conta",
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if(_formKey.currentState.validate()){

                  }
                },

              ),
            )
          ],
        ),
      ),
    );
  }
}
