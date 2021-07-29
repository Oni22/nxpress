

class NxpressErrorHandler {

  String? message;
  bool? isError;

  NxpressErrorHandler({
    this.message,
    this.isError
  });

  throwError() {
    throw FormatException(message ?? "Unknown error");
  }

}