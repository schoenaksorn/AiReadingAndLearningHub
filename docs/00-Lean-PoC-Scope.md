# QriboBook — Lean PoC Scope

## Pain Point ที่ต้องแก้
- ซื้อหนังสือเยอะ แต่ไม่ได้อ่าน
- อ่านไม่จบ กลางคันหาย
- ไม่รู้ว่าตัวเองเรียนรู้อะไรไปแล้วบ้าง
- ไม่สามารถดึงความรู้เก่ากลับมาใช้งานจริง

## หลักการออกแบบ PoC
เก็บเฉพาะ Feature ที่ตอบ Pain Point หลักโดยตรง ด้วยต้นทุนพัฒนาต่ำที่สุด เพื่อทดสอบว่าคนจะใช้และยอมจ่ายจริงหรือไม่ ก่อนลงทุนเพิ่มในฟีเจอร์ AI ขั้นสูงที่มีต้นทุนสูงกว่า

---

## ✅ Feature ที่มีใน PoC

### 1. Content Management
- อัปโหลดไฟล์ PDF/EPUB
- เพิ่มบทความจากลิงก์เว็บ (Paste URL)

### 2. AI Summary (Core Value — "ช่วยอ่านแทน")
- สรุปแบบ Executive Summary (อ่านจบใน 5-10 นาที)
- สรุปแบบ Key Takeaways / Action Items

### 3. Reading & Annotation
- Highlight ข้อความ
- เขียน Note ผูกกับตำแหน่งอ้างอิง

### 4. Progress Tracking
- % ความคืบหน้าการอ่านต่อเล่ม/บทความ
- Dashboard พื้นฐาน (จำนวนที่อ่าน, เวลาที่ใช้)
- Reading Streak
- ตั้งเป้าหมายการอ่าน (จำนวนเล่ม/เดือน)
- Push Notification เตือนกลับมาอ่าน

### 5. Knowledge Retrieval
- Keyword Search (ค้นหาแบบพื้นฐาน)

### 6. Account & Subscription
- สมัครสมาชิก/ล็อกอิน
- Subscription Tier เดียว (ไม่มี Freemium/Quota ซับซ้อน)

### 7. Data & Backup
- ข้อมูลเก็บบน Cloud อัตโนมัติ (ได้ฟรีจากการใช้ Supabase/Firebase)

### 8. Platform
- Mobile App เดียว (iOS + Android จาก Flutter Codebase เดียว)

---

## ❌ Feature ที่ตัดออกจาก PoC (ไปทำเฟสถัดไป)

| Feature | เหตุผลที่ตัด |
|---|---|
| แหล่งข้อมูล: YouTube, Physical Book, Course | เพิ่ม Complexity สูง ยังไม่จำเป็นต่อการพิสูจน์ไอเดียหลัก |
| AI Semantic Search | ต้องมี Vector DB + Embedding Pipeline |
| Knowledge Graph | ต้นทุน Dev สูง |
| AI Chat with Book (RAG) | ต้นทุนสูงสุดทั้ง Dev และ API Cost |
| Flashcard / Quiz | ยังไม่ใช่ Core Value ที่ต้องพิสูจน์ก่อน |
| Admin Dashboard (สร้างเอง) | ใช้ Dashboard สำเร็จรูปจาก Supabase/Firebase แทน |
| Export ข้อมูล (UI เฉพาะ) | ยังไม่จำเป็นตอน PoC |
| Kindle Integration | ไม่รองรับตั้งแต่ต้นอยู่แล้ว |

---

## สถาปัตยกรรมที่แนะนำ
ใช้ **Backend-as-a-Service (Supabase หรือ Firebase)** แทนการสร้าง Backend เอง:
- ได้ Database + Auth + Storage + Cloud Backup + Admin Dashboard สำเร็จรูปทันที
- ไม่ต้องจ้าง Backend Developer เต็มรูปแบบ — Full-stack Developer คนเดียวจัดการได้
- ไม่ต้องมี DevOps แยก
- เรียก LLM API ตรงจาก Client/Cloud Function ด้วย Prompt พื้นฐาน — ไม่ต้องมี AI/ML Engineer เฉพาะทาง

## ทีมงานที่แนะนำ

| ตำแหน่ง | จำนวน | ลักษณะ |
|---|---|---|
| Full-stack Developer (Flutter + Supabase/Firebase + LLM API) | 1–2 | Full-time |
| UI/UX Designer | 1 | Freelance ครั้งเดียว |
| Product/BA | 1 | เจ้าของโปรเจกต์ทำเอง |

## งบประมาณโดยประมาณ (3–4 เดือน)

| รายการ | 1 Developer (~4 เดือน) | 2 Developers (~3 เดือน) |
|---|---|---|
| ค่าพัฒนา | 240,000 | 390,000 |
| UI/UX (เหมาจ่ายครั้งเดียว) | 40,000 | 40,000 |
| LLM API (ช่วงพัฒนา/ทดสอบ) | 10,000–20,000 | 10,000–20,000 |
| Infra (Free–Starter Tier) | 0–5,000 | 0–5,000 |
| App Store/Play Store | 3,000–5,000 | 3,000–5,000 |
| **รวมโดยประมาณ** | **≈ 295,000–310,000 บาท** | **≈ 445,000–460,000 บาท** |

## KPI ที่ต้องวัดผลระหว่าง PoC
- อัตราการอัปโหลดเนื้อหาเฉลี่ยต่อผู้ใช้
- อัตราการเปิดอ่าน AI Summary ที่สร้างแล้ว
- อัตราการสมัคร Subscription จากผู้ใช้ที่ทดลองใช้
- Retention หลัง 7 วัน / 30 วัน

ผลลัพธ์จาก KPI เหล่านี้จะเป็นข้อมูลจริงมาตัดสินใจว่าจะลงทุนเพิ่มในฟีเจอร์ AI ขั้นสูง (AI Chat, Semantic Search, Multi-source) ในเฟสถัดไปหรือไม่
