import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/Cubit/AppStates.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit getAppCubitObject(context) {
    return BlocProvider.of(context);
  }

  int indexScreen = 0;
  List<BottomNavigationBarItem> listBottomNavigationBarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Taskes"),
    BottomNavigationBarItem(icon: Icon(Icons.done_all), label: "Done"),
    BottomNavigationBarItem(icon: Icon(Icons.archive), label: "archive"),
  ];
  List<Widget> screens = [
    new NewTaskesScreen(),
    new DoneTasksScreen(),
    new ArchiveTasksScreen(),
  ];
  void changIndex(int indexItem) {
    indexScreen = indexItem;
    emit(GetIndexItemBottomNavigationBar());
  }

  bool bottomSheet_IsOpen = false;
  void cahengBottomSheetIsOpen(bool value) {
    bottomSheet_IsOpen = value;
    emit(ChangeBottomSheetIsOpenState());
  }

  late Database database;
  List<Map> dataTasksNew = [];
  List<Map> dataTasksDone = [];
  List<Map> dataTasksArchived = [];


  /*Create DataBase*/
  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (databaseObject, version) {
      print("database created");
      databaseObject
          .execute(
              'Create Table tasks(id Integer primary key, title Text,time Text,date Text,status Text)')
          .then((value) {
        print("Table Craated");
      }).catchError((error) {
        print("Error When Creating Table ${error.toString()}");
      });
    }, onOpen: (databaseObject) {
     getDataFromDatabase(databaseObject);
      print("database opened");
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  /*Insert To DataBase*/
  Future insertToDataBase(String title, String time, String date) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,status) VALUES("${title}", "${time}","${date}","new")')
          .then((value) {
        print("inserted successfully ${value}");
        emit(InsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("Error When Inserting New Record: ${error.toString()}");
      });
    });
  }
  
  /*Update Data in Database*/
  void updateData(String newStatus,int id)async{
     database.rawUpdate(
        "UPDATE tasks SET status = ? WHERE id = ?",
        ["$newStatus",id]).then((value){
          print("Value: $value");
          emit(UpdateFromDatabaseState());
          getDataFromDatabase(database);

     });
  }
  /*Delete Data From Database*/
  void deleteData(int id)async{
    database.rawDelete(
        "DELETE FROM tasks WHERE id = ?",
        [id]).then((value){
      print("Value: $value");
      emit(DeleteDataFromDatabaseState());
      getDataFromDatabase(database);

    });
  }

  /*Get Data From Database*/
  void getDataFromDatabase(Database db)  {
    dataTasksNew.clear();
    dataTasksArchived.clear();
    dataTasksDone.clear();
    db.rawQuery('select * from tasks').then((value){
      value.forEach((element) {
        if(element["status"]=="new"){
          dataTasksNew.add(element);
        }else if(element["status"]=="done"){
          dataTasksDone.add(element);
        }else{
          dataTasksArchived.add(element);
        }
      });
      emit(GetDataFromDatabaseState());
    });
  }
}
