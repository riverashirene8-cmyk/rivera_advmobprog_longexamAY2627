import 'package:rivera_mobprog/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivera_mobprog/widgets/custom_font.dart';

void customDialog(BuildContext context, {required title, required content}) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fbDarkPrimary,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Okay'),
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

void customOptionDialog(
  BuildContext context, {
  required title,
  required content,
  required Function onYes,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: CustomFont(text: title, fontSize: 30.sp, color: Colors.black),
    content: CustomFont(text: content, fontSize: 14.sp, color: Colors.black),
    actions: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: CustomFont(text: 'No', fontSize: 14.sp, color: Colors.black),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fbDarkPrimary,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onYes();
        },
        child: CustomFont(
          text: 'Yes',
          fontSize: 14.sp,
          color: fbTextColorWhite,
        ),
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

void customShowImageDialog(BuildContext context, {required imageUrl}) {
  AlertDialog alertDialog = AlertDialog(
    content: SizedBox(
      height: 300.h,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
                color: fbDarkPrimary,
                value: downloadProgress.progress,
              ),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 100.sp),
        ),
      ),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}
