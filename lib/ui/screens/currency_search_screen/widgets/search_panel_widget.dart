import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/i18n/app_localization.dart';
import 'package:robs_currency_calculator/theme/colors.dart';

class SearchInputFieldWidget extends StatefulWidget {
  const SearchInputFieldWidget({Key key, this.onSearch, this.focusNode,
    this.width, this.hintText}) : super(key: key);

  final Function (String searchStr) onSearch;
  final FocusNode focusNode ;
  final double width;
  final String hintText;

  @override
  _SearchInputFieldWidgetState createState() => _SearchInputFieldWidgetState();
}

class _SearchInputFieldWidgetState extends State<SearchInputFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double displayWidth = MediaQuery.of(context).size.width;
    final translate = AppLocalizations.of(context).translate;
    return SizedBox(
      width: widget.width ?? displayWidth * 0.95,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: accentBlack,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                style: Theme.of(context).primaryTextTheme.headline4,
                textAlignVertical: TextAlignVertical.bottom,
                controller: _controller,
                focusNode: widget.focusNode,
                onSubmitted: (str){widget.onSearch(str);},
                onChanged: (str){ widget.onSearch(str);},
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 15, right: 8, bottom: 5),
                    child: Icon(Icons.search_sharp, size: 26, color:  accentWhite,),
                  ),
                  isDense: true,
                  prefixIconConstraints: const BoxConstraints(maxHeight: 26,),
                  border: InputBorder.none,
                  hintText: translate('SEARCH'),
                  hintStyle: Theme.of(context).primaryTextTheme.headline4,
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}