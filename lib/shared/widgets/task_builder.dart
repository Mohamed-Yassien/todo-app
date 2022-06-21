import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/widgets/reusable_task_item.dart';

Widget taskBuilder({required List<Map> tasks}) {
  return tasks.isEmpty
      ? const Center(
          child: Text(
            'No Tasks , Please Try Add Some Tasks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        )
      : ListView.separated(
          itemBuilder: (context, index) => ReusableTaskItem(tasks[index]),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsetsDirectional.only(
              start: 20,
            ),
          ),
          itemCount: tasks.length,
        );
}
