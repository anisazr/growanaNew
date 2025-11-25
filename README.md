**Growana – Aplikasi Flutter Sederhana (Assessment II)**

Growana adalah aplikasi Flutter sederhana sesuai ketentuan Assessment II. Aplikasi ini memiliki fitur login, mode terang/gelap, CRUD SQLite, penyimpanan data terakhir menggunakan SharedPreferences, serta list in-memory untuk menampilkan, menambah, dan menghapus data.

**Anggota Tim & Pembagian Tugas**
1. Anisa
   Bertanggung jawab pada desain UI
   dan tampilan halaman.
   
3. Akifah
   A. Membuat fitur login.
   B. Mengembangkan CRUD SQLite untuk
   data user.
   C. Mengimplementasikan tema terang
   dan gelap.

3. Anita
   A. Membuat fitur penyimpanan
   menggunakan SharedPreferences.
   B. Menangani list in-memory.



**Halaman yang Ada di Aplikasi**
Aplikasi memiliki beberapa halaman utama:
1. Login Page
2. Register Page
3. Home Page
4. Classes Page
5. User Profile Page
6. Edit Profile Page
7. Shopping List Page
8. Awards / Leaderboard Page


**Penjelasan Fitur Login**
Fitur login dibuat menggunakan SQLite untuk menyimpan akun pengguna.

***Alur login:***
1. Pengguna memasukkan email dan password.
2. Sistem mencocokkan email menggunakan fungsi getUserByEmail() dari SQLite.
3. Password divalidasi.
4. Jika benar, ID user disimpan menggunakan SharedPreferences sebagai currentUserId.
5. Aplikasi langsung diarahkan ke Home Page.
6. Email terakhir juga disimpan, sehingga ketika membuka aplikasi lagi, email otomatis terisi.


***File kode penting:***
1. auth_service.dart
2. user_repository.dart
3. login_page.dart



**PENJELASAN FITUR LIGHT / DARK MODE**
Mode terang dan gelap dibuat menggunakan Provider dan SharedPreferences.

Cara kerjanya:
1. ThemeProvider menyimpan status mode gelap dalam variabel isDarkMode.
2. Saat pengguna menekan ikon tema di AppBar, fungsi toggleTheme() dijalankan.
3. Nilai tema disimpan di SharedPreferences.
4. Ketika aplikasi dibuka ulang, mode terakhir otomatis digunakan.


File terkait:
1. theme_provider.dart

**PENJELASAN IMPLEMENTASI SQLite**
SQLite digunakan untuk menyimpan data user secara permanen.

***Komponen yang digunakan:***
1. DatabaseHelper untuk membuka dan menginisialisasi database.
2. User model sebagai representasi struktur tabel.
3. UserRepository sebagai CRUD utama.


***Fungsi yang tersedia:***
1. Menambah user (register)
2. Mencari user (login)
3. Mengambil data profil
4. Mengubah user (edit profil)
5. Menghapus user

***File terkait:***
1. database_helper.dart
2. user_repository.dart
3. user.dart


**PENJELASAN SharedPreferences**
SharedPreferences digunakan untuk menyimpan data ringan yang tidak perlu masuk database, seperti:
1. Email terakhir yang digunakan saat login
2. ID user yang sedang login
3. Status dark mode
4. Last selected tab pada Home Page

Keuntungannya:
Data ini akan tetap tersimpan meskipun aplikasi ditutup.

***File terkait:***
1. prefs_service.dart
2. theme_provider.dart


**PENJELASAN List In-Memory**

Aplikasi memiliki dua jenis data list yang hanya disimpan di memori (tidak di SQLite):

1. Shopping List Page
●Menggunakan List<String> sederhana.
●Item ditambahkan melalui dialog.
●Item dapat dihapus secara langsung.
●Data hilang ketika aplikasi ditutup.

2. Classes Page
●Berisi daftar kelas daring.
●Menggunakan list in-memory _myClasses untuk menyimpan kelas yang dipilih pengguna.
●Hanya digunakan untuk UI.

***File terkait:***
1. class_service.dart
2. shopping_list_page.dart


**UI Menggunakan Widget Dasar Flutter**
Seluruh tampilan aplikasi dibuat menggunakan widget dasar:
1. Scaffold
2. AppBar
3. TextField
4. ListView
5. Container
6. ElevatedButton
7. AlertDialog
8. BottomNavigationBar
9. Icon, Text, Row, Column


**CARA APLIKASI MENYIMPAN DATA**
1. Data user (permanen) → SQLite
2. Email terakhir dan user ID → SharedPreferences
3. Tema terang/gelap → SharedPreferences
4. Shopping list dan kelas ditambahkan → List in-memory (tidak disimpan permanen)

**FINAL BRANCH TEMPAT WEBSITE JALAN UNTUK ASESSMENT 2 --> ps**


**SCREENSHOT 5 PAGE**
![Image](https://github.com/user-attachments/assets/9ed42424-1975-4e3a-a338-51c50a0cc025)
![Image](https://github.com/user-attachments/assets/2eb605c2-b6be-4a14-ac48-4e05516313af)
![Image](https://github.com/user-attachments/assets/85424a0b-2184-472b-801d-bd70b3025311)
![Image](https://github.com/user-attachments/assets/4cac6206-7b65-4878-a8d4-6af82d5e16f3)
![Image](https://github.com/user-attachments/assets/eb21ac53-a04b-4f62-b343-aeb9cc55fb54)
![Image](https://github.com/user-attachments/assets/96aed0d1-4171-4566-aaa2-4fcdea573b11)
