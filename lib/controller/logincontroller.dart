import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final UsersModel _usersModel = UsersModel();

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

      _usersModel.saveUserData(user);

      return user;
    } catch (e) {
      print('구글 로그인 실패 : $e');
    }
    return null;
  }

  // 사용자 회원 타입(구매자, 판매자) 존재 체크-> 1이면 로그인 처음 했다는 거임.
  Future<int> checkUserType() async {
    User user = _auth.currentUser!;
    return _usersModel.checkUserType(user.uid);
  }

  // 사용자 회원 타입(구매자, 판매자) 저장
  Future<void> saveUserType(String type) async {
    User user = _auth.currentUser!;
    return _usersModel.saveUserType(type, user.uid);
  }

  // 로그아웃
  Future<void> signOutWithGoogle() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      print("사용자 로그아웃 실패 : $e");
    }
  }

  // 계정 삭제(탈퇴)
  Future<void> userDelete() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // 재인증 수행
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          );
          await user.reauthenticateWithCredential(credential);

          // 재인증 후 사용자 데이터 삭제
          // 이거 실행하고 fuctions에 있는 이벤트 발생할 예정.(사용자가 작성한 푸드트럭(메뉴 포함), 리뷰 일괄 삭제)
          await _usersModel.deleteUserData();
          await user.delete();
        }
      } catch (e) {
        print('왜 사용자 삭제 중에 오류가 발생하냐고 : $e');
      }
    }
  }
}
