import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AlunoPage extends StatefulWidget {
  final Aluno aluno;

  AlunoPage({this.aluno});

  @override
  _AlunoPageState createState() => _AlunoPageState();
}

class _AlunoPageState extends State<AlunoPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classeController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _userEdit = false;
  ScrollController hController;
  Aluno _editedAluno;
  AlunoHelper helper = AlunoHelper();
  List<Classe> listaClasses;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

_getAllClasses();
    if (widget.aluno == null) {
      _editedAluno = Aluno();
    } else {
      _editedAluno = Aluno.fromMap(widget.aluno.toMap());
      _nameController.text = _editedAluno.name;
      _emailController.text = _editedAluno.email;
      _phoneController.text = _editedAluno.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedAluno.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedAluno.name != null && _editedAluno.name.isNotEmpty) {
              Navigator.pop(context, _editedAluno);
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
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedAluno.img != null
                          ? FileImage(File(_editedAluno.img))
                          : AssetImage("images/person.png"),
                    ),
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editedAluno.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdit = true;
                  setState(() {
                    _editedAluno.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdit = true;
                  _editedAluno.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _userEdit = true;

                  _editedAluno.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),


              Padding(padding: EdgeInsets.all(10.00)),
              DropdownSearch<Classe>(
                label: _editedAluno.className!=null ? _editedAluno.className: "Escolha a Classe",
                items: listaClasses,
                //onFind: (String filter) => getData(filter),
                itemAsString: (Classe u) => u.nameClass,
                onChanged: (Classe data) {
                  _editedAluno.className=data.nameClass;
                  _editedAluno.classId=data.idClass;
                  print(_editedAluno.toString());
                },

              ),
              Padding(padding: EdgeInsets.all(10.00)),
              DropdownSearch<String>(
                label: _editedAluno.funcao!=null ? _editedAluno.funcao: "Escolha a Funcão",
                items: helper.getFuncoes(),

                onChanged: (data) {
                  _editedAluno.funcao=data.toString();

                  print(_editedAluno.toString());

                },
                //onFind: (String filter) => getData(filter),



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

  void _getAllClasses() {
    helper.getAllClasse().then((list) {
      setState(() {
        listaClasses = list;

      });
    });
  }

  void showClasses(){
    SelectDialog.showModal<Classe>(

      context,
      alwaysShowScrollBar: true,
      label: "Classes",
      searchHint: "Escolha uma classe para este aluno",
      items: listaClasses,
      itemBuilder: (context, item, isSelected) => ListTile(title: Text(item.nameClass),),

      onChange: (Classe selected) {
        setState(() {
          _editedAluno.classId = selected.idClass;
          _editedAluno.className=selected.nameClass;
          print(_editedAluno.toString());
        });
      },

    );
  }
}
