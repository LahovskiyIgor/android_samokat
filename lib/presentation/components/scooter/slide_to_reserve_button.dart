import 'package:flutter/material.dart';

class SlideToReserveButton extends StatefulWidget {
  final VoidCallback onSlideComplete;

  const SlideToReserveButton({
    super.key,
    required this.onSlideComplete,
  });

  @override
  State<SlideToReserveButton> createState() => _SlideToReserveButtonState();
}

class _SlideToReserveButtonState extends State<SlideToReserveButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dragAnimation;
  double _dragOffset = 0;
  final double _maxDrag = 240; // ширина кнопки - ширина круга

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dragAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      if (_dragOffset < 0) _dragOffset = 0;
      if (_dragOffset > _maxDrag) _dragOffset = _maxDrag;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragOffset >= _maxDrag * 0.8) {
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onSlideComplete();
      });
    } else {
      _controller.reverse();
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSlided = _dragOffset >= _maxDrag * 0.8;
    final progress = _dragOffset / _maxDrag;

    return SizedBox(
      height: 64,
      child: Stack(
        children: [
          // Фон кнопки: темный → градиент
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: isSlided
                  ? Colors.transparent
                  : const Color(0xFF141530),
            ),
          ),

          // Градиентный фон (появляется при свайпе)
          if (isSlided)
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF67E8F9), Color(0xFF86EFAC)],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
              ),
            ),

          // Текст «Забронировать» — виден только в начальном состоянии
          if (!isSlided)
            Center(
              child: Text(
                'Забронировать',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

          // Три стрелки — справа от текста (только когда текст виден)
          if (!isSlided)
            Positioned(
              right: 40,
              child: Row(
                children: [
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white.withOpacity(0.6)),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white.withOpacity(0.3)),
                ],
              ),
            ),

          // Круг с иконкой самоката — двигается слева направо
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.electric_scooter,
                    color: Color(0xFF141530),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Иконка самоката справа — появляется при полном свайпе
          if (isSlided)
            Positioned(
              right: 16,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.electric_scooter,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}