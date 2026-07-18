# QriboRead — Lean PoC Scope

> เอกสารนี้เป็นสรุปภาพรวมแบบอ่านเร็ว (Quick Reference) ของ Scope PoC — รายละเอียดฉบับเต็มดูได้ที่ `QriboRead-Requirement.md` ซึ่งเป็นเอกสารหลักที่เป็นปัจจุบันที่สุด

## Pain Point ที่ต้องแก้
- ซื้อหนังสือเยอะ แต่ไม่ได้อ่าน
- อ่านไม่จบ กลางคันหาย
- ไม่รู้ว่าตัวเองเรียนรู้อะไรไปแล้วบ้าง
- ไม่สามารถดึงความรู้เก่ากลับมาใช้งานจริง

## หลักการออกแบบ PoC
เก็บเฉพาะ Feature ที่ตอบ Pain Point หลักโดยตรง ด้วยต้นทุนพัฒนาต่ำที่สุด เพื่อทดสอบว่าคนจะใช้และยอมจ่ายจริงหรือไม่ ก่อนลงทุนเพิ่มในฟีเจอร์ AI ขั้นสูงที่มีต้นทุนสูงกว่า

---

## กลุ่มผู้ใช้และ Business Model

| หัวข้อ | รายละเอียด |
|---|---|
| กลุ่มผู้ใช้ | สาธารณะ (เปิดสมัครทั่วไป) |
| Platform | **Web-only** (เว็บแอป Responsive รองรับ Desktop และ Mobile Browser) |
| Business Model | Subscription **Tier เดียว** (ไม่มี Free Tier ถาวร) |
| Free Trial | ทดลองใช้ฟรี 7 วัน ก่อนต้องสมัครสมาชิก |
| ราคา | **179 บาท/เดือน** (รายเดือน) หรือ **149 บาท/เดือน** เฉลี่ย (จ่ายรายปี) |
| Payment Gateway | 2C2P |
| Backend Platform | Supabase |
| LLM Provider | Claude API (Anthropic) |
| Fair-use Soft Cap | AI Summary 25 ครั้ง/เดือน/ผู้ใช้ (แจ้งเตือนตั้งแต่ครั้งที่ 18) |
| ภาษา | รองรับหลายภาษา (ไทย, อังกฤษ ขยายได้ในอนาคต) |

---

## ✅ Feature ที่มีใน PoC

### 1. Content Management
- อัปโหลดไฟล์ PDF/EPUB
- เพิ่มบทความจากลิงก์เว็บ (Paste URL)
- คลังเนื้อหาส่วนตัว (Library)

### 2. AI Summary (Core Value — "ช่วยอ่านแทน")
- สรุปแบบ Executive Summary (อ่านจบใน 5-10 นาที)
- สรุปแบบ Key Takeaways / Action Items
- รองรับหลายภาษาในการสรุป

### 3. Reading & Annotation
- Highlight ข้อความ
- เขียน Note ผูกกับตำแหน่งอ้างอิง

### 4. Progress Tracking
- % ความคืบหน้าการอ่านต่อรายการ
- Dashboard พื้นฐาน (จำนวนที่อ่าน, เวลาที่ใช้)
- Reading Streak
- ตั้งเป้าหมายการอ่าน (จำนวนเล่ม/บทความต่อเดือน)
- แจ้งเตือนกลับมาอ่าน (Email หรือ Web Push Notification)

### 5. Knowledge Retrieval
- Keyword Search ครอบคลุมเนื้อหา + Highlight/Note ทั้งหมด

### 6. Account & Subscription
- สมัครสมาชิก/ล็อกอิน
- Subscription Tier เดียว + Free Trial 7 วัน + ชำระเงินผ่าน 2C2P
- จัดการโปรไฟล์และตั้งค่าบัญชี

### 7. Data & Backup
- ข้อมูลเก็บบน Cloud อัตโนมัติผ่าน Supabase (ไม่มีความเสี่ยงข้อมูลสูญหาย เพราะเป็น Web ไม่ใช่ Local Storage)

### 8. Logging & Observability
- บันทึก Event สำคัญ (`event_log`) และ Error (`error_log`) เพื่อติดตาม KPI และ Debug

### 9. Admin (พื้นฐาน)
- ใช้ Supabase Studio ดูข้อมูลผู้ใช้/Subscription/Usage Log แทนการสร้าง Admin Panel เอง

### 10. Platform
- **Web App เดียว** (Responsive รองรับ Desktop และ Mobile Browser)

---

## ❌ Feature ที่ตัดออกจาก PoC (ไปทำเฟสถัดไป)

| Feature | เหตุผลที่ตัด |
|---|---|
| แหล่งข้อมูล: YouTube, Physical Book (ISBN Scan), Course, Kindle | เพิ่ม Complexity สูง ยังไม่จำเป็นต่อการพิสูจน์ Core Value |
| AI Semantic Search | ต้องมี Vector DB + Embedding Pipeline |
| Knowledge Graph | ต้นทุนพัฒนาสูง |
| AI Chat with Book (RAG) | ต้นทุนสูงสุดทั้งด้าน Dev และ API Cost ต่อการใช้งาน |
| Flashcard / Quiz | ยังไม่ใช่ Core Value ที่ต้องพิสูจน์ก่อน |
| PDF วิเคราะห์เชิงลึก (ทำงานกับเอกสาร) | ยกเลิกตามการตัดสินใจ |
| Mobile App (iOS/Android) | เริ่มจาก Web ก่อนเพื่อลดต้นทุนและความเร็วในการทดสอบ |
| Data Export UI, Multi-device Sync แบบ Real-time, Free Tier ถาวร | เลื่อนไปพิจารณาอีกครั้งหลังเห็นผล PoC |

---

## สถาปัตยกรรมที่แนะนำ

ใช้ **Backend-as-a-Service (Supabase)** แทนการสร้าง Backend เอง:
- ได้ Database (PostgreSQL) + Auth + Storage + Full-text Search + Cloud Backup + Admin Dashboard สำเร็จรูปทันที
- ไม่ต้องจ้าง Backend Developer เต็มรูปแบบ — Full-stack Developer จัดการได้
- ไม่ต้องมี DevOps แยก
- เรียก Claude API ตรงจาก Backend ด้วย Prompt พื้นฐาน — ไม่ต้องมี AI/ML Engineer เฉพาะทางในเฟสนี้ (เพราะไม่มี RAG/Vector Search)

รายละเอียดสถาปัตยกรรมฉบับเต็มดูที่ `QriboRead-System-Architecture.md` และ `QriboRead-Service-Architecture.md`

## ทีมงานที่แนะนำ

| ตำแหน่ง | จำนวน | ลักษณะ |
|---|---|---|
| Full-stack Developer (Web Frontend + Java/Spring Boot Backend + Supabase + Claude API) | 1–2 | Full-time |
| UI/UX Designer | 1 | Freelance ครั้งเดียว |
| Product/BA | 1 | เจ้าของโปรเจกต์ทำเอง |

## งบประมาณโดยประมาณ (3–4 เดือน)

| รายการ | 1 Developer (~4 เดือน) | 2 Developers (~3 เดือน) |
|---|---|---|
| ค่าพัฒนา | 240,000 บาท | 390,000 บาท |
| UI/UX (เหมาจ่ายครั้งเดียว) | 40,000 บาท | 40,000 บาท |
| LLM API (ช่วงพัฒนา/ทดสอบ) | 10,000–20,000 บาท | 10,000–20,000 บาท |
| Infra (Supabase Free–Starter Tier) | 0–5,000 บาท | 0–5,000 บาท |
| Domain/SSL/Hosting | 3,000–5,000 บาท | 3,000–5,000 บาท |
| **รวมโดยประมาณ** | **≈ 295,000–310,000 บาท** | **≈ 445,000–460,000 บาท** |

> Web-first ช่วยลดทั้งเวลาและต้นทุนพัฒนา รวมถึงไม่มีค่าธรรมเนียม App Store/Play Store (15–30%) เทียบกับแนวทาง Mobile App เดิม ทำให้ Margin ของ Subscription ดีขึ้นอย่างมีนัยสำคัญ

## KPI ที่ต้องวัดผลระหว่าง PoC

- อัตราการอัปโหลดเนื้อหาเฉลี่ยต่อผู้ใช้
- อัตราการเปิดอ่าน AI Summary ที่สร้างแล้ว
- **อัตราการสมัคร Subscription หลังจบ Free Trial** (Willingness to Pay — KPI สำคัญที่สุด)
- Retention หลัง 7 วัน / 30 วัน

ผลลัพธ์จาก KPI เหล่านี้จะเป็นข้อมูลจริงมาตัดสินใจว่าจะลงทุนเพิ่มในฟีเจอร์ที่ตัดออกไปด้านบน ในเฟสถัดไปหรือไม่

---

## เอกสารที่เกี่ยวข้อง (ฉบับเต็ม)
- `QriboRead-Requirement.md` — Requirement ฉบับเต็ม (Pricing Rationale, Screen List, ประเด็นตัดสินใจทั้งหมด)
- `QriboRead-Business-Flow.md` — Business Flow และ Use Case แต่ละ Module
- `QriboRead-Service-Architecture.md` — รายละเอียด Service และ Endpoint
- `QriboRead-System-Architecture.md` — ภาพรวมสถาปัตยกรรมระบบ
- `QriboRead-Database-Design.md` + `QriboRead-initial-db.sql` — โครงสร้างฐานข้อมูล
- `QriboRead-openapi.yaml` — API Specification (Swagger)
