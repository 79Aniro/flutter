import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';


import 'package:url_launcher/url_launcher.dart';

import 'aluno_page.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AlunoHelper helper = AlunoHelper();
  List<Aluno> alunos = List();

  @override
  void initState() {
    super.initState();


    _getAllAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alunos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A a Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z a A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlunoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: alunos.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
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
                        alunos[index].className ?? "",
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Text(
                        alunos[index].funcao ?? "",
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
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          launch("tel:${alunos[index].phone}");
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showAlunoPage(aluno: alunos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            helper.deleteAluno(alunos[index].id);
                            alunos.removeAt(index);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _showAlunoPage({Aluno aluno}) async {
    final recAluno = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlunoPage(
              aluno: aluno,
            )));
    if (recAluno != null) {
      if (aluno != null) {
        await helper.updateAluno(recAluno);
      } else {
        await helper.saveAluno(recAluno);
      }
      _getAllAlunos();
    }
  }

  void _getAllAlunos() {
    helper.getAllAlunos().then((list) {
      setState(() {
        alunos = list;

      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        alunos.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        alunos.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
