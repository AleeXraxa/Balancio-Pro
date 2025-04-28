class Usermodel {
  final String uid;
  final String fname;
  final String lname;
  final String gender;
  final bool isCompleted;

  Usermodel({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.gender,
    required this.isCompleted,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fname': fname,
      'lname': lname,
      'gender': gender,
      'isCompleted': isCompleted,
    };
  }
}
