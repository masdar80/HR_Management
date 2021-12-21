import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class httpTest extends StatefulWidget {
  @override
  _httpTestState createState() => _httpTestState();
}

class _httpTestState extends State<httpTest>  {
  Future getData()async
  {
   // var url="https://jsonplaceholder.typicode.com/posts";
    var url=Uri.parse('http://192.168.43.31:5000/patients');
    var response= await http.get(url);
    var responseBody= jsonDecode(response.body) ;
    return responseBody;
  }

  @override
  void initState() {

    getData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

           //   return Container(child: Text(snapshot.data[0]['title']));
              if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                    itemBuilder: (context,i){
                      return Container(child: Text(snapshot.data[i]['first_name']));
                    });

              }
              else{
                return CircularProgressIndicator();
              }

            },
          ),
      ),
    );
  }
}


