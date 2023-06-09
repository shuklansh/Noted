import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taker/main.dart';

class DetailedScreen extends StatefulWidget {
  //const DetailedScreen({Key? key}) : super(key: key);
  String heading;
  String Content;
  DetailedScreen(this.heading,this.Content);

  @override
  State<DetailedScreen> createState() => _DetailedScreenState(this.heading,this.Content);
}

class _DetailedScreenState extends State<DetailedScreen> {

  String contentString;
  String headingString;

  _DetailedScreenState(this.headingString,this.contentString);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(headingString,style: TextStyle(fontSize: 24,letterSpacing: 1,fontWeight: FontWeight.w300),),
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: ()=>
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp())),
          ),
        ),
        backgroundColor: Color.fromRGBO(30, 30, 30, 1.0),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Text(headingString,style: TextStyle(fontSize: 40,color: Colors.purpleAccent),),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.78,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(contentString,style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 1.2)),
                      ),
                    ))
              ],
            ),
          ),

        ),
      ),
    );
  }
}
