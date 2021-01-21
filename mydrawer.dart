import 'package:flutter/material.dart';

class Mydrawer  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(accountName: Text("karam yanes"),
              accountEmail: Text("karamyanes@hotmail.com"),
              currentAccountPicture: CircleAvatar(child:Icon(Icons.person)),
              decoration: BoxDecoration(
                  color: Colors.blue),
            ),
            ListTile(
              title:Text("HomePage", style: TextStyle(color:Colors.black, fontSize: 18,)),
              leading: Icon(Icons.home, color: Colors.blue, size: 20,),
              onTap: (){ Navigator.of(context).pushNamed('HomePage');},

            ),

            ListTile(
              title:Text("Sections",style: TextStyle(color:Colors.black, fontSize: 18,)),
              leading:Icon(Icons.category, color: Colors.blue, size: 20,),
              onTap: () {
                Navigator.of(context).pushNamed('sections');
              },
            ),
            Divider(color: Colors.yellow, thickness: 2,),
            ListTile(
              title:Text("log in", style: TextStyle(color:Colors.black, fontSize: 18,)),
              leading: Icon(Icons.home, color: Colors.blue, size: 20,),
              onTap: (){
                Navigator.of(context).pushNamed("login");
              },
            ),
            ListTile(
              title:Text("setting", style: TextStyle(color:Colors.black, fontSize: 18,)),
              leading: Icon(Icons.home, color: Colors.blue, size: 20,),
              onTap: (){},
            ),
            ListTile(
              title:Text("about us", style: TextStyle(color:Colors.black, fontSize: 18,)),
              leading: Icon(Icons.home, color: Colors.blue, size: 20,),
              onTap: (){},
            ),
          ],));
  }
}