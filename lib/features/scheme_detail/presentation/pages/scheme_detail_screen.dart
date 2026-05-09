import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/scheme_detail_bloc.dart';
import '../../../../core/network/api_client.dart';
import '../../data/scheme_detail_repository.dart';
import '../../data/scheme_detail_model.dart';
import '../../../../core/theme/app_theme.dart';

class SchemeDetailScreen extends StatelessWidget {
  final int schemeCode;
  final String schemeName;

  const SchemeDetailScreen({
    super.key,
    required this.schemeCode,
    required this.schemeName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => SchemeDetailBloc(
        repository: SchemeDetailRepository(apiClient: context.read<ApiClient>()),
      )..add(FetchSchemeDetail(schemeCode)),
      child: Scaffold(
        body: Column(
          children: [
            // Gradient Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 24,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    schemeName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: BlocBuilder<SchemeDetailBloc, SchemeDetailState>(
                builder: (context, state) {
                  if (state is SchemeDetailLoading) {
                    return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                  } else if (state is SchemeDetailError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          Text(
                            state.message, 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  } else if (state is SchemeDetailLoaded) {
                    final data = state.detail.data;
                    
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildMetaInfoChips(context, state.detail, isDark),
                        ),
                        if (data.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                              child: Text(
                                '30-Day NAV Trend', 
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildChart(context, data, isDark),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                              child: Text(
                                'NAV History', 
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final navItem = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.02),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                        leading: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.calendar_month_rounded, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500, size: 20),
                                        ),
                                        title: Text(
                                          navItem.date,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600, 
                                            fontSize: 15,
                                            color: theme.textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.green.shade900.withValues(alpha: 0.3) : Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '₹${navItem.nav}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.green.shade400 : Colors.green.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: data.length,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        ] else ...[
                          SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No NAV history available.',
                                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showInvestBottomSheet(context, isDark),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Invest Now', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfoChips(BuildContext context, SchemeDetailModel detail, bool isDark) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          _buildChip(theme, isDark, Icons.account_balance_rounded, detail.fundHouse),
          const SizedBox(width: 12),
          _buildChip(theme, isDark, Icons.category_rounded, detail.schemeCategory),
          const SizedBox(width: 12),
          _buildChip(theme, isDark, Icons.pie_chart_rounded, detail.schemeType),
        ],
      ),
    );
  }

  Widget _buildChip(ThemeData theme, bool isDark, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.secondaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<NavModel> data, bool isDark) {
    final theme = Theme.of(context);
    final chartData = data.take(30).toList().reversed.toList();
    
    final spots = chartData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.navAsDouble);
    }).toList();

    if (spots.isEmpty) return const SizedBox();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    
    final range = maxY - minY > 0 ? maxY - minY : 1.0;
    final paddedMinY = minY - (range * 0.1);
    final paddedMaxY = maxY + (range * 0.1);
    final interval = range / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(right: 24, left: 16, top: 32, bottom: 20),
        child: LineChart(
          LineChartData(
            minY: paddedMinY, 
            maxY: paddedMaxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.min || value == meta.max) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toStringAsFixed(2),
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500, 
                          fontSize: 12
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: theme.colorScheme.primary,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) => theme.colorScheme.primary,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      '₹${touchedSpot.y.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInvestBottomSheet(BuildContext parentContext, bool isDark) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _InvestBottomSheet(schemeName: schemeName, isDark: isDark);
      },
    );
  }
}

class _InvestBottomSheet extends StatefulWidget {
  final String schemeName;
  final bool isDark;
  const _InvestBottomSheet({required this.schemeName, required this.isDark});

  @override
  State<_InvestBottomSheet> createState() => _InvestBottomSheetState();
}

class _InvestBottomSheetState extends State<_InvestBottomSheet> {
  final _amountController = TextEditingController();
  String? _errorText;

  void _confirmInvestment() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      setState(() => _errorText = 'Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      setState(() => _errorText = 'Please enter a valid number');
      return;
    }

    if (amount < 100) {
      setState(() => _errorText = 'Minimum ₹100 required');
      return;
    }

    Navigator.pop(context); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Investment successful!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Invest in Fund',
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w600, 
              color: widget.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.schemeName,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              labelText: 'Investment Amount',
              prefixText: '₹ ',
              prefixStyle: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: theme.textTheme.bodyLarge?.color,
              ),
              errorText: _errorText,
            ),
            onChanged: (value) {
              if (_errorText != null) setState(() => _errorText = null);
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _confirmInvestment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const Text('Confirm Investment', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
