import 'package:equatable/equatable.dart';

class Due extends Equatable {
  final String date;


  const Due({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}
