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
