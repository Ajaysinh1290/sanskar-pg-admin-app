import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanskar_pg_admin_app/controllers/user_controller.dart';
import 'package:sanskar_pg_admin_app/models/address/address.dart';
import 'package:sanskar_pg_admin_app/models/user/user_model.dart';
import 'package:sanskar_pg_admin_app/screens/authentication/sign_in.dart';
import 'package:sanskar_pg_admin_app/screens/dashboard/dashboard.dart';
import 'package:sanskar_pg_admin_app/widgets/dialog/show_error_dialog.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  static AuthController instance = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Rx<User?> firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(const SignIn(), transition: Transition.size);
    } else {
      FirebaseMessaging.instance.subscribeToTopic('admin');
      Get.offAll(Dashboard(), transition: Transition.size);
    }
  }

  bool _validate() {
    if (emailController.text.trim().isEmpty) {
      showErrorDialog('Authentication Error', 'Email address can\'t be empty.');
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      showErrorDialog('Authentication Error', 'Email address can\'t be empty.');
      return false;
    }
    return true;
  }

  void signIn() async {
    if (!_validate()) {
      return;
    }
    try {
      isLoading.value = true;
      await auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((result) {
        debugPrint('User Id  :  ${result.user!.uid}');
        debugPrint('Email  :  ${result.user!.email}');
      });
    } on FirebaseAuthException catch (e) {
      showErrorDialog("Authentication Error", getMessageFromErrorCode(e));
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog("Authentication Error", e.toString());
    }
    isLoading.value = false;
  }

  void signUp() async {
    if (!_validate()) {
      return;
    }
    try {
      isLoading.value = true;
      await auth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((result) {
        debugPrint('User Id  :  ${result.user!.uid}');
        debugPrint('Email  :  ${result.user!.email}');
      });
    } on FirebaseAuthException catch (e) {
      showErrorDialog("Authentication Error", getMessageFromErrorCode(e));
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog("Authentication Error", e.toString());
    }
    isLoading.value = false;
  }

  Future<UserCredential?> registerUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showErrorDialog("Authentication Error", getMessageFromErrorCode(e));
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog("Authentication Error", e.toString());
    }

    await app.delete();
    return Future.sync(() => userCredential);
  }

  Future<bool> changeEmail(
      String oldEmail, String password, String newEmail) async {
    bool isUpdated = false;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: oldEmail, password: password);
      await FirebaseAuth.instanceFor(app: app)
          .currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instanceFor(app: app)
          .currentUser!
          .updateEmail(newEmail);
      isUpdated = true;
    } on FirebaseAuthException catch (e) {
      showErrorDialog("Authentication Error", getMessageFromErrorCode(e));
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog("Authentication Error", e.toString());
    }
    await app.delete();
    return isUpdated;
  }

  void signOut() {
    // UserController userController = Get.find();
    // userController.clear();
    auth.signOut();
  }

  // UserModel? getUserModel() {
  //   if (auth.currentUser == null) {
  //     return null;
  //   }
  //   return UserModel(
  //     roomId: '1',
  //     hostelId: '1',
  //     userId: auth.currentUser!.uid,
  //     email: auth.currentUser!.email!,
  //     userName: 'Harsh Row',
  //     address: Address(
  //         street: '101, Skyline Apartment',
  //         city: 'Ahmedabad',
  //         pinCode: '382350',
  //         state: 'Gujrat'),
  //     admissionDate: DateTime.now(),
  //     gender: 'Male',
  //     mobileNumber: '9998223222',
  //     referId: 'JOHN20229',
  //     userProfilePic:
  //         'https://images.unsplash.com/flagged/photo-1597694042000-f0150210da38?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aGFwcHklMjBtYW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
  //     pendingRent: 4000,
  //     isAccountApproved: true,
  //     password: 'adsf',
  //     dateOfBirth: DateTime.now(),
  //     documents: [],
  //   );
  // }

  String getMessageFromErrorCode(FirebaseAuthException error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong password";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return error.message ?? 'Login Failed. Please try again.';
    }
  }
}
