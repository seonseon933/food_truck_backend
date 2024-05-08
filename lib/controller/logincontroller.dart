import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User curruntUser;
  final UsersModel _userSaveData = UsersModel();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // 구글 로그인하면, 구글에서 받은 credential을 사용해 Firebase인증에 로그인하고 authResult에 인증 결과 저장
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      // 인증 결과에서 사용자 정보를 가져옴. (현재 로그인한 사용자 정보)
      final User user = authResult.user!;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      _userSaveData.saveUserData(user);

      return user;
    } catch (e) {
      print('구글 로그인 실패 : $e');
    }
    return null;
  }

  void signOutWithGoogle() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      print("사용자 로그아웃 실패 : $e");
    }
  }
}
