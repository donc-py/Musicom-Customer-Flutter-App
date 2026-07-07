class POSResponse {
  final String? invoicePDFUrl;
  final String? qrUrl;
  final int? draftId;
  final int? orderId;

  POSResponse({
    this.invoicePDFUrl,
    this.qrUrl,
    this.draftId,
    this.orderId,
  });
}
