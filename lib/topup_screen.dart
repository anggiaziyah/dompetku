Future<void> topUpSaldo({
  required int jumlahTopup,
  required String metode,
}) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) throw Exception("User belum login");

  final userId = user.id;

  // 1. Tambahkan data ke tabel topup
  await supabase.from('topup').insert({
    'id_user': userId,
    'jumlah_topup': jumlahTopup,
    'metode': metode,
    'status': 'sukses',
  });

  // 2. Ambil saldo lama dari user_data
  final result = await supabase
      .from('user_data')
      .select('saldo')
      .eq('id', userId)
      .single();

  final saldoLama = (result['saldo'] as num?) ?? 0;
  final saldoBaru = saldoLama + jumlahTopup;

  // 3. Update saldo user_data
  await supabase
      .from('user_data')
      .update({'saldo': saldoBaru})
      .eq('id', userId);

  // 4. Catat ke tabel transaksi
  await supabase.from('transaksi').insert({
    'id_user': userId,
    'tipe_transaksi': 'topup',
    'nominal': jumlahTopup,
    'keterangan': 'Top up via $metode',
  });

  // ✅ 5. Tambahkan ke tabel riwayat juga
  await supabase.from('riwayat').insert({
    'id_user': userId,
    'jenis': 'top up',
    'jumlah': jumlahTopup,
    'tujuan': metode,
    'waktu': DateTime.now().toIso8601String(),
  });

  print("✅ Top up sukses. Saldo sekarang: $saldoBaru");
}
