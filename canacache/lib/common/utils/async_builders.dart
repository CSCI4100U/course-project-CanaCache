import "package:flutter/material.dart";

class CanaFutureBuilder<T> extends StatelessWidget {
  final T? initialData;
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? progressIndicator;

  const CanaFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.initialData,
    this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
        }

        if (!snapshot.hasData) {
          return progressIndicator ??
              const Center(child: CircularProgressIndicator());
        }

        return builder(context, snapshot.data as T);
      },
    );
  }
}

class CanaStreamBuilder<T> extends StatelessWidget {
  final T? initialData;
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? progressIndicator;

  const CanaStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.initialData,
    this.progressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Error.throwWithStackTrace(snapshot.error!, snapshot.stackTrace!);
        }

        if (!snapshot.hasData) {
          return progressIndicator ??
              const Center(child: CircularProgressIndicator());
        }

        return builder(context, snapshot.data as T);
      },
    );
  }
}
