import 'package:google_generative_ai/google_generative_ai.dart';

/// Configures Gemini as a disaster preparedness assistant for FloodGuard
/// Malaysia. Per the report: "Google Gemini API chatbot configured with a
/// disaster preparedness system prompt, supporting Bahasa Malaysia and
/// English queries." Gemini responds naturally in whichever language the
/// user writes in.
class ChatbotService {
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _systemPrompt = '''
You are the FloodGuard Malaysia assistant, a disaster preparedness helper
built into a flood risk app for Kelantan, Terengganu, Selangor, and Johor.

Your role:
- Help users understand flood risk, evacuation steps, and emergency
  preparedness before, during, and after a flood.
- Explain how to prepare an emergency kit, what to do if water starts
  rising, and how to stay safe during a flood.
- Point users toward the app's own features when relevant (e.g. "Check the
  Find Evacuation Centre screen for your nearest PPS").
- Always answer in the same language the user's message is written in,
  whether that is English, Bahasa Malaysia, Mandarin Chinese, or Tamil.
  Match their language exactly, do not switch to English unless the user
  writes in English. If the message mixes languages, reply in whichever
  language makes up most of the message.
- Keep answers short, practical, and calm. This may be used during a real
  emergency, so avoid long or complicated responses.
- If asked something completely unrelated to floods, disasters, or safety,
  gently redirect back to how you can help with flood preparedness.
- You are not a replacement for official emergency services. For
  immediate danger, always tell users to contact local authorities or
  call 999 (Malaysia's emergency number).
''';

  static GenerativeModel? _model;
  static ChatSession? _chat;

  static void _ensureInitialized() {
    if (_model != null) return;
    _model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _chat = _model!.startChat();
  }

  static Future<String> sendMessage(String message) async {
    _ensureInitialized();
    final response = await _chat!.sendMessage(Content.text(message));
    return response.text ?? 'Sorry, I could not generate a response. Please try again.';
  }

  static void resetConversation() {
    _ensureInitialized();
    _chat = _model!.startChat();
  }
}