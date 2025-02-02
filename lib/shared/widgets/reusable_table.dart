import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final bool enableRowSelection;
  final int? selectedRowIndex;
  final Function(int)? onRowSelected;
  final Function(int)? onRemoveRow;
  final bool showActions;
  final Color backgroundColor;
  final Color selectionColor;
  final Color headerColor;
  final Color headerTextColor;
  final double headerTextSize;
  final Color bodyTextColor;
  final double bodyTextSize;
  final Color selectedTextColor;
  final List<Color>? rowColors;
  final Map<int, TableColumnWidth>? columnWidths;
  final double rowHeight;
  final TextAlign cellTextAlign;
  final double? maxHeight;
  final double? minHeight;

  const CustomDataTable({
    super.key,
    required this.headers,
    required this.data,
    this.enableRowSelection = false,
    this.selectedRowIndex,
    this.onRowSelected,
    this.onRemoveRow,
    this.showActions = true,
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.selectionColor = const Color(0xFFBBDEFB),
    this.headerColor = const Color(0xFF1976D2),
    this.headerTextColor = Colors.white,
    this.headerTextSize = 16.0,
    this.bodyTextColor = Colors.black,
    this.bodyTextSize = 14.0,
    this.selectedTextColor = Colors.black,
    this.rowColors,
    this.columnWidths,
    this.rowHeight = 48.0,
    this.cellTextAlign = TextAlign.left,
    this.maxHeight,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: bodyTextColor,
          fontSize: bodyTextSize,
        );
    final selectedTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: selectedTextColor,
          fontSize: bodyTextSize,
        );

    return Container(
      color: backgroundColor,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? (maxHeight ?? 0),
      ),
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Table(
              columnWidths: columnWidths ??
                  const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: IntrinsicColumnWidth(),
                  },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  children: headers.map((header) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        header,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: headerTextColor,
                                  fontSize: headerTextSize,
                                ),
                        textAlign: cellTextAlign,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: columnWidths ??
                      const {
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: IntrinsicColumnWidth(),
                      },
                  children: data.map((rowData) {
                    final rowIndex = data.indexOf(rowData);
                    final isSelected =
                        enableRowSelection && rowIndex == selectedRowIndex;
                    final rowColor = rowColors != null
                        ? rowColors![rowIndex]
                        : bodyTextColor;

                    return TableRow(
                      decoration: BoxDecoration(
                        color: isSelected ? selectionColor : Colors.transparent,
                        borderRadius: rowIndex == data.length - 1
                            ? const BorderRadius.all(Radius.circular(8))
                            : BorderRadius.circular(8),
                      ),
                      children: [
                        ...rowData.map((cellData) {
                          return TableCell(
                            child: GestureDetector(
                              onTap: enableRowSelection
                                  ? () {
                                      if (onRowSelected != null) {
                                        onRowSelected!(rowIndex);
                                      }
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.all(rowHeight / 4),
                                child: Text(
                                  cellData,
                                  style: isSelected
                                      ? selectedTextStyle
                                      : defaultTextStyle?.copyWith(
                                          color: rowColor),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: cellTextAlign,
                                ),
                              ),
                            ),
                          );
                        }),
                        if (showActions)
                          TableCell(
                            child: Center(
                              child: IconButton(
                                icon: const Icon(IconsaxPlusLinear.trash),
                                color: Colors.red[300],
                                onPressed: () {
                                  if (onRemoveRow != null) {
                                    onRemoveRow!(rowIndex);
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
