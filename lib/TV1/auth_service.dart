import 'models.dart';

// Mock lưu trong bộ nhớ, dữ liệu mất khi tắt app.
// Giai đoạn 2 thay bằng firebase_auth và Firestore, giữ nguyên các hàm public.
class AuthService {
  AuthService._() {
    _accounts['ungvien@demo.com'] = (
      password: '123456',
      user: const AppUser(
        id: 'u1',
        email: 'ungvien@demo.com',
        name: 'Nguyễn Văn An',
        role: UserRole.candidate,
      ),
    );
    _accounts['ntd@demo.com'] = (
      password: '123456',
      user: const AppUser(
        id: 'u2',
        email: 'ntd@demo.com',
        name: 'Trần Thị Bình',
        role: UserRole.employer,
      ),
    );
  }

  static final AuthService instance = AuthService._();

  final Map<String, ({String password, AppUser user})> _accounts = {};
  final Map<String, CandidateProfile> _candidateProfiles = {};
  final Map<String, CompanyProfile> _companyProfiles = {};
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw Exception('Sai email hoặc mật khẩu');
    }
    return _currentUser = account.user;
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw Exception('Email đã được sử dụng');
    }
    final user = AppUser(
      id: 'u${_accounts.length + 1}',
      email: key,
      name: name.trim(),
      role: role,
    );
    _accounts[key] = (password: password, user: user);
    return _currentUser = user;
  }

  void logout() => _currentUser = null;

  CandidateProfile candidateProfile(String userId) =>
      _candidateProfiles.putIfAbsent(userId, CandidateProfile.new);

  CompanyProfile companyProfile(String userId) =>
      _companyProfiles.putIfAbsent(userId, CompanyProfile.new);

  Future<void> saveCandidateProfile(
    String userId,
    CandidateProfile profile,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _candidateProfiles[userId] = profile;
  }

  Future<void> saveCompanyProfile(String userId, CompanyProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _companyProfiles[userId] = profile;
  }
}
