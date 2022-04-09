import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app3/ScreenDone.dart';
import 'package:flutter_app3/ScreenTasks.dart';
import 'package:flutter_app3/components/components.dart';
import 'package:flutter_app3/cubit/appCubit.dart';
import 'package:flutter_app3/cubit/stateCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'components/constants.dart';

class Home extends StatelessWidget {

  TextEditingController date = new TextEditingController();
  TextEditingController title = new TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appCubit()..createDatabase(),
      child: BlocConsumer<appCubit, stateCubit>(
        listener: (context, state) {},
        builder: (context, state) {
          appCubit cubit = appCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  'To Do'
              ),
              centerTitle: true,
            ),
            body: cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              mini: true,
              child: Icon(
                Icons.add,
              ),
              onPressed: (){
                if(cubit.bottomsheet){
                    if(formKey.currentState!.validate()){
                      cubit.insertRaw(title: title.text, date: date.text);
                      title.text = '';
                      date.text = '';
                      cubit.bottomsheet = false;
                      Navigator.pop(context);
                    }
                  }
                else {
                    cubit.bottomsheet = true;
                    scaffoldKey.currentState!.showBottomSheet(
                          (context) =>
                          Container(
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15,),
                                    defaultForm(
                                      text: 'Title',
                                      controller: title,
                                      validate: (va){
                                        if(va!.isEmpty){
                                          return "title can't must be empty";
                                        }
                                      },
                                      function: (val) {
                                        formKey.currentState!.validate();
                                      },
                                      icon: Icon(
                                        Icons.title,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultForm(
                                      text: 'Date',
                                      read: true,
                                      controller: date,
                                      type: TextInputType.datetime,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2025-05-30'),
                                        ).then((value) {
                                          date.text = DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      validate: (va){
                                        if(va!.isEmpty){
                                          return "date can't must be empty";
                                        }
                                      },
                                      function: (val) {
                                        formKey.currentState!.validate();
                                      },
                                      icon: Icon(
                                        Icons.date_range,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                      backgroundColor: Colors.grey[300],
                      elevation: 40,
                    ).closed.then((value){
                      cubit.bottomsheet = false;
                    });
                  }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottomSheet(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_rounded,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle,
                  ),
                  label: 'Done',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


