import 'package:flutter/material.dart';
import './mydrawer.dart';

class Sections extends StatefulWidget{
  @override
  SectionsState createState() => SectionsState();

}
class SectionsState extends State<Sections>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Sections"),
        centerTitle: true,
      ),
      endDrawer:Mydrawer(),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: <Widget>[
         InkWell(child:Card(child:Column(children: <Widget>[
           Expanded(child: Image.asset('images/samsung.jpg', fit:BoxFit.cover,),),
           Container(child: Text("Samsung", style:TextStyle(fontSize: 18)))
         ],)),onTap: (){
           Navigator.of(context).pushNamed('Samsung');
         },),
          InkWell(child:Card(child:Column(children: <Widget>[
            Expanded(child: Image.asset('images/samsung.jpg', fit:BoxFit.cover,),),
            Container(child: Text("Samsung", style:TextStyle(fontSize: 18)))
          ],)),onTap: (){},),
          InkWell(child:Card(child:Column(children: <Widget>[
            Expanded(child: Image.asset('images/samsung.jpg', fit:BoxFit.cover,),),
            Container(child: Text("Samsung", style:TextStyle(fontSize: 18)))
          ],)),onTap: (){},),
          InkWell(child:Card(child:Column(children: <Widget>[
            Expanded(child: Image.asset('images/samsung.jpg', fit:BoxFit.cover,),),
            Container(child: Text("Samsung", style:TextStyle(fontSize: 18)))
          ],)),onTap: (){},),
        ],
      )
    );
  }

}