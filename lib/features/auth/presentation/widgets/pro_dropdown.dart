import 'package:flutter/material.dart';

class ProDropdown<T> extends StatefulWidget {
  final List<ProDropdownOption<T>> items;
  final List<T>? selectedValues;
  final T? selectedValue;
  final bool multiSelect;
  final String? hint;
  final String? searchHint;
  final Function(List<T>)? onMultiChanged;
  final Function(T?)? onChanged;
  final bool showSearch;
  final double maxHeight;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final InputDecoration? decoration;
  final bool enabled;

  const ProDropdown({
    Key? key,
    required this.items,
    this.selectedValues,
    this.selectedValue,
    this.multiSelect = false,
    this.hint,
    this.searchHint,
    this.onMultiChanged,
    this.onChanged,
    this.showSearch = true,
    this.maxHeight = 300,
    this.itemLabelBuilder,
    this.itemBuilder,
    this.decoration,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ProDropdown<T>> createState() => _ProDropdownState<T>();
}

class _ProDropdownState<T> extends State<ProDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<ProDropdownOption<T>> _filteredItems = [];
  List<T> _tempSelectedValues = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _tempSelectedValues = widget.selectedValues ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: _buildDropdownList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    _filteredItems = widget.items;
  }

  Widget _buildDropdownList() {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSearch) _buildSearchField(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = widget.multiSelect
                    ? _tempSelectedValues.contains(item.value)
                    : widget.selectedValue == item.value;

                return InkWell(
                  onTap: () => _handleItemTap(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.blue.shade50 : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        if (widget.multiSelect)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        Expanded(
                          child: widget.itemBuilder != null
                              ? widget.itemBuilder!(item.value)
                              : Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.blue.shade700
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.multiSelect) _buildMultiSelectActions(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.searchHint ?? 'Search...',
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _filterItems('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
        onChanged: _filterItems,
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
                item.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _handleItemTap(ProDropdownOption<T> item) {
    if (widget.multiSelect) {
      setState(() {
        if (_tempSelectedValues.contains(item.value)) {
          _tempSelectedValues.remove(item.value);
        } else {
          _tempSelectedValues.add(item.value);
        }
      });
      _overlayEntry?.markNeedsBuild();
    } else {
      widget.onChanged?.call(item.value);
      _removeOverlay();
      setState(() {});
    }
  }

  Widget _buildMultiSelectActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _tempSelectedValues.clear();
              });
              _overlayEntry?.markNeedsBuild();
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onMultiChanged?.call(_tempSelectedValues);
              _removeOverlay();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    if (widget.multiSelect) {
      if (_tempSelectedValues.isEmpty) {
        return widget.hint ?? 'Select items';
      }
      return '${_tempSelectedValues.length} selected';
    } else {
      if (widget.selectedValue == null) {
        return widget.hint ?? 'Select an item';
      }
      final item = widget.items.firstWhere(
        (item) => item.value == widget.selectedValue,
        orElse: () => ProDropdownOption(
            value: widget.selectedValue as T, label: widget.hint!),
      );
      return item.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputDecorator(
        decoration: widget.decoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
        child: InkWell(
          onTap: _toggleDropdown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.enabled ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
              Icon(
                _overlayEntry == null
                    ? Icons.arrow_drop_down
                    : Icons.arrow_drop_up,
                color: widget.enabled ? Colors.grey.shade700 : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model for dropdown options
class ProDropdownOption<T> {
  final T value;
  final String label;

  ProDropdownOption({required this.value, required this.label});
}
