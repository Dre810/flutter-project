import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static const String stripePaymentLink =
      'https://buy.stripe.com/test_cNi7sM2tKeTg87veJe7Zu00';

  static Future<void> payWithCard() async {
    final Uri url = Uri.parse(stripePaymentLink);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch Stripe payment page');
    }
  }
}