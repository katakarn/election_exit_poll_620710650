class Candidate {
  final int number;
  final String displayName;
  Candidate({
    required this.number,
    required this.displayName,
  });
  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      number: json['number'],
      displayName: json['displayname'],
    );
  }
}
