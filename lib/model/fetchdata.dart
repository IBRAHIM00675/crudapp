
class Students {
  Students({required this.name, required this.age, required this.email});

  String name;
  String age;
  String email;



factory Students.fromJson(Map<String,dynamic> json){

  return Students(
    name:json['name'] as String,
    age:json['age'] as String,
    email:json['email'] as String

  );
}


}
























// class Student {
//   final String name;
//   final String age;
//   final String email;

//   Student({
//     required this.name,
//     required this.age,
//     required this.email,
//   });

//   // Convert Firestore document to Student model
//   factory Student.fromMap(Map<String, dynamic> map) {
//     return Student(
//       name: map['name'] ?? 'No Name',
//       age: map['age'] ?? 'Unknown Age',
//       email: map['email'] ?? 'No Email',
//     );
//   }

//   // Optional: Convert Student model to Firestore-compatible map
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'age': age,
//       'email': email,
//     };
//   }
// }
