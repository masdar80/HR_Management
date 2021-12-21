class Assets {
  final object_id;
  final asset_id; ///char
  final asset_name;
  final company;//char

  Assets({
    this.object_id,
    this.asset_id,
    this.asset_name,
    this.company,

  });

  Map<String, dynamic> toMap() {
    return {
      'object_id': object_id,
      'asset_id': asset_id,
      'asset_name': asset_name,
      'company': company,

    };
  }
  @override
  String toString() {
    return '${asset_id} ${asset_name}';
  }
}
