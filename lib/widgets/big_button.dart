import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  const BigButton({
    super.key,
    this.onPressed,
    required this.title,
    this.backgroundColor,
  });

  final Function()? onPressed;
  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        // backgroundColor: const Color(0xFF21C69F),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class BigOutlinedButton extends StatelessWidget {
  const BigOutlinedButton({
    super.key,
    this.onPressed,
    required this.title,
  });

  final Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class BigButtonLoading extends StatelessWidget {
  const BigButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }
}

class BigOutlinedButtonWithIcon extends StatelessWidget {
  const BigOutlinedButtonWithIcon({
    super.key,
    this.onPressed,
    required this.title,
    required this.icon,
  });

  final Function()? onPressed;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(icon)
        ],
      ),
    );
  }
}

class BigOutlinedButtonLoading extends StatelessWidget {
  const BigOutlinedButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      height: 48,
      decoration: ShapeDecoration(
        color: Color(0x00C14CF8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor, strokeWidth: 3),
      ),
    );
  }
}
