import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproj/modules/to-do%20app/Tasks/Tasks.dart';
import 'package:flutterproj/modules/to-do%20app/cubit/cubit.dart';
import 'package:flutterproj/modules/to-do%20app/cubit/states.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Home_Layout extends StatelessWidget {
  List<String> titles = [
    'New Tasks ',
    'Done Tasks ',
    'Archieved Tasks ',
  ];

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()..createDatabse(),
      child: BlocConsumer<TasksCubit, TasksStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TasksCubit cubitobj = TasksCubit.get(context);

          return Scaffold(
            key: cubitobj.scaffoldKey,
            appBar: AppBar(
              title: Text(titles[cubitobj.currentIndex]),
            ),
            body: Column(
              children: [
                cubitobj.Screens[cubitobj.currentIndex],

                // (tasks.length==0) ?  CircularProgressIndicator() :cubitobj.Screens[cubitobj.currentIndex]  ,
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubitobj.isBottomSheetShown == true &&
                    cubitobj.formKey.currentState!.validate()) {
                  cubitobj
                      .insertIntoDatabase(
                          cubitobj.titleController.text,
                          cubitobj.timeController.text,
                          cubitobj.dateController.text)
                      .then((value) {
                    if (cubitobj.formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      cubitobj.changIcon(isShow: false, Icon: Icons.edit);
                      cubitobj.titleController.text = " ";
                      cubitobj.timeController.text = " ";
                      cubitobj.dateController.text = " ";
                    }
                  });
                  // cubitobj.insertIntoDatabase(cubitobj.titleController.text, cubitobj.timeController.text, cubitobj.dateController.text);
                  // Navigator.pop(context) ;
                  // cubitobj.changIcon(isShow: false, Icon: Icons.edit);
                  // cubitobj.titleController.text = " "  ;
                  // cubitobj.timeController.text = " "  ;
                  // cubitobj.dateController.text = " "  ;
                } else {
                  cubitobj.scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Container(
                          color: Colors.grey[100],
                          child: Form(
                            key: cubitobj.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: cubitobj.titleController,
                                  onTap: () {
                                    print("Tilte Tapped ");
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title Must not be Empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Task Title ",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: cubitobj.timeController,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubitobj.timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time Must not be Empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Task Time ",
                                    border: OutlineInputBorder(),
                                    prefixIcon:
                                        Icon(Icons.watch_later_outlined),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: cubitobj.dateController,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-12-03'),
                                    ).then((value) {
                                      if (value != null) {
                                        cubitobj.dateController.text =
                                            DateFormat.yMMMMd()
                                                .format(value!)
                                                .toString();
                                      }
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date Must not be Empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Task Date ",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_month),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubitobj.changIcon(isShow: false, Icon: Icons.edit);
                      });
                  cubitobj.changIcon(isShow: true, Icon: Icons.add);
                }
              },
              child: Icon(cubitobj.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubitobj.ChangeIndex(index);
              },
              currentIndex: cubitobj.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archieved"),
              ],
            ),
          );
        },
      ),
    );
  }
}
