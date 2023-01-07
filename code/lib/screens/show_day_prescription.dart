import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensa/screens/assign_day.dart';
import 'package:dispensa/screens/dispense.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'assign_medicine.dart';



class ShowDayPrescription extends StatefulWidget {
 const ShowDayPrescription({required this.documentId});

  
  final String documentId;

  @override
  State<ShowDayPrescription> createState() => _ShowDayPrescriptionState();
}

class _ShowDayPrescriptionState extends State<ShowDayPrescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Patients').doc(widget.documentId).collection('Day').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasError){
                  return Center(child: Text('Some error ocurred ${snapshot.error}'));
                }

                if(snapshot.hasData){
                  QuerySnapshot data = snapshot.data;
                  List<QueryDocumentSnapshot> documents = data.docs;
                  List<Map> items = documents.map((e) => {
                    
                    'Dose': e['Dose']
                  }).toList();

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = snapshot.data!.docs[index];
                      String docId = user.id;
                      Map thisItem = items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(docId.toString()),
                          subtitle: Text(thisItem['Dose'].toString()),
                          
                        
                         ),
                      );
                    }
                    );
                    
               }

                return Center(child: CircularProgressIndicator());
              },
            ),
             ElevatedButton(child: Text('Dispense'),
                    onPressed: (){
                      Navigator.push(context, new MaterialPageRoute
                                    (builder: (context) => Dispense(

                                    )));
                    },)
          ],
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute
                                    (builder: (context) => AssignDay(
                                       documentId: widget.documentId 
                                    )));
          },
              tooltip: 'Increment',
          child: Icon(Icons.add)),
          
    );
  }
}