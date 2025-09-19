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

| **Nama Dataset**                                                     | **Jenis Label** <br/>(**apparent** = dinilai orang lain; **self** = laporan diri)                                                                     | **Modality Audio**                                                              | **Bahasa**                                                           | **#Speaker**                                                | **#Klip**                                                                     | **Durasi Rata2 / Range**                                                                                  | **Kualitas Audio / Noise**                                                                                       | **person\_id tersedia?**                                                                        | **Lisensi / Akses**                                                                                                 | **Tahun / Rilis**             | **Halaman Resmi**                                                                                                         | **Link Unduh / Hosting**                                                                                                     | **Sitasi (APA)**               |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| **ChaLearn First Impressions** (ECCV 2016) – *10k First Impressions* | **apparent** (Big Five dinilai 5-8 juri awam per klip via Amazon MTurk) (TIPI 10-item, skor 0–1)                                                      | Video vlog 15 dtk (gunakan audio saja)                                          | Mayoritas **Inggris** (vlog YouTube internasional)                   | \~2.764 unik (total 10.000 klip) (tiap org muncul 1–4 klip) | 10.000                                                                        | 15 detik (fixed)                                                                                          | Variatif, umumnya jelas (beberapa ada musik latar); SNR rata2 \~12.5 dB                                          | **Ya** (ID klip→dapat mapping ke user YouTube; perlu waspada split agar 1 speaker di satu fold) | Riset non-komersial (terbuka via **ChaLearn**/CodaLab)                                                              | 2016 (ChaLearn LAP ECCV Wksp) | [ChaLearn LAP ECCV2016](https://gesture.chalearn.org/2016-looking-at-people-eccv-workshop-challenge/data-and-description) | [CodaLab (First Impressions Challenge)](https://competitions.codalab.org/competitions/9181)  (download via registration)     | Ponce-López et al. (2016)      |
| **YouTube Vlog (Idiap)** – *YouTube Personality*                     | **apparent** (Big Five dinilai 5 juri per klip, TIPI 10-item, skor 1–7 lalu binarized)                                                                | Video monolog (vlog, gunakan audio)                                             | **Inggris** (monolog vlog dari YouTube)                              | 404 vloggers (1 video per orang) (47% pria, 53% wanita)     | 404                                                                           | \~60 detik diamati (1 menit awal dinilai juri); total durasi vlog bervariasi (umumnya 2–5 menit)          | Beragam (webcam/home recording); umumnya **bersih**, ada minor noise/intro music di beberapa vlog                | **Ya** (unik per vlog; one person one clip)                                                     | Terbuka riset – dataset asli (IDIAP) **sudah tidak direct download**; fitur/transkrip tersedia di Kaggle (BDA 2022) | 2013 (IEEE T-MM)              | [Idiap YouTube Personality](https://www.idiap.ch/en/scientific-research/data/youtube-personality/)  (archived)            | Kaggle: [BDA 2022 Personality Profiling](https://www.kaggle.com/competitions/bda-2022-personality-profiling)  (data + fitur) | Biel & Gatica-Perez (2013)     |
| **SSPNet Speaker Personality Corpus** (SPC) – *French Radio News*    | **apparent** (Big Five dinilai 11 juri per klip, BFI-10, skor 1–5); rata2 diambil sbg ground truth                                                    | Audio monolog (siaran berita radio)                                             | **Prancis** (Swiss French radio)                                     | 322 (penyiar berita); gndr \~60% pria                       | 640 klip (10 detik)                                                           | 10 detik (fixed 10 s per klip, \~1.7 jam total)                                                           | **Tinggi** – rekaman studio radio (speech jernih, tidak ada noise/music)                                         | **Ya** (speaker ID diketahui; resmi split speaker-indep.)                                       | Tersedia via **INTERSPEECH 2012 challenge** (kontak panitia)                                                        | 2012 (collected 2005)         | [INTERSPEECH’12 Challenge](https://www.fon.hum.uva.nl/rob/Publications/IS2012-Speaker-Trait-Challenge.pdf)                | – (upon request via challenge organizers)                                                                                    | Mohammadi & Vinciarelli (2012) |
| **ChaLearn UDIVA v0.5** (Dyadic Interaction)                         | **self** (Big Five laporan diri oleh speaker, NEO-FFI 16-item) **+ peer** (setiap pasangan saling menilai, 1 penilai per orang); skala z-score (self) | Video **dialog** tatap muka (2 orang, multi-sensor; gunakan audio per individu) | **Spanyol** (percakapan informal tugas “Talk, Lego, Animals, Ghost”) | 147 (≥2 sesi per org; total 188 sesi dyad)                  | 188 rekaman dyad (masing2 \~30 menit; disediakan 2 video/sesi, 1 per speaker) | \~30 menit per sesi (4 sub-task); **bisa disegmentasi** 15-30 dtk per ujaran (audio per speaker terpisah) | **Bagus** – rekaman lab 6 kamera + mic (termasuk lavalier); audio jernih, sedikit overlapping (channel terpisah) | **Ya** (ID partisipan, memastikan split per speaker)                                            | Akses **terbatas riset** (ChaLearn Challenge 2021 – data tersedia via perjanjian)                                   | 2021 (WACV Workshop)          | [ChaLearn LAP 2021](https://chalearnlap.cvc.uab.es/dataset/38/description/) (login required)                              | – (request via ChaLearn or authors)                                                                                          | Palmero et al. (2021)          |
| **MuPTA Corpus** (Multimodal Personality Traits Assessment)          | **self** (Big Five laporan diri, BFI-2 60-item; 1–5 Likert, dinormalisasi 0–1)                                                                        | Video monolog + tugas (3 tugas: 2 spontan + 1 baca skrip)                       | **Rusia** (rekaman kantor, native Russian)                           | 30 (15 pr, 15 lk; umur 19–86)                               | 90 rekaman (≈3 per org) – monolog per tugas                                   | \~15 menit per org total; tiap **utterance** 0.5 s – 172 s                                                | **Tinggi** – 48 kHz WAV; ruangan tenang + mic dekat (3 device; kualitas studio)                                  | **Ya** (ID speaker ada, metadata demografi lengkap)                                             | **Gratis riset (email)** – harus email autor (univ. account) untuk link & password                                  | 2023 (INTERSPEECH)            | [SPC RAS – MuPTA](https://hci.nw.ru/en/pages/mupta-corpus)                                                                | via author (email request)                                                                                                   | Ryumina et al. (2023)          |
| **Lukac (2024) Speech Personality** – *Prolific Voice Dataset*       | **self** (Big Five laporan diri, 50-item Big5 survey; skor 1–5) (tanpa penilaian orang lain)                                                          | Audio monolog spontan (perkenalan diri bebas)                                   | **Inggris** (89% native; sisanya beraksen)                           | 2.045                                                       | 2.045 (≈1 klip/org)                                                           | \~**30–60 dtk** (instruksi: “perkenalkan diri Anda” – bebas)                                              | Bervariasi (rekam mandiri via PC/HP, kualitas heterogen; umumnya layak, ada noise minor)                         | **Ya** (unik per file, 1:1 ke speaker)                                                          | **Tertutup** – *tidak tersedia publik* (data pribadi sensitif; hanya analisis agregat)                              | 2024 (Sci. Reports)           | – (dijelaskan di makalah)                                                                                                 | – (data not publicly released)                                                                                               | Lukac (2024)                   |


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

