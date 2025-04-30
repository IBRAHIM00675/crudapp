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
          margin: const EdgeInsets.fromLTRB(10, 10, 20, 50),
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

                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'email',
                  hintText: 'Enter Your Email',
                ),
              ),
              const SizedBox(height: 100),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Cancel')),

                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('students').add({
                        'name': _nameController.text,
                        'age': _ageController.text,
                        'email': _emailController.text,
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void updateStudent(String docId, String name, String age, String email) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(docId)
        .update({'name': name, 'age': age, 'email': email})
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student Updated Successfully')),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to Update Student')),
          );
        });
  }

  void deleteStudent(String docId) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(docId)
        .delete()
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student Deleted Successfully')),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to Delete Student')),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Directory')),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Data not found'));
          }

          final students =
              snapshot.data!.docs
                  .map(
                    (doc) => Students.fromJson(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          return SingleChildScrollView(
            child: Column(
              children:
                  students.map((student) {
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    final nameController =
                                        TextEditingController(
                                          text: student.name,
                                        );
                                    final ageController = TextEditingController(
                                      text: student.age,
                                    );
                                    final emailController =
                                        TextEditingController(
                                          text: student.email,
                                        );
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,

                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              labelText: 'Name',
                                              hintText: 'Enter Your Name',
                                            ),
                                          ),
                                          TextField(
                                            controller: ageController,
                                            decoration: InputDecoration(
                                              labelText: 'Age',
                                              hintText: 'Enter Your Age',
                                            ),
                                          ),
                                          TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              hintText: 'Enter Your Email',
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  updateStudent(
                                                    student.docId,
                                                    nameController.text,
                                                    ageController.text,
                                                    emailController.text,
                                                  );
                                                   Navigator.pop(context);
                                                },
                                                
                                                child: Text('Update Now'),
                                              ),
                                              ElevatedButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('cancel'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 16, 19, 230),
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                deleteStudent(student.docId);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
