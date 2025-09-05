class SelectEvent<S, T> {
  S state;
  T object;
  T noneObject;

  List<void Function(S state, T object)> eventHandlers = [];

  bool isDefined() => object != noneObject;
  bool isNotDefined() => object == noneObject;

  SelectEvent({required this.state, required this.noneObject}) : object = noneObject;

  void subscribe(void Function(S state, T object) eventHandler) {
    eventHandlers.add(eventHandler);
  }

  void unsubscribe(void Function(S state, T object) eventHandler) {
    eventHandlers.remove(eventHandler);
  }

  void select(T object) {
    this.object = object;
    for (var eventHandler in eventHandlers) {
      eventHandler.call(state, object);
    }
  }
}
