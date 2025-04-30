import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudapp/model/fetchdata.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void addStudent() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
          
           margin: const  EdgeInsets.fromLTRB(10, 10, 20, 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              
              
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                ),
                 TextField(
                  controller: _ageController,
                  
                  decoration:const  InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
                  ),
                ),
                 TextField(

                  controller: _emailController,
                  decoration: const  InputDecoration(
                    labelText: 'email',
                    hintText: 'Enter Your Email',
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),

                Row(
                 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     ElevatedButton(onPressed: () {}, child: const Text('Cancel')),

                       ElevatedButton(onPressed: () {

                        FirebaseFirestore.instance.collection('students').add(

                          {
                            'name': _nameController.text,
                            'age': _ageController.text,
                            'email': _emailController.text,
                          }
                        );
                        Navigator.pop(context);
                      }, 
                      child: const Text('Save')
                      )
                  ],
                )
              
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
      ),

      body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('students').snapshots(), builder: (context,snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return  const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||snapshot.data!.docs.isEmpty ){
          return  const Center(child: Text('Data not found'));
        }

        final students = snapshot.data!.docs
        .map((doc) => Students.fromJson(doc.data() as Map<String,dynamic>)).toList();

         return SingleChildScrollView(
        child:  Column(
              children: students.map((student) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('name: ${student.name}'),
                        Text('age: ${student.age}'),
                        Text('email: ${student.email}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
         );

      }),

      floatingActionButton: FloatingActionButton(onPressed: addStudent,child: const Icon(Icons.add),
      ),

    );
  }
}