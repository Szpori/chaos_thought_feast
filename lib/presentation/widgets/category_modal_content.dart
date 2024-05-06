import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModalContent extends StatefulWidget {
  final Map<String, List<String>> categories;
  final Function(String) onSubcategorySelected;

  CategoryModalContent(
      {Key? key, required this.categories, required this.onSubcategorySelected})
      : super(key: key);

  @override
  _CategoryModalContentState createState() => _CategoryModalContentState();
}

class _CategoryModalContentState extends State<CategoryModalContent> {
  Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    widget.categories.forEach((key, value) {
      _expandedCategories[key] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.9,
      child: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              final categoryKey = widget.categories.keys.elementAt(index);
              _expandedCategories[categoryKey] = !_expandedCategories[categoryKey]!;
            });
          },
          children: widget.categories.entries.map<ExpansionPanel>((entry) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    final categoryKey = entry.key;
                    setState(() {
                      _expandedCategories[categoryKey] = !_expandedCategories[categoryKey]!;
                    });
                  },
                );
              },
              body: Column(
                children: entry.value.asMap().map((index, subcategory) {
                  return MapEntry(
                    index,
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            subcategory,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSubcategorySelected(subcategory);
                          },
                        ),
                        if (index != entry.value.length - 1) Divider(indent: 20),
                      ],
                    ),
                  );
                }).values.toList(),
              ),
              isExpanded: _expandedCategories[entry.key] ?? false,
            );
          }).toList(),
        ),
      ),
    );
  }
}
