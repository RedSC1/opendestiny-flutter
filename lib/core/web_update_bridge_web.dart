import 'dart:html' as html;
import 'dart:js' as js;

Future<String> checkForWebUpdate() async {
  if (!js.context.hasProperty('__OD_CHECK_WEB_UPDATE__')) {
    return 'error';
  }
  try {
    js.context.callMethod('__OD_CHECK_WEB_UPDATE__');
    for (var i = 0; i < 60; i += 1) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final result = js.context['__OD_LAST_UPDATE_CHECK_RESULT__'];
      final text = result?.toString() ?? 'error';
      if (text != 'pending' && text != 'idle') {
        return text;
      }
    }
    return 'error';
  } catch (_) {
    return 'error';
  }
}

Future<void> activateWebUpdate() async {
  if (!js.context.hasProperty('__OD_ACTIVATE_WEB_UPDATE__')) {
    html.window.location.reload();
    return;
  }
  try {
    js.context.callMethod('__OD_ACTIVATE_WEB_UPDATE__');
  } catch (_) {
    html.window.location.reload();
  }
}
