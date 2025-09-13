class CustomEvent<S> {
  S state;

  List<void Function(S state)> eventHandlers = [];

  CustomEvent({required this.state});

  void subscribe(void Function(S state) eventHandler) {
    eventHandlers.add(eventHandler);
  }

  void unsubscribe(void Function(S state) eventHandler) {
    eventHandlers.remove(eventHandler);
  }

  void invoke() {
    for (var eventHandler in eventHandlers) {
      eventHandler.call(state);
    }
  }
}
