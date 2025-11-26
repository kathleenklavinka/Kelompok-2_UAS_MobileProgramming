// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:azzura_rewards/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {
  List<Map<String, String>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = prefs.getStringList('saved_addresses') ?? [];
    
    setState(() {
      addresses = addressJson.map((addr) {
        final parts = addr.split('|');
        return {
          'label': parts[0],
          'address': parts.length > 1 ? parts[1] : '',
          'notes': parts.length > 2 ? parts[2] : '',
        };
      }).toList();
      isLoading = false;
    });
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = addresses
        .map((addr) => '${addr['label']}|${addr['address']}|${addr['notes']}')
        .toList();
    await prefs.setStringList('saved_addresses', addressJson);
  }

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (_) => AddAddressDialog(
        onSave: (label, address, notes) async {
          setState(() {
            addresses.add({
              'label': label,
              'address': address,
              'notes': notes,
            });
          });
          await _saveAddresses();
        },
      ),
    );
  }

  void _editAddress(int index) {
    showDialog(
      context: context,
      builder: (_) => AddAddressDialog(
        initialLabel: addresses[index]['label']!,
        initialAddress: addresses[index]['address']!,
        initialNotes: addresses[index]['notes']!,
        onSave: (label, address, notes) async {
          setState(() {
            addresses[index] = {
              'label': label,
              'address': address,
              'notes': notes,
            };
          });
          await _saveAddresses();
        },
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.cream,
        title: const Text(
          'Delete Address?',
          style: TextStyle(
            color: AppColors.redDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${addresses[index]['label']}"?',
          style: const TextStyle(color: AppColors.greenDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grayDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => addresses.removeAt(index));
              await _saveAddresses();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.redDark,
        centerTitle: true,
        title: const Text(
          'Saved Address',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.redDark, AppColors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.red,
              ),
            )
          : addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 64,
                        color: AppColors.grayDark.withOpacity(0.5),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'No Saved Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grayDark,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Add your first address to save time\nwhen placing orders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grayDark.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final addr = addresses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.grayLight.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.greenLight
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color: AppColors.greenDark,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              addr['label']!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.redDark,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              addr['address']!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.grayDark,
                                              ),
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (addr['notes']!.isNotEmpty) ...[

                                    const SizedBox(height: 12),

                                    Text(
                                      'Note: ${addr['notes']!}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.grayDark
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () =>
                                              _editAddress(index),
                                          icon: const Icon(Icons.edit),
                                          label: const Text('Edit'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.greenDark,
                                            side: const BorderSide(
                                              color: AppColors.greenDark,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () =>
                                              _deleteAddress(index),
                                          icon: const Icon(Icons.delete),
                                          label: const Text('Delete'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.red,
                                            side: const BorderSide(
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        backgroundColor: AppColors.red,
        label: const Text(
          'Add Address',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class AddAddressDialog extends StatefulWidget {
  final Function(String label, String address, String notes) onSave;
  final String initialLabel;
  final String initialAddress;
  final String initialNotes;

  const AddAddressDialog({
    super.key,
    required this.onSave,
    this.initialLabel = '',
    this.initialAddress = '',
    this.initialNotes = '',
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialLabel);
    _addressController = TextEditingController(text: widget.initialAddress);
    _notesController = TextEditingController(text: widget.initialNotes);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.cream,
      title: Text(
        widget.initialLabel.isEmpty ? 'Add New Address' : 'Edit Address',
        style: const TextStyle(
          color: AppColors.redDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                hintText: 'e.g., Home, Office, Parents',
                labelText: 'Address Label',
                labelStyle: const TextStyle(color: AppColors.greenDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your complete address',
                labelText: 'Address',
                labelStyle: const TextStyle(color: AppColors.greenDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Gate code, nearby landmarks',
                labelText: 'Additional Notes (Optional)',
                labelStyle: const TextStyle(color: AppColors.greenDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.grayDark)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            if (_labelController.text.isEmpty ||
                _addressController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all required fields'),
                  backgroundColor: AppColors.red,
                ),
              );
              return;
            }
            widget.onSave(
              _labelController.text,
              _addressController.text,
              _notesController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
