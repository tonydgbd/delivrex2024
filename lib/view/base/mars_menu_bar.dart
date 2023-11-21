import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/menu_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:provider/provider.dart';

class PlutoMenuBarView extends StatefulWidget {
  /// Pass [MenuItemView] to List.
  /// create submenus by continuing to pass MenuItemView to children as a List.
  ///
  /// ```dart
  /// MenuItemView(
  ///   title: 'Menu 1',
  ///   children: [
  ///     MenuItemView(
  ///       title: 'Menu 1-1',
  ///       onTap: () => print('Menu 1-1 tap'),
  ///     ),
  ///   ],
  /// ),
  /// ```
  final List<MenuItemView> menus;

  /// Text of the back button. (default. 'Go back')
  final String goBackButtonText;

  /// menu height. (default. '45')
  final double height;

  /// BackgroundColor. (default. 'white')
  final Color backgroundColor;

  /// Border color. (default. 'black12')
  final Color borderColor;

  /// menu icon color. (default. 'black54')
  final Color? menuIconColor;

  /// menu icon size. (default. '20')
  final double menuIconSize;

  /// more icon color. (default. 'black54')
  final Color? moreIconColor;

  /// Enable gradient of BackgroundColor. (default. 'true')
  final bool gradient;

  /// [TextStyle] of Menu title.
  final TextStyle textStyle;

   PlutoMenuBarView({Key? key,
    required this.menus,
    this.goBackButtonText = 'Go back',
    this.height = 45,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black12,
    this.menuIconColor = Colors.black54,
    this.menuIconSize = 20,
    this.moreIconColor = Colors.black54,
    this.gradient = true,
    this.textStyle = const TextStyle(),
  })  : assert(menus.isNotEmpty), super(key: key);

  @override
  State<PlutoMenuBarView> createState() => _PlutoMenuBarViewState();
}

class _PlutoMenuBarViewState extends State<PlutoMenuBarView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return Container(
          width: size.minWidth,
          height: widget.height,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.menus.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return _MenuWidget(
                widget.menus[index],
                goBackButtonText: widget.goBackButtonText,
                height: widget.height,
                backgroundColor: widget.backgroundColor,
                menuIconColor: widget.menuIconColor,
                menuIconSize: widget.menuIconSize,
                moreIconColor: widget.moreIconColor,
                textStyle: widget.textStyle,
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItemView {
  /// Menu title
  final String? title;

  final IconData? icon;

  /// Callback executed when a menu is tapped
  final Function()? onTap;

  /// Passing [MenuItemView] to a [List] creates a sub-menu.
  final List<MenuItemView>? children;

  final MenuType? menuType;

  MenuItemView({
    this.title,
    this.icon,
    this.onTap,
    this.children,
    this.menuType,
  }) : _key = GlobalKey();

  MenuItemView._back({
    this.title,
    this.children,
    this.icon, this.onTap,
    this.menuType,
  })  : _key = GlobalKey(),
        _isBack = true;

  final GlobalKey _key;

  bool _isBack = false;

  Offset get _position {
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.localToGlobal(Offset.zero);
  }

  bool get _hasChildren => children != null && children!.isNotEmpty;
}

class _MenuWidget extends StatelessWidget {
  final MenuItemView menu;

  final String? goBackButtonText;

  final double? height;

  final Color? backgroundColor;

  final Color? menuIconColor;

  final double? menuIconSize;

  final Color? moreIconColor;

  final TextStyle? textStyle;

  _MenuWidget(
      this.menu, {
        this.goBackButtonText,
        this.height,
        this.backgroundColor,
        this.menuIconColor,
        this.menuIconSize,
        this.moreIconColor,
        this.textStyle,
      }) : super(key: menu._key);

  Widget _buildPopupItem(MenuItemView menu) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (menu.icon != null) ...[
          Icon(
            menu.icon,
            color: menuIconColor,
            size: menuIconSize,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              menu.title!,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        if (menu._hasChildren && !menu._isBack)
          Icon(
            Icons.arrow_right,
            color: moreIconColor,
          ),
      ],
    );
  }

  Future<MenuItemView?> _showPopupMenu(
      BuildContext context,
      List<MenuItemView> menuItemViews,
      ) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position = menu._position + Offset(0, height! - 11);

    return await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width,
        overlay.size.height,
      ),
      items: menuItemViews.map((menu) {
        return PopupMenuItem<MenuItemView>(
          value: menu,
          child: _buildPopupItem(menu),
        );
      }).toList(),
      // elevation: 2.0,
      color: backgroundColor,
    );
  }

  Widget _getMenu(
      BuildContext context,
      MenuItemView menu,
      ) {
    Future<MenuItemView?> getSelectedMenu(
        MenuItemView menu, {
          MenuItemView? fromPreviousMenu,
          int? stackIdx,
          List<MenuItemView>? stack,
        }) async {
      if (!menu._hasChildren) {
        return menu;
      }

      final items = [...menu.children!];

      if (fromPreviousMenu != null) {
        items.add(MenuItemView._back(
          title: goBackButtonText,
          children: fromPreviousMenu.children,
          onTap: null,
          icon: null,
          menuType: null,
        ));
      }

      MenuItemView? selectedMenu0 = await _showPopupMenu(
        context,
        items,
      );

      if (selectedMenu0 == null) {
        return null;
      }

      MenuItemView? previousMenu = menu;

      if (!selectedMenu0._hasChildren) {
        return selectedMenu0;
      }

      if (selectedMenu0._isBack) {
        stackIdx = stackIdx! - 1;
        if (stackIdx < 0) {
          previousMenu = null;
        } else {
          previousMenu = stack![stackIdx];
        }
      } else {
        if (stackIdx == null) {
          stackIdx = 0;
          stack = [menu];
        } else {
          stackIdx += 1;
          stack!.add(menu);
        }
      }

      return await getSelectedMenu(
        selectedMenu0,
        fromPreviousMenu: previousMenu,
        stackIdx: stackIdx,
        stack: stack,
      );
    }

    return InkWell(
      onTap: () async {
        if (menu._hasChildren) {
          MenuItemView? selectedMenu = await getSelectedMenu(menu);

          if (selectedMenu?.onTap != null) {
            selectedMenu!.onTap!();
          }
        } else if (menu.onTap != null) {
          menu.onTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           ...[
              OnHover(
                builder: (isHovered) {
                  final color = isHovered ? Theme.of(context).primaryColor : menuIconColor;
                  return menu.menuType == MenuType.cart ?
                  Stack(
                    clipBehavior: Clip.none, children: [
                    Icon(menu.icon, size: menuIconSize,color: color),
                     Positioned(
                      top: -7, right: -7,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Text(
                            Provider.of<CartProvider>(context).cartList.length.toString(),
                            style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ),
                    )
                  ],
                  ) : menu.menuType == MenuType.text ? Text(menu.title!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: color)) :
                  menu.menuType == MenuType.appLogo ?
                  Padding(
                    padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.all(Dimensions.paddingSizeLarge) : const EdgeInsets.all(0),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                      child: Provider.of<SplashProvider>(context).baseUrls != null?  Consumer<SplashProvider>(
                          builder:(context, splash, child) => FadeInImage.assetNetwork(
                            placeholder: Images.placeholderRectangle,
                            image:  '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                            width: 120, height: 80,
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, width: 120, height: 80),
                          )): const SizedBox(),
                    ),
                  ) : menu.menuType == MenuType.search ?
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
                    child: Container(
                      height: 100,
                      width: 300.0,
                      color: Colors.red,
                    ),
                  ) : menu.menuType == MenuType.menu ? OnHover(
                    builder: (isHover) {
                      final color0 = isHovered ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color;
                      return Icon(Icons.menu, size: Dimensions.paddingSizeExtraLarge, color: color0,);
                    }
                  ) : const SizedBox();
                },

              ),

              const SizedBox(
                width: 5,
              ),
            ],
            // Text(
            //   menu.title,
            //   style: textStyle,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getMenu(context, menu);
  }
}
