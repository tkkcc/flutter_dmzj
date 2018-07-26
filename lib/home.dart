import 'package:flutter/material.dart';
import 'package:flutter_dmzj/account/index.dart';
import 'package:flutter_dmzj/comic/index.dart';
import 'package:flutter_dmzj/news/index.dart';
import 'package:flutter_dmzj/novel/index.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationDemo();
  }
}

// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
    Widget page,
  })  : page = page,
        color = color,
        item = BottomNavigationBarItem(
          icon: icon,
          //  activeIcon: activeIcon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }
  final Widget page;
  final Color color;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    // Color iconColor;

    // final ThemeData themeData = Theme.of(context);
    // iconColor = themeData.brightness == Brightness.light
    //     ? themeData.primaryColor
    //     : themeData.accentColor;

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: page,
      ),
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.home),
        title: '漫画',
        page: ComicPage(),
        // color: Colors.deepPurple,
        vsync: this,
      ),
      NavigationIconView(
        // activeIcon:  CustomIcon(),
        icon: const Icon(Icons.message),
        title: '新闻',
        page: NewsPage(),

        // color: Colors.deepOrange,
        vsync: this,
      ),
      NavigationIconView(
        // activeIcon: const Icon(Icons.cloud),
        icon: const Icon(Icons.book),
        title: '轻小说',
        page: NovelPage(),

        vsync: this,
      ),
      NavigationIconView(
        icon: const Icon(Icons.account_circle),
        page: AccountPage(),
        title: '我的',
        // color: Colors.pink,
        vsync: this,
      )
    ];
    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);
    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the ly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      body: Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}
