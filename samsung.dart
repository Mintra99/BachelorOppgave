import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'moblist.dart';
class Samsung extends StatefulWidget{
  @override
  SamsungState createState() => SamsungState();
  }

  class SamsungState extends State<Samsung>{
  var mobilelist=[
    {
    'name' : '20 Ultra',
    'camera': '5 giga',
    'cpu': '8',
    'battary': '10 timer',
    'price' : 'price 1200 \$',
      'memory': '32Gb/64Gb',
    },
    {
      'name' : '20 pro max',
      'camera': '5 giga',
      'cpu': '8',
      'battary': '13 timer',
      'price' : 'price 1300 \$',
      'memory': '32Gb/64Gb',
    },
    {
      'name' : '666 pro max',
      'camera': '5 giga',
      'cpu': '8',
      'battary': '13 timer',
      'price' : 'price 1300 \$',
      'memory': '32Gb/64Gb',
    }
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title:Text('Samsung'),
      centerTitle: true,
    ),
        body: ListView.builder(
          itemCount: mobilelist.length,
          itemBuilder: (context,i){
            return MobList(battary: mobilelist[i]['battary'],camera: mobilelist[i]['camera'],cpu: mobilelist[i]['cpu'],memory: mobilelist[i]['memory'],name:mobilelist[i]['name'],price: mobilelist[i]['price'],);
        } ,
        )

    );

  }

}

