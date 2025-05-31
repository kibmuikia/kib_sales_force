import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/core/utils/export.dart' show VisitStatus;
import 'package:kib_sales_force/data/models/export.dart' show Visit;
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:kib_sales_force/providers/export.dart' show CreateVisitProvider;
import 'package:kib_sales_force/services/export.dart'
    show CustomersService, VisitsService;
import 'package:provider/provider.dart' show Provider, Consumer;

class CreateVisitBottomSheet extends StatefulWidgetK {
  CreateVisitBottomSheet({
    super.key,
    super.tag = "CreateVisitBottomSheet",
    required this.onEntryCreated,
    this.entryToEdit,
  });

  final Function(Visit) onEntryCreated;
  final Visit? entryToEdit;

  @override
  StateK<CreateVisitBottomSheet> createState() =>
      _CreateVisitBottomSheetState();

  static Future<T?> show<T>(
    BuildContext context,
    Function(Visit) onEntryCreated, {
    Visit? entryToEdit,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      useRootNavigator: false,
      builder: (_) => LocalProviderUtils.withProvider(
        create: (ctx) => CreateVisitProvider(
          visitsService: getIt<VisitsService>(),
          customersService: getIt<CustomersService>(),
        ),
        child: CreateVisitBottomSheet(
          onEntryCreated: onEntryCreated,
          entryToEdit: entryToEdit,
        ),
      ),
    );
  }
}

class _CreateVisitBottomSheetState extends StateK<CreateVisitBottomSheet> {
  late final CreateVisitProvider _createVisitProvider;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  List<int> _selectedActivities = [];

  @override
  void initState() {
    super.initState();
    postFrame(() async {
      _initProvider();
      _initControllers();
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initProvider() async {
    _createVisitProvider =
        Provider.of<CreateVisitProvider>(context, listen: false);
    _createVisitProvider.init();
  }

  void _initControllers() {
    final visitToEdit = widget.entryToEdit;

    _locationController = TextEditingController(
      text: visitToEdit?.location ?? '',
    );
    _notesController = TextEditingController(
      text: visitToEdit?.notes ?? '',
    );
    if (visitToEdit != null) {
      _selectedDate = visitToEdit.visitDate;
      _createVisitProvider.updateSelectedCustomerId(visitToEdit.customerId);
      _selectedActivities = visitToEdit.activitiesDone;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final current = _selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && picked != current) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    context.hideKeyboard();

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final location = _locationController.text.trim();
    final notes = _notesController.text.trim();
    final customerId = _createVisitProvider.selectedCustomerId;
    final visitDate = _selectedDate;
    final activities = _selectedActivities;

    if (visitDate == null) {
      _createVisitProvider.updateErrorMessage('Please select a date');
      return;
    }

    final visit = Visit(
      id: widget.entryToEdit?.id ?? 0,
      customerId: customerId,
      visitDate: visitDate,
      location: location,
      notes: notes,
      activitiesDone: activities,
      status: VisitStatus.created.name,
      createdAt: DateTime.now(),
    );

    final success = await _createVisitProvider.saveVisit(visit);
    if (success) {
      widget.onEntryCreated(visit);
      _pop();
    }
    // TODO: to remove once server apikey issue is resolved.
    _pop();
  }

  void _pop() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget buildWithTheme(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          widget.entryToEdit != null ? 'Edit Visit' : 'Create Visit',
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, size: 24, color: colorScheme.onSurface),
        ),
      ),
      body: Consumer<CreateVisitProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    // Customer Selection
                    DropdownButtonFormField<int>(
                      value: provider.selectedCustomerId >= 0
                          ? provider.selectedCustomerId
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Select Customer',
                        border: OutlineInputBorder(),
                      ),
                      items: provider.customers
                          .map((customer) => DropdownMenuItem<int>(
                                value: customer.id,
                                child: Text(customer.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          provider.updateSelectedCustomerId(value);
                        }
                      },
                      validator: (value) {
                        final current = provider.selectedCustomerId;
                        if (current == null || current < 0) {
                          return 'Please select a customer';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Selection
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Visit Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : '',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final current = _locationController.text.trim();
                        if (current.isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                      validator: (value) {
                        final current = _notesController.text.trim();
                        if (current.isEmpty) {
                          return 'Please enter a notes';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    /* // Activities Selection
                    const Text('Activities'),
                    const SizedBox(height: 8),
                    // TODO: Add activities selection
                    const SizedBox(height: 24), */

                    // Submit Button
                    ElevatedButton(
                      onPressed: provider.status.isLoading
                          ? null
                          : () => _submitForm(context),
                      child: provider.status.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Visit'),
                    ),

                    // Error Message
                    if (provider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          provider.errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),

                    // Extra space
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
