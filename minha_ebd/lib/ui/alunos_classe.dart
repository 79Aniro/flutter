import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';



class AlunosClasse extends StatefulWidget {
  final Classe classe;
   AlunosClasse({this.classe});
  @override
  _AlunosClasseState createState() => _AlunosClasseState();
}

class _AlunosClasseState extends State<AlunosClasse> {
  AlunoHelper helper = AlunoHelper();
  List<Aluno> alunos=List();
  bool _userEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAlunosClasse();
    print("olha aqui"+widget.classe.idClass.toString());


  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.classe.nameClass),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: alunos.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    ),
    );
  }


  void _getAlunosClasse()  {
print("_getAlunosClasse");
  helper.getClasseAlunos(widget.classe.idClass).then((list) {
      setState(() {
        alunos = list ;

      });
    });
  }


  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: alunos[index].img != null
                          ? FileImage(File(alunos[index].img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200.0,
                        child: Text(
                          alunos[index].name ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 200.0,
                        child: Text(
                          alunos[index].email ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Text(
                        alunos[index].phone ?? "",
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      onTap: () {

      },
    );
  }
  Future<bool> _requestPop() {
    if (_userEdit) {
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title:Text("Descartar alterações"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),


              ],
            );
          }
      );
      return Future.value(true);

    }
    else{
      return Future.value(true);
    }
  }

}


