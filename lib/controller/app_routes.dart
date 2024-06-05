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
  static const FOODTRUCKUPDATEMAP = _Paths.FOODTRUCKUPDATEMAP;
  static const FOODTRUCKUPDATE = _Paths.FOODTRUCKUPDATE;
  static const MENUSETTING = _Paths.MENUSETTING;
  static const MENUUPDATE = _Paths.MENUUPDATE;
  static const REVIEWSETTING = _Paths.REVIEWSETTING;
  static const REVIEWUPDATE = _Paths.REVIEWUPDATE;
  static const FOODTRUCKCREATE = _Paths.FOODTRUCKCREATE;
  static const FOODTRUCKCREATEMAP = _Paths.FOODTRUCKCREATEMAP;
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
  static const FOODTRUCKUPDATEMAP = '/foodtruckupdatemap';
  static const FOODTRUCKUPDATE = '/foodtruckupdate';
  static const FOODTRUCKCREATE = '/foodtruckcreate';
  static const FOODTRUCKCREATEMAP = '/foodtruckcreatemap';
  static const MENUSETTING = '/menusetting';
  static const MENUUPDATE = '/menuupdate';
  static const REVIEWSETTING = '/reviewsetting';
  static const REVIEWUPDATE = '/reviewupdate';
}
