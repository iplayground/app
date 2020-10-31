import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iplayground19/api/api.dart';
import 'package:iplayground19/api/src/sponsor.dart';
import 'package:iplayground19/bloc/data_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyCacheManager.dart';

center(Widget child) => Center(
        child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 680),
      child: Container(width: double.infinity, child: child),
    ));

centerGrid(context, Widget grid) {
  var padding = (MediaQuery.of(context).size.width - 680) / 2;
  if (padding < 0) {
    padding = 20;
  }
  return SliverPadding(
    padding: EdgeInsets.only(left: padding, right: padding),
    sliver: grid,
  );
}

class AboutPage extends StatefulWidget {
  final ScrollController scrollController;

  AboutPage({Key key, this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final logo = SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver:
            SliverToBoxAdapter(child: center(Image.asset('images/logo.png'))));
    final venueSection = makeVenue();
    final aboutSection = makeAboutUs();
    final sponsorTitle = SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver: SliverToBoxAdapter(
            child: center(_AboutSectionTitle(text: 'Sponsors 贊助'))));

    final coTitle = SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver: SliverToBoxAdapter(
            child: center(_AboutSectionTitle(text: 'Co-organizers 合作夥伴'))));

    final staffTitle = SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver: SliverToBoxAdapter(
            child: center(_AboutSectionTitle(text: 'Staffs 工作人員'))));

    // --

    // ignore: close_sinks
    DataBloc bloc = BlocProvider.of(context);
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text('關於')),
        child: Scrollbar(
          child: Center(
              child: BlocBuilder<DataBloc, DataBlocState>(
            cubit: bloc,
            builder: (context, state) {
              var slivers = <Widget>[];
              slivers.add(SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top)));
              slivers.addAll([logo, venueSection, aboutSection, sponsorTitle]);
              slivers.addAll(makeSponsorGrid(state));
              slivers.addAll([
                coTitle,
                centerGrid(context, makeCoOrganizersGrid(state)),
                staffTitle,
              ]);
              slivers.addAll(makeStaffGrid(state));
              slivers.add(
                SliverToBoxAdapter(
                    child:
                        SizedBox(height: MediaQuery.of(context).padding.top)),
              );
              return CustomScrollView(
                slivers: slivers,
                controller: widget.scrollController,
              );
            },
          )),
        ));
  }

  Widget makeAboutUs() {
    final aboutWidgets = <Widget>[
      _AboutSectionTitle(text: 'About 關於我們'),
      center(Text(
          '2017年9月，一群到東京參加 iOSDC 的工程師們，在看到國外蓬勃活躍的程式力，熱血自此被點燃，決心舉辦一場兼具廣深度又有趣的 iOS 研討會。')),
      SizedBox(height: 5),
      center(Text(
          '2018年10月，有實戰技巧、初心者攻略、hard core 議題以及各式八卦政治學的 iPlaygrouond 華麗登場。')),
      SizedBox(height: 5),
      center(Text('在這裡，iPlayground 誠摯召喚各位鍵盤好手一起來燃燒熱血，讓議程更多元、更有料！'))
    ];
    final aboutSection =
        SliverList(delegate: SliverChildListDelegate(aboutWidgets));
    return SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver: aboutSection);
  }

  makeCoOrganizersGrid(DataBlocState state) {
    if (state is DataBlocLoadingState) {
      return SliverPadding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          sliver: SliverToBoxAdapter(child: CupertinoActivityIndicator()));
    }
    if (state is DataBlocErrorState) {
      return SliverPadding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          sliver: SliverToBoxAdapter(child: Text('資料載入失敗')));
    }

    if (state is DataBlocLoadedState) {
      var data = state.sponsors.partners;
      return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = data[index];
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => launch(item.link),
                  child: Container(),
                ),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(item.iconUrl))),
            );
          });
        }, childCount: (data != null) ? data.length : 0),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          crossAxisSpacing: 10.0,
        ),
      );
    }
  }

  List<Widget> makeSponsorGrid(DataBlocState state) {
    if (state is DataBlocLoadingState) {
      return [
        SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverToBoxAdapter(child: CupertinoActivityIndicator()))
      ];
    }
    if (state is DataBlocErrorState) {
      return [
        SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverToBoxAdapter(child: Text('資料載入失敗')))
      ];
    }

    if (state is DataBlocLoadedState) {
      var widgets = <Widget>[];
      for (final section in state.sponsors.sections) {
        final title =
            SliverToBoxAdapter(child: _SponsorTitle(text: section.title));
        final grid =
            centerGrid(context, _SponsorGrid(sponsors: section.sponsors));
        widgets.add(title);
        widgets.add(grid);
      }
      return widgets;
    }

    return [SliverToBoxAdapter(child: Container())];
  }

  List<Widget> makeStaffGrid(DataBlocState state) {
    if (state is DataBlocLoadingState) {
      return [
        SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverToBoxAdapter(child: CupertinoActivityIndicator()))
      ];
    }
    if (state is DataBlocErrorState) {
      return [
        SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverToBoxAdapter(child: Text('資料載入失敗')))
      ];
    }

    if (state is DataBlocLoadedState) {
      return [
        centerGrid(
            context,
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = state.staffs[index];
                return LayoutBuilder(builder: (context, constraints) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (item.linkUrl != null) {
                          launch(item.linkUrl, forceSafariVC: false);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                              child: CachedNetworkImage(
                            cacheManager: new MyCacheManager(),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: item.imageUrl ?? "",
                            errorWidget: (context, url, error) =>
                                Image(image: AssetImage("images/nopic.png")),
                          )),
                          SizedBox(height: 4),
                          Text(item.name, style: TextStyle(fontSize: 22.0)),
                          SizedBox(height: 4),
                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }, childCount: (state.staffs != null) ? state.staffs.length : 0),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10.0),
            ))
      ];
    }
    return [];
  }

  Widget makeVenue() {
    final venueWidgets = <Widget>[
      _AboutSectionTitle(text: 'Venue 場地'),
      center(Row(
        children: <Widget>[
          Text('張榮發基金會 國際會議中心'),
          CupertinoButton(
            child: Text('[ 地圖 ]'),
            onPressed: () {
              var url = 'https://goo.gl/maps/umbd6vS92QWqSQXq8';
              launch(url, forceSafariVC: false);
            },
          )
        ],
      )),
      center(Text('台北市中正區中山南路11號')),
    ];
    final venueSection =
        SliverList(delegate: SliverChildListDelegate(venueWidgets));
    return SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        sliver: venueSection);
  }
}

class _AboutSectionTitle extends StatelessWidget {
  final String text;

  const _AboutSectionTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return center(Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text,
              style:
                  CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
          Divider(color: Colors.grey),
        ],
      ),
    ));
  }
}

class _SponsorGrid extends StatelessWidget {
  final List<Sponsor> sponsors;

  const _SponsorGrid({
    Key key,
    @required this.sponsors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sponsors.length == 1) {
      return SliverPadding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          sliver: SliverToBoxAdapter(
              child: center(_sponsorCell(sponsor: sponsors[0]))));
    } else {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final sponsor = sponsors[index];
          return _sponsorCell(sponsor: sponsor);
        }, childCount: (sponsors != null) ? sponsors.length : 0),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.7,
        ),
      );
    }
  }

  Widget _sponsorCell({Sponsor sponsor}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (sponsor.link != null) {
            launch(sponsor.link, forceSafariVC: false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(sponsor.imageUrl))),
                );
              }),
              SizedBox(height: 10),
              Text(sponsor.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _SponsorTitle extends StatelessWidget {
  final String text;

  const _SponsorTitle({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return center(Container(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ));
  }
}
