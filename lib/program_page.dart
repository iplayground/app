import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:iplayground19/room_label.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api/api.dart';

class ProgramPage extends StatefulWidget {
  final Session session;

  ProgramPage({Key key, this.session}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  @override
  Widget build(BuildContext context) {
    var text = widget.session.description;
    if (text.contains('<p>') || text.contains('<h4>')) {
      text = html2md.convert(text);
    }
    var widgets = <Widget>[
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: <Widget>[RoomLabel(session: widget.session)]),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          widget.session.title,
          locale: Locale('zh', 'TW'),
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          widget.session.presenter,
          locale: Locale('zh', 'TW'),
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          '第 ${widget.session.conferenceDay} 天  ${widget.session.startTime} - ${widget.session.endTime}',
          locale: Locale('zh', 'TW'),
        ),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: OurMarkdown(
          data: text,
          onTapLink: (link) => launch(link),
        ),
      ),
      SizedBox(height: 30),
    ];

    var body = CustomScrollView(
      slivers: [SliverList(delegate: SliverChildListDelegate(widgets))],
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: SafeArea(
        child: Scrollbar(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 640.0),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

class OurMarkdown extends MarkdownWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  const OurMarkdown({
    Key key,
    String data,
    MarkdownStyleSheet styleSheet,
    SyntaxHighlighter syntaxHighlighter,
    MarkdownTapLinkCallback onTapLink,
    Directory imageDirectory,
    this.padding: const EdgeInsets.all(16.0),
  }) : super(
          key: key,
          data: data,
          styleSheet: styleSheet,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          imageDirectory: imageDirectory,
        );

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, List<Widget> children) {
    return Column(children: children);
  }
}