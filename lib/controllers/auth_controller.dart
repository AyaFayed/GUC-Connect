import "package:firebase_auth/firebase_auth.dart";
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _database = UserController();

  // sign up
  Future signup(String email, String password, String name, bool isTA) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      UserType userType = isAdmin(email)
          ? UserType.admin
          : !isInstructor(email)
              ? UserType.student
              : isTA
                  ? UserType.ta
                  : UserType.professor;

      await _database.createUser(user?.uid, name, userType);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // log in
  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // log out
  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
