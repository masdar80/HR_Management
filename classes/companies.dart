class Company {
  final comp_id; //char
  final comp_name; //char

  Company({
    this.comp_id,
    this.comp_name,

  });

  Map<String, dynamic> toMap() {
    return {
      'comp_id': comp_id,
      'comp_name': comp_name,

    };
  }
}
