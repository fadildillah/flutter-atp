enum TransportType { krl, mrt, lrt, brt }

TransportType transportTypeFromString(String type) {
  switch (type) {
    case 'krl':
      return TransportType.krl;
    case 'mrt':
      return TransportType.mrt;
    case 'lrt':
      return TransportType.lrt;
    case 'brt':
      return TransportType.brt;
    default:
      throw ArgumentError("Invalid transport type");
  }
}

String transportTypeToString(TransportType type) {
  return type.toString().split('.').last;
}
