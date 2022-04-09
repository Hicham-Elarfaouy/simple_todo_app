import 'package:flutter/material.dart';
import 'package:flutter_app3/Home.dart';
import 'package:flutter_app3/cubit/appCubit.dart';
import 'package:flutter_app3/cubit/stateCubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/constants.dart';

class ScreenDone extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, stateCubit>(
      listener: (context, state) {},
      builder: (context, state){
        List<Map> tasks = appCubit.get(context).tasksDone;
        return ListView.separated(
          itemBuilder: (context, index) => Dismissible(
            background: Card(
              color: Colors.red,
              child: Row(
                children: [
                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.white,)),
                ],
              ),
            ),
            key: Key(tasks[index]['id'].toString()),
            onDismissed: (direction){
              appCubit.get(context).deleteData(id: tasks[index]['id']);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tasks[index]['title']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tasks[index]['date']}',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        appCubit.get(context).updateData(state: 'new',id: tasks[index]['id']);
                      },
                      icon: Icon(Icons.check_box,color: Colors.green[400],),
                    ),
                  ],
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: tasks.length,
        );
      },
    );
  }
}