import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherHelper {
  static PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  static String channelName = 'CoffeeShopOrderEventChannelName';

  static init() async {
    await pusher.init(
      apiKey: 'feaa930479d31c2d1ed9',
      cluster: 'mt1',
    );
    await pusher.connect();
  }
}
