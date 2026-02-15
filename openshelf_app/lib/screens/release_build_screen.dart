import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

/// Release Build Helper Screen
/// Provides step-by-step guidance for building release APK and AAB files
class ReleaseBuildScreen extends StatefulWidget {
  const ReleaseBuildScreen({super.key});

  @override
  State<ReleaseBuildScreen> createState() => _ReleaseBuildScreenState();
}

class _ReleaseBuildScreenState extends State<ReleaseBuildScreen> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;
  bool _keystoreConfigured = false;

  final List<BuildStep> _buildSteps = [
    BuildStep(
      number: 1,
      title: 'Generate Keystore',
      description: 'Create a signing key for your release build',
      command:
          'keytool -genkey -v -keystore android/app/app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload',
      details: [
        'Open terminal in project root',
        'Run the keytool command',
        'Enter your information when prompted',
        'Remember your passwords - you\'ll need them!',
        'Store the .jks file securely',
      ],
      icon: Icons.key,
    ),
    BuildStep(
      number: 2,
      title: 'Configure Key Properties',
      description: 'Set up your signing credentials',
      command: null,
      details: [
        'Copy android/key.properties.template to android/key.properties',
        'Edit key.properties with your actual passwords',
        'Set storePassword and keyPassword',
        'Verify keyAlias matches (default: upload)',
        'NEVER commit key.properties to git',
      ],
      icon: Icons.settings,
    ),
    BuildStep(
      number: 3,
      title: 'Update App Version',
      description: 'Set version number in pubspec.yaml',
      command: null,
      details: [
        'Open pubspec.yaml',
        'Update version: 1.0.0+1',
        'Format: MAJOR.MINOR.PATCH+BUILD',
        'Increment build number for each release',
        'Example: 1.0.0+1 → 1.0.1+2',
      ],
      icon: Icons.numbers,
    ),
    BuildStep(
      number: 4,
      title: 'Build Release APK',
      description: 'Generate APK for manual distribution',
      command: 'flutter build apk --release',
      details: [
        'Run command from project root',
        'Wait for build to complete',
        'Output: build/app/outputs/flutter-apk/app-release.apk',
        'Use for testing or manual distribution',
        'Not required for Google Play',
      ],
      icon: Icons.android,
    ),
    BuildStep(
      number: 5,
      title: 'Build App Bundle (AAB)',
      description: 'Generate AAB for Google Play Store',
      command: 'flutter build appbundle --release',
      details: [
        'Required for Google Play Console',
        'Run command from project root',
        'Output: build/app/outputs/bundle/release/app-release.aab',
        'Smaller download size for users',
        'Upload this to Google Play',
      ],
      icon: Icons.cloud_upload,
    ),
    BuildStep(
      number: 6,
      title: 'Test Release Build',
      description: 'Verify the release APK works correctly',
      command: 'flutter install --release',
      details: [
        'Connect physical device',
        'Install and test the release APK',
        'Verify no debug banners appear',
        'Test all features thoroughly',
        'Check Firebase works in release mode',
      ],
      icon: Icons.check_circle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    setState(() => _isLoading = true);

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final keystoreFile = File('android/key.properties');
      final keystoreExists = await keystoreFile.exists();

      setState(() {
        _packageInfo = packageInfo;
        _keystoreConfigured = keystoreExists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyCommand(String command) {
    Clipboard.setData(ClipboardData(text: command));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Command copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Release Build Helper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildQuickActionsCard(),
                const SizedBox(height: 16),
                ..._buildSteps.map((step) => _buildStepCard(step)),
                const SizedBox(height: 16),
                _buildTroubleshootingCard(),
              ],
            ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Build Status',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_packageInfo != null) ...[
              _buildStatusRow('App Name', _packageInfo!.appName),
              _buildStatusRow('Package', _packageInfo!.packageName),
              _buildStatusRow(
                'Version',
                '${_packageInfo!.version}+${_packageInfo!.buildNumber}',
              ),
            ],
            _buildStatusRow(
              'Keystore',
              _keystoreConfigured ? 'Configured ✓' : 'Not Configured ✗',
              color: _keystoreConfigured ? Colors.green : Colors.orange,
            ),
            if (!_keystoreConfigured) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Keystore not configured. Follow Step 1 and Step 2 below.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            value,
            style: TextStyle(
              color:
                  color ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickButton(
                  'Build APK',
                  Icons.android,
                  'flutter build apk --release',
                ),
                _buildQuickButton(
                  'Build AAB',
                  Icons.cloud_upload,
                  'flutter build appbundle --release',
                ),
                _buildQuickButton(
                  'Clean Build',
                  Icons.refresh,
                  'flutter clean',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, IconData icon, String command) {
    return FilledButton.tonalIcon(
      onPressed: () => _copyCommand(command),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildStepCard(BuildStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '${step.number}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          step.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(step.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.command != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.command!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          onPressed: () => _copyCommand(step.command!),
                          tooltip: 'Copy command',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Steps:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...step.details.map(
                  (detail) => Padding(
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
                        Expanded(child: Text(detail)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingCard() {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 12),
                Text(
                  'Common Issues',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTroubleshootingItem(
              'Build fails with signing error',
              'Check that key.properties exists and has correct values',
            ),
            _buildTroubleshootingItem(
              'Firebase not working in release',
              'Add SHA-1 and SHA-256 fingerprints to Firebase Console',
            ),
            _buildTroubleshootingItem(
              'App crashes in release mode',
              'Disable minifyEnabled or add ProGuard rules',
            ),
            _buildTroubleshootingItem(
              'keytool not found',
              'Install JDK and add to PATH',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingItem(String issue, String solution) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error,
                size: 16,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  issue,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(solution, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class BuildStep {
  final int number;
  final String title;
  final String description;
  final String? command;
  final List<String> details;
  final IconData icon;

  BuildStep({
    required this.number,
    required this.title,
    required this.description,
    required this.command,
    required this.details,
    required this.icon,
  });
}
