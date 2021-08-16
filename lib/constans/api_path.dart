class ApiPath {
  String _authServiceUrl = 'http://10.0.2.2:3000/v1';

  //  Auth paths
  String _getAuthPath() {
    return '$_authServiceUrl/auth';
  }

  String getSignInPath() {
    return '${_getAuthPath()}/login';
  }

  String getVerifyCodePath() {
    return '${_getAuthPath()}/verify-code';
  }

  String getRefreshTokenPath() {
    return '${_getAuthPath()}/refresh-tokens';
  }

  //  Users paths
  String getUserPath() {
    return '$_authServiceUrl/user';
  }

  String getUpdateProfileImagePath() {
    return '${getUserPath()}/avatar';
  }
}
