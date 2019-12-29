import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';

class SubTitleBar extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isPopup;
  SubTitleBar({
    @required this.title,
    @required this.onTap,
    @required this.isPopup,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Container(
        color: isPopup ? AppTheme.primaryColor : Colors.transparent,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: _getLeftIcon(context),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isPopup ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _getRight(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLeftIcon(BuildContext context) {
    if (isPopup) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return SizedBox();
  }

  Widget _getRight() {
    if (isPopup) {
      return SizedBox();
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
