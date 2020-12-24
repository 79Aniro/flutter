import 'package:flutter/material.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';
import 'package:flutter/cupertino.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  AlunoClasse alunoClasse;
  List<AlunoClasse> listaAlunoClasse;



  @override
  Widget build(BuildContext context) {
    return
        Scaffold(

          appBar: AppBar(
            title: Text("Minha EBD",style: TextStyle(fontSize: 20.0,color: Colors.white),),
            centerTitle: true,
            backgroundColor:Color.fromARGB(98, 0, 12, 250),
          ),
          body: ListView(

            padding: EdgeInsets.all(20.0),
            children: [
              SizedBox(
                height: 44.0,

                child:ElevatedButton(

                  onPressed: () {
                    // Respond to button press
                  },
                  child: Text('CONTAINED BUTTON'),
                ) ,
              )

            ],

          ),
        );



  }
}


