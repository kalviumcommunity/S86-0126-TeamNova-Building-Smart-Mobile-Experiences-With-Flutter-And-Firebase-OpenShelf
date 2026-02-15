import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Play Store Deployment Screen
/// Comprehensive guide for deploying Flutter app to Google Play Store
class PlayStoreDeploymentScreen extends StatefulWidget {
  const PlayStoreDeploymentScreen({super.key});

  @override
  State<PlayStoreDeploymentScreen> createState() =>
      _PlayStoreDeploymentScreenState();
}

class _PlayStoreDeploymentScreenState extends State<PlayStoreDeploymentScreen> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  final List<DeploymentStep> _steps = [
    DeploymentStep(
      number: 1,
      title: 'Create Google Play Console Account',
      description: 'One-time registration ($25 fee)',
      icon: Icons.account_circle,
      details: [
        'Visit play.google.com/console',
        'Sign in with Google account',
        'Pay \$25 one-time registration fee',
        'Complete developer profile',
        'Accept Developer Distribution Agreement',
      ],
      links: [
        LinkInfo('Play Console', 'https://play.google.com/console'),
        LinkInfo('Registration Guide', 'https://support.google.com/googleplay/android-developer/answer/6112435'),
      ],
    ),
    DeploymentStep(
      number: 2,
      title: 'Create New App',
      description: 'Set up your app in Play Console',
      icon: Icons.add_box,
      details: [
        'Click "Create app" in Play Console',
        'Enter app name (max 30 characters)',
        'Select default language',
        'Choose app type: App or Game',
        'Select Free or Paid',
        'Acknowledge policies',
        'Click "Create"',
      ],
      links: [
        LinkInfo('Create App Guide', 'https://support.google.com/googleplay/android-developer/answer/9859152'),
      ],
    ),
    DeploymentStep(
      number: 3,
      title: 'Complete Store Listing',
      description: 'Provide required app information',
      icon: Icons.shopping_bag,
      details: [
        'App name (30 chars max)',
        'Short description (80 chars)',
        'Full description (4000 chars)',
        'App icon: 512x512 PNG (32-bit, no transparency)',
        'Feature graphic: 1024x500 JPG/PNG',
        'Screenshots: min 2, max 8 (phone required)',
        'App category and tags',
        'Contact email',
        'Privacy policy URL (required)',
      ],
      links: [
        LinkInfo('Store Listing Guide', 'https://support.google.com/googleplay/android-developer/answer/113469'),
        LinkInfo('Graphic Assets Guide', 'https://support.google.com/googleplay/android-developer/answer/1078870'),
      ],
    ),
    DeploymentStep(
      number: 4,
      title: 'Content Rating',
      description: 'Complete questionnaire for age rating',
      icon: Icons.star_rate,
      details: [
        'Navigate to Content rating section',
        'Select questionnaire category',
        'Answer all questions honestly',
        'Submit for rating (free)',
        'Receive rating: Everyone, Teen, Mature, etc.',
        'Rating appears on store listing',
      ],
      links: [
        LinkInfo('Content Rating Guide', 'https://support.google.com/googleplay/android-developer/answer/188189'),
      ],
    ),
    DeploymentStep(
      number: 5,
      title: 'Upload Release AAB',
      description: 'Upload signed App Bundle to Production',
      icon: Icons.cloud_upload,
      details: [
        'Navigate to Production → Releases',
        'Click "Create new release"',
        'Upload app-release.aab file',
        'Enter release name (e.g., "1.0.0")',
        'Add release notes (what\'s new)',
        'Review warnings (address any issues)',
        'Save (don\'t publish yet)',
      ],
      links: [
        LinkInfo('Upload Guide', 'https://support.google.com/googleplay/android-developer/answer/9859348'),
      ],
    ),
    DeploymentStep(
      number: 6,
      title: 'Test Your Release',
      description: 'Use testing tracks before production',
      icon: Icons.science,
      details: [
        'Internal Testing: Quick testing with teammates',
        'Closed Testing: Larger group via email list',
        'Open Testing: Public beta (visible in Play Store)',
        'Add testers via email or Google Groups',
        'Test all features thoroughly',
        'Fix bugs before production',
      ],
      links: [
        LinkInfo('Testing Guide', 'https://support.google.com/googleplay/android-developer/answer/9845334'),
      ],
    ),
    DeploymentStep(
      number: 7,
      title: 'Submit for Review',
      description: 'Final submission to Google',
      icon: Icons.send,
      details: [
        'Complete all required sections (green checkmarks)',
        'Review all policies and guidelines',
        'Click "Submit for review"',
        'Wait for Google review (1-7 days)',
        'Check email for approval/rejection',
        'Address any issues if rejected',
      ],
      links: [
        LinkInfo('Review Process', 'https://support.google.com/googleplay/android-developer/answer/9859455'),
      ],
    ),
    DeploymentStep(
      number: 8,
      title: 'Monitor & Update',
      description: 'Track performance and push updates',
      icon: Icons.analytics,
      details: [
        'Monitor crashes in Play Console',
        'Track installs and uninstalls',
        'Read user reviews and ratings',
        'Respond to user feedback',
        'Push updates with incremented version',
        'Use Firebase Analytics for insights',
      ],
      links: [
        LinkInfo('Analytics Dashboard', 'https://support.google.com/googleplay/android-developer/answer/139628'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    setState(() => _isLoading = true);
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Store Deployment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPackageInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildPrerequisitesCard(),
                const SizedBox(height: 16),
                ..._steps.map((step) => _buildStepCard(step)),
                const SizedBox(height: 16),
                _buildChecklistCard(),
                const SizedBox(height: 16),
                _buildTroubleshootingCard(),
              ],
            ),
    );
  }

  Widget _buildInfoCard() {
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
                  'App Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_packageInfo != null) ...[
              _buildInfoRow('App Name', _packageInfo!.appName),
              _buildInfoRow('Package Name', _packageInfo!.packageName),
              _buildInfoRow('Version', '${_packageInfo!.version}+${_packageInfo!.buildNumber}'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Use this package name when creating your app in Play Console',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () => _copyText(_packageInfo!.packageName),
                      tooltip: 'Copy package name',
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrerequisitesCard() {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 12),
                Text(
                  'Prerequisites',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPrerequisite('Google Play Console account (\$25)'),
            _buildPrerequisite('Signed AAB file (app-release.aab)'),
            _buildPrerequisite('App icon (512x512 PNG)'),
            _buildPrerequisite('Feature graphic (1024x500)'),
            _buildPrerequisite('Screenshots (minimum 2)'),
            _buildPrerequisite('Privacy policy URL'),
            _buildPrerequisite('App description'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrerequisite(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }

  Widget _buildStepCard(DeploymentStep step) {
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
                Text(
                  'Steps:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...step.details.map((detail) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_right,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(detail)),
                        ],
                      ),
                    )),
                if (step.links.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Resources:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...step.links.map((link) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () => _launchUrl(link.url),
                          child: Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  link.title,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Icon(Icons.open_in_new, size: 16),
                            ],
                          ),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: Theme.of(context).colorScheme.tertiary),
                const SizedBox(width: 12),
                Text(
                  'Pre-Submission Checklist',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildChecklistItem('AAB file built and signed'),
            _buildChecklistItem('Version incremented in pubspec.yaml'),
            _buildChecklistItem('App tested in release mode'),
            _buildChecklistItem('Firebase works in release'),
            _buildChecklistItem('All features functional'),
            _buildChecklistItem('Store listing completed'),
            _buildChecklistItem('Screenshots prepared'),
            _buildChecklistItem('Privacy policy hosted'),
            _buildChecklistItem('Content rating obtained'),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank,
            size: 16,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
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
              'AAB rejected',
              'Check all metadata is complete and package name matches',
            ),
            _buildTroubleshootingItem(
              'App crashes on launch',
              'Add SHA-1/SHA-256 fingerprints to Firebase Console',
            ),
            _buildTroubleshootingItem(
              'Version conflict',
              'Increment version code in pubspec.yaml',
            ),
            _buildTroubleshootingItem(
              'Upload blocked',
              'Complete content rating questionnaire',
            ),
            _buildTroubleshootingItem(
              'Debug banner visible',
              'Ensure you uploaded the release AAB, not debug',
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
            child: Text(
              solution,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class DeploymentStep {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final List<String> details;
  final List<LinkInfo> links;

  DeploymentStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.details,
    this.links = const [],
  });
}

class LinkInfo {
  final String title;
  final String url;

  LinkInfo(this.title, this.url);
}
