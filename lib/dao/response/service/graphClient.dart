// import 'package:graphql/client.dart';
// import 'package:ultravmobile/dao/response/git_repo.dart';
// import 'package:ultravmobile/dao/response/service/client.dart';

// class GitHubRepoProvider {
//   Future<List<GithubRepo>> getCurrentUserRepos() {
//     return getGraphQLClient().query(_queryOptions()).then(_toGitHubRepo);
//   }

//   QueryOptions _queryOptions() {
//     return QueryOptions(
//       document: readRepositories,
//       variables: <String, dynamic>{
//         'nRepositories': 50,
//       },
//     );
//   }

//   List<GithubRepo> _toGitHubRepo(QueryResult queryResult) {
//     if (queryResult.hasErrors) {
//       throw Exception();
//     }

//     final list =
//         queryResult.data['viewer']['repositories']['nodes'] as List<dynamic>;

//     return list
//         .map((repoJson) => GithubRepo.fromJson(repoJson))
//         .toList(growable: false);
//   }
// }

// const String readRepositories = r'''
//   query ReadRepositories($nRepositories: Int!) {
//     viewer {
//       repositories(last: $nRepositories) {
//         nodes {
//           name
//           createdAt
//           forkCount
//         }
//       }
//     }
//   }
// ''';
