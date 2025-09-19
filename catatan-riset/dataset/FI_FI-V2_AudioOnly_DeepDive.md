# ChaLearn First Impressions (FI & FI-V2) – Audio-Only Big Five Dataset Audit

> **Scope:** Audit mendalam untuk penggunaan **audio-only** dengan label **Big Five apparent** (O, C, E, A, N) pada **ChaLearn First Impressions (FI)** dan **First Impressions V2 (FI-V2)**. Bahasa target: **Inggris**. Hasil disusun agar siap dipakai sebagai *DATASET_REPORT.md* untuk tesis.

---

## 1) Executive Summary (≤10 bullet)

- **Apa itu FI/FI‑V2:** Dataset video **~10.000 klip (±15 detik)** dari YouTube, orang berbahasa Inggris berbicara di depan kamera; setiap klip diberi **label Big Five apparent (0–1)** oleh crowd (AMT). FI‑V2 menambahkan **transkrip** dan **label “invite‑to‑interview” (0–1)**.
- **Akses & Lisensi:** Tersedia via **ChaLearn LAP (resmi)** dengan registrasi; lisensi **CC BY‑NC 4.0** (non‑komersial) — wajib atribusi dan sitasi publikasi dataset.
- **Kecocokan audio‑only:** Layak untuk riset **audio‑only**; kualitas ucapan umumnya jelas (kurasi manual), tetapi tetap **in‑the‑wild** → heterogen (mic/ruang/aksen).
- **Catatan kualitas:** Persentase klip dengan **musik/noise** tidak tercantum publik (*tidak tertera*) → butuh **QC sampling** (50–100 klip) untuk estimasi dan aturan filtrasi.
- **Split & anti‑leakage:** **GroupKFold 5‑fold** (group = *person_id* turunan dari video/kanal) untuk cegah kebocoran identitas suara; bandingkan dengan split resmi (6k/2k/2k).
- **Risiko bias:** Distribusi demografi tidak seimbang (gender/etnis/usia), ada bukti bias persepsi pada label; perlu evaluasi fairness per kelompok.
- **ETL audio-only:** Ekstrak audio → **WAV 16 kHz mono**, VAD/trim 200–500 ms, normalisasi level (mis. EBU R128), *drop* klip <2–3 dtk (jika ada anomali).
- **Keputusan:** **GO (dengan catatan)** — (1) lisensi **non‑komersial**; (2) **pre‑proses audio** dan **QC musik/noise** wajib; (3) lakukan **analisis bias & fairness** saat pelaporan.

---

## 2) Tabel Fakta Dataset

| **Nama** | **Tahun/Rilis** | **Jenis label** | **Skala (O,C,E,A,N)** | **#Video/Klip** | **#Speaker (person_id?)** | **Rata2 durasi** | **Modality** | **Hosting** | **Lisensi** | **Halaman Resmi** | **Link Unduh** | **Sitasi (APA)** |
|---|---:|---|---|---:|---|---:|---|---|---|---|---|---|
| **ChaLearn First Impressions (FI)** | 2016 (ECCV) | **Apparent** (AMT) | 0–1 (kontinu) | ~10.000 klip | ~2.7k–3k individu (turunan; **person_id eksplisit: tidak**) | ~15 dtk | Video (RGB+Audio) | ChaLearn LAP | **CC BY‑NC 4.0** | https://gesture.chalearn.org/2016-looking-at-people-eccv-workshop-challenge/data-and-description | Portal ChaLearn (login) | Ponce‑López et al., 2016. *ECCV Workshops* 9915:400–418. |
| **ChaLearn First Impressions V2 (FI‑V2)** | 2017 (CVPR) | **Apparent** (AMT) + **Invite** (0–1) | 0–1 (kontinu) | 10.000 (train/val/test: 6k/2k/2k) | ~2.7k–3k individu (turunan; **person_id eksplisit: tidak**) | ~15 dtk | Video (RGB+Audio) + Transkrip (FI‑V2) | ChaLearn LAP (+ kartu HF/Kaggle) | **CC BY‑NC 4.0** | https://chalearnlap.cvc.uab.cat/dataset/24/ | Portal ChaLearn (login) | Escalante et al., 2020. *IEEE TAFFC* 11(1):120–136. |

> **Catatan:** FI++/V3 **tidak diaudit penuh**; secara ringkas mengikuti FI‑V2 (akses, lisensi, struktur), dengan anotasi tambahan (mis. demografi/soft‑labels) di beberapa rilis/analisis.

---

## 3) Label & Metadata

- **Sumber label:** *Apparent personality* dikumpulkan via **AMT** menggunakan **perbandingan berpasangan (pairwise)** antar video per trait; skor kontinu 0–1 direkonstruksi dengan **model Bradley‑Terry‑Luce (BTL)** MLE. Setiap klip memiliki 5 skor: **O, C, E, A, N**.
- **Urutan trait & skala:** Gunakan urutan **O, C, E, A, N** dan skala **float [0,1]** (tanpa pembulatan). Simpan konsisten di metadata.
- **person_id/speaker_id:** **Tidak tersedia eksplisit.** Praktik yang disarankan: turunkan **person_id** dari **ID video asal/kanal YouTube** (klip yang berasal dari video yang sama ≈ orang yang sama). Verifikasi praktis: inspeksi pola penamaan file atau (opsional) *clustering* wajah/suara pada subset untuk konfirmasi.

---

## 4) Akses & Lisensi (kutipan singkat)

- **Lisensi:** **Creative Commons BY‑NC 4.0** — “You are free to share and adapt for **non‑commercial** purposes with **attribution**.”  
  Link: https://creativecommons.org/licenses/by-nc/4.0/
- **Ketentuan penggunaan (ringkas):** Halaman resmi ChaLearn menekankan kewajiban **menyitir publikasi** ketika menggunakan data, dan **peringatan** bahwa dataset **tidak didesain representatif** populasi (potensi bias).  
  Halaman FI (ECCV’16): https://gesture.chalearn.org/2016-looking-at-people-eccv-workshop-challenge/data-and-description  
  Halaman FI‑V2 (CVPR’17): https://chalearnlap.cvc.uab.cat/dataset/24/

> **Rekomendasi:** Unduh hanya dari **portal resmi** ChaLearn (hindari mirror tak resmi). Simpan **checksum** (md5/sha256) per arsip bila disediakan, atau hitung sendiri pasca unduh untuk verifikasi integritas.

---

## 5) Kualitas Audio & Pra‑Proses

- **Kualitas audio (ringkas):** Klip dipilih dari vlog Q&A dengan **suara jelas**, satu orang berbicara ke kamera; tetap **in‑the‑wild** → variasi mic/ruang/aksen ada. Persentase **musik/noise**: **tidak tertera** publik.
- **Protokol QC cepat (disarankan):**
  1) **Sampling** acak **50–100** klip (proporsional per split),  
  2) **Tag**: `speech_clean`, `speech+music`, `speech+noise`, `low_volume`,  
  3) Estimasi **% musik/noise**; tetapkan **aturan filter** (contoh: buang `speech+music` menengah‑berat, perbaiki `low_volume` lewat normalisasi, simpan `speech_clean`).
- **Pra‑proses audio standar:**
  - **Ekstraksi & resampling:** WAV **mono, 16 kHz, 16‑bit PCM**.  
    ```bash
    ffmpeg -i input_video.mp4 -vn -ac 1 -ar 16000 -acodec pcm_s16le output.wav
    ```
  - **VAD / trimming:** pangkas keheningan, sisakan **padding 200–500 ms** di awal/akhir (mis. `webrtcvad` / SoX).
  - **Normalisasi level:** mis. **EBU R128 −23 LUFS** atau *peak normalization* (−1 dBFS).
  - **Drop klip pendek:** buang klip < **2–3 dtk** (anomali ekstraksi).

**Estimasi IO/Waktu:** Total durasi audio ~**41.6 jam** (10k×15 dtk). Ekstraksi 10k → WAV 16 kHz ≈ **~5 GB**. CPU 8‑core (ffmpeg multithread): kira‑kira **1–2 jam** untuk ekstraksi + 0.5–1 jam untuk VAD/normalisasi batch (tergantung tool).

---

## 6) Struktur Berkas & Skema ETL

**Struktur tipikal setelah unduh (video) & anotasi:**
```
FI/
├─ Train/            # ~6000 mp4
├─ Validation/       # ~2000 mp4
├─ Test/             # ~2000 mp4
└─ annotations/
   ├─ train_annotation.pkl
   ├─ val_annotation.pkl
   ├─ test_annotation.pkl
   └─ (opsional) *_transcription.pkl   # FI‑V2
```

**Struktur output audio & metadata yang disarankan:**
```
FI_audio/
├─ audio/
│  ├─ train/*.wav
│  ├─ val/*.wav
│  └─ test/*.wav
└─ meta/
   ├─ labels.csv
   └─ subset_pilot.csv  # (setelah seleksi)
```

**Template `meta/labels.csv`:**
```csv
clip_id,person_id,src_path,path_wav,duration_sec,O,C,E,A,N,label_type,scale
id_ABC123_3,PID_007,Train/id_ABC123_3.mp4,audio/train/ABC123_3.wav,14.8,0.42,0.58,0.70,0.55,0.61,apparent,0-1
```

**Ekstraksi audio (contoh ffmpeg):**
```bash
ffmpeg -i input.mp4 -vn -ac 1 -ar 16000 -acodec pcm_s16le out.wav
# optional: loudness normalization
ffmpeg -i out.wav -af loudnorm=I=-23:LRA=7:TP=-1 out_norm.wav
```

**Langkah ETL (ringkas):**  
1) Loop semua `.mp4` → hasilkan `.wav` (idempoten: **skip jika sudah ada**),  
2) VAD/trim & normalisasi,  
3) Parse `*_annotation.pkl` → baca skor O,C,E,A,N per `clip_id`,  
4) Bentuk `person_id` turunan (mis. *base video id*), tulis `meta/labels.csv`.

---

## 7) Split Evaluasi (Anti‑Leakage)

- **Usulan utama:** **GroupKFold 5‑fold**, `group = person_id` (turunan). Simpan ke `splits/fold_{k}.json`.  
  *Rasional:* mencegah kebocoran **identitas suara** antar train/val/test — krusial karena satu individu bisa memiliki beberapa klip.
- **Split resmi vs GroupKFold:** Split resmi **6k/2k/2k** memudahkan banding dengan literatur, namun hanya satu pemisahan dan tidak selalu transparan *speaker‑independence*. Kompromi: lakukan **5‑fold CV** di train (6k) untuk *tuning*, dan laporkan **final** di **test resmi (2k)** untuk perbandingan eksternal.

---

## 8) Subset Pilot 500–1000 Klip (≤2 bulan)

**Aturan seleksi:**  
- Maks **1 klip per speaker** (berdasar `person_id` turunan),  
- Per trait, ambil **kuantil ekstrem** (top/bottom **20%**) untuk memperkuat variasi sinyal,  
- Gabungkan kandidat semua trait → deduplikasi klip & speaker → target **~800–1000** klip (atau turunkan ambang ke 15% bila terlalu banyak).  
- Validasi kualitas: durasi ≥ **10 dtk**, volume memadai, **tanpa musik** mencolok.

**Pseudocode seleksi (ringkas):**
```python
import pandas as pd

df = pd.read_csv('meta/labels.csv')
keep = set()

for trait in ['O','C','E','A','N']:
    n = len(df)
    q = int(0.2 * n)
    low = df.nsmallest(q, trait)
    high = df.nlargest(q, trait)
    cand = pd.concat([low, high])

    # pilih max 1 klip per speaker (yang paling ekstrem untuk trait tsb)
    for pid, g in cand.groupby('person_id'):
        g = g.copy()
        # pilih yang ter-ekstrem relatif (min atau max)
        ix = g[trait].idxmin() if g[trait].mean() <= 0.5 else g[trait].idxmax()
        keep.add(ix)

subset = df.loc[list(keep)].drop_duplicates(subset=['person_id'])
if len(subset) > 1000:
    subset = subset.sample(n=1000, random_state=42)

# validasi durasi & aturan kualitas dapat diterapkan di sini
subset.to_csv('meta/subset_pilot.csv', index=False)
```

---

## 9) Risiko, Bias & Mitigasi

- **Bias demografi/dialek/domain:** Distribusi gender/etnis/usia **tidak seimbang**; ada bukti bias persepsi pada label (perempuan/kelompok etnis tertentu bisa mendapat skor lebih tinggi/rendah). Domain YouTube vlog juga bias pada gaya bicara tertentu (ekspresif).
- **Dampak:** Model audio‑only bisa menyerap **cue** demografi (pitch, aksen, tempo) → risiko generalisasi buruk.
- **Mitigasi praktis:**  
  - **Stratified sampling** saat train (jika atribut demografi tersedia),  
  - **Fairness report**: metrik per kelompok (MAE/r per gender/etnis), banding rata‑rata prediksi,  
  - **Filter musik/noise** sebelum training; **ablation** (tanpa klip bermusik),  
  - **Re‑weighting** loss atau **adversarial debiasing** (opsional) untuk mengurangi ketergantungan pada cue demografi,  
  - **Dokumentasikan** limitasi & bias pada *model card* / bab etika.

---

## 10) Referensi (tautan dapat diklik)

- **Halaman resmi dataset:**
  - FI (ECCV’16) – Data & description: https://gesture.chalearn.org/2016-looking-at-people-eccv-workshop-challenge/data-and-description  
  - FI‑V2 (CVPR’17) – Dataset hub: https://chalearnlap.cvc.uab.cat/dataset/24/  
  - Catatan perbedaan FI vs V2: https://chalearnlap.cvc.uab.cat/dataset/20/data/34/description/

- **Publikasi primer:**
  - Ponce‑López, V., et al. (2016). *ChaLearn LAP 2016: First Round Challenge on First Impressions — Dataset and Results*. **ECCV Workshops**, 400–418. (PDF) https://discovery.ucl.ac.uk/10114947/1/ECCVW2016_LAP.pdf  
  - Escalante, H. J., et al. (2020). *Modeling, Recognizing, and Explaining Apparent Personality from Videos*. **IEEE Transactions on Affective Computing**, 11(1):120–136. (PDF) https://webspace.science.uu.nl/~salah006/escalante20taffc.pdf  
  - Jacques‑Junior, J. C. S., et al. (2021). *Person Perception Biases Exposed: Revisiting the First Impressions Dataset*. **WACV Workshops**. (PDF) https://openaccess.thecvf.com/content/WACV2021W/HBU/papers/Jacques_Person_Perception_Biases_Exposed_Revisiting_the_First_Impressions_Dataset_WACVW_2021_paper.pdf

---

### Lampiran: Rekomendasi Implementasi Cepat

- **Extractor:** ffmpeg (CLI) + batch script; **VAD:** `webrtcvad` / SoX; **Norma:** ffmpeg `loudnorm` atau `pydub` (peak).  
- **Feature baseline (opsional untuk audio-only):** eGeMAPS (openSMILE), Wav2Vec2‑Base; evaluasi **Pearson r (utama)** + **MAE** (lapor mean±SD per fold).  
- **Tracking:** Simpan log checksum arsip, jumlah file per split, dan laporan QC musik/noise (CSV).

