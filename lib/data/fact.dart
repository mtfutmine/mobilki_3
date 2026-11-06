class Fact {
  const Fact({required this.text});

  final String text;

  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(text: (json['fact'] as String?)?.trim() ?? 'Без текста');
  }
}
