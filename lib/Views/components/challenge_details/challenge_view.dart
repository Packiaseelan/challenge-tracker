import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
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
  MainModel _model;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
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
                                        _buildRow(
                                            'Target',
                                            _buildLabel(
                                                '${widget.challenge.target} km',
                                                null)),
                                        SizedBox(height: 10),
                                        _buildRow('Duration', _getDuration()),
                                        SizedBox(height: 10),
                                        _buildRow('Status', _getStatus()),
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
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                                onTap: () {
                                  model.deleteChallenge(widget.challenge);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete_outline,
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

  Widget _buildRow(String title, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          width: 80,
          child: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }

  Widget _getDuration() {
    return _buildLabel(widget.challenge.getDurationToString(), null);
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 20,
        color: color == null ? Colors.black.withOpacity(0.8) : color,
      ),
    );
  }

  Widget _getStatus() {
    var date = DateTime.now();
    var start = widget.challenge.startDate;
    var end = widget.challenge.endDate;
    double covered = widget.challenge.initial;
    if (start.isAfter(date)) {
      return _buildLabel('Not yet started', Colors.cyan);
    }

    var rides = _model.rides
        .where((ride) =>
            (ride.createdDate.day >= start.day &&
                ride.createdDate.month >= start.month &&
                ride.createdDate.year >= start.year) &&
            (ride.createdDate.day <= end.day &&
                ride.createdDate.month <= end.month &&
                ride.createdDate.year <= end.year))
        .toList();

    rides.forEach((f) => covered += f.kmCovered);

    if (covered >= widget.challenge.target) {
      return _buildLabel('Completed', Colors.green);
    }

    if ((end.difference(date).inDays + 1) == 0) {
      if (covered < widget.challenge.target)
        return _buildLabel('InCompleted', Colors.red);
      else
        return _buildLabel('Completed', Colors.green);
    } else {
      return _buildLabel('InProgress', Colors.indigo);
    }
  }
}
