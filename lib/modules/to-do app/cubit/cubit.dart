import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproj/modules/to-do%20app/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../../shared/components/constant.dart';
import '../../layout/home_layout.dart';
import '../Archieved/Archieved.dart';
import '../DOne/Done.dart';
import '../Tasks/Tasks.dart';

class TasksCubit extends Cubit<TasksStates>
{
  TasksCubit():super(initialState()) ;

 static TasksCubit get(context)
   {
     return  BlocProvider.of(context);
   }

List<Map> new_tasks = [];
List<Map> done_tasks = [];
List<Map> archieved_tasks = [];
var scaffoldKey = GlobalKey<ScaffoldState>();
bool isBottomSheetShown = false;
IconData fabIcon = Icons.edit ;
var titleController =TextEditingController();
TextEditingController dateController =TextEditingController() ;
TextEditingController timeController  = TextEditingController();
var formKey =GlobalKey<FormState>();

int currentIndex = 0 ;
List<Widget> Screens =[
    Tasks() ,
    Done(),
    Archieved() ,
  ];



  void  ChangeIndex (int i)
   {
     currentIndex=i;
    emit(BottomNavState());
    print(currentIndex);
   }
   void changIcon({required bool isShow ,required IconData Icon} )
   {
     isBottomSheetShown =isShow ;
     fabIcon =Icon ;
     emit(ChangeIconState());
   }


  //Create DataBase
  void createDatabse() async
  {
    db =await openDatabase(
        'Todo0.db' ,
        version: 1 ,
        onCreate: (db,version) async
        {
          await db.execute('CREATE TABLE  tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {
            print("Database Created !");
          }).catchError((error){
            print("Error Happened ${error.toString()}");
          });
        } ,
        onOpen: (db)
        {
          print("Database Opened ");
          getdataFromDataBase(db);

        }


    );
    emit(CreateDatbaseState());

  }

  // Insert into DataBase

 insertIntoDatabase(@required String Title ,@required String Time ,@required String Date) async
  {
    return await db!.transaction((txn) async{
      await txn.rawInsert('INSERT INTO tasks(title ,time ,date , status ) Values("$Title","$Time","$Date" , "New")').then((value){
        print("${value} Row Inserted Successfuly ");
        emit(InsertDatbaseState());

        getdataFromDataBase(db);
      }).catchError((error){
        print("Error Happened ${error.toString()}");
      });

    });
  }

  void updateDatabase({
    required String status , required int id
  })
  {
      db?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {

          emit(UpdateDatbaseState());
          getdataFromDataBase(db);
      });


  }

void getdataFromDataBase(db)
  {
    db!.rawQuery('SELECT * FROM tasks').then((value) {
      new_tasks =[];
      done_tasks =[];
      archieved_tasks =[];

      value.forEach((element) {
       if(element['status']=='New')
         {
           new_tasks.add(element);
           //print(new_tasks);
         }
       else if(element['status']=='done')
         {
         done_tasks.add(element);
         print(done_tasks);
         }
       else if(element['status']=='archieve')
         {
           archieved_tasks.add(element);
           //print(archieved_tasks);
         }
      });
      emit(GetDatbaseState());
   

    });

  }

void deleteFromDataBase({required int id }) async
{
 await db?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  getdataFromDataBase(db);
  emit(DeleteDatbaseState());
}




}