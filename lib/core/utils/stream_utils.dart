import 'dart:async';

/// Phát danh sách giá trị mới nhất của mọi stream (sau khi stream nào cũng đã
/// có ít nhất một giá trị).
Stream<List<T>> combineLatest<T>(List<Stream<T>> streams) {
  final values = List<T?>.filled(streams.length, null);
  final ready = List<bool>.filled(streams.length, false);
  final subs = <StreamSubscription<T>>[];
  late final StreamController<List<T>> controller;
  controller = StreamController<List<T>>(
    onListen: () {
      for (var i = 0; i < streams.length; i++) {
        subs.add(
          streams[i].listen((v) {
            values[i] = v;
            ready[i] = true;
            if (ready.every((r) => r)) {
              controller.add(values.cast<T>().toList());
            }
          }, onError: controller.addError),
        );
      }
    },
    onCancel: () => Future.wait(subs.map((s) => s.cancel())),
  );
  return controller.stream;
}
