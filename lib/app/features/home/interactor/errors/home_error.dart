class HomeErrors implements Exception {
  final String message;

  HomeErrors(this.message);
}

class HomeErrorsGemini extends HomeErrors {
  HomeErrorsGemini(String message) : super(message);
}

class HomeErrorsApi extends HomeErrors {
  HomeErrorsApi(String message) : super(message);
}
