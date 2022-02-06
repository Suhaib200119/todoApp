import 'package:flutter/material.dart';

Widget defualtTextFormFiled({
  required TextEditingController textEditingController,
  required FormFieldValidator formFieldValidator,
  required TextInputType textInputType,
  required String labelText,
  required IconData prefixIcon,
  Function? onTap,
}) {
  return TextFormField(
    controller: textEditingController,
    validator: formFieldValidator,
    keyboardType: textInputType,
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(),
    ),
    onTap: (){
      onTap!();
    },
  );
}

Widget itemTasks(
    String? time,
    String? title ,
    String? date,
    String? status,
    Function? functionDone,
    Function? functionArchived,
    int id,
    Function? onDis,
    ){
  return Dismissible(
    key: Key('$id'),
    direction: DismissDirection.startToEnd,
    onDismissed: (direction) {
      if(direction == DismissDirection.startToEnd) {
        return onDis!();
      }
    },
    child: Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: Text(
              '$time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("$title"),
              SizedBox(height: 10,),
              Text("$date"),
              SizedBox(height: 10,),
              Text("$status"),
            ],
          ),
          SizedBox(width: 20,),
          MaterialButton(onPressed: (){
            return functionDone!();
          },child: Text("DONE"),),
          SizedBox(width: 20,),
          MaterialButton(onPressed: (){
            return functionArchived!();
          },child: Text("Archived"),),

        ],
      ),
    ),
  );
}
