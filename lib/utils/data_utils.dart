import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DataUtils {
  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate(); // Convierte el Timestamp a DateTime
    final formatter = DateFormat('dd/MM/yyyy'); 
    return formatter.format(date); // Devuelve la fecha formateada
  }
}
