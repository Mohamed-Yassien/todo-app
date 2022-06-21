import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../shared/cubit/states.dart';
import '../shared/widgets/reusable_text_field.dart';

class HomeBottomBar extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                          (context) => Container(
                            color: Colors.grey[100],
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ReusableTextField(
                                    controller: titleController,
                                    prefixIcon: Icons.title,
                                    textLabel: 'Task Title',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'task title must not be empty';
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ReusableTextField(
                                    controller: timeController,
                                    prefixIcon: Icons.watch_later_outlined,
                                    textLabel: 'Task time',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'task time must not be empty';
                                      }
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          timeController.text =
                                              value.format(context).toString();
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ReusableTextField(
                                    controller: dateController,
                                    prefixIcon: Icons.calendar_today,
                                    textLabel: 'Task date',
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'task date must not be empty';
                                      }
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse(
                                          '2023-09-20',
                                        ),
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Icon(
                  cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 30,
                selectedFontSize: 15,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.menu_open_outlined,
                      ),
                      label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check,
                      ),
                      label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive,
                      ),
                      label: 'Archived'),
                ],
              ),
              body: cubit.screens[cubit.currentIndex]);
        },
      ),
    );
  }
}
