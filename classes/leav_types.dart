class LeaveTypes {
  final type_id; //char
  final decision;
  final company;//char

  LeaveTypes({
    this.type_id,
    this.decision,
    this.company

  });

  Map<String, dynamic> toMap() {
    return {
      'type_id': type_id,
      'decision': decision,
      'company':company

    };
  }
}
