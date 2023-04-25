import 'package:flutter/material.dart';
import 'package:flutterproj/modules/to-do%20app/cubit/cubit.dart';

Widget taskItemBuilder(Map model, context) => Dismissible(
      background: Container(
        color: Colors.blue[200],
      ),
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        TasksCubit.get(context).deleteFromDataBase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text("${model['time']}"),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model['date']} ",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () {
                    TasksCubit cubitobj = TasksCubit.get(context);

                    cubitobj.updateDatabase(status: 'done', id: model['id']);
                  },
                  icon: const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    TasksCubit cubitobj = TasksCubit.get(context);

                    cubitobj.updateDatabase(
                        status: 'archieve', id: model['id']);
                  },
                  icon: const Icon(
                    Icons.archive,
                    color: Colors.black45,
                  ))
            ],
          ),
        ),
      ),
    );
