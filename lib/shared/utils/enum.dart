enum ExerciseStatus { pending, inProgress, completed, cancelled }

enum RoutineSessionStatus { pending, inProgress, completed, cancelled }

enum SessionExerciseStatus { pending, inProgress, completed, cancelled }

enum ExerciseSetStatus { pending, completed, failed }

enum AuditLogAction { insert, update, delete }

extension EnumToString on Enum {
  String get name => toString().split('.').last;
}
