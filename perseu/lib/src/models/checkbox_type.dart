enum CheckboxType { description, time, distance }

extension CheckboxTypesExtension on CheckboxType {
  String get name {
    switch (this) {
      case CheckboxType.distance:
        return 'Distância';
      case CheckboxType.time:
        return 'Tempo';
      case CheckboxType.description:
        return 'Descrição';
      default:
        return 'Desconhecido';
    }
  }
}
