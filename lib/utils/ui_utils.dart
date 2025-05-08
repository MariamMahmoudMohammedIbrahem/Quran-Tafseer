import '../commons.dart';

// --> Reusable button widget used in the home screen
// class HomeButton extends StatelessWidget {
//   final String title; // Button title
//   final VoidCallback onTap; // Action when pressed
//
//   const HomeButton({super.key, required this.title, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green[700], // Button background color
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20), // Rounded corners
//         ),
//         elevation: 5, // Shadow elevation
//       ), // Handle button press
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//         child: Text(
//           title,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

// --> Build single dot for page indicator
Widget buildDot(int index, int currentPage) {
  return Container(
    height: currentPage == index ? 12 : 8,
    width: currentPage == index ? 12 : 8, // Active dot is wider
    margin: EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      color: currentPage == index ? MyColors.deepGreen : MyColors.darkGrey, // Active color
      // borderRadius: BorderRadius.circular(20),
      shape: BoxShape.circle,
    ),
  );
}