import 'package:flutter/material.dart';

class BottomSheetWidget1 extends StatefulWidget {
  final String end;
  final VoidCallback proceed;
  // final ScrollController scrollController;
  //final double bottomSheetOffset;
  BottomSheetWidget1({
    required this.end,
    required this.proceed,
    // required this.scrollController,
    //  required this.bottomSheetOffset,
    Key? key,
  }) : super(key: key);

  @override
  _BottomSheetWidget1State createState() => _BottomSheetWidget1State();
}

class _BottomSheetWidget1State extends State<BottomSheetWidget1> {
  Color color1 = Color(0XffEAEAEA);
  Color color2 = Color(0XffEAEAEA);
  Color color3 = Color(0XffEAEAEA);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.proceed,
      child: Container(
        height: 80, // Fixed height instead of half screen
        width: width,
        decoration: BoxDecoration(
          color: Color(0Xff4C6EE5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Confirm Location',
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Tap to proceed with selected location',
              style: TextStyle(
                fontSize: 12,
                decoration: TextDecoration.none,
                fontFamily: 'Roboto',
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
