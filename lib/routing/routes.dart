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
const debug = '/debug';

// NAMED
const profileScreenName = 'profilescreen';
const profileDetailScreenName = 'profiledetailscreen';
const memberprofilScreenName = 'memberprofilscreen';
const memberCardScreenName = 'memberCard';
const webViewScreen = 'webView';
const debugScreen = 'debugScreen';

// TODO: Make l10n
String getTitel(String route) {
  switch (route) {
    case startScreen:
      return 'Start';
    case moreScreen:
      return 'Mehr';
    case searchScreen:
      return 'Suche';
    case newsScreen:
      return 'News';
    case intro:
      return 'Intro';
    case interests:
      return 'Interessen';
    case login:
      return 'Login';
    // case onboarding:
    // return 'Onboarding';
    case notification:
      return 'Benachrichtigung';
    case profileDetail:
      return 'Profil Details';
    // default case
    default:
      return '';
  }
}
