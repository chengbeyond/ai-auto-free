import 'package:ai_auto_free/generated/l10n.dart';
import 'package:ai_auto_free/models/log_model.dart';
import 'package:flutter/material.dart';

class ConsoleView extends StatefulWidget {
  final bool consoleMinimized;
  final List<LogModel> consoleMessage;
  final void Function(bool) onConsoleMinimized;
  final void Function() onCopyConsoleMessage;
  final ScrollController scrollController;

  const ConsoleView({
    super.key,
    required this.consoleMinimized,
    required this.consoleMessage,
    required this.onConsoleMinimized,
    required this.onCopyConsoleMessage,
    required this.scrollController,
  });

  @override
  State<ConsoleView> createState() => _ConsoleViewState();
}

class _ConsoleViewState extends State<ConsoleView> {
  bool _copiedIcon = false;

  void _setCopiedIcon(bool value) {
    setState(() {
      _copiedIcon = value;
    });
  }

  void _onCopy() {
    widget.onCopyConsoleMessage();
    _setCopiedIcon(true);
    Future.delayed(const Duration(seconds: 1), () {
      _setCopiedIcon(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      constraints: const BoxConstraints(
        maxHeight: 150,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.consoleMinimized
              ? colorScheme.surfaceContainer
              : colorScheme.primaryFixed,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.terminal,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  "${S.of(context).console} ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "(${widget.consoleMessage.length})",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      widget.onConsoleMinimized(!widget.consoleMinimized),
                  icon: Icon(
                    widget.consoleMinimized
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _onCopy,
                  icon: Icon(
                    _copiedIcon ? Icons.check : Icons.copy,
                    size: 16,
                    color: _copiedIcon
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
            if (!widget.consoleMinimized) ...[
              const SizedBox(height: 8),
              Flexible(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colorScheme.surfaceContainerLow,
                        colorScheme.surfaceContainerLow,
                        colorScheme.surfaceContainerLow,
                      ],
                      stops: const [0.0, 0.08, 0.9, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: widget.scrollController,
                    itemCount: widget.consoleMessage.length,
                    itemBuilder: (context, index) {
                      final LogModel log = widget.consoleMessage[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "[${log.time.hour}:${log.time.minute.toString().padLeft(2, '0')}:${log.time.second.toString().padLeft(2, '0')}]",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.surfaceTint,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  log.translatedMessage ?? log.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'monospace',
                                    color: log.type == LogType.error
                                        ? colorScheme.error
                                        : log.type == LogType.success
                                            ? colorScheme.primary
                                            : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (log.logDatas != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    "(${log.logData})",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'monospace',
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
