import 'package:flutter/material.dart';
import 'package:flutter_demo/core/router/context_extension.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo/core/router/router.dart';
import 'package:flutter_demo/core/provider/tab_provider.dart';
import 'package:flutter_demo/pages/home/indexPage.dart';
import 'package:flutter_demo/pages/category/categoryPage.dart';
import 'package:flutter_demo/pages/cart/cartPage.dart';
import 'package:flutter_demo/pages/my/myPage.dart';
import 'package:flutter/services.dart';

class BottomMenuBarPage extends StatefulWidget with RouterBridge<String> {
  final String? initialRoute;
  
  const BottomMenuBarPage({
    Key? key, 
    this.initialRoute,
  }) : super(key: key);

  @override
  State<BottomMenuBarPage> createState() => _BottomMenuBarPageState();
}

class _BottomMenuBarPageState extends State<BottomMenuBarPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  bool _didInitTab = false; // 只初始化一次

  // 页面状态管理
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // 保存所有页面的实例
  final List<Widget> _pages = [];

  // 底部导航栏配置
  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '首页',
    ),
    NavigationItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      label: '分类',
    ),
    NavigationItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: '购物车',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '我的',
    ),
  ];

  @override
  void initState() {
    super.initState();
    print('BottomMenuBarPage initState - 开始初始化');
    
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializePages();
    
    print('BottomMenuBarPage initState - 初始化tab');
    // 延迟初始化tab，确保所有组件都已构建完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_didInitTab) {
        print('BottomMenuBarPage initState - 开始初始化tab');
        _initializeTab();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 如果还没有初始化，在这里也尝试初始化
    if (!_didInitTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_didInitTab) {
          _initializeTab();
        }
      });
    }
  }

  void _initializeTab() {
    if (_didInitTab) return;
    
    print('BottomMenuBarPage._initializeTab - 开始初始化');
    
    String? targetRoute;
    
    // 尝试从RouteSettings获取参数
    final routeSettings = ModalRoute.of(context)?.settings;
    print('BottomMenuBarPage._initializeTab - routeSettings: ${routeSettings?.name}, arguments: ${routeSettings?.arguments}');
    
    if (routeSettings?.arguments != null) {
      targetRoute = routeSettings!.arguments as String?;
      print('BottomMenuBarPage._initializeTab - 从RouteSettings获取到targetRoute: $targetRoute');
    }
    
    // 如果RouteSettings中没有参数，使用initialRoute
    targetRoute ??= widget.initialRoute;
    print('BottomMenuBarPage._initializeTab - 最终targetRoute: $targetRoute');
    
    final tabProvider = context.read<TabProvider>();
    final initialIndex = tabProvider.getIndexFromRoute(targetRoute ?? 'IndexPage');
    
    print('BottomMenuBarPage._initializeTab - initialIndex: $initialIndex, currentIndex: ${tabProvider.currentIndex}');
    
    // 设置TabProvider状态
    if (tabProvider.currentIndex != initialIndex) {
      print('BottomMenuBarPage._initializeTab - 切换TabProvider状态到: $initialIndex');
      tabProvider.switchTab(initialIndex);
    }
    
    // 直接跳转，不使用延迟
    if (mounted && _pageController.hasClients) {
      print('BottomMenuBarPage._initializeTab - 直接跳转到页面: $initialIndex');
      _pageController.jumpToPage(initialIndex);
    } else {
      print('BottomMenuBarPage._initializeTab - PageController未准备好，延迟跳转');
      // 如果PageController未准备好，延迟跳转
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          print('BottomMenuBarPage._initializeTab - 延迟跳转到页面: $initialIndex');
          _pageController.jumpToPage(initialIndex);
        } else {
          print('BottomMenuBarPage._initializeTab - 延迟跳转失败，mounted: $mounted, hasClients: ${_pageController.hasClients}');
        }
      });
    }
    
    _didInitTab = true;
    print('BottomMenuBarPage._initializeTab - 初始化完成');
  }

  void _initializePages() {
    _pages.addAll([
      Navigator(
        key: _navigatorKeys[0],
        onGenerateRoute: (settings) {
          // 只处理tabs页面
          if (TabProvider.isTabRoute(settings.name ?? '')) {
            // 对于tabs页面，直接返回对应的页面，不创建新的BottomMenuBarPage
            switch (settings.name) {
              case 'IndexPage':
                return MaterialPageRoute(
                  builder: (context) => IndexPage(),
                  settings: settings,
                );
              case 'CategoryPage':
                return MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                  settings: settings,
                );
              case 'CartPage':
                return MaterialPageRoute(
                  builder: (context) => CartPage(),
                  settings: settings,
                );
              case 'MyPage':
                return MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => IndexPage(),
                  settings: const RouteSettings(name: 'IndexPage'),
                );
            }
          } else {
            // 非tabs页面，使用根Navigator跳转
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pushNamed(settings.name!);
              }
            });
            // 返回当前页面
            return MaterialPageRoute(
              builder: (context) => IndexPage(),
              settings: const RouteSettings(name: 'IndexPage'),
            );
          }
        },
        initialRoute: 'IndexPage',
      ),
      Navigator(
        key: _navigatorKeys[1],
        onGenerateRoute: (settings) {
          // 只处理tabs页面
          if (TabProvider.isTabRoute(settings.name ?? '')) {
            // 对于tabs页面，直接返回对应的页面，不创建新的BottomMenuBarPage
            switch (settings.name) {
              case 'IndexPage':
                return MaterialPageRoute(
                  builder: (context) => IndexPage(),
                  settings: settings,
                );
              case 'CategoryPage':
                return MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                  settings: settings,
                );
              case 'CartPage':
                return MaterialPageRoute(
                  builder: (context) => CartPage(),
                  settings: settings,
                );
              case 'MyPage':
                return MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                  settings: const RouteSettings(name: 'CategoryPage'),
                );
            }
          } else {
            // 非tabs页面，使用根Navigator跳转
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pushNamed(settings.name!);
              }
            });
            // 返回当前页面
            return MaterialPageRoute(
              builder: (context) => CategoryPage(),
              settings: const RouteSettings(name: 'CategoryPage'),
            );
          }
        },
        initialRoute: 'CategoryPage',
      ),
      Navigator(
        key: _navigatorKeys[2],
        onGenerateRoute: (settings) {
          // 只处理tabs页面
          if (TabProvider.isTabRoute(settings.name ?? '')) {
            // 对于tabs页面，直接返回对应的页面，不创建新的BottomMenuBarPage
            switch (settings.name) {
              case 'IndexPage':
                return MaterialPageRoute(
                  builder: (context) => IndexPage(),
                  settings: settings,
                );
              case 'CategoryPage':
                return MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                  settings: settings,
                );
              case 'CartPage':
                return MaterialPageRoute(
                  builder: (context) => CartPage(),
                  settings: settings,
                );
              case 'MyPage':
                return MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => CartPage(),
                  settings: const RouteSettings(name: 'CartPage'),
                );
            }
          } else {
            // 非tabs页面，使用根Navigator跳转
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pushNamed(settings.name!);
              }
            });
            // 返回当前页面
            return MaterialPageRoute(
              builder: (context) => CartPage(),
              settings: const RouteSettings(name: 'CartPage'),
            );
          }
        },
        initialRoute: 'CartPage',
      ),
      Navigator(
        key: _navigatorKeys[3],
        onGenerateRoute: (settings) {
          // 只处理tabs页面
          if (TabProvider.isTabRoute(settings.name ?? '')) {
            // 对于tabs页面，直接返回对应的页面，不创建新的BottomMenuBarPage
            switch (settings.name) {
              case 'IndexPage':
                return MaterialPageRoute(
                  builder: (context) => IndexPage(),
                  settings: settings,
                );
              case 'CategoryPage':
                return MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                  settings: settings,
                );
              case 'CartPage':
                return MaterialPageRoute(
                  builder: (context) => CartPage(),
                  settings: settings,
                );
              case 'MyPage':
                return MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => MyPage(),
                  settings: const RouteSettings(name: 'MyPage'),
                );
            }
          } else {
            // 非tabs页面，使用根Navigator跳转
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pushNamed(settings.name!);
              }
            });
            // 返回当前页面
            return MaterialPageRoute(
              builder: (context) => MyPage(),
              settings: const RouteSettings(name: 'MyPage'),
            );
          }
        },
        initialRoute: 'MyPage',
      ),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    final tabProvider = context.read<TabProvider>();
    if (tabProvider.currentIndex != index) {
      print('点击切换到tab: ${tabProvider.getRouteFromIndex(index)}');
      
      // 先更新Provider状态
      tabProvider.switchTab(index);
      
      // 使用动画控制器
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      
      // 确保PageController跳转到正确的页面
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients && 
            _pageController.page?.round() != index) {
          print('PageController准备跳转 - 当前页面: ${_pageController.page?.round()}, 目标页面: $index');
          _pageController.jumpToPage(index);
          print('PageController跳转到页面: $index');
        } else {
          print('PageController无需跳转 - 当前页面: ${_pageController.page?.round()}, 目标页面: $index');
        }
      });
    }
  }

  // 公共方法，供外部调用以跳转到指定页面
  void jumpToPage(int index) {
    print('BottomMenuBarPage.jumpToPage - 跳转到页面: $index');
    if (mounted && _pageController.hasClients && 
        _pageController.page?.round() != index) {
      _pageController.jumpToPage(index);
      print('PageController跳转到页面: $index');
    } else {
      print('PageController无需跳转 - 当前页面: ${_pageController.page?.round()}, 目标页面: $index');
    }
  }

  // 处理返回按钮
  Future<bool> _onWillPop() async {
    final tabProvider = context.read<TabProvider>();
    final NavigatorState? navigator = _navigatorKeys[tabProvider.currentIndex].currentState;
    
    // 如果当前tab的Navigator可以返回，则返回上一页
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false; // 阻止系统返回
    }
    
    // 检查是否是根页面
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (!rootNavigator.canPop()) {
      // 如果是根页面，允许退出应用
      print('BottomMenuBarPage是根页面，允许退出应用');
      return true;
    }
    
    // 如果不是根页面，允许返回
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        print('BottomMenuBarPage build - currentIndex: ${tabProvider.currentIndex}, mounted: $mounted, hasClients: ${_pageController.hasClients}');

        // 当TabProvider状态变化时，自动跳转到对应页面
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients && 
              _pageController.page?.round() != tabProvider.currentIndex) {
            print('build中PageController自动跳转 - 当前页面: ${_pageController.page?.round()}, 目标页面: ${tabProvider.currentIndex}');
            _pageController.jumpToPage(tabProvider.currentIndex);
          } else {
            print('build中PageController无需跳转 - 当前页面: ${_pageController.page?.round()}, 目标页面: ${tabProvider.currentIndex}, mounted: $mounted, hasClients: ${_pageController.hasClients}');
          }
        });
        
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            print('PopScope onPopInvokedWithResult - didPop: $didPop');
            if (!didPop) {
              // 只有当系统没有处理返回操作时，才执行我们的自定义返回逻辑
              final shouldPop = await _onWillPop();
              print('PopScope - shouldPop: $shouldPop, context.mounted: ${context.mounted}');
              if (shouldPop && context.mounted) {
                // 只有在明确允许返回时才执行返回操作
                print('执行返回操作');
                // 使用SystemNavigator.pop()来退出应用，而不是Navigator.pop()
                SystemNavigator.pop();
              } else {
                print('阻止返回操作');
              }
            } else {
              // 如果系统已经处理了返回操作（didPop为true），不需要做任何额外操作
              print('系统已处理返回操作，无需额外处理');
            }
          },
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // 只有当状态不同时才更新，避免重复调用
                if (tabProvider.currentIndex != index) {
                  tabProvider.switchTab(index);
                  print('滑动切换到tab: ${tabProvider.getRouteFromIndex(index)}');
                }
              },
              children: _pages,
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: tabProvider.currentIndex,
              onTap: _onTabTapped,
              items: _navigationItems,
            ),
          ),
        );
      },
    );
  }
}

// 自定义底部导航栏组件
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('CustomBottomNavigationBar build - currentIndex: $currentIndex');
    
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _buildNavigationItem(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(BuildContext context, int index) {
    final item = items[index];
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected 
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected 
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected 
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// 导航项数据模型
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
