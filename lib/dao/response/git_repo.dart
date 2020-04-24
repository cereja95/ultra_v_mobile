class GithubRepo {
  String name;
  DateTime createdAt;
  int forkCount;

  GithubRepo({
    this.name,
    this.createdAt,
    this.forkCount,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) => new GithubRepo(
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        forkCount: json["forkCount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "forkCount": forkCount,
      };
}
