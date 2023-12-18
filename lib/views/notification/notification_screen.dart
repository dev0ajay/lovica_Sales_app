import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lovica_sales_app/common/font_palette.dart';
import 'package:lovica_sales_app/models/notification_list_model.dart';
import 'package:lovica_sales_app/providers/notification_provider.dart';
import 'package:lovica_sales_app/generated/assets.dart';
import 'package:provider/provider.dart';
import '../../common/color_palette.dart';
import '../../common/constants.dart';
import '../../common/network_connectivity.dart';
import '../../services/app_data.dart';
import '../../widgets/common_header_tile.dart';
import '../../providers/authentication_provider.dart';
import '../../widgets/reusable_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerSub = ScrollController();
  final ValueNotifier<int> pageStartCount = ValueNotifier<int>(1);
  List oldNotification = [];

  @override
  void initState() {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    _scollListen(notificationProvider);
    Future.microtask(() {
      notificationProvider
        ..clearList()
        ..getNotificationList(
            context: context, limit: 20, start: 0, initialLoad: true);
    });
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _scollListen(NotificationProvider notificationProvider) {
    pageStartCount.value = pageStartCount.value + 20;
    scrollControllerSub.addListener(() {
      if (scrollControllerSub.position.pixels ==
          scrollControllerSub.position.maxScrollExtent) {
        if (notificationProvider.totPdtCount! >
            notificationProvider.totPdtCountAftrPagination!) {
          notificationProvider.getNotificationList(
              context: context,
              limit: 20,
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (notificationProvider.totPdtCount! >
            notificationProvider.totPdtCountAftrPagination!) {
          notificationProvider.getNotificationList(
              context: context,
              limit: 20,
              start: pageStartCount.value,
              initialLoad: false);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    scrollControllerSub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<AuthenticationProvider, NotificationProvider>(
          builder: (context, value, notProvider, child) {
            return NetworkConnectivity(
              inAsyncCall: value.loaderState == LoadState.loading ||
                  notProvider.loaderState == LoadState.loading,
              child: buildBody(context, notProvider),
            );
          },
        ),
      ),
    );
  }

  Column buildBody(BuildContext context, NotificationProvider notProvider) {
    return Column(
              crossAxisAlignment: AppData.appLocale == "ar"
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                HeaderTile(
                  showAppIcon: true,
                  title: Constants.notification,
                  onTapBack: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 20.h
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Wrap(
                    children: [
                      Text(
                        Constants.home,
                        style: FontPalette.grey10Italic,
                      ),
                      Text(" / ", style: FontPalette.grey10Italic),
                      Text(Constants.notification,
                          style: FontPalette.grey10Italic,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 29.h
                ),
                buildTabBar(),
                (notProvider.notificationList?.isNotEmpty ?? true)
                    ? Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: _tabController, // <-- Your TabBarView
                        children: [
                          buildGeneralTabView(notProvider),
                          buildIndividualTabView(notProvider),
                          buildTransactionTabView(notProvider),
                        ],
                      ),
                    )
                    : const SizedBox(),
                Center(
                    child: ReusableWidgets.paginationLoader(
                        notProvider.paginationLoader),
                ),
              ],
            );
  }

  TabBar buildTabBar() {
    return TabBar(
                  padding: EdgeInsets.zero,
                  controller: _tabController,
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: FontPalette.black15W500,
                  labelColor: Colors.black,
                  unselectedLabelColor: HexColor("#7A7A7A"),
                  tabs: [
                    Tab(
                        child: Text(
                      Constants.general,
                    )),
                    Tab(
                        child: Text(
                      Constants.personal,
                    )),
                    Tab(
                        child: Text(
                      Constants.transactions,
                    ),
                    ),
                  ],
                );
  }

  CupertinoScrollbar buildTransactionTabView(NotificationProvider notProvider) {
    return CupertinoScrollbar(
                            thumbVisibility: false,
                            // controller: scrollController,
                            thickness: 3,
                            child: buildTransactionListView(notProvider),
                          );
  }

  ListView buildTransactionListView(NotificationProvider notProvider) {
    return


    ListView.builder(
                              // controller: scrollController,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder:
                                  (BuildContext context, int inx) {
                                return Column(
                                  crossAxisAlignment:
                                      AppData.appLocale == "ar"
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: AppData.appLocale == "ar"
                                              ? 0
                                              : 14.h,
                                          right: AppData.appLocale == "ar"
                                              ? 14.h
                                              : 0,
                                          bottom: 11.h),
                                      child: Text(
                                        inx == 0 &&
                                                notProvider
                                                    .transListToday!
                                                    .isNotEmpty
                                            ? Constants.today
                                            : inx == 1 &&
                                                    notProvider.transList!
                                                        .isNotEmpty
                                                ? ""
                                        // Constants.old
                                                : "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        controller: scrollControllerSub,
                                        itemCount: inx == 0
                                            ? notProvider
                                                .transListToday!.length
                                            : notProvider
                                                .transList!.length,
                                        physics:
                                            const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context,
                                                int index) {
                                          NotificationItem? item =
                                          // notProvider
                                          //     .transList![index];
                                          inx ==
                                                  0
                                              ? notProvider
                                                  .transListToday![index]
                                              : notProvider
                                                  .transList![index];
                                          return Container(
                                            decoration:  BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10.w)),
                                              color:
                                              const Color(0xFFF5F5F5),
                                              boxShadow:  [
                                                BoxShadow(
                                                  color: Colors.grey.shade400,
                                                  blurRadius: 1.0, // soften the shadow
                                                  spreadRadius: 0.0, //extend the shadow
                                                  offset: const Offset(
                                                    1.0, // Move to right 10  horizontally
                                                    1.0, // Move to bottom 10 Vertically
                                                  ),

                                                ),
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 1.0, // soften the shadow
                                                  spreadRadius: 0.0, //extend the shadow
                                                  offset: const Offset(
                                                    -1.0, // Move to right 10  horizontally
                                                    -1.0, // Move to bottom 10 Vertically
                                                  ),
                                                ),

                                              ],

                                            ),
                                            margin: EdgeInsets.only(
                                                left: 12.w,
                                                right: 12.w,
                                                bottom: 16.h,
                                                top: 11.h),
                                            child: InkWell(
                                              splashColor: item.messageRead == 0?Colors.grey:Colors.transparent,

                                              onTap: () async{
                                                if (item.messageRead == 0) {
                                                  await notProvider.readNotification(context: context, id: item.id ?? "").then((value)  {
                                                    // if (value) {
                                                    // Future.microtask(() {
                                                      notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                    // });
                                                    // }
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                  padding: EdgeInsets.all(
                                                      11.w),
                                                  child:
                                                      AppData.appLocale ==
                                                              "ar"
                                                          ? Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment.topLeft,
                                                                  child:
                                                                      Text(
                                                                    item.dateFormatted ??
                                                                        "",
                                                                    maxLines:
                                                                        3,
                                                                    overflow:
                                                                        TextOverflow.ellipsis,
                                                                    style:
                                                                        FontPalette.black10w600,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          16.w,
                                                                    ),
                                                                    Directionality(
                                                                      textDirection:
                                                                          TextDirection.rtl,
                                                                      child:
                                                                          Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              item.titleAr ?? "",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.black14w600,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10.h,
                                                                            ),
                                                                            Text(
                                                                              item.messageAr ?? "",
                                                                              maxLines: 6,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.grey12Regular,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          16.w,
                                                                    ),
                                                                    Image
                                                                        .asset(
                                                                      item.messageRead == 0
                                                                          ? Assets.iconsNotifBelleNewIcon
                                                                          : Assets.iconsNotifIcon,
                                                                      height:
                                                                          28.h,
                                                                      width:
                                                                          40.w,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  10.h,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment.bottomLeft,
                                                                  child:
                                                                      Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        item.timeformatted ?? "",
                                                                        maxLines: 3,
                                                                        textAlign: TextAlign.end,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: FontPalette.black10w600,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (item.messageRead == 0) {
                                                                            notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                              if (value) {
                                                                                Future.microtask(() {
                                                                                  notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                });
                                                                              }
                                                                            });                                                                                }
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: SvgPicture.asset(
                                                                            item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                            height: item.messageRead == 0 ? 13.h : 18.h,
                                                                            width: item.messageRead == 0 ? 13.w : 13.h,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment.topRight,
                                                                  child:
                                                                      Text(
                                                                    item.dateFormatted ??
                                                                        "",
                                                                    maxLines:
                                                                        3,
                                                                    overflow:
                                                                        TextOverflow.ellipsis,
                                                                    style:
                                                                        FontPalette.black10w600,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    Image
                                                                        .asset(
                                                                      item.messageRead == 0
                                                                          ? Assets.iconsNotifBelleNewIcon
                                                                          : Assets.iconsNotifIcon,
                                                                      height:
                                                                          28.h,
                                                                      width:
                                                                          40.w,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          16.w,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            item.title ?? "",
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: FontPalette.black14w600,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10.h,
                                                                          ),
                                                                          Text(
                                                                            item.message ?? "",
                                                                            maxLines: 6,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: FontPalette.grey12Regular,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          16.w,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  10.h,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment.bottomRight,
                                                                  child:
                                                                      Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (item.messageRead == 0) {
                                                                            notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                              // if (value) {
                                                                                Future.microtask(() {
                                                                                  notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                });
                                                                              // }
                                                                            });                                                                                }
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: SvgPicture.asset(
                                                                            item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                            height: item.messageRead == 0 ? 13.h : 18.h,
                                                                            width: item.messageRead == 0 ? 13.w : 13.h,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 5.w,
                                                                      ),
                                                                      Text(
                                                                        item.timeformatted ?? "",
                                                                        maxLines: 3,
                                                                        textAlign: TextAlign.end,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: FontPalette.black10w600,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                            ),
                                          );
                                        }),
                                  ],
                                );
                              });
  }
///Individual Tab bar view
  CupertinoScrollbar buildIndividualTabView(NotificationProvider notProvider) {
    return CupertinoScrollbar(
                              thumbVisibility: false,
                              controller: scrollController,
                              thickness: 3,
                              child: buildIndividualListView(notProvider));
  }
///Individual tab list view method
  ListView buildIndividualListView(NotificationProvider notProvider) {
    return ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder:
                                    (BuildContext context, int inx) {
                                  return Column(
                                    crossAxisAlignment:
                                        AppData.appLocale == "ar"
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                AppData.appLocale == "ar"
                                                    ? 0
                                                    : 14.h,
                                            right:
                                                AppData.appLocale == "ar"
                                                    ? 14.h
                                                    : 0,
                                            bottom: 11.h),
                                        child: Text(
                                          inx == 0 &&
                                                  notProvider
                                                      .indListToday!
                                                      .isNotEmpty
                                              ? Constants.today
                                              : inx == 1 &&
                                                      notProvider.indList!
                                                          .isNotEmpty
                                                  ?
                                          ""
                                          // Constants.old
                                                  : "",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                          controller: scrollControllerSub,

                                          itemCount: inx == 0
                                              ? notProvider
                                                  .indListToday!.length
                                              : notProvider
                                                  .indList!.length,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            NotificationItem? item = inx ==
                                                    0
                                                ? notProvider
                                                    .indListToday![index]
                                                : notProvider
                                                    .indList![index];
                                            return Container(
                                              decoration:  BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.w)),
                                                color:
                                                const Color(0xFFF5F5F5),
                                                boxShadow:  [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 1.0, // soften the shadow
                                                    spreadRadius: 0.0, //extend the shadow
                                                    offset: const Offset(
                                                      1.0, // Move to right 10  horizontally
                                                      1.0, // Move to bottom 10 Vertically
                                                    ),

                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 1.0, // soften the shadow
                                                    spreadRadius: 0.0, //extend the shadow
                                                    offset: const Offset(
                                                      -1.0, // Move to right 10  horizontally
                                                      -1.0, // Move to bottom 10 Vertically
                                                    ),
                                                  ),

                                                ],

                                              ),

                                              margin: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  bottom: 16.h,
                                                  top: 11.h),
                                              child: InkWell(
                                                splashColor: item.messageRead == 0?Colors.grey:Colors.transparent,

                                                onTap: () {
                                                  if (item.messageRead == 0) {
                                                    notProvider.readNotification(context: context, id: item.id ?? "").then((value)  {
                                                      // if (value) {
                                                      notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);

                                                      // Future.microtask(() {
                                                      //   notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                      // });
                                                      // }
                                                    });                                                                                }
                                                },
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.all(
                                                            11.w),
                                                    child:
                                                        AppData.appLocale ==
                                                                "ar"
                                                            ? Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.topLeft,
                                                                    child:
                                                                        Text(
                                                                      item.dateFormatted ??
                                                                          "",
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow.ellipsis,
                                                                      style:
                                                                          FontPalette.black10w600,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 16.w
                                                                      ),
                                                                      Directionality(
                                                                        textDirection: TextDirection.rtl,
                                                                        child: Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                item.titleAr ?? "",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: FontPalette.black14w600,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10.h,
                                                                              ),
                                                                              Text(
                                                                                item.messageAr ?? "",
                                                                                maxLines: 6,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: FontPalette.grey12Regular,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 16.w
                                                                      ),
                                                                      Image.asset(
                                                                        item.messageRead == 0 ? Assets.iconsNotifBelleNewIcon : Assets.iconsNotifIcon,
                                                                        height: 28.h,
                                                                        width: 40.w,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                    10.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.bottomLeft,
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          item.timeformatted ?? "",
                                                                          maxLines: 3,
                                                                          textAlign: TextAlign.end,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: FontPalette.black10w600,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            if (item.messageRead == 0) {

                                                                              notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                                if (value) {
                                                                                  Future.microtask(() {
                                                                                    notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                  });
                                                                                }
                                                                              });                                                                                  }

                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: SvgPicture.asset(
                                                                              item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                              height: item.messageRead == 0 ? 13.h : 18.h,
                                                                              width: item.messageRead == 0 ? 13.w : 13.h,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.topRight,
                                                                    child:
                                                                        Text(
                                                                      item.dateFormatted ??
                                                                          "",
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow.ellipsis,
                                                                      style:
                                                                          FontPalette.black10w600,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Image.asset(
                                                                        item.messageRead == 0 ? Assets.iconsNotifBelleNewIcon : Assets.iconsNotifIcon,
                                                                        height: 28.h,
                                                                        width: 40.w,
                                                                      ),
                                                                      SizedBox(
                                                                        width: 16.w,
                                                                      ),
                                                                      Expanded(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              item.title ?? "",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.black14w600,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10.h,
                                                                            ),
                                                                            Text(
                                                                              item.message ?? "",
                                                                              maxLines: 6,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.grey12Regular,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 16.w,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                    10.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.bottomRight,
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.end,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            if (item.messageRead == 0) {
                                                                              notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                                if (value) {
                                                                                  Future.microtask(() {
                                                                                    notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                  });
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: SvgPicture.asset(
                                                                              item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                              height: item.messageRead == 0 ? 13.h : 18.h,
                                                                              width: item.messageRead == 0 ? 13.w : 13.h,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        Text(
                                                                          item.timeformatted ?? "",
                                                                          maxLines: 3,
                                                                          textAlign: TextAlign.end,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: FontPalette.black10w600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                              ),
                                            );
                                          }),
                                    ],
                                  );
                                });
  }


 ///General Tab bar view
  CupertinoScrollbar buildGeneralTabView(NotificationProvider notProvider) {
    return CupertinoScrollbar(
                            thumbVisibility: false,
                            controller: scrollController,
                            thickness: 3,
                            child: Padding(
                              padding:  EdgeInsets.zero,
                              child: buildGeneralListView(notProvider),
                            ),
                          );
  }
///General Tab list view method
  ListView buildGeneralListView(NotificationProvider notProvider) {
    return ListView.builder(
                              padding: EdgeInsets.zero,
                              // physics: BouncingScrollPhysics(),
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder:
                                    (BuildContext context, int inx) {
                                  return Column(
                                    crossAxisAlignment:
                                        AppData.appLocale == "ar"
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: AppData.appLocale == "ar"
                                                ? 0
                                                : 14.h,
                                            right: AppData.appLocale == "ar"
                                                ? 14.h
                                                : 0,
                                            bottom: 11.h),
                                        child: Text(
                                          inx < 1 &&
                                                  notProvider.genListToday!
                                                      .isNotEmpty
                                              ? Constants.today
                                              : inx >= 1  &&
                                                      notProvider.genList!
                                                          .isNotEmpty
                                                  ?
                                              ""
                                          // Constants.old
                                                  : "",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                          controller: scrollControllerSub,

                                          itemCount: inx == 0
                                              ? notProvider
                                                  .genListToday!.length
                                              : notProvider.genList!.length,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            NotificationItem? item = inx ==
                                                    0
                                                ? notProvider
                                                    .genListToday![index]
                                                : notProvider
                                                    .genList![index];
                                            return Container(
                                              decoration:  BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.w)),
                                                color:
                                                const Color(0xFFF5F5F5),
                                                boxShadow:  [
                                                  BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 1.0, // soften the shadow
                                                    spreadRadius: 0.0, //extend the shadow
                                                    offset: const Offset(
                                                      1.0, // Move to right 10  horizontally
                                                      1.0, // Move to bottom 10 Vertically
                                                    ),

                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 1.0, // soften the shadow
                                                    spreadRadius: 0.0, //extend the shadow
                                                    offset: const Offset(
                                                      -1.0, // Move to right 10  horizontally
                                                      -1.0, // Move to bottom 10 Vertically
                                                    ),
                                                  ),

                                                ],

                                              ),

                                              margin: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  bottom: 16.h,
                                                  top: 11.h),
                                              child: InkWell(
                                                splashColor: item.messageRead == 0 ? Colors.grey:Colors.transparent,

                                                onTap: () {
                                                  if (item.messageRead == 0) {
                                                    // oldNotification.add(item.id);

                                                    notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                      if (value) {

                                                      Future.microtask(() {
                                                        notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                      });
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Padding(
                                                    padding: EdgeInsets.all(
                                                        11.w),
                                                    child:
                                                        AppData.appLocale ==
                                                                "ar"
                                                            ? Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.topLeft,
                                                                    child:
                                                                        Text(
                                                                      item.dateFormatted ??
                                                                          "",
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow.ellipsis,
                                                                      style:
                                                                          FontPalette.black10w600,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            16.w,
                                                                      ),
                                                                      Directionality(
                                                                        textDirection:
                                                                            TextDirection.rtl,
                                                                        child:
                                                                            Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                item.titleAr ?? "",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: FontPalette.black14w600,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10.h,
                                                                              ),
                                                                              Text(
                                                                                item.messageAr ?? "",
                                                                                maxLines: 6,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: FontPalette.grey12Regular,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.w,
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        item.messageRead == 0
                                                                            ? Assets.iconsNotifBelleNewIcon
                                                                            : Assets.iconsNotifIcon,
                                                                        height:
                                                                            28.h,
                                                                        width:
                                                                            40.w,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.bottomLeft,
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          item.timeformatted ?? "",
                                                                          maxLines: 3,
                                                                          textAlign: TextAlign.end,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: FontPalette.black10w600,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            if (item.messageRead == 0) {
                                                                              notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                                if (value) {
                                                                                  Future.microtask(() {
                                                                                    notProvider..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                  });
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: SvgPicture.asset(
                                                                              item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                              height: item.messageRead == 0 ? 13.h : 18.h,
                                                                              width: item.messageRead == 0 ? 13.w : 13.h,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.topRight,
                                                                    child:
                                                                        Text(
                                                                      item.dateFormatted ??
                                                                          "",
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow.ellipsis,
                                                                      style:
                                                                          FontPalette.black10w600,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        item.messageRead == 0
                                                                            ? Assets.iconsNotifBelleNewIcon
                                                                            : Assets.iconsNotifIcon,
                                                                        height:
                                                                            28.h,
                                                                        width:
                                                                            40.w,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.w,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              item.title ?? "",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.black14w600,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10.h,
                                                                            ),
                                                                            Text(
                                                                              item.message ?? "",
                                                                              maxLines: 6,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FontPalette.grey12Regular,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.w,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                    10.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.bottomRight,
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.end,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                             if (item.messageRead == 0) {
                                                                              notProvider.readNotification(context: context, id: item.id ?? "").then((value) {
                                                                                if (value) {
                                                                                  Future.microtask(() {
                                                                                    notProvider ..clearList()..getNotificationList(context: context, limit: 0, start: 0, initialLoad: true);
                                                                                  });
                                                                                }
                                                                              });                                                                                }
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: SvgPicture.asset(
                                                                              item.messageRead == 1 ? "assets/icons/read_notif_icon.svg" : "assets/icons/unread_notif_icon.svg",
                                                                              height: item.messageRead == 0 ? 13.h : 18.h,
                                                                              width: item.messageRead == 0 ? 13.w : 13.h,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5.w,
                                                                        ),
                                                                        Text(
                                                                          item.timeformatted ?? "",
                                                                          maxLines: 3,
                                                                          textAlign: TextAlign.end,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: FontPalette.black10w600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                              ),
                                            );
                                          }),
                                    ],
                                  );
                                });
  }
}
