

class NxpressValidator {

  String? message;
  bool? isError;

  NxpressValidator({
    this.message,
    this.isError
  });

  throwError() {
    throw FormatException(message ?? "Unknown error");
  }

}

class NxpressFormatException implements Exception{

  final String? message;

  const NxpressFormatException([this.message = ""]);

}