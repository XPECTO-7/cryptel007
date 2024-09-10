import 'package:cryptel007/Tools/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class WorkCard extends StatefulWidget {
  final dynamic doc;
  final VoidCallback onEdit;
  final VoidCallback onViewImage;
  final int itemNumber;

  const WorkCard({
    super.key,
    required this.doc,
    required this.onEdit,
    required this.onViewImage,
    required this.itemNumber,
  });

  @override
  _WorkCardState createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  bool _isExpanded = false;
  final bool _isAllowed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset _isExpanded to false when the widget is rebuilt
    _isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final name = (widget.doc['name'] ?? '').toUpperCase();
    final completion = (widget.doc['completion'] ?? '0') as String;
    final quantity = widget.doc['quantity'] ?? '';
    final expectedDeliveryDate = widget.doc['expectedDeliveryDate'] ?? '';
    final id = widget.doc['id'] ?? '';
    final rawmaterial = widget.doc['rawmaterial'] ?? '';
    final rmsize = widget.doc['rmsize'] ?? '';
    final rmc = widget.doc['rmc'] ?? '';
    final machine = widget.doc['machine'] ?? '';
    final operators = widget.doc['operator'] ?? '';
    final workcenter = widget.doc['workcenter'] ?? '';
    final lastEdit = widget.doc['lastedit'] ?? '';
    final imageUrl = widget.doc['imageUrl'] ?? '';
    final drawingnumber = widget.doc['drawingnumber'] ?? '';

    return GestureDetector(
      onTap: widget.onEdit,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl.isNotEmpty)
                            GestureDetector(
                              onTap: widget.onViewImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (imageUrl.isNotEmpty) const SizedBox(height: 10),
                         
          //                   GestureDetector(  onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => PdfUploadPage(
          //         workOrderNumber: '123456', // Pass required parameters
          //         workId: 'work-id',
          //       ),
          //     ),
          //   );
          // },
          //                     child: Image.asset(
          //                       'assets/pdf.png',
          //                       height: 70,
          //                       width: 70,
          //                     ),
          //                   )
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Expected Delivery Date',
                                      style: GoogleFonts.roboto(
                                          color: AppColors.logoblue,
                                          fontSize: 11),
                                    ),
                                    Text(
                                      expectedDeliveryDate,
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ID: $id',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Dwg No: $drawingnumber',
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildPercentageIndicator(completion),
                            const SizedBox(height: 8),
                            Text(
                              'Last Edited: $lastEdit',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if(_isAllowed)
                Positioned(
                  right: 1,
                  bottom: 0.01,
                  child: IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.black,
                      size: 34,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_isExpanded && _isAllowed)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Details:',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey[300], thickness: 1),
                    const SizedBox(height: 8),
                    _buildDetailRow('Quantity', quantity),
                    _buildDetailRow('Raw Material', rawmaterial),
                    _buildDetailRow('Size', rmsize),
                    _buildDetailRow('RMC', rmc),
                    _buildDetailRow('Machine', machine),
                    _buildDetailRow('Operator', operators),
                    _buildDetailRow('Work Center', workcenter),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

Widget _buildPercentageIndicator(String completion) {
  final double percentage = double.tryParse(completion) ?? 0;

  // Define the progress color based on percentage value
  Color getProgressColor(double percentage) {
    if (percentage < 30) {
      return Colors.red;
    } else if (percentage < 60) {
      return Colors.orange;
    } else if (percentage < 80) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  return SizedBox(
    width: double.infinity, // Increase the bar length to maximum width
    child: LinearPercentIndicator(
      lineHeight: 25.0,
      percent: percentage / 100,
      backgroundColor: Colors.grey[200]!,
      progressColor: getProgressColor(percentage), // Dynamic progress color
      center: Text(
        '${percentage.toStringAsFixed(1)}%',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      barRadius: const Radius.circular(12), // Controls rounded corners
    ),
  );
}


}
