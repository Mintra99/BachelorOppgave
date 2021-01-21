import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MobList extends StatelessWidget{
  final name;
  final camera ;
  final cpu ;
  final price ;
  final battary ;
  final memory ;
  MobList({this.price, this.memory, this.cpu , this.name , this.battary, this.camera});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:Container(
        height: 160,
        width: 100,
        child:Card(
            child: Row(children: <Widget> [
              Expanded(flex:1 ,child: Image.asset('images/image.jpg'),),
              Expanded(flex:2 ,child:Container(alignment: Alignment.topCenter,height:160,child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Container(
                    margin:
                    EdgeInsets.only(top:10,bottom: 10),
                    child: Text(name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center),
                  ),
                  Row(
                    children: [
                      Expanded( child: Row(children: [Text('Camera', style: TextStyle(color: Colors.grey)),Text(camera,style:TextStyle(color: Colors.blue) ,)])  ),
                    ],),
                  Row(
                    children: [
                      Expanded(child: Row(children: [Text('cpu', style: TextStyle(color: Colors.grey)),Text(cpu,style:TextStyle(color: Colors.blue) ,)]) ),
                    ],),
                  Row(
                    children: [
                      Expanded(child: Row(children: [Text('battery', style: TextStyle(color: Colors.grey)),Text(battary,style:TextStyle(color: Colors.blue) ,)]) ),
                      Row(children: [Text('memory', style: TextStyle(color: Colors.grey)),Text(battary,style:TextStyle(color: Colors.blue) ,),]) ,
                    ],),

                  Row(
                    children: [
                      Expanded(child: Row(children: [Text('price', style: TextStyle(color: Colors.grey)),Text(price,style:TextStyle(color: Colors.blue) ,)]) ),
                    ],),

                ],)) ),
            ],)
        ),),
      onTap: () {
        Navigator.of(context).pushNamed('mobiledetails');
      },);
  }

}
