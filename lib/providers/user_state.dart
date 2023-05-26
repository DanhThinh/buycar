import 'package:car_rent/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../common/alert.dart';
import '../configs/basic_config.dart';

class UserState extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopesGoogle,
  );
  User? user;
  late UserModel userModel;
  bool isLogin = false;
  String documentid = "";

  Future<void> initData() async {
    user = FirebaseAuth.instance.currentUser;
    documentid = user == null ? "" : user!.uid;
    isLogin = user == null ? false : true;
  }

  Future<void> loadUserModel() async {
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where("email", isEqualTo: user!.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        userModel = UserModel(
          id: document.id,
          username: document["username"],
          password: document["password"],
          email: document["email"],
          address: document["address"],
        );
      } else {
        print("Không tìm thấy tài liệu phù hợp");
      }
    }
  }

  Future<void> register(UserModel u) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: u.email,
      password: u.password,
    );
    user = userCredential.user;
    await FirebaseFirestore.instance
        .collection('User')
        .doc(user!.uid)
        .set(u.toJson())
        .then((value) {
      isLogin = user == null ? false : true;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      isLogin = user == null ? false : true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        alert(ctx, "khong thay user");
      } else if (e.code == 'wrong-password') {
        alert(ctx, "sai mat khau");
      }
    }
  }

  Future signInWithGoogle() async {
    try {
      try {
        await FirebaseAuth.instance.signOut();
        await _googleSignIn.disconnect();
      } catch (e) {
        print(e);
      }
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      user = FirebaseAuth.instance.currentUser;
      UserModel u = UserModel(
          id: "",
          username: user!.displayName!,
          password: "",
          email: user!.email!,
          address: "");
      await FirebaseFirestore.instance
          .collection('User')
          .doc(user!.uid)
          .set(u.toJson());
      isLogin = user == null ? false : true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future logout() async {
    if (user!.providerData[0].providerId == "google.com") {
      GoogleSignInAccount? googleUser = await _googleSignIn.disconnect();
    }
    await FirebaseAuth.instance.signOut();
    isLogin = false;
    notifyListeners();
  }
}
