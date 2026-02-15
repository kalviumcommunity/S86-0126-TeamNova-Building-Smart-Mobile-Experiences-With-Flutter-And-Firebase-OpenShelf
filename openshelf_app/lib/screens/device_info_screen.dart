import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

/// Device Information Screen
/// Displays detailed device and app information for testing purposes
class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    setState(() => _isLoading = true);

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      Map<String, dynamic> deviceData = {};

      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceData = {
          'Platform': 'Android',
          'Device': androidInfo.device,
          'Model': androidInfo.model,
          'Manufacturer': androidInfo.manufacturer,
          'Brand': androidInfo.brand,
          'Android Version': androidInfo.version.release,
          'SDK Level': androidInfo.version.sdkInt.toString(),
          'Is Physical Device': androidInfo.isPhysicalDevice ? 'Yes' : 'No (Emulator)',
          'Supported ABIs': androidInfo.supportedAbIs.join(', '),
          'Display': '${androidInfo.displayMetrics.widthPx}x${androidInfo.displayMetrics.heightPx}',
          'Screen Density': '${androidInfo.displayMetrics.density}',
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceData = {
          'Platform': 'iOS',
          'Device': iosInfo.name,
          'Model': iosInfo.model,
          'System Name': iosInfo.systemName,
          'System Version': iosInfo.systemVersion,
          'Is Physical Device': iosInfo.isPhysicalDevice ? 'Yes' : 'No (Simulator)',
          'Identifier': iosInfo.identifierForVendor ?? 'N/A',
          'Localized Model': iosInfo.localizedModel,
        };
      } else {
        deviceData = {
          'Platform': Platform.operatingSystem,
          'Version': Platform.operatingSystemVersion,
        };
      }

      setState(() {
        _deviceData = deviceData;
        _packageInfo = packageInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _deviceData = {'Error': e.toString()};
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDeviceInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(
                  'Device Information',
                  Icons.phone_android,
                  _deviceData,
                ),
                if (_packageInfo != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    'App Information',
                    Icons.apps,
                    {
                      'App Name': _packageInfo!.appName,
                      'Package Name': _packageInfo!.packageName,
                      'Version': _packageInfo!.version,
                      'Build Number': _packageInfo!.buildNumber,
                    },
                  ),
                ],
                const SizedBox(height: 16),
                _buildInfoCard(
                  'Screen Information',
                  Icons.screen_lock_portrait,
                  {
                    'Width': MediaQuery.of(context).size.width.toStringAsFixed(2),
                    'Height': MediaQuery.of(context).size.height.toStringAsFixed(2),
                    'Pixel Ratio': MediaQuery.of(context).devicePixelRatio.toString(),
                    'Text Scale': MediaQuery.of(context).textScaleFactor.toStringAsFixed(2),
                    'Orientation': MediaQuery.of(context).orientation == Orientation.portrait
                        ? 'Portrait'
                        : 'Landscape',
                    'Padding Top': MediaQuery.of(context).padding.top.toString(),
                    'Padding Bottom': MediaQuery.of(context).padding.bottom.toString(),
                  },
                ),
                const SizedBox(height: 16),
                _buildTestingTips(),
              ],
            ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, Map<String, dynamic> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...data.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.value.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTestingTips() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Testing Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('Use this screen to verify device detection'),
            _buildTip('Compare emulator vs physical device specs'),
            _buildTip('Check screen density for responsive design'),
            _buildTip('Verify app version before testing'),
            _buildTip('Test on both portrait and landscape orientations'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
