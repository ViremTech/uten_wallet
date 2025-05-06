String truncateAddress(String address, {int start = 6, int end = 6}) {
  if (address.length <= start + end) return address;
  return '${address.substring(0, start)}...${address.substring(address.length - end)}';
}
