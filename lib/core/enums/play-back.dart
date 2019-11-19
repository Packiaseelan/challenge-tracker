enum Playback {
  /// Animation stands still.
  PAUSE,

  /// Animation plays forwards and stops at the end.
  PLAY_FORWARD,

  /// Animation plays backwards and stops at the beginning.
  PLAY_REVERSE,

  /// Animation will reset to the beginning and start playing forward.
  START_OVER_FORWARD,

  /// Animation will reset to the end and start play backward.
  START_OVER_REVERSE,

  /// Animation will play forwards and start over at the beginning when it
  /// reaches the end.
  LOOP,

  /// Animation will play forward until the end and will reverse playing until
  /// it reaches the beginning. Then it starts over playing forward. And so on.
  MIRROR
}