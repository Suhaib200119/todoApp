import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/Cubit/AppCubit.dart';
import 'package:todo_app/shared/Cubit/AppStates.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController tec_title = new TextEditingController();
  TextEditingController tec_date = new TextEditingController();
  TextEditingController tec_time = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AppCubit()..createDataBase();
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit appCubitObject = AppCubit.getAppCubitObject(context);

          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                    "${appCubitObject.listBottomNavigationBarItem[appCubitObject.indexScreen].label.toString()} Screen"),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (appCubitObject.bottomSheet_IsOpen) {
                    if (formKey.currentState!.validate()) {
                      appCubitObject.insertToDataBase(
                              tec_title.text.toString(),
                              tec_time.text.toString(),
                              tec_date.text.toString()
                      ).then((value){
                        Navigator.pop(context);
                        appCubitObject.cahengBottomSheetIsOpen(false);
                      });
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet((context) {
                          return Form(
                            key: formKey,
                            child: Container(
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: tec_title,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "You must enter the title";
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Task Title",
                                      prefixIcon: Icon(Icons.title),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      controller: tec_time,
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return "You must enter the time";
                                        }
                                      },
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText: "Task Time",
                                        prefixIcon: Icon(Icons.watch_later),
                                        border: OutlineInputBorder(),
                                      ),
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          tec_time.text =
                                              value!.format(context).toString();
                                        });
                                      }),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: tec_date,
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "You must enter the date";
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Task Date",
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2022-05-05"),
                                      ).then((value) {
                                        String dateTimeUser =
                                            value.toString().substring(0, 10);
                                        tec_date.text = dateTimeUser;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {

                      appCubitObject.cahengBottomSheetIsOpen(false);
                        });
                    appCubitObject.cahengBottomSheetIsOpen(true);
                  }
                },
                child: appCubitObject.bottomSheet_IsOpen ? Icon(Icons.add) : Icon(Icons.edit),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: appCubitObject.indexScreen,
                onTap: (int indexItem) {
                  appCubitObject.changIndex(indexItem);
                },
                items: appCubitObject.listBottomNavigationBarItem,
              ),
              body:appCubitObject.screens[appCubitObject.indexScreen],
          );
        },
      ),
    );
  }


}
