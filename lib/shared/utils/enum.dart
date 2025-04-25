// ignore_for_file: constant_identifier_names

enum ExerciseStatus { pending, in_progress, completed, cancelled }

enum RoutineSessionStatus { pending, in_progress, completed, cancelled }

enum SessionExerciseStatus { pending, in_progress, completed, cancelled }

enum ExerciseSetStatus { pending, completed, failed }

enum AuditLogAction { insert, update, delete }

extension EnumToString on Enum {
  String get name => toString().split('.').last;
}
