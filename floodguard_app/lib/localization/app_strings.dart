import 'package:flutter/material.dart';

/// Holds every translated string used in the app. Add new keys here as
/// more screens get translated (see tracker items 7.9 and 7.13).
class AppStrings {
  static const Map<String, Map<String, String>> _values = {
    'en': {
      // Login / Register
      'welcome_back': 'Welcome Back',
      'create_account': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'register': 'Register',
      'no_account_register': 'No account? Register',
      'already_have_account_login': 'Already have an account? Login',

      // Home
      'app_title': 'FloodGuard Malaysia',
      'feature_risk_title': 'Check Flood Risk',
      'feature_risk_subtitle': 'GPS-based prediction for your area',
      'feature_pps_title': 'Find Evacuation Centre',
      'feature_pps_subtitle': 'Nearest PPS with directions',
      'feature_announcements_title': 'Government Announcements',
      'feature_announcements_subtitle': 'Live JPS, NADMA & state advisories',
      'feature_alerts_title': 'Alert History',
      'feature_alerts_subtitle': 'Past High-risk alerts on this device',
      'feature_timeline_title': 'Flood History',
      'feature_timeline_subtitle': 'Real past flood events, EM-DAT data',
      'feature_weather_title': 'Weather',
      'feature_weather_subtitle': 'Current conditions & 72-hour forecast',
      'feature_chatbot_title': 'Ask FloodGuard Assistant',
      'feature_chatbot_subtitle': 'Flood safety help, EN & BM',

      // Onboarding
      'onb_skip': 'Skip',
      'onb_next': 'Next',
      'onb_get_started': 'Get Started',
      'onb_title_1': 'Know Your Flood Risk',
      'onb_desc_1': 'FloodGuard checks your GPS location and current weather '
          'to give you a real-time flood risk level: Low, Medium, or High.',
      'onb_title_2': 'Find Safety Fast',
      'onb_desc_2': 'When risk is high, quickly locate the nearest '
          'evacuation centre with directions, capacity, and contact details.',
      'onb_title_3': 'Stay Alerted',
      'onb_desc_3': 'Get notified the moment your area is classified as '
          'High risk, plus live announcements from JPS, NADMA, and state '
          'authorities.',
      'onb_title_4': 'Ask Anytime',
      'onb_desc_4': 'Not sure what to do? Ask the built-in assistant about '
          'flood preparedness, in English or Bahasa Malaysia.',

      // Settings
      'settings_title': 'Settings',
      'preferences': 'Preferences',
      'language': 'Language',
      'high_risk_alerts': 'High-risk alerts',
      'high_risk_alerts_subtitle': 'Get notified when your area is High risk',
      'dark_mode': 'Dark mode',
      'about': 'About',
      'about_app': 'About FloodGuard Malaysia',
      'replay_onboarding': 'Replay Onboarding',
      'sign_out': 'Sign Out',

      // Risk Detection
      'risk_detection_title': 'Risk Detection',
      'water_condition_heading': 'Current water condition near you',
      'water_condition_desc': 'Live river sensor data is not yet available. '
          'Please select the option that best matches what you observe or '
          'have heard reported locally.',
      'water_normal': 'Normal',
      'water_normal_desc': 'No visible rise, water level looks typical',
      'water_rising': 'Rising',
      'water_rising_desc': 'Water level appears higher than usual',
      'water_high': 'High / Flooding',
      'water_high_desc': 'Visible flooding or water near critical level',
      'check_flood_risk': 'Check Flood Risk',
      'checking': 'Checking...',
      'select_water_condition_error': 'Please select the current water condition first.',
      'flood_risk_label': 'Flood Risk',
      'confidence_label': 'Confidence',
      'rainfall': 'Rainfall',
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'wind': 'Wind',
      'cloud_cover': 'Cloud cover',
      'risk_high': 'High',
      'risk_medium': 'Medium',
      'risk_low': 'Low',

      // PPS Locator / Detail
      'evacuation_centres_title': 'Evacuation Centres',
      'showing_all_centres_notice': 'Showing all centres — location unavailable',
      'centre_details_title': 'Centre Details',
      'km_away': 'km away',
      'capacity_label': 'Capacity',
      'occupied': 'occupied',
      'full_pct': 'full',
      'nearby_severity_note': 'This reflects the surrounding area, not the centre itself.',
      'nearby_severity_label': 'Nearby flood severity',
      'get_directions': 'Get Directions',
      'severity_low': 'Low',
      'severity_moderate': 'Moderate',
      'severity_high': 'High',
      'severity_critical': 'Critical',

      // Announcements
      'announcements_title': 'Government Announcements',
      'announcement_title': 'Announcement',
      'no_announcements': 'No announcements right now.',
      'could_not_load_announcements': 'Could not load announcements.',
      'severity_advisory': 'Advisory',
      'severity_warning': 'Warning',

      // Alerts History
      'alert_history_title': 'Alert History',
      'no_alerts_yet': 'No alerts yet. High-risk alerts you receive will appear here.',
      'clear_all_alerts_title': 'Clear all alerts?',
      'clear_all_alerts_desc': 'This removes your alert history from this device.',
      'cancel': 'Cancel',
      'clear': 'Clear',

      // Flood Timeline
      'flood_timeline_title': 'Historical Flood Timeline',
      'all_states': 'All States',
      'recorded_events': 'recorded events',
      'recorded_event': 'recorded event',
      'no_events_for_state': 'No events for this state.',
      'cause_label': 'Cause',
      'deaths_label': 'deaths',
      'affected_label': 'affected',

      // Weather
      'weather_title': 'Weather',
      'next_72_hours': 'Next 72 hours',
      'details': 'Details',
      'feels_like': 'Feels like',
      'pressure': 'Pressure',
      'visibility': 'Visibility',
      'sunrise_sunset': 'Sunrise / Sunset',
      'rain_expected_prompt': 'Rain expected — check your flood risk',
      'check_flood_risk_prompt': 'Check your flood risk',
      'flood_risk_prompt_subtitle': 'See how current and forecast conditions affect your area',
      'retry': 'Retry',

      // Chatbot
      'chatbot_title': 'FloodGuard Assistant',
      'chatbot_greeting': 'Hi! I\'m your FloodGuard assistant. Ask me about '
          'flood preparedness, evacuation steps, or what to do during a '
          'flood. You can ask in English or Bahasa Malaysia.',
      'chatbot_new_conversation': 'New conversation started. How can I help?',
      'chatbot_input_hint': 'Ask about flood safety...',
      'chatbot_new_conversation_tooltip': 'Start new conversation',

      // Error messages (shown when location/network actions fail)
      'error_location_services_off': 'Location services are turned off.',
      'error_location_permission_denied': 'Location permission denied.',
      'error_location_permission_denied_forever': 'Location permission permanently denied.',
      'error_fetch_weather_failed': 'Failed to fetch weather data.',
      'error_fetch_forecast_failed': 'Failed to fetch forecast data.',
      'error_prediction_failed': 'Prediction failed. Please try again.',
      'error_generic': 'Something went wrong. Please try again.',

      // Alert content (regenerated at display time in current language,
      // not baked in at the moment the alert fired)
      'high_risk_alert_title': 'High Flood Risk Warning',
      'high_risk_alert_body': 'Your area has been classified as High risk. Check nearby evacuation centres now.',

      // Simulation feature (was a temporary test button, now a
      // permanent, clearly labeled demonstration feature — see tracker 7.10)
      'simulate_extreme_conditions': 'Simulate Extreme Conditions',
      'simulate_extreme_conditions_subtitle': 'For demonstration — shows the High-risk alert flow without waiting for real severe weather',
    },
    'ms': {
      'welcome_back': 'Selamat Kembali',
      'create_account': 'Cipta Akaun',
      'email': 'E-mel',
      'password': 'Kata Laluan',
      'login': 'Log Masuk',
      'register': 'Daftar',
      'no_account_register': 'Tiada akaun? Daftar',
      'already_have_account_login': 'Sudah ada akaun? Log Masuk',

      'app_title': 'FloodGuard Malaysia',
      'feature_risk_title': 'Semak Risiko Banjir',
      'feature_risk_subtitle': 'Ramalan berasaskan GPS untuk kawasan anda',
      'feature_pps_title': 'Cari Pusat Pemindahan',
      'feature_pps_subtitle': 'PPS terdekat dengan arah tuju',
      'feature_announcements_title': 'Pengumuman Kerajaan',
      'feature_announcements_subtitle': 'Nasihat langsung JPS, NADMA & negeri',
      'feature_alerts_title': 'Sejarah Amaran',
      'feature_alerts_subtitle': 'Amaran risiko Tinggi lepas pada peranti ini',
      'feature_timeline_title': 'Sejarah Banjir',
      'feature_timeline_subtitle': 'Kejadian banjir sebenar, data EM-DAT',
      'feature_weather_title': 'Cuaca',
      'feature_weather_subtitle': 'Keadaan semasa & ramalan 72 jam',
      'feature_chatbot_title': 'Tanya Pembantu FloodGuard',
      'feature_chatbot_subtitle': 'Bantuan keselamatan banjir, EN & BM',

      'onb_skip': 'Langkau',
      'onb_next': 'Seterusnya',
      'onb_get_started': 'Mula',
      'onb_title_1': 'Ketahui Risiko Banjir Anda',
      'onb_desc_1': 'FloodGuard menyemak lokasi GPS dan cuaca semasa anda '
          'untuk memberikan tahap risiko banjir masa nyata: Rendah, '
          'Sederhana, atau Tinggi.',
      'onb_title_2': 'Cari Keselamatan dengan Pantas',
      'onb_desc_2': 'Apabila risiko tinggi, cari pusat pemindahan terdekat '
          'dengan pantas lengkap dengan arah tuju, kapasiti, dan butiran '
          'hubungan.',
      'onb_title_3': 'Kekal Diberi Amaran',
      'onb_desc_3': 'Dapatkan notifikasi sebaik sahaja kawasan anda '
          'dikelaskan sebagai risiko Tinggi, serta pengumuman langsung '
          'daripada JPS, NADMA, dan pihak berkuasa negeri.',
      'onb_title_4': 'Tanya Bila-bila Masa',
      'onb_desc_4': 'Tidak pasti apa perlu dibuat? Tanya pembantu terbina '
          'dalam tentang kesediaan banjir, dalam Bahasa Inggeris atau '
          'Bahasa Malaysia.',

      'settings_title': 'Tetapan',
      'preferences': 'Keutamaan',
      'language': 'Bahasa',
      'high_risk_alerts': 'Amaran risiko tinggi',
      'high_risk_alerts_subtitle': 'Dapatkan notifikasi apabila kawasan anda berisiko Tinggi',
      'dark_mode': 'Mod Gelap',
      'about': 'Tentang',
      'about_app': 'Tentang FloodGuard Malaysia',
      'replay_onboarding': 'Ulang Tunjuk Cara',
      'sign_out': 'Log Keluar',

      'risk_detection_title': 'Pengesanan Risiko',
      'water_condition_heading': 'Keadaan air semasa berhampiran anda',
      'water_condition_desc': 'Data sensor sungai langsung belum tersedia. '
          'Sila pilih pilihan yang paling sesuai dengan apa yang anda lihat '
          'atau dengar dilaporkan secara tempatan.',
      'water_normal': 'Normal',
      'water_normal_desc': 'Tiada kenaikan ketara, paras air kelihatan seperti biasa',
      'water_rising': 'Meningkat',
      'water_rising_desc': 'Paras air kelihatan lebih tinggi daripada biasa',
      'water_high': 'Tinggi / Banjir',
      'water_high_desc': 'Banjir jelas kelihatan atau air hampir paras kritikal',
      'check_flood_risk': 'Semak Risiko Banjir',
      'checking': 'Memeriksa...',
      'select_water_condition_error': 'Sila pilih keadaan air semasa terlebih dahulu.',
      'flood_risk_label': 'Risiko Banjir',
      'confidence_label': 'Keyakinan',
      'rainfall': 'Hujan',
      'temperature': 'Suhu',
      'humidity': 'Kelembapan',
      'wind': 'Angin',
      'cloud_cover': 'Litupan Awan',
      'risk_high': 'Tinggi',
      'risk_medium': 'Sederhana',
      'risk_low': 'Rendah',

      'evacuation_centres_title': 'Pusat Pemindahan',
      'showing_all_centres_notice': 'Menunjukkan semua pusat — lokasi tidak tersedia',
      'centre_details_title': 'Butiran Pusat',
      'km_away': 'km jauh',
      'capacity_label': 'Kapasiti',
      'occupied': 'diisi',
      'full_pct': 'penuh',
      'nearby_severity_note': 'Ini mencerminkan kawasan sekeliling, bukan pusat itu sendiri.',
      'nearby_severity_label': 'Tahap keterukan banjir berdekatan',
      'get_directions': 'Dapatkan Arah Tuju',
      'severity_low': 'Rendah',
      'severity_moderate': 'Sederhana',
      'severity_high': 'Tinggi',
      'severity_critical': 'Kritikal',

      'announcements_title': 'Pengumuman Kerajaan',
      'announcement_title': 'Pengumuman',
      'no_announcements': 'Tiada pengumuman buat masa ini.',
      'could_not_load_announcements': 'Tidak dapat memuatkan pengumuman.',
      'severity_advisory': 'Nasihat',
      'severity_warning': 'Amaran',

      'alert_history_title': 'Sejarah Amaran',
      'no_alerts_yet': 'Belum ada amaran. Amaran risiko Tinggi yang anda terima akan dipaparkan di sini.',
      'clear_all_alerts_title': 'Kosongkan semua amaran?',
      'clear_all_alerts_desc': 'Ini akan mengeluarkan sejarah amaran anda daripada peranti ini.',
      'cancel': 'Batal',
      'clear': 'Kosongkan',

      'flood_timeline_title': 'Sejarah Banjir',
      'all_states': 'Semua Negeri',
      'recorded_events': 'kejadian direkodkan',
      'recorded_event': 'kejadian direkodkan',
      'no_events_for_state': 'Tiada kejadian untuk negeri ini.',
      'cause_label': 'Punca',
      'deaths_label': 'kematian',
      'affected_label': 'terjejas',

      'weather_title': 'Cuaca',
      'next_72_hours': 'Ramalan 72 Jam Akan Datang',
      'details': 'Butiran',
      'feels_like': 'Rasa seperti',
      'pressure': 'Tekanan',
      'visibility': 'Jarak Penglihatan',
      'sunrise_sunset': 'Matahari Terbit / Terbenam',
      'rain_expected_prompt': 'Hujan dijangka — semak risiko banjir anda',
      'check_flood_risk_prompt': 'Semak risiko banjir anda',
      'flood_risk_prompt_subtitle': 'Lihat bagaimana keadaan semasa dan ramalan mempengaruhi kawasan anda',
      'retry': 'Cuba Lagi',

      'chatbot_title': 'Pembantu FloodGuard',
      'chatbot_greeting': 'Hai! Saya pembantu FloodGuard anda. Tanya saya '
          'tentang kesediaan banjir, langkah pemindahan, atau apa yang '
          'perlu dilakukan semasa banjir. Anda boleh bertanya dalam Bahasa '
          'Inggeris atau Bahasa Malaysia.',
      'chatbot_new_conversation': 'Perbualan baharu bermula. Bagaimana saya boleh membantu?',
      'chatbot_input_hint': 'Tanya tentang keselamatan banjir...',
      'chatbot_new_conversation_tooltip': 'Mula perbualan baharu',

      'error_location_services_off': 'Perkhidmatan lokasi dimatikan.',
      'error_location_permission_denied': 'Kebenaran lokasi ditolak.',
      'error_location_permission_denied_forever': 'Kebenaran lokasi ditolak secara kekal.',
      'error_fetch_weather_failed': 'Gagal mendapatkan data cuaca.',
      'error_fetch_forecast_failed': 'Gagal mendapatkan data ramalan.',
      'error_prediction_failed': 'Ramalan gagal. Sila cuba lagi.',
      'error_generic': 'Sesuatu tidak kena. Sila cuba lagi.',

      'high_risk_alert_title': 'Amaran Risiko Banjir Tinggi',
      'high_risk_alert_body': 'Kawasan anda telah dikelaskan sebagai risiko Tinggi. Semak pusat pemindahan berdekatan sekarang.',

      'simulate_extreme_conditions': 'Simulasi Keadaan Melampau',
      'simulate_extreme_conditions_subtitle': 'Untuk demonstrasi — menunjukkan aliran amaran risiko Tinggi tanpa perlu menunggu cuaca buruk sebenar',
    },
    'zh': {
      'welcome_back': '欢迎回来',
      'create_account': '创建账户',
      'email': '电子邮件',
      'password': '密码',
      'login': '登录',
      'register': '注册',
      'no_account_register': '没有账户？注册',
      'already_have_account_login': '已有账户？登录',

      'app_title': 'FloodGuard Malaysia',
      'feature_risk_title': '检查洪水风险',
      'feature_risk_subtitle': '基于GPS的所在地区预测',
      'feature_pps_title': '寻找疏散中心',
      'feature_pps_subtitle': '附近的疏散中心及路线',
      'feature_announcements_title': '政府公告',
      'feature_announcements_subtitle': 'JPS、NADMA及州政府的实时通告',
      'feature_alerts_title': '警报记录',
      'feature_alerts_subtitle': '此设备过去收到的高风险警报',
      'feature_timeline_title': '洪水历史',
      'feature_timeline_subtitle': '真实过往洪水事件，EM-DAT数据',
      'feature_weather_title': '天气',
      'feature_weather_subtitle': '当前状况及72小时预报',
      'feature_chatbot_title': '咨询FloodGuard助手',
      'feature_chatbot_subtitle': '洪水安全帮助，英文及马来文',

      'onb_skip': '跳过',
      'onb_next': '下一步',
      'onb_get_started': '开始使用',
      'onb_title_1': '了解您的洪水风险',
      'onb_desc_1': 'FloodGuard检查您的GPS位置和当前天气，为您提供实时洪水风险等级：低、中或高。',
      'onb_title_2': '快速寻找安全地点',
      'onb_desc_2': '当风险较高时，快速找到最近的疏散中心，附带路线、容量和联系方式。',
      'onb_title_3': '保持警惕',
      'onb_desc_3': '当您所在地区被列为高风险时立即收到通知，并获取JPS、NADMA及州政府的实时公告。',
      'onb_title_4': '随时提问',
      'onb_desc_4': '不确定该怎么做？用英文或马来文询问内置助手关于防洪准备的问题。',

      'settings_title': '设置',
      'preferences': '偏好设置',
      'language': '语言',
      'high_risk_alerts': '高风险警报',
      'high_risk_alerts_subtitle': '当您所在地区处于高风险时收到通知',
      'dark_mode': '深色模式',
      'about': '关于',
      'about_app': '关于 FloodGuard Malaysia',
      'replay_onboarding': '重新观看引导教程',
      'sign_out': '登出',

      'risk_detection_title': '风险检测',
      'water_condition_heading': '您附近当前的水情',
      'water_condition_desc': '实时河流传感器数据尚未提供。请选择最符合您所观察或听闻的当地情况的选项。',
      'water_normal': '正常',
      'water_normal_desc': '无明显上升，水位看起来正常',
      'water_rising': '上升中',
      'water_rising_desc': '水位看起来比平时高',
      'water_high': '高 / 洪水',
      'water_high_desc': '明显可见洪水或水位接近临界水平',
      'check_flood_risk': '检查洪水风险',
      'checking': '检查中...',
      'select_water_condition_error': '请先选择当前的水情。',
      'flood_risk_label': '洪水风险',
      'confidence_label': '置信度',
      'rainfall': '降雨量',
      'temperature': '温度',
      'humidity': '湿度',
      'wind': '风速',
      'cloud_cover': '云量',
      'risk_high': '高',
      'risk_medium': '中',
      'risk_low': '低',

      'evacuation_centres_title': '疏散中心',
      'showing_all_centres_notice': '显示所有中心 — 位置不可用',
      'centre_details_title': '中心详情',
      'km_away': '公里',
      'capacity_label': '容量',
      'occupied': '已入住',
      'full_pct': '已满',
      'nearby_severity_note': '这反映的是周边地区，而非该中心本身。',
      'nearby_severity_label': '附近洪水严重程度',
      'get_directions': '获取路线',
      'severity_low': '低',
      'severity_moderate': '中等',
      'severity_high': '高',
      'severity_critical': '危急',

      'announcements_title': '政府公告',
      'announcement_title': '公告',
      'no_announcements': '目前没有公告。',
      'could_not_load_announcements': '无法加载公告。',
      'severity_advisory': '提醒',
      'severity_warning': '警告',

      'alert_history_title': '警报记录',
      'no_alerts_yet': '暂无警报。您收到的高风险警报将显示在这里。',
      'clear_all_alerts_title': '清除所有警报？',
      'clear_all_alerts_desc': '这将从此设备中删除您的警报记录。',
      'cancel': '取消',
      'clear': '清除',

      'flood_timeline_title': '洪水历史记录',
      'all_states': '所有州属',
      'recorded_events': '起记录事件',
      'recorded_event': '起记录事件',
      'no_events_for_state': '该州属没有事件记录。',
      'cause_label': '起因',
      'deaths_label': '人死亡',
      'affected_label': '人受影响',

      'weather_title': '天气',
      'next_72_hours': '未来72小时',
      'details': '详情',
      'feels_like': '体感温度',
      'pressure': '气压',
      'visibility': '能见度',
      'sunrise_sunset': '日出 / 日落',
      'rain_expected_prompt': '预计有雨 — 请检查您的洪水风险',
      'check_flood_risk_prompt': '检查您的洪水风险',
      'flood_risk_prompt_subtitle': '查看当前及预测天气状况对所在地区的影响',
      'retry': '重试',

      'chatbot_title': 'FloodGuard 助手',
      'chatbot_greeting': '你好！我是您的FloodGuard助手。您可以问我有关防洪准备、疏散步骤，或洪水期间该怎么做的问题。您可以用英文或马来文提问。',
      'chatbot_new_conversation': '新对话已开始。我能帮您什么？',
      'chatbot_input_hint': '询问洪水安全相关问题...',
      'chatbot_new_conversation_tooltip': '开始新对话',

      'error_location_services_off': '定位服务已关闭。',
      'error_location_permission_denied': '定位权限被拒绝。',
      'error_location_permission_denied_forever': '定位权限已被永久拒绝。',
      'error_fetch_weather_failed': '无法获取天气数据。',
      'error_fetch_forecast_failed': '无法获取预报数据。',
      'error_prediction_failed': '预测失败，请重试。',
      'error_generic': '出现问题，请重试。',

      'high_risk_alert_title': '高洪水风险警告',
      'high_risk_alert_body': '您所在地区已被列为高风险。请立即查看附近的疏散中心。',

      'simulate_extreme_conditions': '模拟极端天气状况',
      'simulate_extreme_conditions_subtitle': '用于演示 — 无需等待真实恶劣天气即可展示高风险警报流程',
    },
    'ta': {
      'welcome_back': 'மீண்டும் வரவேற்கிறோம்',
      'create_account': 'கணக்கை உருவாக்கவும்',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'login': 'உள்நுழையவும்',
      'register': 'பதிவு செய்யவும்',
      'no_account_register': 'கணக்கு இல்லையா? பதிவு செய்யவும்',
      'already_have_account_login': 'ஏற்கனவே கணக்கு உள்ளதா? உள்நுழையவும்',

      'app_title': 'FloodGuard Malaysia',
      'feature_risk_title': 'வெள்ள ஆபத்தை சரிபார்க்கவும்',
      'feature_risk_subtitle': 'உங்கள் பகுதிக்கான GPS அடிப்படையிலான கணிப்பு',
      'feature_pps_title': 'வெளியேற்ற மையத்தைக் கண்டறியவும்',
      'feature_pps_subtitle': 'அருகிலுள்ள மையம் திசைகளுடன்',
      'feature_announcements_title': 'அரசாங்க அறிவிப்புகள்',
      'feature_announcements_subtitle': 'JPS, NADMA & மாநில அறிவிப்புகள் நேரடியாக',
      'feature_alerts_title': 'எச்சரிக்கை வரலாறு',
      'feature_alerts_subtitle': 'இந்த சாதனத்தில் கடந்த உயர் ஆபத்து எச்சரிக்கைகள்',
      'feature_timeline_title': 'வெள்ள வரலாறு',
      'feature_timeline_subtitle': 'உண்மையான கடந்தகால வெள்ள நிகழ்வுகள், EM-DAT தரவு',
      'feature_weather_title': 'வானிலை',
      'feature_weather_subtitle': 'தற்போதைய நிலைமைகள் & 72 மணிநேர முன்னறிவிப்பு',
      'feature_chatbot_title': 'FloodGuard உதவியாளரிடம் கேளுங்கள்',
      'feature_chatbot_subtitle': 'வெள்ள பாதுகாப்பு உதவி, ஆங்கிலம் & மலாய்',

      'onb_skip': 'தவிர்க்கவும்',
      'onb_next': 'அடுத்து',
      'onb_get_started': 'தொடங்குவோம்',
      'onb_title_1': 'உங்கள் வெள்ள ஆபத்தை அறியுங்கள்',
      'onb_desc_1': 'FloodGuard உங்கள் GPS இருப்பிடத்தையும் தற்போதைய வானிலையையும் சரிபார்த்து, நிகழ்நேர வெள்ள ஆபத்து நிலையை வழங்குகிறது: குறைவு, நடுத்தரம் அல்லது அதிகம்.',
      'onb_title_2': 'விரைவாக பாதுகாப்பைக் கண்டறியவும்',
      'onb_desc_2': 'ஆபத்து அதிகமாக இருக்கும்போது, திசைகள், கொள்ளளவு மற்றும் தொடர்பு விவரங்களுடன் அருகிலுள்ள வெளியேற்ற மையத்தை விரைவாகக் கண்டறியவும்.',
      'onb_title_3': 'எச்சரிக்கையாக இருங்கள்',
      'onb_desc_3': 'உங்கள் பகுதி உயர் ஆபத்து என வகைப்படுத்தப்பட்டவுடன் அறிவிப்பைப் பெறுங்கள், மேலும் JPS, NADMA மற்றும் மாநில அதிகாரிகளிடமிருந்து நேரடி அறிவிப்புகள்.',
      'onb_title_4': 'எப்போது வேண்டுமானாலும் கேளுங்கள்',
      'onb_desc_4': 'என்ன செய்வது என்று தெரியவில்லையா? உள்ளமைந்த உதவியாளரிடம் வெள்ள தயார்நிலை பற்றி ஆங்கிலத்திலோ மலாய் மொழியிலோ கேளுங்கள்.',

      'settings_title': 'அமைப்புகள்',
      'preferences': 'விருப்பத்தேர்வுகள்',
      'language': 'மொழி',
      'high_risk_alerts': 'உயர் ஆபத்து எச்சரிக்கைகள்',
      'high_risk_alerts_subtitle': 'உங்கள் பகுதி உயர் ஆபத்தில் இருக்கும்போது அறிவிப்பு பெறுங்கள்',
      'dark_mode': 'இருண்ட பயன்முறை',
      'about': 'பற்றி',
      'about_app': 'FloodGuard Malaysia பற்றி',
      'replay_onboarding': 'வழிகாட்டலை மீண்டும் காணவும்',
      'sign_out': 'வெளியேறு',

      'risk_detection_title': 'ஆபத்து கண்டறிதல்',
      'water_condition_heading': 'உங்களுக்கு அருகிலுள்ள தற்போதைய நீர் நிலை',
      'water_condition_desc': 'நேரடி ஆற்று சென்சார் தரவு இன்னும் கிடைக்கவில்லை. நீங்கள் கவனித்த அல்லது உள்ளூரில் அறிவிக்கப்பட்டதைப் பொருத்தமான விருப்பத்தைத் தேர்ந்தெடுக்கவும்.',
      'water_normal': 'சாதாரணம்',
      'water_normal_desc': 'குறிப்பிடத்தக்க உயர்வு இல்லை, நீர் மட்டம் வழக்கமாகத் தெரிகிறது',
      'water_rising': 'உயர்ந்து வருகிறது',
      'water_rising_desc': 'நீர் மட்டம் வழக்கத்தை விட அதிகமாகத் தெரிகிறது',
      'water_high': 'அதிகம் / வெள்ளம்',
      'water_high_desc': 'தெளிவான வெள்ளம் அல்லது நீர் முக்கிய நிலைக்கு அருகில்',
      'check_flood_risk': 'வெள்ள ஆபத்தை சரிபார்க்கவும்',
      'checking': 'சரிபார்க்கிறது...',
      'select_water_condition_error': 'முதலில் தற்போதைய நீர் நிலையைத் தேர்ந்தெடுக்கவும்.',
      'flood_risk_label': 'வெள்ள ஆபத்து',
      'confidence_label': 'நம்பகத்தன்மை',
      'rainfall': 'மழைவீழ்ச்சி',
      'temperature': 'வெப்பநிலை',
      'humidity': 'ஈரப்பதம்',
      'wind': 'காற்று',
      'cloud_cover': 'மேக மூட்டம்',
      'risk_high': 'அதிகம்',
      'risk_medium': 'நடுத்தரம்',
      'risk_low': 'குறைவு',

      'evacuation_centres_title': 'வெளியேற்ற மையங்கள்',
      'showing_all_centres_notice': 'அனைத்து மையங்களையும் காட்டுகிறது — இருப்பிடம் கிடைக்கவில்லை',
      'centre_details_title': 'மைய விவரங்கள்',
      'km_away': 'கி.மீ தொலைவில்',
      'capacity_label': 'கொள்ளளவு',
      'occupied': 'ஆக்கிரமிக்கப்பட்டது',
      'full_pct': 'நிரம்பியது',
      'nearby_severity_note': 'இது சுற்றியுள்ள பகுதியை பிரதிபலிக்கிறது, மையத்தை அல்ல.',
      'nearby_severity_label': 'அருகிலுள்ள வெள்ள தீவிரம்',
      'get_directions': 'திசைகளைப் பெறவும்',
      'severity_low': 'குறைவு',
      'severity_moderate': 'நடுத்தரம்',
      'severity_high': 'அதிகம்',
      'severity_critical': 'மிக முக்கியமானது',

      'announcements_title': 'அரசாங்க அறிவிப்புகள்',
      'announcement_title': 'அறிவிப்பு',
      'no_announcements': 'தற்போது அறிவிப்புகள் இல்லை.',
      'could_not_load_announcements': 'அறிவிப்புகளை ஏற்ற முடியவில்லை.',
      'severity_advisory': 'ஆலோசனை',
      'severity_warning': 'எச்சரிக்கை',

      'alert_history_title': 'எச்சரிக்கை வரலாறு',
      'no_alerts_yet': 'இதுவரை எச்சரிக்கைகள் இல்லை. நீங்கள் பெறும் உயர் ஆபத்து எச்சரிக்கைகள் இங்கே தோன்றும்.',
      'clear_all_alerts_title': 'அனைத்து எச்சரிக்கைகளையும் அழிக்கவா?',
      'clear_all_alerts_desc': 'இது இந்த சாதனத்திலிருந்து உங்கள் எச்சரிக்கை வரலாற்றை அகற்றும்.',
      'cancel': 'ரத்து செய்',
      'clear': 'அழி',

      'flood_timeline_title': 'வரலாற்று வெள்ள காலவரிசை',
      'all_states': 'அனைத்து மாநிலங்களும்',
      'recorded_events': 'பதிவுசெய்யப்பட்ட நிகழ்வுகள்',
      'recorded_event': 'பதிவுசெய்யப்பட்ட நிகழ்வு',
      'no_events_for_state': 'இந்த மாநிலத்திற்கு நிகழ்வுகள் இல்லை.',
      'cause_label': 'காரணம்',
      'deaths_label': 'இறப்புகள்',
      'affected_label': 'பாதிக்கப்பட்டோர்',

      'weather_title': 'வானிலை',
      'next_72_hours': 'அடுத்த 72 மணி நேரம்',
      'details': 'விவரங்கள்',
      'feels_like': 'உணரப்படும் வெப்பநிலை',
      'pressure': 'அழுத்தம்',
      'visibility': 'தெரிவுநிலை',
      'sunrise_sunset': 'சூரிய உதயம் / அஸ்தமனம்',
      'rain_expected_prompt': 'மழை எதிர்பார்க்கப்படுகிறது — உங்கள் வெள்ள ஆபத்தை சரிபார்க்கவும்',
      'check_flood_risk_prompt': 'உங்கள் வெள்ள ஆபத்தை சரிபார்க்கவும்',
      'flood_risk_prompt_subtitle': 'தற்போதைய மற்றும் முன்னறிவிப்பு நிலைமைகள் உங்கள் பகுதியை எவ்வாறு பாதிக்கின்றன என்பதைப் பார்க்கவும்',
      'retry': 'மீண்டும் முயற்சிக்கவும்',

      'chatbot_title': 'FloodGuard உதவியாளர்',
      'chatbot_greeting': 'வணக்கம்! நான் உங்கள் FloodGuard உதவியாளர். வெள்ள தயார்நிலை, வெளியேற்ற நடவடிக்கைகள் அல்லது வெள்ளத்தின் போது என்ன செய்வது என்பது பற்றி என்னிடம் கேளுங்கள். நீங்கள் ஆங்கிலத்திலோ மலாய் மொழியிலோ கேட்கலாம்.',
      'chatbot_new_conversation': 'புதிய உரையாடல் தொடங்கியது. நான் எப்படி உதவ முடியும்?',
      'chatbot_input_hint': 'வெள்ள பாதுகாப்பு பற்றி கேளுங்கள்...',
      'chatbot_new_conversation_tooltip': 'புதிய உரையாடலைத் தொடங்கு',

      'error_location_services_off': 'இருப்பிட சேவைகள் அணைக்கப்பட்டுள்ளன.',
      'error_location_permission_denied': 'இருப்பிட அனுமதி நிராகரிக்கப்பட்டது.',
      'error_location_permission_denied_forever': 'இருப்பிட அனுமதி நிரந்தரமாக நிராகரிக்கப்பட்டது.',
      'error_fetch_weather_failed': 'வானிலை தரவைப் பெற முடியவில்லை.',
      'error_fetch_forecast_failed': 'முன்னறிவிப்பு தரவைப் பெற முடியவில்லை.',
      'error_prediction_failed': 'கணிப்பு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.',
      'error_generic': 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.',

      'high_risk_alert_title': 'உயர் வெள்ள ஆபத்து எச்சரிக்கை',
      'high_risk_alert_body': 'உங்கள் பகுதி உயர் ஆபத்து எனப் வகைப்படுத்தப்பட்டுள்ளது. அருகிலுள்ள வெளியேற்ற மையங்களை இப்போது சரிபார்க்கவும்.',

      'simulate_extreme_conditions': 'தீவிர நிலைமைகளை உருவகப்படுத்தவும்',
      'simulate_extreme_conditions_subtitle': 'செயல்விளக்கத்திற்காக — உண்மையான கடுமையான வானிலைக்காக காத்திருக்காமல் உயர் ஆபத்து எச்சரிக்கை செயல்முறையைக் காட்டுகிறது',
    },
  };

  static String of(String key, String locale) {
    return _values[locale]?[key] ?? _values['en']?[key] ?? key;
  }
}

/// Provides the current language code to the whole widget tree via
/// InheritedWidget, the same mechanism Theme.of(context) uses. This means
/// any screen calling tr(context, 'key') automatically rebuilds when the
/// language changes, even screens already pushed onto the navigation
/// stack, without needing to manually restart or re-navigate.
class AppLocale extends InheritedWidget {
  final String code;

  const AppLocale({super.key, required this.code, required super.child});

  static AppLocale of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppLocale>();
    assert(result != null, 'No AppLocale found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppLocale oldWidget) => code != oldWidget.code;
}

/// Shorthand for looking up a translated string in the current context.
String tr(BuildContext context, String key) {
  return AppStrings.of(key, AppLocale.of(context).code);
}