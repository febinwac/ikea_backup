import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import '../common/preference_utils.dart';
import 'app_data.dart';
import 'custom_auth_link.dart';

class GraphQLClientConfiguration {
  //init
  GraphQLClientConfiguration._privateConstructor();

  static final GraphQLClientConfiguration _instance =
      GraphQLClientConfiguration._privateConstructor();

  static GraphQLClientConfiguration get instance => _instance;
  static GraphQLClient? _graphClient;

  static GraphQLClient? get graphQL => _graphClient;

  //config
  Future<bool> config({
    BuildContext? context,
  }) async {
    String baseUrl = await PreferenceUtils().getBaseUrl();
    String? token = await PreferenceUtils().getAccessToken();
    String? region = await PreferenceUtils().getRegion();
    String? storeCode = await PreferenceUtils().getStoreCode();


    final HttpLink _link = HttpLink(
      baseUrl,
    );

    final CustomAuthLink authLink = CustomAuthLink(getToken: () async {
      return "Bearer $token";
    }, getStore: () async {
      return "dfc";
    }, getRegion: () async {
      return region;
    });
    final Link link = authLink.concat(_link);
    _graphClient = GraphQLClient(cache: GraphQLCache(), link: link);
    return _graphClient != null ? true : false;
  }

  //query call
  Future<dynamic> query(String query) async {
    _showQueryCalls(" QUERY --> $query");
    try {
      final QueryResult resp = await (_graphClient!
          .query(QueryOptions(
              document: gql(query), fetchPolicy: FetchPolicy.networkOnly))
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw NetworkException(
            message: 'Check your internet connection',
            uri: Uri(path: '${AppData.baseUrl}graphql'));
      }));
      if (resp.exception != null && resp.data == null) {
        if (resp.exception?.graphqlErrors != null &&
            resp.exception!.graphqlErrors.isNotEmpty) {
          _showQueryCalls(
              " QUERY EXCEPTION 1--> ${resp.exception?.graphqlErrors[0].message}");

          return <String, dynamic>{
            'status': 'error',
            'message': resp.exception?.graphqlErrors[0].message ??
                'Something went wrong'
          };
        } else {
          _showQueryCalls(
              " QUERY EXCEPTION 2--> ${resp.exception?.linkException?.originalException ?? 'Something went wrong'}");

          return <String, dynamic>{
            'status': 'error',
            'message': resp.exception?.linkException?.originalException ??
                'Something went wrong'
          };
        }
      }

      return resp.data;
    } catch (error) {
      _showQueryCalls(" QUERY ERROR--> $error");
      return <String, dynamic>{
        'status': 'error',
        'message': 'Something went wrong',
        'extensions': null
      };
    }
  }

  //mutation call
  Future<dynamic> mutation(String query,
      {Map<String, dynamic>? variables}) async {
    try {
      _showQueryCalls(" MUTATION --> $query");

      final QueryResult resp = await (_graphClient!
          .mutate(MutationOptions(
              document: gql(query),
              fetchPolicy: FetchPolicy.networkOnly,
              variables: variables ?? {},
              errorPolicy: ErrorPolicy.all))
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw NetworkException(
            message: 'Check your internet connection',
            uri: Uri(path: AppData.baseUrl + 'graphql'));
      }));

      if (resp.exception != null) {
        print(resp.exception!.graphqlErrors);
        if (resp.exception?.graphqlErrors != null &&
            resp.exception!.graphqlErrors.isNotEmpty) {
          _showQueryCalls(
              " MUTATION EXCEPTION 1--> ${resp.exception?.graphqlErrors[0].message}");

          return <String, dynamic>{
            'status': 'error',
            'message': resp.exception?.graphqlErrors[0].message ??
                'Something went wrong',
            'extensions': resp.exception?.graphqlErrors[0].extensions ??
                'Something went wrong'
          };
        } else {
          if (resp.exception!.linkException != null &&
              resp.exception?.linkException?.originalException != null) {
            _showQueryCalls(
                " MUTATION EXCEPTION 2--> ${resp.exception?.linkException?.originalException ?? 'Something went wrong'}");

            return <String, dynamic>{
              'status': 'error',
              'message': resp.exception?.linkException?.originalException ??
                  'Something went wrong'
            };
          }

          return <String, dynamic>{
            'status': 'error',
            'message': 'Something went wrong'
          };
        }
      }

      return resp.data;
    } catch (error) {
      _showQueryCalls(" MUTATION ERROR--> $error");

      return <String, dynamic>{
        'status': 'error',
        'message': 'Something went wrong',
        'extensions': null
      };
    }
  }

  // query print
  void _showQueryCalls(dynamic message) {
    print(message);
  }
}

typedef GetToken = Future<String> Function();
typedef GetStoreCode = Future<String> Function();

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'utilities/preference_utils.dart';
//
// class GraphQLClientConfiguration {
//   //init
//   GraphQLClientConfiguration._privateConstructor();
//
//   static final GraphQLClientConfiguration _instance =
//       GraphQLClientConfiguration._privateConstructor();
//
//   static GraphQLClientConfiguration get instance => _instance;
//   static String _token = '';
//   static GraphQLClient _graphClient;
//
//   static GraphQLClient get graphQL => _graphClient;
//
//   //config
//   Future<void> config(
//       {String token, BuildContext context, String store, String region}) async {
//     String baseUrl = await PreferenceUtils().getBaseUrl();
//
//     _showQueryCalls(
//         "GraphQl initialized with token as-->$_token and URL as $baseUrl");
//     final HttpLink _link = HttpLink(
//       uri: '$baseUrl',
//     );
//     // token = token ?? _token;
//     final AuthLinkGraphQL tokenLink = AuthLinkGraphQL(getToken: () async {
//       String token = await PreferenceUtils().getAccessToken();
//       return token;
//     }, getStore: () async {
//       if (store != null) {
//         return store;
//       } else {
//         String storeId = await PreferenceUtils().getStoreCode();
//         return storeId;
//       }
//     }, getRegion: () async {
//       if (region != null) {
//         print("Region 1 $region");
//         return region;
//
//       }
//      else {
//         String region = await PreferenceUtils().getRegion();
//         print("Region 2 $region");
//
//         return region;
//       }
//     });
//     _graphClient =
//         GraphQLClient(cache: InMemoryCache(), link: tokenLink.concat(_link));
//     print(tokenLink);
//   }
//
//   //query call
//   Future<dynamic> query(String query) async {
//     _showQueryCalls(" QUERY --> $query");
//     try {
//       final QueryResult resp = await _graphClient
//           .query(QueryOptions(
//               documentNode: gql(query), fetchPolicy: FetchPolicy.networkOnly))
//           .timeout(const Duration(seconds: 60), onTimeout: () {
//         throw NetworkException(message: 'Check your internet connection');
//       });
//
//       if (resp.exception != null && resp.data == null) {
//         if (resp.exception.graphqlErrors != null &&
//             resp.exception.graphqlErrors.isNotEmpty) {
//           _showQueryCalls(
//               " QUERY EXCEPTION--> ${resp.exception?.graphqlErrors[0]?.message}");
//
//           return <String, dynamic>{
//             'status': 'error',
//             'message': resp.exception?.graphqlErrors[0]?.message ??
//                 'Something went wrong'
//           };
//         } else {
//           _showQueryCalls(
//               " QUERY EXCEPTION--> ${resp.exception?.clientException?.message}");
//
//           return <String, dynamic>{
//             'status': 'error',
//             'message': resp.exception?.clientException?.message ??
//                 'Something went wrong'
//           };
//         }
//       }
//
//       return resp.data;
//     } catch (error) {
//       _showQueryCalls(" QUERY ERROR--> $error");
//
//       return <String, dynamic>{
//         'status': 'error',
//         'message': 'Something went wrong'
//       };
//     }
//   }
//
//   //mutation call
//   Future<dynamic> mutation(String query,
//       {Map<String, dynamic> variables}) async {
//     try {
//       _showQueryCalls(" MUTATION --> $query");
//
//       final QueryResult resp = await _graphClient
//           .mutate(MutationOptions(
//               documentNode: gql(query),
//               fetchPolicy: FetchPolicy.networkOnly,
//               variables: variables,
//               errorPolicy: ErrorPolicy.all))
//           .timeout(const Duration(seconds: 60), onTimeout: () {
//         throw NetworkException(message: 'Check your internet connection');
//       });
//
//       if (resp.exception != null) {
//         print(resp.exception.graphqlErrors);
//         if (resp.exception.graphqlErrors != null &&
//             resp.exception.graphqlErrors.isNotEmpty) {
//           _showQueryCalls(
//               " MUTATION EXCEPTION--> ${resp.exception?.graphqlErrors[0]?.message}");
//
//           return <String, dynamic>{
//             'status': 'error',
//             'message': resp.exception.graphqlErrors[0]?.message ??
//                 'Something went wrong',
//             'extensions': resp.exception.graphqlErrors[0]?.extensions ??
//                 'Something went wrong'
//           };
//         } else {
//           _showQueryCalls(
//               " MUTATION EXCEPTION--> ${resp.exception?.clientException?.message}");
//
//           return <String, dynamic>{
//             'status': 'error',
//             'message':
//                 resp.exception.clientException.message ?? 'Something went wrong'
//           };
//         }
//       }
//
//       return resp.data;
//     } catch (error) {
//       _showQueryCalls(" MUTATION ERROR--> $error");
//
//       return <String, dynamic>{
//         'status': 'error',
//         'message': 'Something Went wrong'
//       };
//     }
//   }
//
//   // query print
//   void _showQueryCalls(dynamic message) {
//     print(message);
//   }
// }
//
// enum Status { LOADING, COMPLETED, ERROR }
//
// class CustomAuthLink extends Link {
//   Map<String, String> headers;
//
//   CustomAuthLink({@required this.headers})
//       : super(
//           request: (Operation operation, [NextLink forward]) {
//             StreamController<FetchResult> controller;
//
//             Future<void> onListen() async {
//               try {
//                 print(headers);
//                 if (headers != null) {
//                   operation.setContext(
//                       <String, Map<String, String>>{'headers': headers});
//                 }
//               } catch (error) {
//                 controller.addError(error);
//               }
//
//               await controller.addStream(forward(operation));
//               await controller.close();
//             }
//
//             controller = StreamController<FetchResult>(onListen: onListen);
//
//             return controller.stream;
//           },
//         );
// }
//
// typedef GetToken = FutureOr<String> Function();
// typedef GetStoreCode = FutureOr<String> Function();
// typedef GetRegion = FutureOr<String> Function();
//
// class AuthLinkGraphQL extends Link {
//   AuthLinkGraphQL(
//       {@required this.getToken,
//       @required this.getStore,
//       @required this.getRegion,
//       this.headerKey = 'Authorization'})
//       : super(
//           request: (Operation operation, [NextLink forward]) {
//             StreamController<FetchResult> controller;
//
//             Future<void> onListen() async {
//               try {
//                 final String token = await getToken();
//                 final String storeCode = await getStore();
//                 final String region = await getRegion();
//                 if (token != null &&
//                     token.isNotEmpty &&
//                     storeCode != null &&
//                     storeCode.isNotEmpty &&
//                     region != null &&
//                     region.isNotEmpty) {
//                   print("Header : all available  $token   $storeCode  $region");
//                   operation.setContext(<String, Map<String, String>>{
//                     'headers': <String, String>{
//                       'Authorization': token,
//                       'store': storeCode,
//                       'region': region,
//                       'platform': "mobile_app",
//                     }
//                   });
//                 } else if (token != null &&
//                     token.isNotEmpty &&
//                     storeCode != null &&
//                     storeCode.isNotEmpty) {
//                   print("Header : only token & store code available  $token   $storeCode  $region");
//                   operation.setContext(<String, Map<String, String>>{
//                     'headers': <String, String>{
//                       'Authorization': token,
//                       'store': storeCode,
//                       'platform': "mobile_app",
//                     }
//                   });
//                 } else if (storeCode == null ||
//                     storeCode.isEmpty && token != null && token.isNotEmpty) {
//                   print("Header : only token available");
//                   operation.setContext(<String, Map<String, String>>{
//                     'headers': <String, String>{'Authorization': token,'platform': "mobile_app"}
//                   });
//                 } else if (storeCode != null ||
//                     storeCode.isNotEmpty && token == null && token.isEmpty) {
//                   print("Header : only storeCode available");
//                   operation.setContext(<String, Map<String, String>>{
//                     'headers': <String, String>{'store': storeCode,'platform': "mobile_app",}
//                   });
//                 }
//               } catch (error) {
//                 controller.addError(error);
//               }
//
//               await controller.addStream(forward(operation));
//               await controller.close();
//             }
//
//             controller = StreamController<FetchResult>(onListen: onListen);
//
//             return controller.stream;
//           },
//         );
//
//   GetRegion getRegion;
//   GetToken getToken;
//   GetStoreCode getStore;
//   String headerKey;
// }
