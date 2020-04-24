// import 'dart:io';

// import 'package:graph_ql_poc/config.dart';
// import 'package:graphql/client.dart';
// import 'package:path_provider/path_provider.dart';

// final HttpLink _httpLink = HttpLink(
//   uri: 'https://api.github.com/graphql',
// );

// final AuthLink _authLink = AuthLink(
//   getToken: () async => 'Bearer $GITHUB_TOKEN',
// );

// final Link _link = _authLink.concat(_httpLink as Link);

// GraphQLClient _client;

// GraphQLClient getGraphQLClient() {
//   _client ??= GraphQLClient(
//     link: _link,
//     cache: InMemoryCache(storageProvider: () {
//       return getTemporaryDirectory();
//     }),
//   );

//   return _client;
// }
