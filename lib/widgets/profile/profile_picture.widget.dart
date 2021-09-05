import 'package:demos_app/widgets/general/bucket_image.image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final VoidCallback? onPictureEditPress;
  final String? imageKey;

  const ProfilePicture({
    Key? key,
    this.onPictureEditPress,
    this.imageKey,
  }) : super(key: key);

  bool get editable => onPictureEditPress != null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        getImage(size),
        Positioned(
            bottom: 0,
            right: 0,
            child: this.editable
                ? FloatingActionButton(
                    elevation: 0,
                    mini: true,
                    child: Icon(Icons.photo_camera),
                    onPressed: onPictureEditPress,
                  )
                : Container())
      ],
    );
  }

  Widget getImage(size) {
    double width = size.width * 0.4;
    return imageKey == null ? getDefaultImage(width) : getProfileImage(width);
  }

  Widget getDefaultImage(double width) {
    return Image(
        image: AssetImage('assets/images/default-profile.png'),
        width: width,
        height: width,
        fit: BoxFit.cover);
  }

  Widget getProfileImage(double width) {
    return BucketImage(
        imageKey: imageKey, width: width, boderRadius: width / 2);
  }
}
