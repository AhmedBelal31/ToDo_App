import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproj/models/components/Components.dart';
import 'package:flutterproj/modules/to-do%20app/cubit/states.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Archieved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<TasksCubit, TasksStates>(
              listener: (context, state) {},
              builder: (context, state) {
                TasksCubit cubitobj = TasksCubit.get(context);
                var x = cubitobj.archieved_tasks;
                if (x.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.menu,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          "No Tasks Yet , Please Add Some Tasks ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  );
                } else {
                  return ListView.separated(
                      // shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => taskItemBuilder(
                          cubitobj.archieved_tasks[index], context),
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 20.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                      itemCount: cubitobj.archieved_tasks.length);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
