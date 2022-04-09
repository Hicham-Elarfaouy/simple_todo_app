import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app3/ScreenDone.dart';
import 'package:flutter_app3/ScreenTasks.dart';
import 'package:flutter_app3/cubit/stateCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class appCubit extends Cubit<stateCubit>{

  appCubit() : super(stateInitiale());

  static appCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<Map> tasks = [];
  List<Map> tasksDone = [];

  int currentIndex = 0;
  bool bottomsheet = false;

  List<Widget> screen = [
    ScreenTasks(),
    ScreenDone(),
  ];

  void changeBottomSheet(index){
    currentIndex = index;
    emit(stateBottomSheetChange());
  }

  void createDatabase () async {
    database = await openDatabase(
      'todo5.db',
      version: 1,
      onCreate: (database , version) async {
        print('db created');
        await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,state TEXT)');
      },
      onOpen: (database){
        getTasks(database).then((value) {
          tasks = value;
        });
        getDoneTasks(database).then((value) {
          tasksDone = value;
        });
        emit(stateGetTasks());
        print('db opened');
      },
    );
  }

  insertRaw ({
    required String title,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn.rawInsert('INSERT INTO tasks(title,date,state) VALUES ("$title","$date","new")').then((value) {
        print('$value raw inserted');
        emit(stateInsertTasks());

        getTasks(database).then((value) {
          tasks = value;
          emit(stateGetTasks());
        });
      });
    });
  }

  Future<List<Map>> getTasks (database) async {
    return await database.rawQuery('SELECT * FROM tasks  WHERE state = ?',['new']);
  }
  Future<List<Map>> getDoneTasks (database) async {
    return await database.rawQuery('SELECT * FROM tasks  WHERE state = ?',['done']);
  }

  void updateData({required String state,required int id}) async {
    await database.rawUpdate(
        'UPDATE tasks SET state = ? WHERE id = ?',
        ['$state',id]);
    getTasks(database).then((value) {
      tasks = value;
      emit(stateGetTasks());
    });
    getDoneTasks(database).then((value) {
      tasksDone = value;
      emit(stateGetTasks());
    });
    emit(stateUpdateTasks());
  }

  void deleteData({required int id}) async {
    await database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]);
    getTasks(database).then((value) {
      tasks = value;
      emit(stateGetTasks());
    });
    getDoneTasks(database).then((value) {
      tasksDone = value;
      emit(stateGetTasks());
    });
    emit(stateDeleteTasks());
  }

}