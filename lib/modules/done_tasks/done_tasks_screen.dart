import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/Cubit/AppCubit.dart';
import 'package:todo_app/shared/Cubit/AppStates.dart';
import 'package:todo_app/shared/component/components.dart';

class DoneTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        List tasksDone = AppCubit.getAppCubitObject(context).dataTasksDone;
        AppCubit appCubitObject = AppCubit.getAppCubitObject(context);
        return ConditionalBuilder(
            condition: tasksDone.length>0,
            builder: (ctx){return ListView.builder(
              itemBuilder: (context, index) {
                return itemTasks(tasksDone[index]['time'], tasksDone[index]['title'],
                    tasksDone[index]['date'],tasksDone[index]["status"] ,() {
                      appCubitObject.updateData("done", tasksDone[index]["id"]);
                    }, () {
                      appCubitObject.updateData("archive", tasksDone[index]["id"]);
                    },tasksDone[index]["id"],(){
                      appCubitObject.deleteData(tasksDone[index]["id"]);
                    }
                );
              },
              itemCount: tasksDone.length,
            );},
            fallback: (ctx){return Center(child: CircularProgressIndicator());}
        );
      },
    );
  }
}
