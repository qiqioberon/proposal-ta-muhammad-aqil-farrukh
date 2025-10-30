# Dokumentasi Notebook: `eda-audio-cvpr-ready-train.ipynb`

Notebook ini menyiapkan dataset audio ChaLearn FI-V2 (audio-only) agar siap dipakai untuk eksperimen machine learning. Seluruh penjelasan di bawah merangkum kode, hasil utama, serta alur yang dijalankan di dalam notebook.

## Ringkasan Singkat
- Memuat 5.997 segmen audio beserta label Big Five dari `fi_v2_meta.clean.csv`.
- Memperbaiki kolom `wav_path` sehingga menunjuk ke `wav/` di dataset input dan menulis ulang metadata ke `fi_v2_meta.clean.inputpaths.csv`.
- Mengekstrak 24 fitur akustik Librosa (durasi, RMS, VAD metrics, centroid, MFCC mean, dan lain-lain) lalu menyimpan kombinasi meta+fitur ke `fi_v2_meta.with_feats.csv` dan `audio_features.parquet`.
- Melakukan EDA singkat (statistik deskriptif, histogram, korelasi) dan menyimpulkan redundancy fitur (misal RMS mean vs median, centroid vs bandwidth).
- Mengulang perhitungan VAD dengan WebRTC untuk 122 klip dengan `voiced_ratio >= 0.98`, ditambah targeted re-VAD (aggressiveness=3) pada 2 klip yang masih mencurigakan.
- Membersihkan data menggunakan rule berbasis sinyal serta penyaringan outlier robust (MAD), menghasilkan 5.425 baris akhir (`fi_v2_meta.with_feats.clean.csv`).
- Menyusun 5-fold Stratified GroupKFold berdasarkan `person_key` dan kuantil rata-rata label. Distribusi per fold: 1.017–1.121 sampel dan 486–498 persona unik; rerata label antar fold saling berdekatan.
- Menyiapkan paket Checkpoint2 di `/kaggle/working` (salinan WAV, manifest, ringkasan split, README).

## Input dan Artefak Keluaran Utama
- `fi_v2_meta.clean.csv`: metadata awal dari dataset Kaggle `checkpointcvpr-1`.
- `fi_v2_meta.clean.inputpaths.csv`: versi metadata dengan jalur WAV yang sudah dipetakan ke `/kaggle/input/.../wav/<file>.wav`.
- `audio_features.parquet`: fitur numerik hasil ekstraksi Librosa untuk seluruh klip.
- `fi_v2_meta.with_feats.csv`: gabungan metadata dan fitur sebelum cleaning.
- `fi_v2_meta.revad_only.csv`: metadata setelah perhitungan ulang VAD.
- `fi_v2_meta.with_feats.clean.csv`: metadata+fitur bersih sesudah rule filtering dan outlier removal (5.425 baris).
- `audio_features.clean.parquet`: subset fitur yang sejajar dengan baris bersih.
- `fi_v2_meta.with_feats.clean.folds.csv`: dataset bersih plus kolom `fold` hasil Stratified GroupKFold.
- `person_folds.csv`: mapping `person_key → fold` untuk konsistensi eksperimen.
- `wav_manifest.csv`, `SPLIT_SUMMARY.json`, `README.md` (di `/kaggle/working`): artefak paket akhir beserta ringkasan distribusi.

## Tahapan Notebook

### 1. Setup & Validasi Metadata
- Mengatur direktori `DATASET_ROOT` ke `/kaggle/input/checkpointcvpr-1`, membuat folder kerja `/kaggle/working`, dan memuat metadata awal.
- Memastikan kolom label Big Five (`extraversion`, `agreeableness`, `conscientiousness`, `neuroticism`, `openness`) tersedia; total baris terkonfirmasi 5.997.

### 2. Perbaikan Kolom `wav_path`
- Membuat fungsi `remap_wav_path` yang memprioritaskan nama file dari kolom lama atau `raw_id`, lalu mengarahkannya ke `DATASET_ROOT / "wav" / <nama file>`.
- Hasil: 5.997 jalur valid ditemukan, disimpan ke `fi_v2_meta.clean.inputpaths.csv` tanpa menimpa file asli.

### 3. Ekstraksi Fitur Audio
- Memastikan ulang jalur WAV valid dengan `ensure_input_wav_path`.
- Menggunakan Librosa untuk mengekstrak durasi, RMS, voiced ratio, speech seconds, spectral centroid/bandwidth/rolloff, flatness, zero-crossing rate, clip ratio, dan MFCC mean (1–13).
- Menjalankan proses sekuensial (opsional parallel) dan menyusun `audio_features.parquet` (24 kolom fitur, 5.997 baris). Metadata plus fitur disimpan di `fi_v2_meta.with_feats.csv`.

### 4. Eksplorasi Data (EDA)
- Membatasi daftar fitur ke kolom yang tersedia, kemudian:
  - Menghitung statistik deskriptif (`duration_sec`, `rms_db_med`, `voiced_ratio`, `speech_sec`, dan fitur spektral).
  - Membuat histogram fitur kunci.
  - Menghasilkan heatmap korelasi; ditemukan korelasi tinggi antara `rms_db_med` vs `rms_db_mean`, serta `centroid_mean` vs `bandwidth_mean` vs `rolloff95_mean`, dan `voiced_ratio` vs `speech_sec`.
- Menyimpulkan kondisi umum: RMS median sekitar -30 dB, voiced ratio sekitar 0.71, speech length sekitar 10.9 detik, clip ratio mendekati nol, dan sebagian fitur memiliki redundansi kuat.

### 5. Recompute VAD dengan WebRTC
- Menginstal `webrtcvad` dan `soundfile` via `pip`.
- Menghitung ulang VAD pada baris dengan `voiced_ratio >= 0.98` dengan WebRTC VAD (aggressiveness=2). Terdapat 122 klip terdampak dan hasil disimpan ke `fi_v2_meta.revad_only.csv`.
- Mengevaluasi hasil: distribusi global `voiced_ratio` stabil (rata-rata 0.7121), namun spike ekstrem berkurang. Proporsi `voiced_ratio >= 0.95` menjadi 3,28% dan `>= 0.98` menjadi 1,98%.
- Targeted re-VAD (aggressiveness=3) dijalankan pada 2 klip yang masih mencurigakan (drop drastis sesudah re-VAD pertama) untuk memastikan nilai akhir wajar.

### 6. Cleaning Data
- Rule filtering:
  - `rms_db_med >= -45`
  - `clip_ratio <= 0.02`
  - `0.35 <= voiced_ratio <= 0.99`
  - `speech_sec >= 6.0`
- Robust outlier removal menggunakan robust z-score (median/MAD) pada `centroid_mean`, `bandwidth_mean`, `rolloff95_mean`, `zcr_mean`, dan `flatness_med` dengan ambang |rZ| ≤ 4.
- Hasil akhir: dari 5.997 baris, 5.717 lolos rule, 5.425 lolos sekaligus dari outlier check. File bersih ditulis ke `fi_v2_meta.with_feats.clean.csv` dan fitur selaras ke `audio_features.clean.parquet`.

### 7. Quality Check Sebelum Splitting
- Menampilkan breakdown kehilangan data per rule: RMS rendah (4,40%), clip ratio tinggi (0,13%), voiced ratio rendah (0%), speech duration pendek (0,13%).
- Memverifikasi statistik label Big Five pada dataset bersih serta memastikan tidak ada label yang hilang.
- Menampilkan preview 10 baris pertama untuk inspeksi cepat.

### 8. Pembekuan 5-Fold Split
- Menentukan `person_key` dari `raw_id` (fallback ke `group_id` atau nama file).
- Menghitung rata-rata label (y_mean) lalu membaginya ke 5 kuantil sebagai strata.
- Menjalankan `StratifiedGroupKFold` (`n_splits=5`, `random_state=42`); fallback ke `GroupKFold` bila modul tidak tersedia.
- Menyimpan hasil ke `fi_v2_meta.with_feats.clean.folds.csv` dan `person_folds.csv`.
- QC: tiap fold berisi 1.017–1.121 baris, 486–498 persona unik, dan rata-rata label Big Five berbeda <0,01 antar fold. Ringkasan lengkap juga dicatat ke `SPLIT_SUMMARY.json`.

### 9. Paket Checkpoint2
- Menyalin seluruh berkas WAV ke `/kaggle/working/wav` (skip jika sudah ada) dan memetakan ulang `wav_path` menjadi relatif (`wav/<file>.wav`).
- Menulis `wav_manifest.csv`, `SPLIT_SUMMARY.json`, serta README ringkas artefak Checkpoint2 di folder kerja.
- Total berkas WAV ~2,73 GiB; proses copy mencatat jumlah file yang tersalin maupun dilewati.

## Dependensi dan Cara Menjalankan
- Notebook dirancang untuk lingkungan Kaggle dengan struktur `/kaggle/input` dan `/kaggle/working`.
- Paket tambahan yang dipasang: `webrtcvad` dan `soundfile`. Dalam notebook, instalasi dilakukan dengan `!pip -q install webrtcvad soundfile`.
- Jalankan sel secara berurutan tanpa melewati tahap karena setiap tahap mengandalkan artefak yang dihasilkan sebelumnya (misal hasil re-VAD dipakai untuk cleaning dan splitting).

## Pemanfaatan Artefak Bersih
- Gunakan `fi_v2_meta.with_feats.clean.folds.csv` sebagai sumber utama training; kolom `fold` menentukan fold validasi.
- `audio_features.clean.parquet` dapat dipakai untuk baseline model berbasis fitur klasik atau sebagai input tambahan untuk model tabular.
- Jika membutuhkan audio mentah di luar Kaggle working directory, gunakan `wav_manifest.csv` untuk memetakan nama file ke fold serta `person_key`.
- Dokumentasikan eksperimen dengan menyertakan versi artefak (hash tersedia di `CHECKSUMS_SHA256.json` bila menjalankan sel Checkpoint2).

Notebook ini bisa dijadikan landasan untuk eksperimen supervised (regresi) maupun fine-tuning model audio, karena seluruh tahapan mulai dari validasi data, ekstraksi fitur, cleaning, hingga pembentukan fold sudah terdokumentasi dan dapat direplikasi.
