class Students {
  
  Students({
     required this.name,
     required this.age, 
     required this.email, 
     required this.docId
     }
     );

  String name;
  String age;
  String email;
  String docId;

  factory Students.fromJson( String id, Map<String , dynamic> json) {
    return Students(
      
      docId: id,
      name: json['name'] as String,
      age: json['age'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'age': age,
      'email': email,
      'docId': docId
    };
  }
}

