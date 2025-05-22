import '../commons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final currentFontLevel = themeProvider.currentFontLevel;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Settings')),
        backgroundColor: MyColors.red,
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Settings Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),

            // 🌓 Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleDarkMode(value);
              },
            ),
            const Divider(),

            // 🔡 Font Size Slider (3 levels only)
            ListTile(
              title: const Text('Font Size'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: currentFontLevel.toDouble(),
                    min: 0,
                    max: 2,
                    divisions: 2,
                    label: ['Small', 'Medium', 'Large'][currentFontLevel],
                    onChanged: (value) {
                      themeProvider.setFontLevel(value.toInt());
                    },
                  ),
                ],
              ),
            ),
            const Divider(),

            // ⬇️ Downloaded Audio
            ListTile(
              title: const Text('Downloaded Audio'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This feature will be added soon')),
                );
              },
            ),
            const Divider(),

            // ℹ️ About
            ListTile(
              title: const Text('About the App'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Quran App',
                  applicationVersion: 'Version 1.0.0',
                  children: const [
                    Text('An app for reading and listening to the Quran with Tafsir'),
                    SizedBox(height: 8),
                    Text('Privacy policy will be added soon'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
