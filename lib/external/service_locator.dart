import 'http_service.dart';

ServiceLocator sl() => ServiceLocator.i;

class ServiceLocator {
  static ServiceLocator i = const ServiceLocator._();

  const ServiceLocator._();

  HttpService get httpService => HttpService.i;
}
