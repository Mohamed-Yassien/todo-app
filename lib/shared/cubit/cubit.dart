import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks_screen.dart';
import '../../modules/done_tasks_screen.dart';
import '../../modules/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarIndex());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      print('database created');
      await database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');
      }).catchError(
        (e) {
          print('error here!!');
        },
      );
    }, onOpen: (database) {
      emit(AppCreateDatabaseLoadingState());
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void updateDataBase({required String status, required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseLoadingState());
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database
        .transaction(
      (txn) => txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'),
    )
        .then(
      (value) {
        emit(AppInsertToDatabaseLoadingState());
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      },
    ).catchError(
      (error) => print('error occurred : $error'),
    );
  }

  deleteFromDataBase({required int id}) {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseLoadingState());
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    await database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach(
          (element) {
            if (element['status'] == 'new') {
              newTasks.add(element);
            } else if (element['status'] == 'done') {
              doneTasks.add(element);
            } else {
              archivedTasks.add(element);
            }
            print(element['status']);
          },
        );
        emit(AppGetDatabaseLoadingState());
        emit(AppGetDatabaseState());
      },
    ).catchError(
      (error) => print('error : $error'),
    );
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetSheetState());
  }
}
