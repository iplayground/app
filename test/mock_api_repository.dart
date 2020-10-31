import 'dart:convert';

import 'package:iplayground19/api/api.dart';
import 'package:mockito/mockito.dart';

class MockAPIRepository extends Mock implements APIRepository {
  static MockAPIRepository presetMockRepository() {
    var repository = MockAPIRepository();

    const jsonSponsors = '{"sponsors":[{"items":[{"name":"17 Media","picture":"https://raw.githubusercontent.com/iplayground/SessionData/master/images/sponsor/logo_17_Media.png","link":"https://m17.asia/"}],"title":"鑽石贊助"}],"partner":[{"name":"TWDC","icon":"https://raw.githubusercontent.com/iplayground/SessionData/2019/v2/images/partner/logo_twdc.png","link":"https://aatp.com.tw/"}]}';
    Sponsors mockSponsors = Sponsors(json.decode(jsonSponsors));
    when(repository.fetchSponsors())
        .thenAnswer((realInvocation) => Future.value(mockSponsors));

    const jsonPrograms =
        '{"slides_url":"","review_tags":[],"id":106,"title":"Beyond a player: CarPlay and MFI Hearing Aids","track":null,"abstract":"Nowadays the music experience for iOS devices is not merely limited on speakers and headsets, but already expanded to  modern car systems, hearing aids and more.This brings challenges to music services like KKBOX, since some audio APIs behave in unexpectedly ways and some of them are not actually well documented, while playing audio on these new output devices.\\r\\n\\r\\nThe talks covers how we encountered and solved the challenges, although they might not be good solutions.\\r\\n","video_url":"","custom_fields":{"SNS":"https://twitter.com/zonble"},"speakers":[{"name":"zonble","bio":"A Taipei-based developer working at KKBOX. Started developing in Objective-C language for macOS since 2005 and became an iOS developer since 2008 when iPhone SDK was out. Contributed to products including Yahoo! KeyKey Input Method, Boshiamy Input Method for macOS, KKBOX for macOS/iOS/tvOS, Uta Pass for iOS and so on. Wrote a free online e-book in Chinese about iOS development in 2015.\\r\\nHis latest work is KKBOX Kids, a new audio app with latest Flutter technology parenting contents from KKBOX."}]}';
    List<Program> mockPrograms = [Program(json.decode(jsonPrograms))];
    when(repository.fetchPrograms())
        .thenAnswer((realInvocation) => Future.value(mockPrograms));


    const jsonSessions =
        '{"end_time":"10:40","desc":"Nowadays the music experience for iOS devices is not merely limited on speakers and headsets, but already expanded to  modern car systems, hearing aids and more.\\r\\n\\r\\nThis brings challenges to music services like KKBOX, since some audio APIs behave in unexpectedly ways and some of them are not actually well documented, while playing audio on these new output devices.\\r\\n\\r\\nThe talks covers how we encountered and solved the challenges, although they might not be good solutions.\\r\\n","proposal_id":"prop_106","start_time":"10:00","session_id":81,"title":"Beyond a player: CarPlay and MFI Hearing Aids","presenter":"zonble","room_name":"101","track_name":null,"conference_day":1}';
    List<Session> mockSessions = [Session(json.decode(jsonSessions))];
    when(repository.fetchSessions())
        .thenAnswer((realInvocation) => Future.value(mockSessions));

    return repository;
  }
}
