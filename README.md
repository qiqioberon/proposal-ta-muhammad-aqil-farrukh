# Tugas Akhir – Estimasi Kepribadian Big Five dari Data Suara (Audio-Only)

Repositori ini berisi seluruh dokumen, catatan riset, serta kode yang digunakan dalam pengerjaan Tugas Akhir **Muhammad Aqil Farrukh** dengan topik:

> **Estimasi Kepribadian Big Five dari Data Suara (Audio-Only)**

---

## 📂 Struktur Folder

```
catatan-riset/            # Catatan progres riset dalam format Markdown
├─ dataset/               # Audit dataset (FI, FI-V2, ringkasan)
├─ metodologi.md          # Draft metodologi penelitian
├─ rencana-ETL.md         # Rencana preprocessing audio (ETL)
└─ Readme.md              # Penjelasan isi folder catatan-riset

code/                     # Kode riset & eksperimen
├─ configs/               # Konfigurasi eksperimen (YAML/JSON)
├─ experiments/           # Log hasil eksperimen
├─ notebook/              # Jupyter Notebook eksplorasi
├─ scripts/               # Script CLI (etl.py, train.py, evaluate.py, infer.py)
├─ src/                   # Modul sumber (data loader, fitur, model, evaluasi)
├─ Readme.md              # Panduan menjalankan kode
└─ requirement.txt        # Dependensi Python

data/                     # Data audio (tidak di-commit)
├─ raw/                   # Data mentah
├─ interim/               # Data sementara hasil preprocessing
└─ processed/             # Data siap digunakan untuk training

models/                   # Checkpoint model (tidak di-commit)

dokumen-proposal-ta/      # Draft proposal & dokumen formal
├─ ProposalTAMuhammadAqilFarrukh.docx
└─ proposalTAMuhammadAqilFarrukh.md

sumber-jurnal-dan-riset/  # Referensi literatur & screenshot
├─ DokumenSumber/
└─ Screenshot Sumber/

.gitignore                # File/folder yang diabaikan Git
```

---

## 🚀 Tujuan

1. **Mendokumentasikan progres riset** (audit dataset, rencana ETL, metodologi).
2. **Mengimplementasikan pipeline** untuk estimasi Big Five dari audio-only.
3. **Menyediakan kode eksperimen** yang bisa direplikasi.
4. **Menyusun laporan akhir TA** berbasis catatan dan eksperimen di repo ini.

---

## 🔧 Cara Menjalankan Kode

1. Buat virtual environment Python (disarankan `venv` atau `conda`).
2. Install dependensi:

   ```bash
   pip install -r code/requirement.txt
   ```
3. Jalankan preprocessing (contoh dengan config FI baseline):

   ```bash
   python code/scripts/etl.py --config code/configs/fi-baseline.yaml
   ```
4. Training:

   ```bash
   python code/scripts/train.py --config code/configs/fi-baseline.yaml
   ```
5. Evaluasi:

   ```bash
   python code/scripts/evaluate.py --config code/configs/fi-baseline.yaml
   ```
6. Inference:

   ```bash
   python code/scripts/infer.py --audio path/to/sample.wav
   ```

---

## 📌 Status Progres

* [x] Struktur repo & dokumentasi awal
* [x] Audit dataset FI (deep-dive)
* [ ] Audit dataset FI-V2
* [ ] Ringkasan perbandingan dataset
* [ ] Rencana ETL final
* [ ] Implementasi baseline model
* [ ] Evaluasi & analisis hasil

---

## 📚 Lisensi & Hak Akses Dataset

* Dataset yang digunakan (FI, FI-V2, dll.) tunduk pada lisensi masing-masing penyedia.
* Dataset **tidak disertakan dalam repo ini**. Untuk akses, silakan mengacu ke situs resmi penyedia dataset.

---

## ✍️ Penulis

**Muhammad Aqil Farrukh (5025221158)**
Institut Teknologi Sepuluh Nopember (ITS)
Departemen Teknik Informatika – Angkatan 2022
