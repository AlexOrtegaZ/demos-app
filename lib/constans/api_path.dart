class ApiPath {
  String _authServiceUrl = 'http:localhost:3000/v1';

  //  Auth paths
  String _getAuthPath() {
    return '$_authServiceUrl/auth';
  }

  String getSignInPath() {
    return '$_getAuthPath()/login';
  }

  String getVerifyCodePath() {
    return '$_getAuthPath()/verify-code';
  }

  String getRefreshTokenPath() {
    return '$_getAuthPath()/login';
  }
}
