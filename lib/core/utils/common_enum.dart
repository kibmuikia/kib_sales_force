enum GeneralStatus {
  initial,
  loading,
  loaded,
  error;

  bool get isInitial => this == GeneralStatus.initial;
  bool get isLoading => this == GeneralStatus.loading;
  bool get isLoaded => this == GeneralStatus.loaded;
  bool get isError => this == GeneralStatus.error;
}

enum VisitStatus {
  created(name: 'created', label: 'Created'),
  ongoing(name: 'ongoing', label: 'Ongoing'),
  pending(name: 'pending', label: 'Pending'),
  completed(name: 'completed', label: 'Completed'),
  cancelled(name: 'cancelled', label: 'Cancelled');

  final String name;
  final String label;

  const VisitStatus({required this.name, required this.label});

  bool get isCreated => this == VisitStatus.created;
  bool get isOngoing => this == VisitStatus.ongoing;
  bool get isPending => this == VisitStatus.pending;
  bool get isCompleted => this == VisitStatus.completed;
  bool get isCancelled => this == VisitStatus.cancelled;
}

extension StringVisitStatusExtension on String {
  VisitStatus? tryFromString() {
    if (isEmpty) {
      return null;
    }
    switch (toLowerCase()) {
      case 'created':
        return VisitStatus.created;
      case 'ongoing':
        return VisitStatus.ongoing;
      case 'pending':
        return VisitStatus.pending;
      case 'completed':
        return VisitStatus.completed;
      case 'cancelled':
        return VisitStatus.cancelled;
      default:
        return null;
    }
  }
}

extension IntVisitStatusExtension on int {
  VisitStatus fromInt() {
    if (this < 0 || this > 4) {
      throw Exception('Invalid visit status: $this');
    }
    switch (this) {
      case 0:
        return VisitStatus.created;
      case 1:
        return VisitStatus.ongoing;
      case 2:
        return VisitStatus.pending;
      case 3:
        return VisitStatus.completed;
      case 4:
        return VisitStatus.cancelled;
      default:
        throw Exception('Unknown visit status: $this');
    }
  }

  VisitStatus? tryFromInt() {
    try {
      return fromInt();
    } catch (_) {
      return null;
    }
  }
}
