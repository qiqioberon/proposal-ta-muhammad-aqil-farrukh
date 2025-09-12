# Pencarian Dataset

## Pendahuluan
Dokumen ini merangkum proses **pencarian dan pemilihan dataset** untuk riset *Estimasi Kepribadian Big Five dari Data Suara (audio‑only)*. Fokus utama:
- **Jenis label:** *apparent personality* (dinilai orang lain).
- **Identitas speaker:** tersedia **person_id** agar evaluasi **speaker‑independent** (anti‑leakage) dapat dilakukan.
- **Durasi klip ideal:** **10–30 detik** per sampel (bisa segmentasi dari rekaman panjang).
- **Lisensi:** akses **non‑komersial/akademis** yang jelas.

Empat dataset utama yang diaudit: **FI**, **FI‑V2**, **SPC**, dan **UDIVA** (tanpa memasukkan kandidat lain).

## Status Audit Dataset
| Dataset | Jenis Audit        | Status     |
|--------:|--------------------|------------|
| FI      | FULL deep-dive     | ✅ Selesai |
| FI-V2   | FULL deep-dive     | ⏳ Antrean |
| SPC     | LIGHT deep-dive    | ⚪ Opsional |
| UDIVA   | SELECTIVE deep-dive| ⚪ Cadangan |

## Tabel Kandidat Dataset
> Semua tautan mengarah ke halaman resmi/asal (bukan mirror ilegal).

| Nama Dataset | Jenis Label (apparent/self) | Modality | Bahasa | #Speaker | #Klip | Durasi Rata2/Range | Kualitas Audio/Noise | Ada person_id? | Lisensi/Akses | Tahun/Rilis | Link Halaman Resmi | Link Unduh/Hosting | Sitasi (APA) |
|---|---|---|---|---:|---:|---|---|---|---|---|---|---|---|
| **ChaLearn First Impressions (FI)** | apparent | Video monolog (gunakan audio) | Inggris (mayoritas) | ~2.7k | 10,000 | 15 dtk (fixed) | Variatif; beberapa klip ada musik latar | Ya (wajib split per speaker) | Riset non‑komersial (registrasi) | 2016 | https://gesture.chalearn.org/ | CodaLab (registrasi) | Ponce‑López, V., Escalante, H. J., Guyon, I., Baró, X., dkk. (2016). *ChaLearn LAP 2016: First Impressions*. EURASIP JIVP. https://jivp-eurasipjournals.springeropen.com/ |
| **ChaLearn First Impressions V2 (FI‑V2)** | apparent | Video monolog (gunakan audio) | Inggris | — | — | ≈15 dtk (mirip FI) | Variatif | Ya | Riset non‑komersial (registrasi/perjanjian) | 2017 | https://chalearnlap.cvc.uab.cat/ | CodaLab/ChaLearn (registrasi) | Escalante, H. J., Guyon, I., dkk. (2017). *ChaLearn LAP 2017 Job Candidate Screening (First Impressions V2)*. CVPRW. |
| **SSPNet Speaker Personality Corpus (SPC)** | apparent | **Audio‑only** (siaran berita) | Prancis | 322 | 640 | 10 dtk (fixed) | **Tinggi** (studio radio; bersih) | Ya (ID speaker + split resmi) | Akses riset via panitia (permintaan) | 2012 | http://sspnet.eu/2012/04/speaker-personality-corpus/ | By request (organizers) | Mohammadi, G., & Vinciarelli, A. (2012). *Automatic personality perception from speech*. INTERSPEECH. https://www.isca-archive.org/ |
| **ChaLearn UDIVA v0.5 (Dyadic Interaction)** | self (NEO‑FFI) + peer (terbatas) | Video dialog (gunakan audio per speaker) | Spanyol | 147 | — (per sesi/segmentasi) | ≈30 mnt/sesi → perlu segmentasi 10–30 dtk | **Tinggi** (lab; mic terpisah) | Ya (ID partisipan) | Akses terbatas (perjanjian riset) | 2021 | https://chalearnlap.cvc.uab.cat/dataset/26/description/ | By agreement | Palmero, C., González‑Sosa, E., dkk. (2021). *UDIVA: Multimodal Personality Analysis in Dyadic Interactions*. WACV‑W. https://openaccess.thecvf.com/ |

## Evaluasi per Dataset
### FI
**PRO**
- Label **apparent** dengan banyak penilai; durasi **15 dtk** sudah ideal; skala besar (10k) → kuat untuk pelatihan awal.
- **person_id** memungkinkan **speaker‑independent** split; ekosistem riset matang (challenge, baseline).  
**CON**
- Kualitas audio **heterogen**; sebagian klip mengandung musik latar → perlu filter/noise gating.
- Akses via registrasi; ukuran total moderat → butuh storage & waktu ekstraksi fitur.  
**Kelayakan ≤ 2 bulan:** **Tinggi** (langsung mulai dari subset 500–1000 klip).  
**Sumber:** Halaman ChaLearn: https://gesture.chalearn.org/ · Artikel JIVP: https://jivp-eurasipjournals.springeropen.com/  
**Sitasi (APA):** Ponce‑López, V., Escalante, H. J., Guyon, I., Baró, X., & Guyon, I. (2016). *ChaLearn LAP 2016: First Impressions*. EURASIP Journal on Image and Video Processing.

### FI‑V2
**PRO**
- Lanjutan FI dengan fokus *first impressions* (apparent); kompatibel untuk konsolidasi hasil FI.  
- Infrastruktur kompetisi (CVPRW/ChaLearn) mempermudah replikasi baseline & evaluasi.  
**CON**
- Detail granular (#klip/#speaker) tidak selalu dirilis di ringkasan publik; perlu registrasi untuk metadata lengkap.  
- Distribusi kualitas audio mirip FI (heterogen).  
**Kelayakan ≤ 2 bulan:** **Tinggi/Sedang** (mulai subset; sinkronkan skema label dengan FI).  
**Sumber:** ChaLearn LAP: https://chalearnlap.cvc.uab.cat/ · (kompetisi terkait) CodaLab/ChaLearn.  
**Sitasi (APA):** Escalante, H. J., Guyon, I., et al. (2017). *ChaLearn LAP 2017 Job Candidate Screening (First Impressions V2)*. In *CVPR Workshops*.

### SPC
**PRO**
- **Audio‑only** studio‑grade (bersih), durasi **10 dtk** (fixed) → cocok untuk ekstraksi fitur akustik.  
- Label **apparent** dari banyak juri; **person_id** & split resmi tersedia.  
**CON**
- Bahasa **Prancis** (domain mismatch jika target bahasa Inggris/Indonesia).  
- Akses melalui permintaan; ukuran kecil (640 klip).  
**Kelayakan ≤ 2 bulan:** **Sedang** (mudah diproses, tapi domain mismatch).  
**Sumber:** SSPNet: http://sspnet.eu/2012/04/speaker-personality-corpus/ · ISCA Archive: https://www.isca-archive.org/  
**Sitasi (APA):** Mohammadi, G., & Vinciarelli, A. (2012). *Automatic personality perception from speech*. In *INTERSPEECH*. ISCA.

### UDIVA
**PRO**
- Data **lab** berkualitas tinggi; **person_id** per partisipan; tersedia *peer* rating (tambahan perspektif).  
- Kaya metadata (multi‑modal), memudahkan perluasan eksperimen di masa depan.  
**CON**
- Label utama **self‑report**; *peer* terbatas → tidak sepenuhnya apparent.  
- Rekaman panjang (≈30 mnt/sesi) → perlu **segmentasi 10–30 dtk**; akses via perjanjian.  
**Kelayakan ≤ 2 bulan:** **Sedang/Rendah** (feasible bila hanya subset sesi diproses).  
**Sumber:** ChaLearn LAP UDIVA: https://chalearnlap.cvc.uab.cat/dataset/26/description/ · Paper WACV‑W: https://openaccess.thecvf.com/  
**Sitasi (APA):** Palmero, C., González‑Sosa, E., et al. (2021). *UDIVA: Multimodal Personality Analysis in Dyadic Interactions*. In *WACV Workshops*. CVF.

## Decision Matrix
Bobot kriteria:
- **Kesesuaian label (apparent)** – 25%  
- **person_id & anti‑leakage** – 20%  
- **Kualitas audio** – 15%  
- **Ukuran & keberagaman speaker** – 15%  
- **Lisensi/kemudahan akses** – 10%  
- **Kecocokan durasi 10–30 dtk** – 10%  
- **Dokumentasi/metadata** – 5%

> Skor 0–100 per kriteria (subjektif‑terbimbing berdasarkan spesifikasi publik); **Total** = Σ(skor × bobot).

| Dataset | Label | person_id | Kualitas Audio | Ukuran | Lisensi | Durasi | Metadata | **Total** |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **FI** | 100 | 85 | 70 | 100 | 90 | 100 | 70 | **90.00** |
| **FI‑V2** | 100 | 85 | 70 | 80 | 80 | 90 | 75 | **85.25** |
| **SPC** | 100 | 100 | 95 | 55 | 50 | 100 | 60 | **85.50** |
| **UDIVA** | 60 | 100 | 90 | 50 | 60 | 70 | 90 | **73.50** |

## Rekomendasi
**Top‑3**: **FI**, **FI‑V2**, **SPC**. **Cadangan**: **UDIVA**.  
Alasan utama: FI & FI‑V2 memenuhi label **apparent**, memiliki **person_id**, durasi **≈15 dtk**, dan skala cukup besar; SPC menambah **audio‑only** bersih untuk validasi akustik; UDIVA berguna sebagai **cadangan** (kaya metadata) namun label dominan *self* dan perlu segmentasi.

**Usulan subset pilot (≤ 2 bulan):**
- **FI:** 800–1000 klip (seimbang skor trait tinggi/rendah) sebagai baseline awal.  
- **FI‑V2:** 400–600 klip (sinkron label & protokol dengan FI).  
- **SPC:** seluruh 640 klip (ringkas, audio bersih) untuk validasi fitur prosodi.  
- **UDIVA (opsional):** 10–20 sesi (≈5–10 jam) → disegmentasi 10–30 dtk per speaker, hanya jika waktu cukup.

> Catatan: Seluruh eksperimen **wajib speaker‑independent split** (GroupKFold per **person_id**) untuk mencegah kebocoran data dan memvalidasi kemampuan generalisasi.
Siap, saya akan mulai pencarian 5–10 dataset terkini (2021–2025) untuk prediksi Big Five dari data audio-only, memprioritaskan: apparent label, monolog, metadata person\_id, dan lisensi terbuka/akademik. Bahasa dibatasi pada Inggris dan Indonesia, dengan preferensi durasi klip 10–30 detik dan audio bersih.

Saya akan segera kembali dengan tabel lengkap kandidat, evaluasi decision matrix, dan rekomendasi subset pilot realistis.
