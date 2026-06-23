import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/renkler.dart';
import '../../models/mesaj_model.dart';
import '../../services/mesaj_service.dart';
import '../../widgets/listing_image.dart';

class SohbetEkrani extends StatefulWidget {
  final String karsiKullaniciId;
  final String karsiKullaniciAd;
  final String? ilanId;
  final String? ilanBaslik;
  final String? ilanKonum;
  final String? ilanFotoUrl;

  const SohbetEkrani({
    super.key,
    this.karsiKullaniciId = '',
    this.karsiKullaniciAd = 'Vesta kullanıcısı',
    this.ilanId,
    this.ilanBaslik,
    this.ilanKonum,
    this.ilanFotoUrl,
  });

  factory SohbetEkrani.fromSummary(SohbetOzeti sohbet) {
    return SohbetEkrani(
      karsiKullaniciId: sohbet.karsiKullaniciId,
      karsiKullaniciAd: sohbet.karsiKullaniciAd,
      ilanId: sohbet.ilanId,
      ilanBaslik: sohbet.ilanBaslik,
      ilanKonum: sohbet.ilanKonum,
      ilanFotoUrl: sohbet.ilanFotoUrl,
    );
  }

  @override
  State<SohbetEkrani> createState() => _SohbetEkraniState();
}

class _SohbetEkraniState extends State<SohbetEkrani> {
  static const _currentUserId = 'user-1';

  final _service = const MesajService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<MesajModel> _messages = [];
  Timer? _pollTimer;
  bool _loading = true;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _loadMessages(silent: true),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canChat = widget.karsiKullaniciId.isNotEmpty;
    return Scaffold(
      backgroundColor: Renkler.cream,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Renkler.oliveLight,
              child: Icon(Icons.person_outline, color: Renkler.paper),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.karsiKullaniciAd,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Güvenli sohbet',
                    style: TextStyle(fontSize: 11, color: Renkler.olive),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: canChat
          ? Column(
              children: [
                if (widget.ilanBaslik != null) _ListingHeader(widget: widget),
                Expanded(child: _buildMessages()),
                _Composer(
                  controller: _controller,
                  sending: _sending,
                  onSend: _send,
                ),
              ],
            )
          : const _NoChatSelected(),
    );
  }

  Widget _buildMessages() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 42, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Renkler.inkSoft),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadMessages,
                child: const Text('Tekrar dene'),
              ),
            ],
          ),
        ),
      );
    }
    if (_messages.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Bu ilan için henüz mesaj yok. İlk mesajı yazabilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Renkler.inkSoft),
          ),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _MessageBubble(
          message: message,
          mine: message.gondericId == _currentUserId,
        );
      },
    );
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (widget.karsiKullaniciId.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    if (!silent && mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final messages = await _service.getMesajlar(
        karsiKullaniciId: widget.karsiKullaniciId,
        ilanId: widget.ilanId,
      );
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _loading = false;
        _error = null;
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted || silent) return;
      setState(() {
        _loading = false;
        _error = 'Mesajlar yüklenemedi. Lütfen tekrar dene.';
      });
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final message = await _service.mesajGonder(
        aliciId: widget.karsiKullaniciId,
        ilanId: widget.ilanId,
        icerik: text,
      );
      _controller.clear();
      setState(() {
        _messages = [..._messages, message];
      });
      _scrollToBottom();
    } on MesajServiceException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }
}

class _ListingHeader extends StatelessWidget {
  final SohbetEkrani widget;

  const _ListingHeader({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Renkler.paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Renkler.line),
      ),
      child: Row(
        children: [
          ListingImage(
            source: widget.ilanFotoUrl ?? '',
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ilanBaslik ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Renkler.baslik(size: 16),
                ),
                if (widget.ilanKonum != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    widget.ilanKonum!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Renkler.inkSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: Renkler.paper,
        border: Border(top: BorderSide(color: Renkler.line)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Mesajını yaz...',
                  filled: true,
                  fillColor: Renkler.cream,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sending ? null : onSend,
              icon: sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MesajModel message;
  final bool mine;

  const _MessageBubble({required this.message, required this.mine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? Renkler.terracotta : Renkler.paper,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: Renkler.line),
        ),
        child: Column(
          crossAxisAlignment: mine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.icerik,
              style: TextStyle(
                height: 1.35,
                color: mine ? Renkler.paper : Renkler.ink,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.saatFormati,
                  style: TextStyle(
                    fontSize: 11,
                    color: mine
                        ? Renkler.paper.withValues(alpha: 0.8)
                        : Renkler.inkSoft,
                  ),
                ),
                if (mine) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 15, color: Renkler.paper),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoChatSelected extends StatelessWidget {
  const _NoChatSelected();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Sohbet başlatmak için Mesajlar ekranından bir ilan seç.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Renkler.inkSoft),
        ),
      ),
    );
  }
}
