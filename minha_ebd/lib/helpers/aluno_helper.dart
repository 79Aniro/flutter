import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String alunoTable = "alunoTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";
final String classIdColumn = "classIdColumn";
final String classNameColumn = "classNameColumn";

final String classeTable = "classeTable";
final String idClassColumn = "idClassColumn";
final String nameClassColumn = "nameClassColumn";
final String funcaoColumn="funcaoColumn";

class AlunoHelper {

  static final AlunoHelper _instance = AlunoHelper.internal();

  factory AlunoHelper() => _instance;

  AlunoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "alunosnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $classeTable($idClassColumn INTEGER PRIMARY KEY, $nameClassColumn TEXT)");
      await db.execute(
          "CREATE TABLE $alunoTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT,$classIdColumn INTEGER,$classNameColumn TEXT,$funcaoColumn TEXT, FOREIGN KEY (classIdColumn) REFERENCES Classe (id) ON DELETE NO ACTION ON UPDATE NO ACTION)",

      );
    });
  }

  Future<Aluno> saveAluno(Aluno aluno) async {
    print(aluno.toString());
    Database dbAluno = await db;
    aluno.id = await dbAluno.insert(alunoTable, aluno.toMap());
    return aluno;
  }

  Future<Classe> saveClasse(Classe classe) async {
    print(classe.toString());
    Database dbAluno = await db;
    classe.idClass = await dbAluno.insert(classeTable, classe.toMap());
    return classe;
  }

  Future<Aluno> getAluno(int id) async {
    print("entrou "+id.toString());
    Database dbAluno = await db;
    List<Map> maps = await dbAluno.query(alunoTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Aluno.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future <List> getClasseAlunos(int id) async {
    print("Aqui"+id.toString());
     Database dbAluno = await db;
    List listMap = await dbAluno.rawQuery("SELECT * FROM $alunoTable");
    List<Aluno> listAluno = List();
    for(Map m in listMap){
      listAluno.add(Aluno.fromMap(m));
    }



    List<Aluno> alunosClasse= List();
    if(listAluno!=null){
      for(Aluno a in listAluno){
        if(a.classId==id){
          alunosClasse.add(a);
        }
      }
      return alunosClasse;
    }
    else{
      return [];
    }





  }

  Future<Classe> getClasse(int id) async {
    Database dbAluno = await db;
    List<Map> maps = await dbAluno.query(classeTable,
        columns: [idClassColumn, nameClassColumn],
        where: "$idClassColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Classe.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteAluno(int id) async {
    Database dbAluno = await db;
    return await dbAluno.delete(alunoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> deleteClasse(int id) async {
    Database dbAluno = await db;
    return await dbAluno.delete(classeTable, where: "$idClassColumn = ?", whereArgs: [id]);
  }

  Future<int> updateAluno(Aluno aluno) async {
    Database dbAluno = await db;
    return await dbAluno.update(alunoTable,
        aluno.toMap(),
        where: "$idColumn = ?",
        whereArgs: [aluno.id]);
  }

  Future<int> updateClasse(Classe classe) async {
    Database dbAluno = await db;
    return await dbAluno.update(classeTable,
        classe.toMap(),
        where: "$idClassColumn = ?",
        whereArgs: [classe.idClass]);
  }

  Future<List> getAllAlunos() async {
    Database dbAluno = await db;
    List listMap = await dbAluno.rawQuery("SELECT * FROM $alunoTable");
    List<Aluno> listAluno = List();
    for(Map m in listMap){
      listAluno.add(Aluno.fromMap(m));
    }
    return listAluno;
  }

  Future<List> getAllClasse() async {
    Database dbAluno = await db;
    List listMap = await dbAluno.rawQuery("SELECT * FROM $classeTable");
    List<Classe> listClasse = List();
    for(Map m in listMap){
      listClasse.add(Classe.fromMap(m));
    }
    return listClasse;
  }

  Future<int> getNumber() async {
    Database dbAluno = await db;
    return Sqflite.firstIntValue(await dbAluno.rawQuery("SELECT COUNT(*) FROM $alunoTable"));
  }

  Future<int> getNumberClasse() async {
    Database dbAluno = await db;
    return Sqflite.firstIntValue(await dbAluno.rawQuery("SELECT COUNT(*) FROM $classeTable"));
  }

  Future close() async {
    Database dbAluno = await db;
    dbAluno.close();
  }
  
  getFuncoes(){
    List<String>lista= List();
    lista.add("Aluno");
    lista.add("Superintendente");
    lista.add("Secretário");
    lista.add("Professor");
    return lista;
  }

}

class Aluno {



  int id;
  int classId;
  String name;
  String email;
  String phone;
  String img;
  String className;
  String funcao;


  Aluno();

  Aluno.fromMap(Map map){
    id = map[idColumn];
    classId=map[classIdColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
    classId=map[classIdColumn];
    className=map[classNameColumn];
    funcao=map[funcaoColumn];


  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
      classIdColumn:classId,
      classNameColumn:className,
      funcaoColumn:funcao

    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Aluno{id: $id, classId: $classId, name: $name, email: $email, phone: $phone, img: $img, className: $className, funcao: $funcao}';
  }
}

class Classe{

  int idClass;
  String nameClass;

  Classe();

  Classe.fromMap(Map map){
    idClass = map[idClassColumn];
    nameClass = map[nameClassColumn];


  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameClassColumn: nameClass,


    };
    if(idClass != null){
      map[idClassColumn] = idClass;
    }
    return map;
  }

  @override
  String toString() {
    return 'Classe{idClass: $idClass, nameClass: $nameClass}';
  }
}

class AlunoClasse{

  int id;
  int classId;
  String name;
  String email;
  String phone;
  String img;
  int idClass;
  String nameClass;
  AlunoClasse();

  AlunoClasse.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
    classId=map[classIdColumn];
    idClass = map[idClassColumn];
    nameClass = map[nameClassColumn];

  }




}


enum Funcoes{Aluno,Superintendente,Secretario}