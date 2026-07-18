# QriboRead — Requirement Document (PoC)

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
| ราคาแนะนำ | **179 บาท/เดือน** (รายเดือน) หรือ **149 บาท/เดือน** เฉลี่ย (จ่ายรายปี) — ดูเหตุผลและ Unit Economics ที่ Section 2.1 |
| ช่องทางชำระเงิน | 2C2P |
| ภาษา | รองรับหลายภาษา (ไทย, อังกฤษ ขยายได้ในอนาคต) |

### 2.1 เหตุผลของราคานี้ (Pricing Rationale)

**Unit Economics ที่ Worst Case (ผู้ใช้เรียก AI Summary เต็มโควตา 25 ครั้ง/เดือนทุกเดือน):**

| แผน | ราคา | หลังหักค่าธรรมเนียม 2C2P (~3%) | ต้นทุนสูงสุด/ผู้ใช้ | Margin |
|---|---|---|---|---|
| รายเดือน | 179 บาท | 173.6 บาท | 68 บาท | **~61%** |
| รายปี (เฉลี่ย) | 149 บาท | 144.5 บาท | 68 บาท | **~53%** |

**ทำไมเลือกราคานี้แทนที่จะตั้งสูงกว่า:** เทียบกับคู่แข่งเจ้าตลาดโลกอย่าง Blinkist (~289 บาท/เดือนเทียบเท่า) ราคานี้อยู่ที่ประมาณครึ่งเดียว ซึ่งเหมาะสมกับสถานะ PoC ที่ยังไม่มี Library ขนาดใหญ่หรือฐานผู้ใช้/แบรนด์ ให้ความสำคัญกับ **Adoption และการเก็บสัญญาณ Willingness to Pay ให้ได้เร็วที่สุด** มากกว่าการบีบ Margin ต่อคนให้สูงสุด เนื่องจากต้นทุนทีมพัฒนา (~4 ล้านบาท) เป็นต้นทุนคงที่ที่ต้องหารด้วยจำนวนผู้ใช้ทั้งหมด — ผู้ใช้จำนวนมากขึ้นที่ Margin ปานกลาง มีประโยชน์ต่อการ Cover ต้นทุนคงที่มากกว่าผู้ใช้น้อยที่ Margin สูงมาก

**หากต้องการเพิ่ม Margin ในอนาคต ให้ลดต้นทุนแทนการขึ้นราคา** เพื่อไม่ให้กระทบ Conversion Rate:

| วิธี | หลักการ | ผลกระทบต่อผู้ใช้ |
|---|---|---|
| Cache AI Summary เนื้อหายอดนิยม | เนื้อหาเดียวกันที่มีคนอัปโหลดซ้ำ สรุปครั้งเดียวแล้วใช้ผลเดิมซ้ำ ไม่เรียก Claude API ใหม่ทุกครั้ง | ไม่มีเลย ได้ผลลัพธ์เร็วขึ้นด้วยซ้ำ |
| ตัดข้อความก่อนส่งเข้า AI | สกัดเฉพาะส่วนสำคัญของเอกสาร (ตัดหน้าว่าง/สารบัญ/ส่วนซ้ำ) ลด Input Token | ไม่มีเลย คุณภาพสรุปเท่าเดิมหรือดีขึ้น |
| Fair-use Cap แบบ Soft Throttle | ผู้ใช้ที่เกิน 25 ครั้ง ยังใช้ต่อได้แต่ประมวลผลช้าลง (เข้าคิว) แทนบล็อกทันที | แทบไม่กระทบ เพราะ Heavy User เป็นส่วนน้อย |
| Right-size Infrastructure | เลือก Supabase Tier ให้พอดีกับปริมาณผู้ใช้จริงในแต่ละช่วง | ไม่กระทบผู้ใช้เลย |
| ลบ/บีบอัดไฟล์ที่ไม่ได้ใช้งานนาน | Archive ไฟล์ต้นฉบับที่ไม่ถูกเปิดอ่านเกิน X เดือน | แทบไม่กระทบ ถ้ามีระบบกู้คืนได้ |
| ต่อรอง Volume Discount | เจรจาราคากับ Claude API/Supabase เมื่อ Usage สูงขึ้นตามผู้ใช้ | ไม่กระทบผู้ใช้เลย |

**ลำดับความสำคัญ:** เริ่มจาก "Cache AI Summary" และ "ตัดข้อความก่อนส่งเข้า AI" ก่อน เพราะทำได้ตั้งแต่ MVP โดยไม่ต้องรอ Scale และให้ผลชัดเจนที่สุด ส่วนที่เหลือทยอยทำเมื่อระบบเริ่มมีผู้ใช้จริงและเห็น Pattern การใช้งาน

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

- **สถาปัตยกรรม:** ใช้ Supabase (Backend-as-a-Service) สำหรับ Database/Auth/Storage เพื่อลดต้นทุนทีมและเวลาพัฒนา ส่วน Business Logic เขียนด้วย Java (Spring Boot) เป็น Backend Service แยกต่างหาก
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

## 7. สรุปหน้าจอที่ต้องมีในระบบ (Screen List)

| # | หน้าจอ | คำอธิบาย | Module ที่เกี่ยวข้อง |
|---|---|---|---|
| 1 | Landing Page | หน้าแรกแนะนำแอป พร้อมปุ่มสมัคร/เข้าสู่ระบบ | Onboarding |
| 2 | Sign Up | ฟอร์มสมัครสมาชิก (Email/Password) | Onboarding |
| 3 | Email Verification | หน้าแจ้งให้ยืนยันอีเมล | Onboarding |
| 4 | Login | ฟอร์มเข้าสู่ระบบ | Onboarding |
| 5 | Forgot / Reset Password | ขอลิงก์รีเซ็ตรหัสผ่าน และหน้าตั้งรหัสผ่านใหม่ | Onboarding |
| 6 | Onboarding Tutorial | แนะนำการใช้งานเบื้องต้นหลังสมัครครั้งแรก | Onboarding |
| 7 | Dashboard (หน้าหลัก) | ภาพรวม: จำนวนที่อ่าน, เวลาที่ใช้, Streak, ความคืบหน้าเทียบเป้าหมาย | Progress Tracking |
| 8 | Library (คลังเนื้อหา) | รายการเนื้อหาทั้งหมดของผู้ใช้ พร้อมสถานะ (รอสรุป/สรุปแล้ว) | Content Management |
| 9 | Add Content | ฟอร์มเพิ่มเนื้อหา — อัปโหลดไฟล์ PDF/EPUB หรือวางลิงก์บทความ | Content Management |
| 10 | Content Detail / Reading View | หน้าอ่านเนื้อหาต้นฉบับ พร้อม Highlight และเพิ่ม Note ระหว่างอ่าน | Reading & Annotation |
| 11 | AI Summary View | แสดง Executive Summary + Key Takeaways ของเนื้อหานั้น (มักแสดงเป็นส่วนหนึ่งของ Content Detail) | AI Summarization |
| 12 | Quota Warning / Notice | ข้อความแจ้งเตือนใกล้ครบ/ครบโควตา AI Summary รายเดือน (Modal หรือ Banner ไม่ใช่หน้าเต็ม) | AI Summarization |
| 13 | Highlights & Notes (บันทึกของฉัน) | รวมรายการ Highlight/Note ทั้งหมดของผู้ใช้ ข้ามทุกเนื้อหา | Reading & Annotation |
| 14 | Goal Setting | ตั้ง/แก้ไขเป้าหมายการอ่านรายเดือน | Progress Tracking |
| 15 | Search Results | หน้าแสดงผลลัพธ์การค้นหา Keyword ข้ามเนื้อหา/Highlight/Note | Knowledge Retrieval |
| 16 | Account Settings | จัดการโปรไฟล์, เปลี่ยนรหัสผ่าน, ตั้งค่าภาษา, เปิด/ปิดการแจ้งเตือน | Account |
| 17 | Subscription / Billing | แสดงสถานะ Trial/Subscription ปัจจุบัน, เลือกแพ็กเกจ, ปุ่มยกเลิก | Account & Subscription |
| 18 | Checkout (Redirect) | หน้า Redirect ไปชำระเงินผ่าน 2C2P (อยู่นอกระบบ ไม่ได้พัฒนาเอง) | Account & Subscription |
| 19 | Trial Expiry Notice | แจ้งเตือนก่อน/หลัง Trial หมดอายุ พร้อม CTA ให้สมัครสมาชิก | Account & Subscription |
| 20 | Cancel Subscription Confirmation | หน้ายืนยันก่อนยกเลิก Subscription | Account & Subscription |
| 21 | 404 / Empty State | หน้าว่างเมื่อยังไม่มีเนื้อหา/ผลการค้นหา และหน้า Error ทั่วไป | ทุก Module |

> หมายเหตุ: ตารางนี้นับเฉพาะหน้าจอฝั่งผู้ใช้ (Client) เท่านั้น ไม่รวม Admin เพราะทีมงานใช้ Supabase Studio ซึ่งเป็น Dashboard สำเร็จรูปที่ไม่ต้องออกแบบ/พัฒนา UI เอง (ตามที่ระบุไว้ใน Service Architecture Document)

## 8. ทีมงานและงบประมาณ (PoC)

**ทีมงานที่แนะนำ:**

| ตำแหน่ง | จำนวน | ลักษณะ |
|---|---|---|
| Full-stack Developer (Web Frontend + **Java/Spring Boot Backend** + Supabase + Claude API) | 1–2 | Full-time |
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

## 9. KPI ที่ต้องวัดผลระหว่าง PoC

- อัตราการอัปโหลดเนื้อหาเฉลี่ยต่อผู้ใช้ (มีคนใช้งานจริงหรือไม่)
- อัตราการเปิดอ่าน AI Summary ที่สร้างแล้ว (Feature หลักถูกใช้จริงหรือไม่)
- **อัตราการสมัคร Subscription หลังจบ Free Trial** (Willingness to Pay — KPI สำคัญที่สุด)
- Retention หลัง 7 วัน / 30 วัน

ผลลัพธ์จาก KPI เหล่านี้จะเป็นข้อมูลจริงมาตัดสินใจว่าจะลงทุนเพิ่มในฟีเจอร์ที่ตัดออกไป (ข้อ 5) ในเฟสถัดไปหรือไม่

---

## 10. ผลการตัดสินใจล่าสุด (สัมภาษณ์รอบเพิ่มเติม)

| ประเด็น | ผลสรุป | หมายเหตุ |
|---|---|---|
| Payment Gateway | **2C2P** | เลือกเป็นเจ้าหลัก |
| Backend Platform | **Supabase** | เลือกเพราะมี Full-text Search ในตัว (PostgreSQL) เหมาะกับ Feature Keyword Search ที่มีอยู่แล้วใน Scope โดยไม่ต้องเพิ่ม Service อื่น |
| LLM Provider | **Claude API (Anthropic)** | เลือกเพราะ Hallucination ต่ำ สำคัญมากสำหรับงาน AI Summary ที่ต้องการความถูกต้อง (Core Value "ช่วยอ่านแทน") |
| Fair-use Soft Cap (AI Summary) | **25 ครั้ง/เดือน/ผู้ใช้** | ตามที่เสนอไว้เดิมในการคำนวณ Unit Economics |
| การแจ้งเตือนก่อนถึง Soft Cap | **แจ้งเตือนตั้งแต่ครั้งที่ 18** | แจ้งล่วงหน้าก่อนถึง Cap 25 ครั้ง เพื่อให้ผู้ใช้ทราบล่วงหน้าและไม่รู้สึกถูกตัดใช้งานกะทันหัน |

## 11. ประเด็นที่ยังต้องตัดสินใจเพิ่มเติม

ไม่มีประเด็นค้างแล้ว — Requirement พร้อมส่งต่อให้ทีม Dev เริ่มพัฒนาได้
