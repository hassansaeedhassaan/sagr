import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  late RtcEngine _engine;

  Future<void> initialize(String appId) async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.enableAudio();
  }

 
  Future<void> joinChannel(String token, String channelName, int userId) async {
    await _engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: userId,
        // options: const ChannelMediaOptions(),
        options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ));
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> setUserRole(ClientRoleType role) async {


await _engine.setEnableSpeakerphone(true);
    await _engine.setClientRole(role: role);
    
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );

  }


  Future<void> muteLocalAudio(bool mute) async {
    await _engine.muteLocalAudioStream(mute);
  }

  Future<void> destroy() async {
    await _engine.release();
  }
}
