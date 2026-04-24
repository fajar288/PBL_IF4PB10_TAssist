import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem({required this.icon, required this.label});
}

class NavbarShell extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final Function(int) onTap;
  final List<Animation<double>> scaleAnimations;
  final List<Animation<double>> labelAnimations;

  const NavbarShell({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.scaleAnimations,
    required this.labelAnimations,
  });

  @override
  Widget build(BuildContext context) {
    // Tinggi navbar dikunci agar konsisten
    return SizedBox(
      height: 95, 
      child: Padding(
        // Padding luar disesuaikan agar lebar navbar terasa natural dengan konten
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), 
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          // ClipRRect ditambahkan untuk memastikan latar belakang biru tidak tembus keluar
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: _NavbarItemWidget(
                      item: items[i],
                      isActive: currentIndex == i,
                      scaleAnimation: scaleAnimations[i],
                      labelAnimation: labelAnimations[i],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final Animation<double> scaleAnimation;
  final Animation<double> labelAnimation;

  const _NavbarItemWidget({
    required this.item,
    required this.isActive,
    required this.scaleAnimation,
    required this.labelAnimation,
  });

  static const Color _activeColor = Color(0xFF0D4AA3);
  static const Color _inactiveColor = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnimation, labelAnimation]),
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              // Ukuran pill aktif dibatasi agar tidak meluap (overflow)
              width: isActive ? 110 : 60,
              height: isActive ? 60 : 50,
              decoration: BoxDecoration(
                color: isActive ? _activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: isActive ? Colors.white : _inactiveColor,
                  ),
                  // Animasi kemunculan label secara vertikal tepat di bawah icon
                  if (isActive) 
                    Flexible(
                      child: FadeTransition(
                        opacity: labelAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}