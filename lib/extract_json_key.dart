/// Recursively collects every JSON key that appears anywhere in [json].
///
/// [json] is expected to be the result of `jsonDecode(...)`, i.e. a
/// `Map<String, dynamic>` (or it may be a `List` of maps).
///
/// The returned list contains each key only once, preserving the discovery
/// order (breadth‑first).
List<String> extractJsonKeys(dynamic json) {
  final seen = <String>{};         // makes keys unique
  final queue = <dynamic>[json];   // breadth‑first traversal

  while (queue.isNotEmpty) {
    final current = queue.removeLast();

    if (current is Map<String, dynamic>) {
      for (final entry in current.entries) {
        if (seen.add(entry.key)) {
          // key is new -> add nested value to queue
          queue.add(entry.value);
        }
      }
    } else if (current is List) {
      queue.addAll(current);
    }
    // primitive values (String, num, bool, null) are ignored
  }

  return List<String>.from(seen);
}
