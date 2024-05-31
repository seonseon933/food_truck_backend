part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const BASE = _Paths.BASE;
  static const WISHLIST = _Paths.WISHLIST;
  static const FOODTRUCK = _Paths.FOODTRUCK;
  static const PROFILE = _Paths.PROFILE;
  static const HOME = _Paths.HOME;
  static const SETTING = _Paths.SETTING;
  static const PROFILESETTING = _Paths.PROFILESETTING;
  static const REVIEW = _Paths.REVIEW;
  static const FIRSTLOGIN = _Paths.FIRSTLOGIN;
  static const SEARCH = _Paths.SEARCH;
  static const FOODTRUCKSETTING = _Paths.FOODTRUCKSETTING;
  static const FOODTRUCKDETAIL = _Paths.FOODTRUCKDETAIL;
  //수정
  static const FOODTRUCKUPDATEMAP = _Paths.FOODTRUCKUPDATEMAP;
  static const FOODTRUCKUPDATE = _Paths.FOODTRUCKUPDATE;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const BASE = '/base';
  static const WISHLIST = '/wishlist';
  static const FOODTRUCK = '/foodtruck';
  static const PROFILE = '/profile';
  static const SETTING = '/setting';
  static const PROFILESETTING = '/profilesetting';
  static const HOME = '/home';
  static const REVIEW = '/review';
  static const FIRSTLOGIN = '/firstlogin';
  static const SEARCH = '/search';
  static const FOODTRUCKSETTING = '/foodtrucksetting';
  static const FOODTRUCKDETAIL = '/foodtruckdetail';
  // 수정 부분.
  static const FOODTRUCKUPDATEMAP = '/foodtruckupdatemap';
  static const FOODTRUCKUPDATE = '/foodtruckupdate';
}
