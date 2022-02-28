import 'dart:html' as html;

import 'package:flutter/widgets.dart';

const String _popStateEvent = 'popstate';

class BrowserWillPopScope extends StatefulWidget {
  const BrowserWillPopScope({
    Key? key,
    required this.onWillPop,
    required this.child,
  }) : super(key: key);

  final WillPopCallback onWillPop;
  final Widget child;
  @override
  _BrowserWillPopScopeState createState() => _BrowserWillPopScopeState();
}

class _BrowserWillPopScopeState extends State<BrowserWillPopScope> {
  final _history = html.window.history;
  late final Function(html.Event event) _onPopStateHandler = (event) async {
    assert(event is html.PopStateEvent);
    print((event as html.PopStateEvent).state);

    // if ((event as html.PopStateEvent).toString() != '_temp_state_') return;
    if (await widget.onWillPop()) {
      _history.back();
    } else {
      _history.pushState('{serialCount: 0, state: fake}', '', null);
    }
  };

  @override
  void initState() {
    super.initState();
    _history.pushState('{serialCount: 0, state: fake}', '', null);
    html.window.addEventListener(_popStateEvent, _onPopStateHandler, true);
  }

  @override
  void dispose() {
    super.dispose();
    html.window.removeEventListener(_popStateEvent, _onPopStateHandler, true);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// class AutoRouteUtils {
//   AutoRouteUtils() {
//     _onPopStateHandler = _handleBeforeUnload;
//   }
//
//   // This ensures that when we refer to the tearoff in JavaScript, it refers to
//   // the exact same function. Referring to `_handleBeforeUnload` directly
//   // causes the JavaScript code to refer to a new function reference every
//   // time, thus causing the `removeEventListener()` to not remove the listener.
//
//   void _handleBeforeUnload(html.Event rawEvent, bool Function() canUnload) {
//     assert(rawEvent is html.BeforeUnloadEvent);
//     var event = rawEvent as html.BeforeUnloadEvent;
//     print(event);
//     if (!canUnload()) {
//       event.preventDefault();
//       event.returnValue = 'are you sure';
//     }
//   }
//
//   void onBeforeUnload(Future<bool> Function() canUnload) {
//     final history = html.window.history;
//     history.pushState('', 'FakeDataTitle', null);
//
//     html.window.onPopState.listen((event) async {
//       if (await canUnload()) {
//         history.go(-2);
//       } else {
//         history.pushState('newState', 'FakeDataTitle', null);
//       }
//     });
//     html.window.addEventListener('popstate', (event) => print(event));
//   }
//
//   void removeListeners() {
//     html.window.removeEventListener(_popStateEvent, (event) {}, true);
//   }
// }
//
