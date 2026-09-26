import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I track my order status?',
      'answer': 'You can track your order by going to My Orders section in your profile or by clicking on the Track Order button on your order success screen.',
    },
    {
      'question': 'What is your 30-day return policy?',
      'answer': 'We offer a hassle-free 30-day return policy. Items must be unused, in original condition with tags attached.',
    },
    {
      'question': 'How long does shipping take?',
      'answer': 'Standard shipping takes 3-5 business days. Express shipping is delivered within 1-2 business days.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept Credit/Debit cards (Visa, MasterCard), Apple Pay, Google Pay, PayPal, and Cash on Delivery.',
    },
    {
      'question': 'How can I request a refund?',
      'answer': 'Once your returned product is received and inspected, your refund will be processed to your original payment method within 3-7 business days.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs
        .where((faq) =>
            faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.messageSquare),
            onPressed: () => _openLiveChat(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Search Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Search for questions, topics or contact support',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search help articles...',
                        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        prefixIcon: const Icon(LucideIcons.search, color: AppTheme.textSecondary),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(LucideIcons.x, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Support Channels Grid
                  Text(
                    'Contact Support',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1.4,
                    children: [
                      _buildContactCard(
                        icon: LucideIcons.messageSquare,
                        title: 'Live Chat',
                        subtitle: 'Online 24/7',
                        badge: 'Fastest',
                        badgeColor: Colors.green,
                        onTap: () => _openLiveChat(context),
                      ),
                      _buildContactCard(
                        icon: LucideIcons.phoneCall,
                        title: 'Call Us',
                        subtitle: '+1 800 123 4567',
                        badge: 'Toll-Free',
                        badgeColor: AppTheme.primaryColor,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling customer support...')),
                          );
                        },
                      ),
                      _buildContactCard(
                        icon: LucideIcons.mail,
                        title: 'Email Support',
                        subtitle: 'support@shop.com',
                        badge: 'Within 2 hrs',
                        badgeColor: Colors.orange,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening email client...')),
                          );
                        },
                      ),
                      _buildContactCard(
                        icon: LucideIcons.fileText,
                        title: 'User Guide',
                        subtitle: 'Policies & FAQs',
                        badge: 'Docs',
                        badgeColor: Colors.purple,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening user guide...')),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Quick Topic Badges
                  Text(
                    'Popular Topics',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildTopicChip('Orders & Shipping', LucideIcons.truck),
                      SizedBox(width: 8.w),
                      _buildTopicChip('Returns', LucideIcons.rotateCcw),
                      SizedBox(width: 8.w),
                      _buildTopicChip('Payment', LucideIcons.creditCard),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Frequently Asked Questions (FAQ) Section
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _filteredFaqs.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              'No matching questions found.',
                              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: _filteredFaqs.map((faq) {
                              return ExpansionTile(
                                leading: Icon(
                                  LucideIcons.helpCircle,
                                  color: AppTheme.primaryColor,
                                  size: 20.sp,
                                ),
                                title: Text(
                                  faq['question']!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                                    child: Text(
                                      faq['answer']!,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppTheme.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: badgeColor, size: 20.sp),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.sp, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.sp, color: AppTheme.primaryColor),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLiveChat(BuildContext context) {
    final List<Map<String, String>> messages = [
      {'sender': 'bot', 'text': 'Hello! Welcome to Customer Support 👋 How can I help you today?'},
      {'sender': 'user', 'text': 'Hi, I need help tracking my latest order.'},
      {'sender': 'bot', 'text': 'Sure! Your latest order #ORD-98234 is currently In Transit and expected to arrive on 22 Aug 2026.'},
    ];
    final TextEditingController msgController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: 500.h,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Chat Header
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Icon(LucideIcons.bot, color: AppTheme.primaryColor, size: 22.sp),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Support Assistant',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Online',
                                  style: TextStyle(fontSize: 12.sp, color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey.shade200),

                    // Chat Messages List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isUser = msg['sender'] == 'user';
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isUser ? AppTheme.primaryColor : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                msg['text']!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isUser ? Colors.white : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Chat Input Bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: msgController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.send, color: AppTheme.primaryColor),
                            onPressed: () {
                              if (msgController.text.trim().isNotEmpty) {
                                final text = msgController.text.trim();
                                setModalState(() {
                                  messages.add({'sender': 'user', 'text': text});
                                  msgController.clear();
                                });
                                // Auto bot response after 1 sec
                                Future.delayed(const Duration(milliseconds: 800), () {
                                  setModalState(() {
                                    messages.add({
                                      'sender': 'bot',
                                      'text': 'Thanks for reaching out! Our team is reviewing your query.',
                                    });
                                  });
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
