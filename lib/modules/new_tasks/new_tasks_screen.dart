import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/Cubit/AppStates.dart';
import 'package:todo_app/shared/component/components.dart';
import 'package:todo_app/shared/Cubit/AppCubit.dart';

class NewTaskesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        List tasksNew = AppCubit.getAppCubitObject(context).dataTasksNew;
        AppCubit appCubitObject = AppCubit.getAppCubitObject(context);

        return ConditionalBuilder(
          condition: tasksNew.length>0,
          builder: (ctx){return ListView.builder(
            itemBuilder: (context, index) {
              return itemTasks(tasksNew[index]['time'], tasksNew[index]['title'],
                  tasksNew[index]['date'],tasksNew[index]["status"] ,() {
                    appCubitObject.updateData("done", tasksNew[index]["id"]);
                  }, () {
                    appCubitObject.updateData("archive", tasksNew[index]["id"]);
                  },tasksNew[index]["id"],(){
                    appCubitObject.deleteData(tasksNew[index]["id"]);
                  }
              );
            },
            itemCount: tasksNew.length,
          );},
          fallback: (ctx){return Center(child: CircularProgressIndicator());},

        );
      },
    );
  }
}
