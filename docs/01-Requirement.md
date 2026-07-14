# AI Reading & Learning Hub — Requirement Document (PoC)

## 1. ภาพรวมโปรเจกต์

**จุดขาย:** "ทุกความรู้มาอยู่ที่เดียว" — ช่วยแก้ปัญหาการอ่านหนังสือ/บทความไม่จบ ไม่รู้ว่าเรียนอะไรไปแล้ว และนำความรู้เก่ากลับมาใช้ไม่ได้

**Pain Point ที่แก้:**
- ซื้อหนังสือเยอะ แต่ไม่ได้อ่าน
- อ่านไม่จบ กลางคันหาย
- ไม่รู้ว่าตัวเองเรียนรู้อะไรไปแล้วบ้าง
- ไม่สามารถดึงความรู้เก่ากลับมาใช้งานจริง

**Positioning:** เครื่องมือจัดการความรู้ส่วนบุคคล (Personal Knowledge Management Tool) — ไม่ใช่ผู้เผยแพร่/จัดจำหน่ายเนื้อหาที่มีลิขสิทธิ์ ผู้ใช้ต้องมีสิทธิ์ในเนื้อหาที่นำเข้าระบบเอง

**สถานะเอกสารนี้:** เป็น Requirement สำหรับเฟส **Proof of Concept (PoC)** เพื่อทดสอบ Core Value และ Willingness to Pay ก่อนขยาย Scope เต็มรูปแบบในเฟสถัดไป

---

## 2. กลุ่มผู้ใช้และ Business Model

| หัวข้อ | รายละเอียด |
|---|---|
| กลุ่มผู้ใช้ | สาธารณะ (เปิดสมัครทั่วไป) |
| Platform | **Web-only** (เว็บแอป Responsive รองรับ Desktop และ Mobile Browser) |
| Business Model | Subscription **Tier เดียว** (ไม่มี Free Tier ถาวร) |
| Free Trial | ทดลองใช้ฟรี 7 วัน ก่อนต้องสมัครสมาชิก |
| ราคาแนะนำ | **149–199 บาท/เดือน** (หรือ 1,490–1,990 บาท/ปี) |
| ช่องทางชำระเงิน | 2C2P |
| ภาษา | รองรับหลายภาษา (ไทย, อังกฤษ ขยายได้ในอนาคต) |

---

## 3. Scope of Function (PoC)

### 3.1 Content Management
- อัปโหลดไฟล์ PDF/EPUB
- เพิ่มบทความจากลิงก์เว็บ (Paste URL → ดึงเนื้อหาเว็บอัตโนมัติ)
- คลังเนื้อหาส่วนตัว (Library) แสดงรายการทั้งหมดของผู้ใช้

### 3.2 AI Summarization
> **เป้าหมาย: "ช่วยอ่านแทน"** — ผู้ใช้ต้องได้ใจความสำคัญโดยไม่ต้องอ่านต้นฉบับทั้งหมด นี่คือ Core Value หลักของ PoC
- สรุปแบบ Executive Summary (อ่านจบใน 5–10 นาที)
- สรุปแบบ Key Takeaways / Action Items ที่นำไปใช้ได้จริง
- รองรับหลายภาษาในการสรุป

### 3.3 Reading & Annotation
- Highlight ข้อความ
- เขียน Note ผูกกับตำแหน่งอ้างอิงในเนื้อหา

### 3.4 Progress Tracking
- % ความคืบหน้าการอ่านต่อรายการ
- Dashboard ภาพรวม (จำนวนที่อ่าน, เวลาที่ใช้)
- Reading Streak
- ตั้งเป้าหมายการอ่าน (จำนวนเล่ม/บทความต่อเดือน)
- แจ้งเตือนกลับมาอ่าน (Email หรือ Web Push Notification)

### 3.5 Knowledge Retrieval
- Keyword Search ครอบคลุมเนื้อหา + Highlight/Note ทั้งหมดของผู้ใช้

### 3.6 Account & Subscription
- สมัครสมาชิก / เข้าสู่ระบบ
- ระบบ Subscription (Tier เดียว) + Free Trial 7 วัน + การชำระเงิน
- จัดการโปรไฟล์และตั้งค่าบัญชี

### 3.7 Data & Backup
- ข้อมูลผู้ใช้ (Note/Highlight/Progress) เก็บบน Cloud โดยอัตโนมัติ (ได้จากสถาปัตยกรรม Backend-as-a-Service)

### 3.8 Admin (พื้นฐาน)
- ใช้ Dashboard สำเร็จรูปของ Backend Platform (เช่น Supabase Studio) ดูข้อมูลผู้ใช้/Subscription/Usage log แทนการสร้าง Admin Panel เอง

---

## 4. Non-Functional Requirements

- **สถาปัตยกรรม:** ใช้ Backend-as-a-Service (Supabase หรือ Firebase) เพื่อลดต้นทุนทีมและเวลาพัฒนา
- **AI Integration:** เรียก LLM API ตรงด้วย Prompt พื้นฐานสำหรับ AI Summary — ไม่ต้องมี RAG/Vector DB ใน PoC นี้
- **Performance:** ต้องมีการแจ้งสถานะระหว่างประมวลผล AI Summary (Loading state) เพราะใช้เวลาสร้างสรุปหลายวินาที
- **Data Retention:** ข้อมูลผูกกับบัญชีผู้ใช้บน Cloud ตั้งแต่ต้น (ไม่มีความเสี่ยงข้อมูลสูญหายจากการเปลี่ยนอุปกรณ์ เพราะเป็น Web ไม่ใช่ Local Storage)
- **Fair-use Policy:** ตั้ง Soft Cap การใช้ AI Summary ที่ ~25 ครั้ง/เดือน/ผู้ใช้ เพื่อป้องกันต้นทุน AI บานปลาย
- **Logging & Error Tracking:** ทุก Custom Service ต้องบันทึก Event สำคัญลงตาราง `event_log` (เช่น อัปโหลดสำเร็จ, สร้าง AI Summary สำเร็จ, ชำระเงินสำเร็จ) และบันทึก Error ลงตาราง `error_log` (พร้อม Service ที่เกิด, ระดับความรุนแรง, เวลาที่เกิด) เพื่อให้ทีมงานติดตามปัญหาและวัด KPI ย้อนหลังได้ โดยไม่ต้องพึ่ง Logging Tool ภายนอกในเฟส PoC

---

## 5. Feature ที่ตัดออกจาก PoC (Backlog สำหรับเฟสถัดไป)

| Feature | เหตุผลที่ตัด |
|---|---|
| แหล่งข้อมูล: YouTube, Physical Book (ISBN Scan), Course, Kindle | เพิ่ม Complexity สูง ยังไม่จำเป็นต่อการพิสูจน์ Core Value |
| AI Semantic Search | ต้องมี Vector DB + Embedding Pipeline |
| Knowledge Graph | ต้นทุนพัฒนาสูง |
| AI Chat with Book (RAG) | ต้นทุนสูงสุดทั้งด้าน Dev และ API Cost ต่อการใช้งาน |
| Flashcard / Quiz | ยังไม่ใช่ Core Value ที่ต้องพิสูจน์ก่อน |
| PDF วิเคราะห์เชิงลึก (ทำงานกับเอกสาร) | ยกเลิกตามการตัดสินใจล่าสุด |
| Mobile App (iOS/Android) | เริ่มจาก Web ก่อนเพื่อลดต้นทุนและความเร็วในการทดสอบ |
| Data Export UI, Multi-device Sync แบบ Real-time, Free Tier ถาวร | เลื่อนไปพิจารณาอีกครั้งหลังเห็นผล PoC |

---

## 6. User Flow หลัก

```
สมัคร/เข้าสู่ระบบ (Onboarding)
        ↓
เพิ่มเนื้อหา (อัปโหลด PDF หรือวางลิงก์บทความ)
        ↓
AI สรุปอัตโนมัติ (Core Value: ช่วยอ่านแทน)
        ↓
อ่าน & บันทึกความรู้ (Highlight, Note, ติดตามความคืบหน้า)
        ↓
ครบ Free Trial 7 วัน → แจ้งเตือนให้สมัครสมาชิก
        ↓
สมัคร Subscription (Tier เดียว รายเดือน/รายปี)
```

---

## 7. ทีมงานและงบประมาณ (PoC)

**ทีมงานที่แนะนำ:**

| ตำแหน่ง | จำนวน | ลักษณะ |
|---|---|---|
| Full-stack Developer (Web + Supabase/Firebase + LLM API) | 1–2 | Full-time |
| UI/UX Designer | 1 | Freelance ครั้งเดียว |
| Product/BA | 1 | เจ้าของโปรเจกต์ทำเอง |

**งบประมาณโดยประมาณ (3–4 เดือน):**

| รายการ | 1 Developer (~4 เดือน) | 2 Developers (~3 เดือน) |
|---|---|---|
| ค่าพัฒนา | 240,000 บาท | 390,000 บาท |
| UI/UX (เหมาจ่ายครั้งเดียว) | 40,000 บาท | 40,000 บาท |
| LLM API (ช่วงพัฒนา/ทดสอบ) | 10,000–20,000 บาท | 10,000–20,000 บาท |
| Infra (Free–Starter Tier) | 0–5,000 บาท | 0–5,000 บาท |
| Domain/SSL/Hosting | 3,000–5,000 บาท | 3,000–5,000 บาท |
| **รวมโดยประมาณ** | **≈ 295,000–310,000 บาท** | **≈ 445,000–460,000 บาท** |

> หมายเหตุ: เมื่อเทียบกับ Mobile PoC เดิม การเลือก Web ช่วยลดทั้งเวลาและต้นทุนพัฒนา รวมถึงไม่มีค่าธรรมเนียม App Store/Play Store (15–30%) ทำให้ Margin ของ Subscription ดีขึ้นอย่างมีนัยสำคัญ

---

## 8. KPI ที่ต้องวัดผลระหว่าง PoC

- อัตราการอัปโหลดเนื้อหาเฉลี่ยต่อผู้ใช้ (มีคนใช้งานจริงหรือไม่)
- อัตราการเปิดอ่าน AI Summary ที่สร้างแล้ว (Feature หลักถูกใช้จริงหรือไม่)
- **อัตราการสมัคร Subscription หลังจบ Free Trial** (Willingness to Pay — KPI สำคัญที่สุด)
- Retention หลัง 7 วัน / 30 วัน

ผลลัพธ์จาก KPI เหล่านี้จะเป็นข้อมูลจริงมาตัดสินใจว่าจะลงทุนเพิ่มในฟีเจอร์ที่ตัดออกไป (ข้อ 5) ในเฟสถัดไปหรือไม่

---

## 9. ผลการตัดสินใจล่าสุด (สัมภาษณ์รอบเพิ่มเติม)

| ประเด็น | ผลสรุป | หมายเหตุ |
|---|---|---|
| Payment Gateway | **2C2P** | เลือกเป็นเจ้าหลัก |
| Backend Platform | **Supabase** | เลือกเพราะมี Full-text Search ในตัว (PostgreSQL) เหมาะกับ Feature Keyword Search ที่มีอยู่แล้วใน Scope โดยไม่ต้องเพิ่ม Service อื่น |
| LLM Provider | **Claude API (Anthropic)** | เลือกเพราะ Hallucination ต่ำ สำคัญมากสำหรับงาน AI Summary ที่ต้องการความถูกต้อง (Core Value "ช่วยอ่านแทน") |
| Fair-use Soft Cap (AI Summary) | **25 ครั้ง/เดือน/ผู้ใช้** | ตามที่เสนอไว้เดิมในการคำนวณ Unit Economics |
| การแจ้งเตือนก่อนถึง Soft Cap | **แจ้งเตือนตั้งแต่ครั้งที่ 18** | แจ้งล่วงหน้าก่อนถึง Cap 25 ครั้ง เพื่อให้ผู้ใช้ทราบล่วงหน้าและไม่รู้สึกถูกตัดใช้งานกะทันหัน |

## 10. ประเด็นที่ยังต้องตัดสินใจเพิ่มเติม

ไม่มีประเด็นค้างแล้ว — Requirement พร้อมส่งต่อให้ทีม Dev เริ่มพัฒนาได้
