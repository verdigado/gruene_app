// PATHS
const startScreen = '/';
const moreScreen = '/more';
const searchScreen = '/search';
const newsScreen = '/news';
const interests = '/interests';
// Subroutes of interests
const interestpages = '/interestpages';

const intro = '/intro';
const login = '/login';
// const onboarding = '/onboarding';
const notification = '/notification';
const profile = '/profile';
// WebView
const webView = '/inAppWebview';
// Subroutes of profile
const profileDetail = 'profileDetail';
const memberProfil = 'memberProfil';
const memberCard = 'memberCard';
const twofactorapprove = '/twofactorapprove';
const twofactorregistration = '/twofactorregistration';

// NAMED
const profileScreenName = 'profilescreen';
const profileDetailScreenName = 'profiledetailscreen';
const memberprofilScreenName = 'memberprofilscreen';
const memberCardScreenName = 'memberCard';
const webViewScreen = 'webView';

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
  } else if (interests == route) {
    return 'Interessen';
  } else if (notification == route) {
    return 'Benachrichtigung';
  } else if (profileDetail == route) {
    return 'Profil Details';
  } else if (twofactorregistration == route) {
    return 'Zwei-Faktor-Registrierung';
  } else if (twofactorapprove == route) {
    return 'Zwei-Faktor-Bestätigung';
  } else {
    return 'NoneTitel';
  }
}
