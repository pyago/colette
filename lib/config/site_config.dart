/// Public hostnames for the memorial. Google / OAuth sign-in only works when
/// each of these (except localhost, which Firebase includes by default) is
/// listed under Authentication → Settings → Authorized domains.
class SiteConfig {
  static const firebaseProjectId = 'colette-memorial';

  static const customDomain = 'colletemariefoundation.com';
  static const customDomainWww = 'www.colletemariefoundation.com';
  static const hostingDomain = 'colette-memorial.web.app';
  static const authHandlerDomain = 'colette-memorial.firebaseapp.com';

  static const customHosts = <String>[customDomain, customDomainWww];

  static const authorizedDomainsConsoleUrl =
      'https://console.firebase.google.com/project/colette-memorial/authentication/settings';

  static const googleOauthCredentialsUrl =
      'https://console.cloud.google.com/apis/credentials?project=colette-memorial';
}
