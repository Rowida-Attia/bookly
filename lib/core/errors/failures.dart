import 'package:dio/dio.dart'; 
abstract class Failure {
  final String errMassage;

  const Failure(this.errMassage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMassage);
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerFailure('BadCertificate with ApiServer');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request To ApiServer was Cancel');
      case DioExceptionType.connectionError:
        return ServerFailure('No Internet Connection');

      case DioExceptionType.unknown:
        return ServerFailure('Unexpected Error, Please try again!');

      default:
        return ServerFailure('Opps There was an Error');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('your Request not found , please try later !');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server error , please try later !');
    } else {
      return ServerFailure('Opps There was an Error');
    }
  }
}
