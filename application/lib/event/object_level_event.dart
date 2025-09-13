class ObjectLevelEvent<S, T> {
  S state;
  T object;
  T noneObject;

  List<void Function(S state, T object)> selectionEventHandlers = [];
  List<void Function(S state, T object)> removalEventHandlers = [];

  bool isDefined() => object != noneObject;
  bool isNotDefined() => object == noneObject;

  ObjectLevelEvent({required this.state, required this.noneObject}) : object = noneObject;

  void subscribeSelection(void Function(S state, T object) eventHandler) {
    selectionEventHandlers.add(eventHandler);
  }

  void unsubscribeSelection(void Function(S state, T object) eventHandler) {
    selectionEventHandlers.remove(eventHandler);
  }

  void subscribeRemoval(void Function(S state, T object) eventHandler) {
    removalEventHandlers.add(eventHandler);
  }

  void unsubscribeRemoval(void Function(S state, T object) eventHandler) {
    removalEventHandlers.remove(eventHandler);
  }

  void unselect() {
    select(noneObject);
  }

  void select(T object) {
    this.object = object;
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(state, object);
    }
  }

  void remove() {
    if (isDefined()) {
      for (var eventHandler in removalEventHandlers) {
        eventHandler.call(state, object);
      }
    }
  }
}
