class Diagnostics {
  final diag_id; //char
  final diag_name;
  final company;//char

  Diagnostics({
    this.diag_id,
    this.diag_name,
    this.company,

  });

  Map<String, dynamic> toMap() {
    return {
      'diag_id': diag_id,
      'diag_name': diag_name,
      'company': company,

    };
  }
  @override
  String toString() {
    return '${diag_id} ${diag_name}';
  }
}
