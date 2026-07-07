import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:readypos_flutter/services/pos_service_provider.dart';

class PaypalWebViewScreen extends ConsumerStatefulWidget {
  final String approvalUrl;
  final int orderId;

  const PaypalWebViewScreen({
    super.key,
    required this.approvalUrl,
    required this.orderId,
  });

  @override
  ConsumerState<PaypalWebViewScreen> createState() =>
      _PaypalWebViewScreenState();
}

class _PaypalWebViewScreenState extends ConsumerState<PaypalWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isCapturing = false;

  // Debe coincidir con tu route('payment.success') de Laravel
  static const String _successPattern = 'callback-success';
  static const String _cancelPattern  = 'callback-cancel';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            // PayPal redirige a success con ?token=PAYPAL_ORDER_ID
            if (url.contains(_successPattern)) {
              final token = Uri.parse(url).queryParameters['token'];
              if (token != null && !_isCapturing) {
                _isCapturing = true;
                _capturePayment(token);
              }
              // Bloquear la navegación — ya lo manejamos nosotros
              return NavigationDecision.prevent;
            }

            if (url.contains(_cancelPattern)) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            // Solo mostrar errores reales, no los de redirect interceptado
            if (error.errorCode != -1) {
              debugPrint('WebView error: ${error.description}');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          if (_isCapturing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Procesando pago...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _capturePayment(String token) async {
    try {
      final response = await ref
          .read(posServiceProvider)
          .capturePaypalPayment(
            token: token,
            orderId: widget.orderId,
          );

      if (!mounted) return;

      Navigator.pop(context, response.statusCode == 200);
    } catch (e) {
      if (mounted) Navigator.pop(context, false);
    }
  }
}