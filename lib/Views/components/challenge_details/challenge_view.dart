import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengeView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final ChallengeModel challenge;

  ChallengeView({
    @required this.animationController,
    @required this.animation,
    @required this.challenge,
  });

  @override
  _ChallengeViewState createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: widget.animation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 50 * (1.0 - widget.animation.value), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(4, 4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            color: AppTheme.background,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 8, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            widget.challenge.challengeName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        _buildRow('Target   ',
                                            '${widget.challenge.target} km'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _buildRow('Duration', _getDuration()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                                onTap: () {
                                  widget.challenge.isFavourite =
                                      !widget.challenge.isFavourite;
                                  model.updateChallenge(widget.challenge);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    widget.challenge.isFavourite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }

  String _getDuration() {
    String str = '';
    str =
        '${DateFormat("dd MMM").format(widget.challenge.startDate)} - ${DateFormat("dd MMM").format(widget.challenge.endDate)}';

    return str;
  }
}
