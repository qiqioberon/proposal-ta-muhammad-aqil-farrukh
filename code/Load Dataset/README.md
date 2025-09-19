# Panduan Notebook Load Dataset (FI-V2)

Dokumen ini merangkum alur kerja notebook `load-dataset-cvpr17.ipynb` yang berada di folder ini. Notebook tersebut menyiapkan metadata First Impressions v2 (CVPR 2017) untuk eksperimen analisis kepribadian, mulai dari pemindaian video mentah, penormaan label, eksplorasi data, hingga ekstraksi fitur audio dasar.

## Prasyarat dan Konteks Eksekusi
- Notebook diasumsikan berjalan di lingkungan Kaggle dengan struktur direktori standar (`/kaggle/input` untuk dataset read-only dan `/kaggle/working` untuk artefak keluaran).
- Dataset harus tersedia di `/kaggle/input/first-impressions-v2-cvpr17-training`. Notebook akan menghentikan eksekusi apabila folder ini tidak ditemukan.
- Untuk tahap ETL audio diperlukan utilitas `ffmpeg`/`ffprobe`. Untuk analisis suara dibutuhkan pustaka Python seperti `pandas`, `numpy`, `matplotlib`, `tqdm`, `scikit-learn`, dan `librosa`.

## Berkas Penting yang Dihasilkan
Semua artefak disimpan di `/kaggle/working`:
- `fi_v2_meta.csv` — metadata awal per-klip (ID mentah, path relatif, skor Big Five).
- `fi_v2_meta.clean.csv` — metadata setelah gate durasi video/audio.
- `fi_v2_meta.speechclean.csv` — metadata yang lolos kriteria kualitas suara.
- `rejected.by_duration.csv`, `rejected.by_speech.csv` — daftar klip yang dibuang pada tahap pembersihan.
- Folder `wav/` — hasil konversi audio 16 kHz mono dari setiap video yang valid.
- Folder `fig/` — visualisasi EDA berupa histogram, heatmap korelasi, dan scatter plot sampel.

## Ringkasan Alur Notebook
1. **Inisialisasi dan validasi dataset** — memastikan path dataset tersedia.
2. **Pemindaian video** — mengambil semua folder `train-*` dan membangun indeks path video.
3. **Pencarian serta pemuatan anotasi** — mendeteksi berkas label dalam format PKL/CSV/JSON dan mengubahnya menjadi `DataFrame` seragam.
4. **Normalisasi label Big Five** — transpose matriks label ke bentuk baris-per-video, menyambungkan path video, dan membuat metadata awal.
5. **Eksplorasi Data (EDA)** — menilai kelengkapan label, distribusi nilai, korelasi, dan stabilitas fold berbasis `group_id`.
6. **ETL Audio** — mengonversi video menjadi berkas WAV 16 kHz mono secara paralel dan menyimpan path audio ke metadata.
7. **Pengukuran durasi audio** — menjalankan `ffprobe` untuk mendapatkan panjang klip dan menganalisis distribusinya.
8. **Perbaikan serta gate berdasar durasi** — re-konversi klip bermasalah, menghapus audio yang terlalu pendek/panjang, dan menyimpan metadata bersih.
9. **Statistik VAD sederhana** — menghitung durasi ucapan efektif, rasio voiced, serta median RMS menggunakan `librosa`, lalu menerapkan ambang kualitas suara.

## Penjelasan Setiap Tahap
### 1. Validasi dan Konstanta Awal
Notebook mengimpor modul utilitas (`pathlib`, `pandas`, `json`, `pickle`, dsb.) lalu mendefinisikan konstanta `DATA_ROOT = Path("/kaggle/input/first-impressions-v2-cvpr17-training")`. Eksekusi dihentikan dengan `assert` apabila folder tidak ditemukan untuk mencegah error lanjutan.

### 2. Pemindaian Struktur Video
- Fungsi `list_videos` menelusuri seluruh folder `train-*` dan mengumpulkan file dengan ekstensi video umum (`.mp4`, `.avi`, `.mov`, `.mkv`).
- Dibangun dua peta bantu: `stem_map` (nama file tanpa ekstensi ke path penuh) dan `rel_map` (path relatif terhadap `DATA_ROOT`). Kedua peta ini penting untuk menyatukan label dengan video, meskipun format penamaan berbeda.

### 3. Deteksi & Pemuatan Anotasi
- Fungsi `guess_labels_file` mencari berkas label terbaik di folder `train-annotation`, dengan prioritas PKL lalu CSV/JSON serta memeriksa kata kunci nama file.
- `load_labels_flex` memuat anotasi secara adaptif:
  - Mengatasi pickle Python 2 (`encoding="latin1"`).
  - Mengonversi struktur dict/list yang umum menjadi `DataFrame`.
  - Menangani kasus khusus di mana data tersebar dalam list paralel.
- Setelah pemuatan, notebook menampilkan kolom asli dan sampel baris untuk inspeksi cepat.

### 4. Normalisasi Label Big Five
- Label disejajarkan agar indeks mewakili trait, lalu ditranspose sehingga setiap baris sesuai dengan satu klip video.
- Nilai dinumerikkan (`pd.to_numeric`) dan nama kolom diseragamkan (tetap menggunakan `neuroticism`, tidak diganti ke `emotional_stability`).
- Ditambahkan kolom ID bantu (`raw_id`, `stem`, `group_id`) dan path relatif (`relpath`), menggunakan peta yang dibangun pada tahap 2.
- Metadata disusun ulang dalam `meta_df` dan disimpan ke `fi_v2_meta.csv` sebagai acuan utama tahap-tahap berikutnya.

### 5. Exploratory Data Analysis (EDA)
- Membaca `fi_v2_meta.csv` dan memeriksa jumlah baris, kolom, serta ketersediaan label.
- Fungsi `out_of_range_mask` memastikan skor Big Five berada pada rentang [0, 1].
- Menghasilkan statistik deskriptif (`describe()`), histogram tiap trait, heatmap korelasi (signed dan absolut), serta scatter plot acak antar trait untuk menilai hubungan linear.
- Menganalisis distribusi `group_id` guna mencegah kebocoran data saat membuat fold, lalu menjalankan contoh `GroupKFold` 5-fold untuk melihat rata-rata label per fold.
- Seluruh visualisasi disimpan ke folder `fig/`.

### 6. Konversi Video ke WAV
- Membaca kembali metadata, memastikan direktori `wav/` ada, lalu menjalankan fungsi `to_wav` secara paralel menggunakan `ThreadPoolExecutor` (maksimal 8 worker).
- `ffmpeg` dipanggil dengan parameter standar Kaggle (`-ac 1 -ar 16000 -sample_fmt s16`) untuk menghasilkan audio mono 16 kHz.
- Status konversi dipantau melalui progress bar `tqdm`; jumlah kegagalan dilaporkan dan metadata diperbarui (`wav_path`).

### 7. Pengukuran Durasi Audio
- Fungsi `get_duration_seconds` memanggil `ffprobe` untuk membaca panjang audio dan menuliskannya ke kolom `duration_sec`.
- Distribusi durasi dianalisis melalui statistik ringkas, histogram (termasuk versi terklip), dan boxplot guna mendeteksi outlier.
- Notebook menandai klip yang lebih pendek dari batas bawah (`MIN_SEC = 4.0s`) atau lebih panjang dari batas atas (`MAX_SEC = 30.0s`).

### 8. Perbaikan & Gate Durasi
- Langkah ini mengulangi konversi WAV khusus untuk klip bermasalah (durasi NaN atau di luar batas) dan mengukur ulang durasi setelah re-konversi.
- Metadata diperbarui dan dua subset dibuat:
  - `fi_v2_meta.clean.csv` — hanya klip dengan durasi valid.
  - `rejected.by_duration.csv` — klip yang tetap bermasalah setelah perbaikan.
- Distribusi durasi pasca-filter divisualisasikan kembali untuk memastikan hasil sesuai ekspektasi.

### 9. Statistik Suara (VAD Sederhana)
- Menggunakan `librosa` untuk memuat audio dan menghitung fitur dasar tiap klip: durasi ucapan efektif (`speech_sec`), rasio voiced (`voiced_ratio`), dan median RMS dalam dB (`rms_db_median`).
- VAD dilakukan via energi frame dengan ambang relatif terhadap median energi, termasuk prosedur penggabungan gap singkat agar tidak memecah segmen ucapan.
- Diterapkan ambang kualitas suara default:
  - `speech_sec >= 6.0`
  - `voiced_ratio >= 0.35`
  - `rms_db_median >= -40 dB`
- Metadata yang lolos disimpan sebagai `fi_v2_meta.speechclean.csv`, sedangkan sisanya ke `rejected.by_speech.csv`. Statistik ringkas untuk fitur `speech_sec`, `voiced_ratio`, dan `rms_db_median` ditampilkan.

## Cara Menggunakan Notebook
1. Pastikan dataset First Impressions v2 sudah ditambahkan ke sesi Kaggle.
2. Jalankan notebook sel secara berurutan tanpa melewati tahap manapun; setiap sel bergantung pada artefak yang dihasilkan sel sebelumnya.
3. Setelah konversi audio, cek jumlah kegagalan pada progress bar. Bila banyak klip gagal, verifikasi ketersediaan `ffmpeg` atau path video.
4. Perhatikan hasil EDA (histogram/korelasi) untuk memastikan distribusi label masuk akal sebelum melanjutkan ke model.
5. Gunakan metadata akhir (`fi_v2_meta.speechclean.csv`) sebagai data input utama untuk pelatihan agar terhindar dari klip yang bermasalah.

## Catatan Tambahan
- Apabila struktur dataset berbeda (misalnya diletakkan di folder lain), ubah konstanta `DATA_ROOT` di sel pertama.
- Ambang durasi dan VAD bersifat heuristik; sesuaikan dengan kebutuhan proyek dengan mengubah nilai konstanta terkait.
- Notebook belum menyertakan tahap pembagian data atau pelatihan model; fokus utama adalah menyiapkan data yang bersih dan terdokumentasi.
