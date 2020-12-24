
import 'package:flutter/material.dart';

import 'package:minha_ebd/helpers/aluno_helper.dart';

class ClassePage extends StatefulWidget {
  final Classe classe;

  ClassePage({this.classe});

  @override
  _ClassePageState createState() => _ClassePageState();
}

class _ClassePageState extends State<ClassePage> {
  final _nameController = TextEditingController();

  final _nameFocus = FocusNode();
  bool _userEdit = false;

  Classe _editedClasse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.classe == null) {
      _editedClasse = Classe();
    } else {
      _editedClasse = Classe.fromMap(widget.classe.toMap());
      _nameController.text = _editedClasse.nameClass;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedClasse.nameClass ?? "Nova Classe"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedClasse.nameClass != null && _editedClasse.nameClass.isNotEmpty) {
              Navigator.pop(context, _editedClasse);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome da Classe"),
                onChanged: (text) {
                  _userEdit = true;
                  setState(() {
                    _editedClasse.nameClass = text;
                  });
                },
              ),


            ],
          ),
        ),
      ),
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
                )
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
