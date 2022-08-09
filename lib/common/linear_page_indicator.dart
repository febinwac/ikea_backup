import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/linear_progress_page_indicator.dart';
import 'package:sfm_module/common/colors.dart';
import 'package:sfm_module/common/common_loader.dart';

import '../models/product_model.dart';

class LinearProgressImageIndicator extends StatelessWidget {
  List<MediaGallery>? mediaGallery;

  LinearProgressImageIndicator({required this.mediaGallery});

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildImageView(context),
          (mediaGallery == null || mediaGallery!.length == 1)
              ? Container()
              : _buildLinearImageIndicator(context),
        ],
      ),
    );
  }

  _buildImageView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.42,
      //color: white,
      child: PageView.builder(
          itemCount: mediaGallery?.length ?? 1,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 1000),
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              imageUrl:
                  mediaGallery != null ? mediaGallery![index].jpgUrl! : '',
              placeholder: (context, url) => const CommonContainerShimmer(),
              errorWidget: (context, url, error) =>
                  const CommonContainerShimmer(),
            );
          },
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildLinearImageIndicator(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              LinearProgressPageIndicator(
            itemCount: mediaGallery!.length,
            currentPageNotifier: _currentPageNotifier,
            progressColor: HexColor(black),
            backgroundColor: HexColor('E5E5E5'),
            width: constraints.maxWidth,
            height: 2,
          ),
        ));
  }
}
