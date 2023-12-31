import 'package:flutter/material.dart';

class ImageSheet extends StatelessWidget {
  const ImageSheet({
    super.key,
    required this.title,
    required this.onCameraPress,
    required this.onGalleryPress,
    required this.onViewPress,
    required this.tooltip,
    required this.icon,
    required this.onIconPress,
  });

  final String title;
  final String tooltip;
  final IconData icon;
  final Function onIconPress;
  final Function onCameraPress;
  final Function onGalleryPress;
  final Function onViewPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100)),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => onIconPress(),
                icon: Icon(icon),
                tooltip: tooltip,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    tooltip: 'Camera',
                    onPressed: () => onCameraPress(),
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Camera",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    tooltip: 'Gallery',
                    onPressed: () => onGalleryPress(),
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Gallery",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                children: [
                  IconButton(
                    tooltip: 'View Image',
                    onPressed: () => onViewPress(),
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "View Image",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
