import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../../mydrawer.dart';
class Home extends StatefulWidget{
  State<StatefulWidget> createState(){
    return HomeState();
  }
}
class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Fake news"),
          backgroundColor: Colors.red,
          actions: <Widget>[

          ],
          centerTitle: true,
          elevation: 20,
          leading: IconButton(icon: Icon(Icons.security), onPressed: null),
          brightness: Brightness.dark,
        ),
        endDrawer: Mydrawer() ,
        body: ListView(
          children:<Widget>[
            Container(
              height: 150.0,
              width: double.infinity,
              child: Carousel(
                images: [
                  AssetImage('images/fakenews1.jpg'),
                  AssetImage('images/fakenews2.jpg'),

                ],
                dotSize: 8,
                dotIncreaseSize: 2,
                dotSpacing: 20,
                dotColor:Colors.white ,
                dotBgColor: Colors.black.withOpacity(0.5),
                boxFit: BoxFit.cover,
                dotIncreasedColor: Colors.blue,
                // borderRadius: true,
                // radius : Radius.circular(300),
              ),
            ),
            // End Carousel
            Container(padding: EdgeInsets.all(10),child: Text("Sections", style: TextStyle(fontSize: 30,color:Colors.blue), ),),

            // Start container
            Container(height:60, child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                    height: 100,
                    width: 100,
                    child:ListTile(
                      title: Image.asset('images/fakenews1.jpg'),
                      subtitle: Container(child: Text("Samsung", textAlign: TextAlign.center,),),
                    )),
                Container(
                    height: 100,
                    width: 100,
                    child:ListTile(
                      title: Image.asset('images/fakenews1.jpg'),
                      subtitle: Container(child: Text("Samsung", textAlign: TextAlign.center,),),
                    )),
                Container(
                    height: 100,
                    width: 100,
                    child:ListTile(
                      title: Image.asset('images/fakenews1.jpg'),
                      subtitle: Container(child: Text("Samsung", textAlign: TextAlign.center,),),
                    )),
                Container(
                    height: 100,
                    width: 100,
                    child:ListTile(
                      title: Image.asset('images/fakenews1.jpg'),
                      subtitle: Container(child: Text("Samsung", textAlign: TextAlign.center,),),
                    )),
                Container(
                    height: 100,
                    width: 100,
                    child:ListTile(
                      title: Image.asset('images/fakenews1.jpg'),
                      subtitle: Container(child: Text("Samsung", textAlign: TextAlign.center,),),
                    )),
                //End Containers
              ],),),
            Container(padding: EdgeInsets.all(10),child: Text("new products", style: TextStyle(fontSize: 30,color:Colors.blue), ),),
            // Start new products
            Container(height: 285, child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                InkWell(child:GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),
                InkWell(child:GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),
                InkWell(child:GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),
                InkWell(child: GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),
                InkWell(child:GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),
                InkWell(child:GridTile(child: Image.asset('images/image.jpg'),
                    footer:Container(height: 20,color: Colors.black.withOpacity(0.5), child:Text('Note 20 Ultra',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w700), textAlign: TextAlign.center,))),onTap:(){},),

              ],



            ),)
            //End new products
          ],)
    );

  }
  
}
