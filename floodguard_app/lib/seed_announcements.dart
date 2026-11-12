// TEMPORARY SEED SCRIPT — run once (via the dev-only Home screen button)
// to populate Firestore with sample bilingual government announcements.
// Content is representative/sample data written in the style of real
// JPS, NADMA, and state flood advisories. No public live API exists for
// these agencies, so this demonstrates the Firestore-backed architecture
// described in the report using realistic sample content, similar to how
// the PPS and river-level datasets use synthetic data.
//
// Each announcement stores both an English and Bahasa Malaysia version
// (title_en/title_ms, body_en/body_ms, source_en/source_ms) so the app
// can display the correct language instantly when the user switches,
// without needing a translation service at runtime.

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedAnnouncements() async {
  final collection = FirebaseFirestore.instance.collection('announcements');

  final announcements = [
    {
      'title_en': 'Monsoon Season Advisory — Kelantan',
      'title_ms': 'Nasihat Musim Monsun — Kelantan',
      'source_en': 'JPS Malaysia',
      'source_ms': 'JPS Malaysia',
      'state': 'Kelantan',
      'body_en':
          'The Department of Irrigation and Drainage (JPS) advises residents in '
          'low-lying areas of Kota Bharu, Tumpat, and Pasir Mas to monitor water '
          'levels closely as the Northeast Monsoon approaches. Residents are '
          'encouraged to prepare emergency supplies and identify their nearest '
          'evacuation centre in advance.',
      'body_ms':
          'Jabatan Pengairan dan Saliran (JPS) menasihatkan penduduk di kawasan '
          'rendah Kota Bharu, Tumpat, dan Pasir Mas supaya memantau paras air '
          'dengan teliti ketika Monsun Timur Laut menghampiri. Penduduk '
          'digalakkan menyediakan bekalan kecemasan dan mengenal pasti pusat '
          'pemindahan terdekat lebih awal.',
      'severity': 'Advisory',
      'timestamp': Timestamp.now(),
    },
    {
      'title_en': 'Flood Alert Level Raised — Segamat, Johor',
      'title_ms': 'Tahap Amaran Banjir Dinaikkan — Segamat, Johor',
      'source_en': 'NADMA',
      'source_ms': 'NADMA',
      'state': 'Johor',
      'body_en':
          'The National Disaster Management Agency (NADMA) has raised the flood '
          'alert level for Segamat district following continuous heavy rainfall '
          'over the past 24 hours. Residents near the Sungai Segamat basin should '
          'remain alert and follow instructions from local authorities.',
      'body_ms':
          'Agensi Pengurusan Bencana Negara (NADMA) telah menaikkan tahap amaran '
          'banjir bagi daerah Segamat berikutan hujan lebat berterusan sejak 24 '
          'jam yang lalu. Penduduk berhampiran lembangan Sungai Segamat perlu '
          'sentiasa berwaspada dan mengikut arahan pihak berkuasa tempatan.',
      'severity': 'Warning',
      'timestamp': Timestamp.now(),
    },
    {
      'title_en': 'River Water Level Update — Kuala Terengganu',
      'title_ms': 'Kemas Kini Paras Air Sungai — Kuala Terengganu',
      'source_en': 'JPS Malaysia',
      'source_ms': 'JPS Malaysia',
      'state': 'Terengganu',
      'body_en':
          'Water levels at the Sungai Terengganu monitoring station remain within '
          'normal range as of this morning. JPS will continue monitoring '
          'conditions throughout the week amid forecasted rain.',
      'body_ms':
          'Paras air di stesen pemantauan Sungai Terengganu kekal dalam julat '
          'normal setakat pagi ini. JPS akan terus memantau keadaan sepanjang '
          'minggu ini berikutan ramalan hujan.',
      'severity': 'Advisory',
      'timestamp': Timestamp.now(),
    },
    {
      'title_en': 'Flash Flood Warning — Hulu Langat, Selangor',
      'title_ms': 'Amaran Banjir Kilat — Hulu Langat, Selangor',
      'source_en': 'NADMA',
      'source_ms': 'NADMA',
      'state': 'Selangor',
      'body_en':
          'Heavy rainfall in the Hulu Langat district has triggered a flash flood '
          'warning. Residents in Kampung Baru Hulu Langat and surrounding areas '
          'are advised to move to higher ground and avoid crossing flooded roads.',
      'body_ms':
          'Hujan lebat di daerah Hulu Langat telah mencetuskan amaran banjir '
          'kilat. Penduduk di Kampung Baru Hulu Langat dan kawasan sekitar '
          'dinasihatkan berpindah ke kawasan lebih tinggi dan mengelakkan '
          'melintasi jalan yang ditenggelami banjir.',
      'severity': 'Warning',
      'timestamp': Timestamp.now(),
    },
    {
      'title_en': 'State Flood Operations Centre Activated — Johor',
      'title_ms': 'Pusat Operasi Banjir Negeri Diaktifkan — Johor',
      'source_en': 'Johor State Government',
      'source_ms': 'Kerajaan Negeri Johor',
      'state': 'Johor',
      'body_en':
          'The Johor State Disaster Management Committee has activated the state '
          'flood operations centre in response to ongoing heavy rain across '
          'multiple districts. The public can contact the centre hotline for '
          'evacuation assistance and updates.',
      'body_ms':
          'Jawatankuasa Pengurusan Bencana Negeri Johor telah mengaktifkan pusat '
          'operasi banjir negeri sebagai respons kepada hujan lebat berterusan di '
          'pelbagai daerah. Orang ramai boleh menghubungi talian hotline pusat '
          'untuk bantuan pemindahan dan kemas kini.',
      'severity': 'Advisory',
      'timestamp': Timestamp.now(),
    },
  ];

  for (final announcement in announcements) {
    await collection.add(announcement);
  }
}