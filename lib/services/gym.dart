import 'dart:ffi';

class Gym {
  final name;
  final lat;
  final long;
  final bool? openNow; // Store the openNow field
  final List<dynamic>? periods; // Store the periods if available


  const Gym({
    required this.name,
    required this.lat,
    required this.long,
    this.openNow,
    this.periods,
  });

   @override
  String toString() {
    String openStatus = openNow == null ? 'No information available' : (openNow! ? 'Open now' : 'Closed now');
    
    String periodsText = '';
    if (periods != null) {
      for (var period in periods!) {
        var openTime = period['open']['time'];
        var closeTime = period['close']['time'];
        var day = _getDayFromIndex(period['open']['day']);
        periodsText += '$day: $openTime - $closeTime\n';
      }
    } else {
      periodsText = 'No detailed hours available';
    }

    return 'Gym: $name\nLocation: Lat: $lat, Long: $long\nStatus: $openStatus\nOpening hours:\n$periodsText';
  }


String _getDayFromIndex(int index) {
    const days = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ];
    return days[index];
  }



}