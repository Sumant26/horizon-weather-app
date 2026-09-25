// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_interop';

@JS('window.horizonExporter.printOrSaveReport')
external void _jsPrintOrSaveReport(JSString title, JSString htmlBody);

@JS('window.horizonExporter.downloadMarkdown')
external void _jsDownloadMarkdown(JSString filename, JSString content);

void printOrSaveDossierReport(String title, String htmlBody) {
  try {
    _jsPrintOrSaveReport(title.toJS, htmlBody.toJS);
  } catch (_) {}
}

void downloadMarkdownDossier(String filename, String content) {
  try {
    _jsDownloadMarkdown(filename.toJS, content.toJS);
  } catch (_) {}
}
