// PATHS
const startScreen = '/';
const moreScreen = '/more';
const searchScreen = '/search';
const newsScreen = '/news';
const intro = '/intro';
const login = '/login';
const onboarding = '/onboarding';
const notification = '/notification';
const profileDetail = 'profileDetail';
const memberProfil = 'memberProfil';
const profile = '/profile';

// NAMED
const profileScreenName = 'profilescreen';
const profileDetailScreenName = 'profiledetailscreen';
const memberprofilScreenName = 'memberprofilscreen';

// TODO: Make l10n
String getTitel(String route) {
  if (startScreen == route) {
    return 'Start';
  } else if (moreScreen == route) {
    return 'Mehr';
  } else if (searchScreen == route) {
    return 'Suche';
  } else if (newsScreen == route) {
    return 'News';
  } else if (intro == route) {
    return 'Intro';
  } else if (login == route) {
    return 'Login';
  } else if (onboarding == route) {
    return 'Onboarding';
  } else if (notification == route) {
    return 'Benachrichtigung';
  } else if (profileDetail == route) {
    return 'Profil Details';
  } else {
    return 'NoneTitel';
  }
}
