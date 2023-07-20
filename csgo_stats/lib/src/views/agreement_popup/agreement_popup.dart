import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreementPopup extends StatefulWidget {
  const AgreementPopup({super.key});

  @override
  State<AgreementPopup> createState() => _AgreementPopupState();
}

class _AgreementPopupState extends State<AgreementPopup> {
  Future<void> _launchUrl({required Uri uri}) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: const Color.fromRGBO(27, 40, 56, 1),
      surfaceTintColor: const Color.fromRGBO(27, 40, 56, 1),
      title: Text(
        'License Agreement',
        style: GoogleFonts.getFont(
          'Montserrat Alternates',
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      content: _buildBody(context),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 57, 64, 73),
            elevation: 3,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Yes, I Agree',
            style: GoogleFonts.getFont(
              'Montserrat Alternates',
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggle(
              context: context,
              title: 'EULA Agreement',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AgreementDetails(
                      documentTitle: 'EULA Agreement',
                      documentUrl: 'assets/markdownpages/eula_agreement.md',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            _buildToggle(
              context: context,
              title: 'Steam EULA Agreement',
              onTap: () => _launchUrl(
                uri:
                    Uri.parse('https://store.steampowered.com/eula/39140_eula'),
              ),
            ),
            const SizedBox(height: 5),
            _buildToggle(
              context: context,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AgreementDetails(
                      documentTitle: 'Privacy Policy',
                      documentUrl: 'assets/markdownpages/privacy_policy.md',
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 57, 64, 73),
      dense: true,
      title: Text(
        title,
        style: GoogleFonts.getFont(
          'Montserrat Alternates',
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
      leading: FaIcon(
        FontAwesomeIcons.fileSignature,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 30,
      ),
    );
  }
}

class AgreementDetails extends StatefulWidget {
  final String documentTitle;
  final String documentUrl;

  const AgreementDetails({
    super.key,
    required this.documentTitle,
    required this.documentUrl,
  });

  @override
  State<AgreementDetails> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AgreementDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String fileData = '';

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  Future _asyncInit() async {
    fileData = await rootBundle.loadString(
      widget.documentUrl,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(27, 40, 56, 1),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Color.fromRGBO(152, 152, 152, 1),
            size: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          widget.documentTitle,
          style: GoogleFonts.getFont(
            'Montserrat Alternates',
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Markdown(
      data: fileData,
      styleSheet: MarkdownStyleSheet(
        listBullet: GoogleFonts.getFont(
          'Montserrat Alternates',
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        p: GoogleFonts.getFont(
          'Montserrat Alternates',
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
