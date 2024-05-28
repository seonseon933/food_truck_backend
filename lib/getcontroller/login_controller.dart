import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_truck/model/usersmodel.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final UsersModel _usersModel = UsersModel();

  void goBase() {
    // USER 아이디를 넘겨주어야함
    Get.offAllNamed(Routes.BASE);
  }

  Future<void> signInWithGoogle() async {
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

      await _usersModel.saveUserData(user);

      // 회원 타입 체크
      int userType = await checkUserType();
      if (userType == 0) {
        // 회원 타입이 존재하는 경우
        Get.offAllNamed(Routes.HOME); // 홈 화면으로 이동
      } else if (userType == 1) {
        // 회원 타입이 존재하지 않는 경우
        Get.offAllNamed(Routes.FIRSTLOGIN); // 첫 로그인 화면으로 이동
      }
    } catch (e) {
      print('구글 로그인 실패 : $e');
    }
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

  void goFirstLogin() {
    Get.offAllNamed(Routes.FIRSTLOGIN);
  }
}
