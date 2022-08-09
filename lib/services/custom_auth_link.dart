import 'dart:async';
import 'package:graphql/client.dart';

import "package:gql_exec/gql_exec.dart";
import "package:gql_http_link/gql_http_link.dart";
import "package:gql_link/gql_link.dart";
import "package:gql_transform_link/gql_transform_link.dart";

typedef _RequestTransformer = Future<Request> Function(Request request);

typedef OnException = Future<String> Function(
    HttpLinkServerException exception,
    );

/// Simple header-based authentication link that adds [headerKey]: [getToken()] to every request.
///
/// If a lazy or exception-based authentication link is needed for your use case,
/// implementing your own from the [gql reference auth link] or opening an issue.
///
/// [gql reference auth link]: https://github.com/gql-dart/gql/blob/1884596904a411363165bcf3c7cfa9dcc2a61c26/examples/gql_example_http_auth_link/lib/http_auth_link.dart
class CustomAuthLink extends _AsyncReqTransformLink {
  CustomAuthLink({
    this.getToken,
    this.getStore,
    this.getRegion,
    this.headerKey = 'Authorization',
  }) : super(requestTransformer: transform(headerKey, getToken, getStore,getRegion));

  /// Authentication callback. Note – must include prefixes, e.g. `'Bearer $token'`
  final Future<String> Function()? getToken;
  final Future<String?> Function()? getStore;
  final Future<String?> Function()? getRegion;

  /// Header key to set to the result of [getToken]
  final String headerKey;

  static _RequestTransformer transform(
      String headerKey,
      Future<String> Function()? getToken,
      Future<String?> Function()? getStore,
      Future<String?> Function()? getRegion,
      ) =>
          (Request request) async {
        final token = await getToken!();
        final store = await getStore!();
        final region = await getRegion!();
        print("Header :  available are Token: $token , Store:  $store , Region :  $region");

        return request.updateContextEntry<HttpLinkHeaders>(
              (headers) => HttpLinkHeaders(
            headers: <String, String>{
              ...headers?.headers ?? <String, String>{},
              if (token != null && token.isNotEmpty) headerKey: token,
              if(store != null && store.isNotEmpty) "store" : store,
              if(region != null && region.isNotEmpty) "region" : region,
              'platform': "mobile_app"
            },
          ),
        );
      };
}

/// Version of [TransformLink] that handles async transforms
class _AsyncReqTransformLink extends Link {
  final _RequestTransformer? requestTransformer;

  _AsyncReqTransformLink({
    this.requestTransformer,
  });

  @override
  Stream<Response> request(
      Request request, [
        NextLink? forward,
      ]) async* {
    final req = await requestTransformer!(request);

    yield* forward!(req);
  }
}