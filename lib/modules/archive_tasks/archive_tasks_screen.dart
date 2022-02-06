import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/Cubit/AppCubit.dart';
import 'package:todo_app/shared/Cubit/AppStates.dart';
import 'package:todo_app/shared/component/components.dart';

class ArchiveTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        List tasksArchive = AppCubit.getAppCubitObject(context).dataTasksArchived;
        AppCubit appCubitObject = AppCubit.getAppCubitObject(context);
        return ConditionalBuilder(
            condition: tasksArchive.length>0,
            builder: (ctx){return ListView.builder(
              itemBuilder: (context, index) {
                return itemTasks(tasksArchive[index]['time'], tasksArchive[index]['title'],
                    tasksArchive[index]['date'],tasksArchive[index]["status"] ,() {
                      appCubitObject.updateData("done", tasksArchive[index]["id"]);
                    }, () {
                      appCubitObject.updateData("archive", tasksArchive[index]["id"]);
                    },tasksArchive[index]["id"],(){
                      appCubitObject.deleteData(tasksArchive[index]["id"]);
                    }
                );
              },
              itemCount: tasksArchive.length,
            );},
            fallback: (ctx){return Center(child: CircularProgressIndicator());}
        );

      },
    );
  }
}
