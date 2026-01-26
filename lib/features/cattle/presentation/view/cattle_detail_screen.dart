import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/utils/age_calculator.dart';
import 'package:digital_dairy/core/utils/custom_snackbar.dart';
import 'package:digital_dairy/core/widget/custom_scaffold_container.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
import 'package:digital_dairy/features/cattle/presentation/widget/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget for displaying detailed information about a cattle.
class CattleDetailScreen extends StatefulWidget {
  /// Initializes a new instance of the [CattleDetailScreen] widget.
  const CattleDetailScreen({required this.cattle, super.key});

  /// The cattle object containing all details
  final Cattle cattle;

  @override
  State<CattleDetailScreen> createState() => _CattleDetailScreenState();
}

class _CattleDetailScreenState extends State<CattleDetailScreen> {
  late Cattle cattle;

  @override
  void initState() {
    cattle = widget.cattle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocListener<CattleCubit, CattleState>(
    listener: (BuildContext context, CattleState state) {
      if (state is CattleUpdatedSuccess) {
        setState(() {
          cattle = state.updatedCattle;
        });
      }
      if (state is CattleDeletedSuccess) {
        context.pop();
        showAppSnackbar(context, message: context.strings.cattleDeletedSuccess);
      }
      if (state is CattleDeleteFailure) {
        showAppSnackbar(context, message: state.msg, type: SnackbarType.error);
      }
    },
    child: Scaffold(
      body: CustomScaffoldContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Stack(
                children: <Widget>[
                  _cattleImage(context),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: context.height * 0.30),
                            _buildHeaderCard(context),
                            const SizedBox(height: 20),
                            _buildBasicInfoCard(context),
                            const SizedBox(height: 16),
                            _buildPhysicalDetailsCard(context),
                            const SizedBox(height: 16),
                            _buildDatesCard(context),
                            if (widget.cattle.notes.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 16),
                              _buildNotesCard(context),
                            ],
                            const SizedBox(height: 16),
                            if (widget.cattle.gender == 'Female')
                              _buildActionButtons(context)
                            else
                              const SizedBox.shrink(),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _cattleImage(BuildContext context) => SizedBox(
    height: context.height * 0.35,
    width: double.infinity,
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: (widget.cattle.imageUrl?.isNotEmpty ?? false)
                ? cattle.imageUrl!
                : 'https://thumbs.dreamstime.com/b/comic-cow-model-taken-closeup-effect-40822303.jpg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              padding: const EdgeInsets.only(left: 10),
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 16,
          child: Row(
            children: <Widget>[
              CircularButton(
                icon: Icons.edit,
                iconColor: context.isDarkMode ? Colors.white : Colors.black,
                onTap: () => context.push(AppRoutes.addCattle, extra: cattle),
              ),
              const SizedBox(width: 15),
              CircularButton(
                iconColor: context.colorScheme.error,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildHeaderCard(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.colorScheme.surface.withAlpha(240),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: context.colorScheme.shadow.withAlpha(30),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Text(
          cattle.name,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(context, cattle.status).withAlpha(50),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getStatusColor(context, cattle.status)),
          ),
          child: Text(
            _getLocalizedStatus(cattle.status, context),
            style: context.textTheme.labelLarge?.copyWith(
              color: _getStatusColor(context, cattle.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${context.strings.tag}: ${widget.cattle.tagId}',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(180),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _buildBasicInfoCard(BuildContext context) => _buildInfoCard(
    context,
    context.strings.basicInformation,
    Icons.info_outline,
    <Widget>[
      _buildInfoRow(
        context,
        context.strings.breed,
        cattle.breed,
        Icons.category,
      ),
      _buildInfoRow(
        context,
        context.strings.gender,
        _getLocalizedGender(cattle.gender, context),
        cattle.gender == 'Female' ? Icons.female : Icons.male,
      ),
      _buildInfoRow(
        context,
        context.strings.age,
        calculateAge(widget.cattle.dob),
        Icons.calendar_today,
      ),
    ],
  );

  Widget _buildPhysicalDetailsCard(BuildContext context) => _buildInfoCard(
    context,
    context.strings.physicalDetails,
    Icons.pets,
    <Widget>[
      _buildInfoRow(
        context,
        context.strings.currentStatus,
        _getLocalizedStatus(cattle.status, context),
        Icons.health_and_safety,
        valueColor: _getStatusColor(context, cattle.status),
      ),
      if (widget.cattle.gender == 'Female') ...<Widget>[
        _buildInfoRow(
          context,
          context.strings.monthlyMilk,
          '${widget.cattle.thisMonthL!} L',
          Icons.water_drop,
        ),
        if (widget.cattle.calvingDate != null)
          _buildInfoRow(
            context,
            context.strings.expectedCalving,
            _formatDate(widget.cattle.calvingDate, context),
            Icons.baby_changing_station,
          ),
      ],
    ],
  );

  Widget _buildDatesCard(BuildContext context) => _buildInfoCard(
    context,
    context.strings.importantDates,
    Icons.event,
    <Widget>[
      if (widget.cattle.dob != null)
        _buildInfoRow(
          context,
          context.strings.dateOfBirth,
          _formatDate(widget.cattle.dob, context),
          Icons.cake,
        ),
      if (widget.cattle.calvingDate != null)
        _buildInfoRow(
          context,
          context.strings.calvingDate,
          _formatDate(widget.cattle.calvingDate, context),
          Icons.baby_changing_station,
        ),
    ],
  );

  Widget _buildNotesCard(BuildContext context) => _buildInfoCard(
    context,
    context.strings.additionalNotes,
    Icons.note,
    <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
        ),
        child: Text(
          cattle.notes,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ),
    ],
  );

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.colorScheme.surface.withAlpha(240),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.colorScheme.outline.withAlpha(50)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: context.colorScheme.shadow.withAlpha(20),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withAlpha(150),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: context.colorScheme.onSurface, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: <Widget>[
        Icon(icon, size: 18, color: context.colorScheme.primary.withAlpha(180)),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(160),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? context.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );

  Widget _buildActionButtons(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () {
        context.push(
          AppRoutes.cattleMilkDetail,
          extra: <String, String?>{
            'cattleId': cattle.id,
            'cattleName': cattle.name,
          },
        );
      },
      icon: const Icon(Icons.water_drop),
      label: Text(context.strings.viewMilkProduction),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.secondary,
        foregroundColor: context.colorScheme.onSecondaryContainer,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  String _formatDate(DateTime? date, BuildContext context) {
    if (date == null) {
      return context.strings.notSet;
    }

    // Get localized month names from context.strings
    final String monthName = _getLocalizedMonth(date.month - 1, context);

    return '${date.day} $monthName ${date.year}';
  }

  String _getLocalizedMonth(int monthIndex, BuildContext context) {
    final List<String> monthKeys = <String>[
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];

    if (monthIndex >= 0 && monthIndex < monthKeys.length) {
      // Access the localized month name from context.strings
      // Using a switch or map to map month keys to actual string access
      switch (monthIndex) {
        case 0:
          return context.strings.jan;
        case 1:
          return context.strings.feb;
        case 2:
          return context.strings.mar;
        case 3:
          return context.strings.apr;
        case 4:
          return context.strings.may;
        case 5:
          return context.strings.jun;
        case 6:
          return context.strings.jul;
        case 7:
          return context.strings.aug;
        case 8:
          return context.strings.sep;
        case 9:
          return context.strings.oct;
        case 10:
          return context.strings.nov;
        case 11:
          return context.strings.dec;
        default:
          return '';
      }
    }
    return '';
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Pregnant':
        return Colors.purple;
      case 'Sick':
        return Colors.orange;
      case 'Dry':
        return Colors.blue;
      case 'Sold':
        return Colors.grey;
      case 'Dead':
        return Colors.red;
      default:
        return context.colorScheme.onSurface;
    }
  }

  String _getLocalizedStatus(String status, BuildContext context) {
    switch (status) {
      case 'Active':
        return context.strings.active;
      case 'Pregnant':
        return context.strings.pregnant;
      case 'Sick':
        return context.strings.sick;
      case 'Dry':
        return context.strings.dry;
      case 'Sold':
        return context.strings.sold;
      case 'Dead':
        return context.strings.dead;
      default:
        return status;
    }
  }

  String _getLocalizedGender(String gender, BuildContext context) {
    switch (gender) {
      case 'Female':
        return context.strings.female;
      case 'Male':
        return context.strings.male;
      default:
        return gender;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(context.strings.deleteCattle),
        content: Text(context.strings.deleteConfirmation),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.strings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: Text(context.strings.delete),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await context.read<CattleCubit>().deleteCattle(widget.cattle.id!);
    }
  }
}
