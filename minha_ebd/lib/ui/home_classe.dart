

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minha_ebd/helpers/aluno_helper.dart';
import 'package:minha_ebd/ui/alunos_classe.dart';
import 'package:minha_ebd/ui/classe_page.dart';



enum OrderOptions { orderaz, orderza }

class HomeClassePage extends StatefulWidget {
  @override
  _HomeClasseState createState() => _HomeClasseState();
}

class _HomeClasseState extends State<HomeClassePage> {
  AlunoHelper helper = AlunoHelper();
  List<Classe> classes = List();

  @override
  void initState() {
    super.initState();


    _getAllClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes"),
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
          _showClassePage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: classes.length,
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

              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(

                        height: 44.0,
                        child: Text(
                          classes[index].nameClass ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
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
                          "Alunos",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showAlunosClasse(classe: classes[index]);
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
                          _showClassePage(classe: classes[index]);
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
                            helper.deleteClasse(classes[index].idClass);
                            classes.removeAt(index);
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

  void _showClassePage({Classe classe}) async {
    final recClasse = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClassePage(
              classe: classe,
            )));
    if (recClasse  != null) {
      if (classe != null) {
        await helper.updateClasse(recClasse);
      } else {
        await helper.saveClasse(recClasse);
      }
      _getAllClasses();
    }
  }

  void _showAlunosClasse({Classe classe}) async {
    final recClasse = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlunosClasse(
              classe: classe,
            )));
  if (recClasse  != null) {
     if (classe != null) {
       await helper.updateClasse(recClasse);
     } else {
      await helper.saveClasse(recClasse);
    }
     _getAllClasses();
   }
  }

  void _getAllClasses() {
    helper.getAllClasse().then((list) {
      setState(() {
        classes = list;


      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        classes.sort((a, b) {
          return a.nameClass.toLowerCase().compareTo(b.nameClass.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        classes.sort((a, b) {
          return b.nameClass.toLowerCase().compareTo(a.nameClass.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
