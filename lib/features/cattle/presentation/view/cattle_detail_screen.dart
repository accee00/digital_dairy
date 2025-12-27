import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_dairy/core/extension/build_extenstion.dart';
import 'package:digital_dairy/core/routes/app_routes.dart';
import 'package:digital_dairy/core/widget/custom_container.dart';
import 'package:digital_dairy/features/cattle/cubit/cattle_cubit.dart';
import 'package:digital_dairy/features/cattle/model/cattle_model.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cattle deleted successfully')),
        );
      }

      if (state is CattleDeleteFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.msg), backgroundColor: Colors.red),
        );
      }
    },
    child: Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScaffoldContainer(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _cattleImage(context),
                    const SizedBox(height: 20),
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
                    _buildActionButtons(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Center _cattleImage(BuildContext context) => Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: context.colorScheme.surface, width: 4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colorScheme.shadow.withAlpha(50),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: (widget.cattle.imageUrl?.isNotEmpty ?? false)
              ? cattle.imageUrl!
              : 'https://thumbs.dreamstime.com/b/comic-cow-model-taken-closeup-effect-40822303.jpg',
          fit: BoxFit.fill,
        ),
      ),
    ),
  );

  Widget _buildAppBar(BuildContext context) => SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text('Cattle Deatils'),
    leading: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back, color: context.colorScheme.onSurface),
      ),
    ),
    actions: <Widget>[
      Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withAlpha(200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => _confirmDelete(context),
          icon: Icon(Icons.delete, color: context.colorScheme.error),
        ),
      ),
    ],
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
            cattle.status,
            style: context.textTheme.labelLarge?.copyWith(
              color: _getStatusColor(context, cattle.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tag: ${widget.cattle.tagId}',
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(180),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _buildBasicInfoCard(BuildContext context) =>
      _buildInfoCard(context, 'Basic Information', Icons.info_outline, <Widget>[
        _buildInfoRow(context, 'Breed', cattle.breed, Icons.category),
        _buildInfoRow(
          context,
          'Gender',
          cattle.gender,
          cattle.gender == 'Female' ? Icons.female : Icons.male,
        ),
        _buildInfoRow(
          context,
          'Age',
          _calculateAge(widget.cattle.dob),
          Icons.calendar_today,
        ),
      ]);

  Widget _buildPhysicalDetailsCard(BuildContext context) =>
      _buildInfoCard(context, 'Physical Details', Icons.pets, <Widget>[
        _buildInfoRow(
          context,
          'Current Status',
          cattle.status,
          Icons.health_and_safety,
          valueColor: _getStatusColor(context, cattle.status),
        ),
        if (widget.cattle.gender == 'Female') ...<Widget>[
          _buildInfoRow(
            context,
            'Monthly Milk',
            'Data not available', // You can add this field to your model
            Icons.water_drop,
          ),
          if (widget.cattle.calvingDate != null)
            _buildInfoRow(
              context,
              'Expected Calving',
              _formatDate(widget.cattle.calvingDate),
              Icons.baby_changing_station,
            ),
        ],
      ]);

  Widget _buildDatesCard(BuildContext context) =>
      _buildInfoCard(context, 'Important Dates', Icons.event, <Widget>[
        if (widget.cattle.dob != null)
          _buildInfoRow(
            context,
            'Date of Birth',
            _formatDate(widget.cattle.dob),
            Icons.cake,
          ),
        if (widget.cattle.calvingDate != null)
          _buildInfoRow(
            context,
            'Calving Date',
            _formatDate(widget.cattle.calvingDate),
            Icons.baby_changing_station,
          ),
      ]);

  Widget _buildNotesCard(BuildContext context) =>
      _buildInfoCard(context, 'Additional Notes', Icons.note, <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(50),
            ),
          ),
          child: Text(
            cattle.notes,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ]);

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

  Widget _buildActionButtons(BuildContext context) => Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.addCattle, extra: cattle),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Add health record functionality
            },
            icon: const Icon(Icons.medical_information),
            label: const Text('Health Records'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: context.colorScheme.primary),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (widget.cattle.gender == 'Female')
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(
                AppRoutes.cattleMilk,
                extra: <String, String?>{
                  'cattleId': cattle.id,
                  'cattleName': cattle.name,
                },
              );
            },
            icon: const Icon(Icons.water_drop),
            label: const Text('View Milk Production'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.secondary,
              foregroundColor: context.colorScheme.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
    ],
  );

  String _calculateAge(DateTime? dob) {
    if (dob == null) {
      return 'Unknown';
    }

    final DateTime now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years == 0) {
      return '$months mo';
    }
    if (months == 0) {
      return '$years y';
    }
    return '$years y $months mo';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';

    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
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

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Cattle'),
        content: const Text(
          'Are you sure you want to delete this cattle? This action cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<CattleCubit>().deleteCattle(widget.cattle.id!);
    }
  }
}
