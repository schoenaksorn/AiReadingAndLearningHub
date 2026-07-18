# QriboRead — Requirement & Scope Summary (v2)

## 1. Pain Point ที่ต้องแก้
- ซื้อหนังสือเยอะ แต่ไม่ได้อ่าน
- อ่านไม่จบ กลางคันหาย
- ไม่รู้ว่าตัวเองเรียนรู้อะไรไปแล้วบ้าง
- ไม่สามารถดึงความรู้เก่ากลับมาใช้งานจริง

## 2. Product Positioning (อัปเดต)

> **"ทุกความรู้มาอยู่ที่เดียว"** — Kindle + Physical Book + PDF + YouTube + Article + Course → AI Learning Hub

แอปวางตัวเป็น **เครื่องมือจัดการความรู้ส่วนบุคคล (Personal Knowledge Management Tool)** ไม่ใช่ผู้เผยแพร่/จัดจำหน่ายเนื้อหาที่มีลิขสิทธิ์ ซึ่งช่วยลดความเสี่ยงด้านกฎหมายเมื่อเทียบกับโมเดลที่เก็บและเผยแพร่เนื้อหาเต็มรูปแบบ

**นโยบายการใช้งานที่ต้องมี (Terms of Use):**
- ผู้ใช้อัปโหลด/บันทึกได้เฉพาะเนื้อหาที่ตนมีสิทธิ์ใช้งาน
- ไม่อนุญาตให้แชร์ไฟล์หรือข้อความเต็มให้ผู้อื่นผ่านแพลตฟอร์ม
- มีกระบวนการรับคำขอลบข้อมูล (Takedown request) จากเจ้าของลิขสิทธิ์
- ปฏิบัติตามกฎหมายลิขสิทธิ์ของประเทศที่ให้บริการ

## 3. แหล่งข้อมูล (Content Sources) และวิธีนำเข้าระบบ

| แหล่งข้อมูล | วิธีนำเข้า | ระดับการสรุปด้วย AI | สถานะ |
|---|---|---|---|
| PDF / EPUB | อัปโหลดไฟล์โดยตรง | สรุปจากเนื้อหาเต็ม (Full-text Summary) | MVP |
| Article (บทความเว็บ) | วางลิงก์ (Paste URL) → ระบบดึงเนื้อหาเว็บ | สรุปจากเนื้อหาเต็ม | MVP |
| YouTube | วางลิงก์ → ดึง Transcript/คำบรรยายอัตโนมัติ | สรุปจาก Transcript ด้วย AI | MVP |
| Physical Book (หนังสือกระดาษ) | Scan ISBN (Barcode) → ดึง Metadata (ชื่อ/ผู้แต่ง/ปก) จาก ISBN API → Save เข้าคลัง | **ไม่มี Full Summary** — AI สรุปได้เฉพาะจาก Highlight/Note ที่ผู้ใช้พิมพ์เอง | MVP |
| Course (คอร์สออนไลน์) | วางลิงก์คอร์ส (Paste URL) → ดึง Metadata พื้นฐาน → Save เข้าคลัง | **ไม่มี Full Summary** — AI สรุปได้เฉพาะจาก Note ที่ผู้ใช้พิมพ์เองระหว่างเรียน | MVP |
| Kindle | — | — | **ยังไม่รองรับในเฟสนี้** (Backlog) |

**หมายเหตุสำคัญ:** Physical Book และ Course เป็นแหล่งข้อมูลที่ระบบ "ดึงเนื้อหาเต็ม" มาสรุปเองไม่ได้ (ไม่มี OCR / ไม่ผูก API แพลตฟอร์มคอร์สในเฟสนี้) ดังนั้น AI Summary ของ 2 แหล่งนี้จะทำงานบนพื้นฐาน Note ที่ผู้ใช้พิมพ์เท่านั้น — ต้องสื่อสารเรื่องนี้ให้ชัดเจนใน UX เพื่อไม่ให้ผู้ใช้คาดหวังผิด (เช่น ข้อความแจ้งเตือนว่า "จดบันทึกระหว่างอ่าน/เรียน เพื่อให้ AI ช่วยสรุปได้")

## 4. Scope of Function (แบ่งตามโมดูล)

### Module 1: Content Management (จัดการเนื้อหา — Multi-source)
- F1.1 อัปโหลดไฟล์ดิจิทัล (PDF, EPUB)
- F1.2 เพิ่มบทความจากลิงก์เว็บ (Web scraping)
- F1.3 เพิ่มวิดีโอจากลิงก์ YouTube + ดึง Transcript อัตโนมัติ
- F1.4 เพิ่มหนังสือกระดาษ: Scan ISBN Barcode → เรียก ISBN Lookup API → ดึง Metadata → บันทึก
- F1.5 เพิ่มคอร์สออนไลน์จากลิงก์ (Paste URL) → ดึง Metadata พื้นฐาน (ชื่อ/แพลตฟอร์ม) → บันทึก
- F1.6 คลังความรู้กลาง (Unified Library) แสดงทุกแหล่งข้อมูลในที่เดียว พร้อมไอคอนแยกประเภท
- F1.7 จัดหมวดหมู่/แท็กเนื้อหาข้ามแหล่งข้อมูล
- F1.8 (Backlog) เชื่อมต่อ Kindle

### Module 2: AI Summarization
> **เป้าหมายของฟีเจอร์นี้: "ช่วยอ่านแทน"** — ผู้ใช้ต้องได้ใจความสำคัญของเนื้อหาโดยไม่ต้องอ่าน/ดู/ฟังต้นฉบับทั้งหมดด้วยตัวเอง นี่คือหลักในการออกแบบ UX และ Prompt ของ AI Summary ทุกจุด (เช่น ความยาว, โทนภาษา, และสิ่งที่ต้องสรุปให้ครบ) ไม่ใช่แค่ "ย่อข้อความ" แต่ต้องทำให้ผู้ใช้ "รู้สึกว่าอ่านจบแล้ว"
- F2.1 Full-content Summary (สำหรับ PDF, Article, YouTube) — Executive Summary + Key Takeaways/Action Items
- F2.2 Note-based Summary (สำหรับ Physical Book, Course) — AI สรุปจาก Note ที่ผู้ใช้พิมพ์เอง
- F2.3 รองรับหลายภาษา (ไทย/อังกฤษ ขยายได้)
- F2.4 ประมวลผลแบบ Background Job สำหรับไฟล์/วิดีโอขนาดใหญ่

### Module 3: Reading & Annotation
- F3.1 ตัว Reader แสดงเนื้อหาไฟล์ต้นฉบับ (สำหรับ PDF/Article/YouTube)
- F3.2 Highlight ข้อความ (เนื้อหาดิจิทัล)
- F3.3 เขียน Note ผูกกับตำแหน่งอ้างอิง (page/paragraph/timestamp anchor)
- F3.4 หน้าจดบันทึกอิสระ (Free-form Note) สำหรับ Physical Book และ Course ที่ไม่มีเนื้อหาดิจิทัลให้ผูกตำแหน่ง
- F3.5 ดูรายการ Highlight/Note ทั้งหมดของแต่ละรายการ

### Module 4: Progress Tracking & Dashboard
- F4.1 คำนวณ % ความคืบหน้าต่อรายการ (ทุกแหล่งข้อมูล)
- F4.2 Timeline/ประวัติย้อนหลังข้ามทุกแหล่งข้อมูล
- F4.3 Dashboard สรุปภาพรวม: จำนวนที่อ่าน/ดู/เรียนจบ, ชั่วโมงที่ใช้, Streak
- F4.4 ตั้งเป้าหมาย (จำนวนเล่ม/คอร์ส/วิดีโอ ต่อเดือน)
- F4.5 แจ้งเตือนเทียบเป้าหมาย (on track / behind)

### Module 5: Knowledge Retrieval (ค้นหาและดึงความรู้กลับมาใช้)
- F5.1 Keyword Search ครอบคลุมทุกแหล่งข้อมูล (เนื้อหาเต็ม + Note)
- F5.2 AI Semantic Search (ถามด้วยภาษาธรรมชาติ)
- F5.3 Knowledge Graph เชื่อมโยงหัวข้อ/แนวคิดข้ามแหล่งข้อมูล (เช่น เชื่อม Concept จากหนังสือ + คอร์ส + วิดีโอที่พูดเรื่องเดียวกัน)
- F5.4 หน้าแสดงผลลัพธ์พร้อมลิงก์กลับไปตำแหน่งต้นฉบับ/Note ที่เกี่ยวข้อง

### Module 6: Sharing & Export
- F6.1 แชร์สรุปการอ่าน/เรียนรู้ไปยัง Social Media ภายนอก
- F6.2 สร้าง Newsletter/สรุปรายสัปดาห์ ส่งทางอีเมล

### Module 7: Account & Subscription
- F7.1 สมัครสมาชิก/ลงชื่อเข้าใช้
- F7.2 ระบบ Subscription รายเดือน/รายปี + ชำระเงิน
- F7.3 จัดการโปรไฟล์และตั้งค่าบัญชี
- F7.4 การจัดการภาษาของ UI
- F7.5 ยอมรับ Terms of Use เรื่องลิขสิทธิ์เนื้อหา (ตอนสมัคร/ตอนเพิ่มเนื้อหาครั้งแรก)

### Module 8: Platform
- F8.1 Mobile App (iOS/Android) — พัฒนาก่อน
- F8.2 Web App — พัฒนาในเฟสถัดไป

## 5. ข้อเสนอแนะ MVP (เฟส 1)

**MVP (เฟส 1) ควรมี:**
- Module 1: ทุกแหล่งข้อมูล **ยกเว้น Kindle** (F1.1–F1.7)
- Module 2: ทั้งหมด (ทั้ง Full-content Summary และ Note-based Summary)
- Module 3: ทั้งหมด รวม Free-form Note (F3.4) สำหรับ Physical Book/Course
- Module 4: ทั้งหมด
- Module 5: เริ่มจาก Keyword + Semantic Search ก่อน (Knowledge Graph เลื่อนไปเฟส 2 เพราะซับซ้อนและต้นทุนสูง)
- Module 7: ทั้งหมด
- Module 8: Mobile App เท่านั้น

**เฟส 2 (ต่อยอด):**
- Knowledge Graph แบบเต็มรูปแบบ
- เชื่อมต่อ Kindle (Import My Clippings หรือ Amazon Account)
- เชื่อม API แพลตฟอร์มคอร์ส (Coursera/Udemy) เพื่อดึง Progress อัตโนมัติ
- Sharing & Export (Social share, Newsletter)
- Web App

## 6. ประเด็นที่ต้องตัดสินใจเพิ่มก่อนเริ่มพัฒนา
1. โครงสร้างราคาการสมัครสมาชิก (ราคา/ระดับสิทธิ์การใช้งาน)
2. ปริมาณ/ขนาดไฟล์สูงสุดต่อผู้ใช้ 1 คน (Storage policy)
3. เลือก ISBN Lookup API ที่จะใช้ (เช่น Google Books API, Open Library API)
4. ข้อความ UX ที่จะสื่อสารกับผู้ใช้เรื่องข้อจำกัดของ Physical Book/Course (ไม่มี Full Summary อัตโนมัติ)

---

# ส่วนเพิ่มเติม v3: Freemium Tier & Feature เพิ่มเติม

## 7. อัปเดต Business Model: Freemium

เปลี่ยนจาก "Subscription อย่างเดียว" → **Freemium (Free Tier + Paid Tier)**

**หลักการแบ่ง Tier:**
- **Free Tier** = ฟีเจอร์ที่ช่วยสร้างนิสัย (Habit-forming) และการจัดระเบียบข้อมูลพื้นฐาน — ต้นทุนต่ำ ไม่พึ่ง AI หนัก ใช้ดึงคนเข้าแอปและสร้าง Data ส่วนตัว (ยิ่งมี Data เยอะ ยิ่งอยากอัปเกรดเพื่อปลดล็อค AI)
- **Paid Tier** = ฟีเจอร์ที่พึ่งพา AI/LLM โดยตรง (มีต้นทุนต่อการใช้งานจริง) และเป็นฟีเจอร์ที่สร้างคุณค่าการเรียนรู้เชิงลึก ซึ่งเป็นจุดขายหลักของแอป

## 8. Feature Tier Mapping

| Feature | Free Tier | Paid Tier (Subscription) |
|---|---|---|
| Reading Tracker | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| Learning Tracker (Course/Video) | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| Goal Setting | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| Reading Streak | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| Highlight / Note | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| Keyword Search | ✅ ใช้ได้เต็มรูปแบบ | ✅ |
| เพิ่มเนื้อหา (PDF/Article/YouTube/Book/Course) | ✅ จำกัดจำนวน (เช่น 5 รายการ/เดือน) | ✅ ไม่จำกัด |
| AI Summary | ⚠️ จำกัดโควตา (เช่น 3 ครั้ง/เดือน) | ✅ ไม่จำกัด |
| AI Semantic Search | ❌ | ✅ |
| Knowledge Graph | ❌ | ✅ |
| AI Flashcard (สร้างอัตโนมัติจาก Note/เนื้อหา) | ❌ | ✅ |
| AI Quiz (สร้างอัตโนมัติจาก Note/เนื้อหา) | ❌ | ✅ |
| AI ถามจากหนังสือ (Chat with book) | ❌ | ✅ |
| Export Newsletter/สรุปรายสัปดาห์ | ❌ | ✅ |
| แชร์ไปยัง Social Media | ✅ | ✅ |

**เหตุผลของเส้นแบ่ง:** ฟีเจอร์ที่ต้องเรียก AI/LLM ต่อการใช้งาน 1 ครั้ง (Summary, Semantic Search, Knowledge Graph, Flashcard, Quiz, AI Chat, PDF Analysis) มีต้นทุน API โดยตรง จึงเป็นเส้นแบ่งที่สมเหตุสมผลทั้งเชิงธุรกิจ (ควบคุมต้นทุน) และเชิงคุณค่า (ผู้ใช้เห็นความแตกต่างชัดเจนว่าเสียเงินแล้วได้อะไรเพิ่ม)

## 9. Module เพิ่มเติมจาก Feature ใหม่

### Module 9: Flashcard & Quiz (Paid)
- F9.1 สร้าง Flashcard อัตโนมัติจาก Highlight/Note/เนื้อหาที่สรุปแล้ว
- F9.2 ระบบทบทวน Flashcard แบบ Spaced Repetition
- F9.3 สร้าง Quiz อัตโนมัติ (Multiple choice/True-False) จากเนื้อหาที่สรุปแล้ว
- F9.4 บันทึกคะแนน/ประวัติการทำ Quiz

### Module 10: AI Chat with Book (Paid)
- F10.1 ถาม-ตอบกับ AI โดยอ้างอิงเฉพาะเนื้อหาที่ผู้ใช้เคยเพิ่มเข้าระบบ (RAG บนคลังความรู้ส่วนตัว)
- F10.2 อ้างอิงแหล่งที่มา/ตำแหน่งในเนื้อหาต้นฉบับทุกคำตอบ
- F10.3 ประวัติการสนทนาเพื่อย้อนดูภายหลัง

> **Module 11 (PDF วิเคราะห์เชิงลึก) — ตัดออกจาก Scope แล้ว** ไม่รวมอยู่ในแผนพัฒนาปัจจุบัน

## 10. อัปเดต MVP ที่แนะนำ

เนื่องจากตอนนี้เป็น Freemium ต้องมีทั้ง Free และ Paid Feature ให้เห็นความแตกต่างตั้งแต่เปิดตัว **MVP ควรมีอย่างน้อย 1 ฟีเจอร์ Paid ที่เป็นจุดขายชัดเจน** แนะนำ:

- **Free scope**: Module 1 (จำกัดโควตา), Module 3, Module 4, Module 7, Module 8 (Mobile)
- **Paid scope ที่ควรมีตั้งแต่ MVP**: Module 2 (AI Summary แบบไม่จำกัด), Module 10 (AI Chat with Book) — เพราะเป็นจุดขายหลักที่ทำให้เห็นคุณค่าเทียบราคาสมัครสมาชิกชัดเจนที่สุด
- **เลื่อนไปเฟส 2**: Module 9 (Flashcard/Quiz), Knowledge Graph, Kindle, Course API integration, Web App
- **ตัดออกจาก Scope**: Module 11 (PDF วิเคราะห์เชิงลึก)

---

# ส่วนเพิ่มเติม v4: Non-Functional Requirements & Admin

## 11. สรุปคำตอบเพิ่มเติมจากการสัมภาษณ์รอบ 4

| หัวข้อ | ผลสรุป |
|---|---|
| Free Trial | ไม่มี Trial — ให้ผู้ใช้ทดลองผ่าน Free Tier ก่อนตัดสินใจสมัคร Paid |
| ช่องทางแจ้งเตือน (Reminder) | Push Notification บนมือถือเท่านั้น |
| Offline Support | ใช้งาน UI หลัก/ดูเนื้อหาที่เคยโหลดได้แบบ Offline ได้ แต่ AI Feature ทุกอย่างต้องใช้ Internet เสมอ |
| Data Export | **อยู่ใน MVP** — ผู้ใช้ Export ข้อมูล/ความรู้ของตัวเองออกจากระบบได้ (ปรับจากเดิมที่จะเลื่อนไปเฟส 2)
| Admin/Back-office | ต้องมีตั้งแต่ MVP — จัดการผู้ใช้, ตรวจสอบ Subscription, ดู Usage Log |
| Multi-device Sync | ไม่ต้องมี Feature Multi-device เต็มรูปแบบใน MVP — 1 User ใช้ได้ 1 เครื่องเป็นหลัก |
| Cloud Backup (เบื้องหลัง) | **เพิ่มเข้า MVP** — สำรอง Note/Highlight/Progress ขึ้น Cloud แบบเงียบๆ อัตโนมัติ เพื่อกันข้อมูลสูญหาย (ยังไม่เปิดให้ผู้ใช้สลับเครื่องแล้วเห็นข้อมูลได้เองแบบ Real-time) |

> ✅ **อัปเดต:** ความเสี่ยงข้อมูลสูญหายด้านบนได้รับการแก้ไขแล้วด้วยการเพิ่ม **Cloud Backup แบบเบื้องหลัง** (ดู Module 13 ด้านล่าง) — ข้อมูลจะถูกสำรองขึ้น Cloud อัตโนมัติ แม้จะยังไม่เปิดฟีเจอร์ Multi-device Sync แบบเต็มรูปแบบให้ผู้ใช้สลับเครื่องแล้วเห็นข้อมูล Real-time ก็ตาม ผู้ใช้ที่ทำเครื่องหาย/ลบแอป จะสามารถกู้คืนข้อมูลได้เมื่อติดตั้งแอปใหม่และ Login ด้วยบัญชีเดิม

## 12.5 Module 13: Data Export & Cloud Backup (MVP)
- F13.1 Export Note/Highlight/Progress ของตัวเองออกจากระบบ (รูปแบบไฟล์ เช่น Markdown/CSV/PDF)
- F13.2 สำรองข้อมูล Note/Highlight/Progress ขึ้น Cloud อัตโนมัติแบบเบื้องหลัง (ไม่ต้องมี UI ให้ผู้ใช้จัดการ Sync เอง)
- F13.3 กู้คืนข้อมูลจาก Cloud Backup เมื่อผู้ใช้ Login บนเครื่องใหม่ (Restore-on-login) — ยังไม่ใช่ Real-time Multi-device Sync

## 12. Module 12: Admin / Back-office (MVP)
- F12.1 จัดการบัญชีผู้ใช้ (ดู/ระงับ/ลบบัญชี)
- F12.2 ตรวจสอบสถานะ Subscription ของผู้ใช้แต่ละราย (Active/Expired/Cancelled)
- F12.3 ดู Usage Log (การเรียกใช้ AI Feature, ปริมาณการใช้งานต่อผู้ใช้ — ใช้ตรวจสอบโควตา Free Tier ด้วย)
- F12.4 Dashboard ภาพรวมระบบ (จำนวนผู้ใช้ทั้งหมด, Free vs Paid, Revenue คร่าวๆ)

## 13. Non-Functional Requirements สรุป
- **Reliability**: AI Feature ต้องมีระบบแจ้งผู้ใช้ชัดเจนเมื่อไม่มี Internet (Feature ใช้ไม่ได้)
- **Data Retention**: เนื่องจากไม่มี Cloud Sync ใน MVP ต้องมีนโยบายเตือนผู้ใช้เรื่องความเสี่ยงข้อมูลสูญหายให้ชัดเจนตั้งแต่ Onboarding
- **Notification**: ต้องขอ Permission แจ้งเตือนตั้งแต่ Onboarding

## 14. อัปเดต MVP Scope สุดท้าย
เพิ่มเข้า MVP: Module 12 (Admin/Back-office), Module 13 (Data Export & Cloud Backup แบบเบื้องหลัง), Push Notification (ส่วนหนึ่งของ Module 4), Offline mode สำหรับ UI/เนื้อหาที่โหลดแล้ว
เลื่อนไปเฟส 2: Multi-device Sync แบบ Real-time เต็มรูปแบบ, Web App, Flashcard/Quiz, Knowledge Graph, Kindle, Course API Integration

---

# ส่วนเพิ่มเติม v5: ประเมินทีมงานและงบประมาณ (MVP)

**สมมติฐาน:** ทีม Full-time ในไทย (Bangkok market rate), ระยะเวลา MVP ~6 เดือน, ใช้ Cross-platform Framework (Flutter/React Native) เพื่อไม่ต้องแยกทีม iOS/Android

## 15. ทีมงานที่แนะนำ (MVP)

| ตำแหน่ง | จำนวน | เงินเดือน/คน (THB) | รวม/เดือน (THB) | เหตุผล |
|---|---|---|---|---|
| Product Manager / BA | 1 | 70,000–90,000 | 80,000 | ดูแล Scope, Priority, ประสาน AI/Backend/Mobile |
| UI/UX Designer | 1 | 50,000–65,000 | 55,000 | ออกแบบ Reader, Dashboard, Admin |
| Mobile Developer (Flutter/RN) | 2 | 65,000–90,000 | 150,000 | ครอบคลุมทั้ง iOS/Android ด้วย 1 codebase |
| Backend Developer | 2 | 65,000–90,000 | 150,000 | Content ingestion pipeline, Subscription/Payment, Admin API, Cloud Backup |
| AI/ML Engineer | 1 | 80,000–120,000 | 95,000 | RAG (AI Chat), Embedding/Semantic Search, Prompt Engineering สำหรับ Summary |
| QA Engineer | 1 | 40,000–55,000 | 45,000 | ทดสอบ Multi-source ingestion + AI Feature ที่ผลลัพธ์ไม่ตายตัว |
| DevOps (Part-time ~50%) | 1 | 70,000–90,000 | 40,000 | Cloud infra, CI/CD, Cloud Backup pipeline |
| **รวมทีม/เดือน** | **9 คน** | | **≈ 615,000 THB/เดือน** | |

**ค่าทีมงานรวม 6 เดือน ≈ 3,690,000 THB**

> หมายเหตุ: ตัวเลขนี้เป็นค่าจ้างต่อเดือนแบบตรงไปตรงมา ยังไม่รวม Employer Cost เพิ่มเติม (ประกันสังคม, สวัสดิการ) ซึ่งปกติบวกเพิ่มอีก ~15–20%

## 16. ค่าใช้จ่ายอื่นนอกเหนือจากทีมงาน (6 เดือนแรก)

| รายการ | ประมาณการ (THB) | หมายเหตุ |
|---|---|---|
| Cloud Infrastructure (Hosting, Database, Storage) | 180,000–300,000 | ขึ้นกับปริมาณไฟล์ผู้ใช้ทดสอบ + Cloud Backup |
| LLM API cost (ช่วงพัฒนา/ทดสอบ) | 120,000–300,000 | AI Summary, AI Chat, Semantic Search — ยังไม่รวมต้นทุนหลัง Launch ที่ผูกกับจำนวนผู้ใช้จริง |
| Third-party API อื่นๆ (ISBN Lookup, YouTube Transcript, Push Notification Service) | 40,000–60,000 | ส่วนใหญ่มี Free Tier ช่วงทดสอบ |
| App Store / Play Store Developer Account | ~5,000 | Apple ~$99/ปี, Google $25 ครั้งเดียว |
| Payment Gateway Setup (สำหรับ Subscription) | 20,000–50,000 | ค่าธรรมเนียมตั้งค่า + Transaction fee ต่อเนื่อง |
| Design/Dev Tools & Licenses | 15,000–30,000 | Figma, Testing tools ฯลฯ |
| **รวมค่าใช้จ่ายอื่น** | **≈ 380,000–745,000 THB** | |

## 17. สรุปงบประมาณรวม MVP (6 เดือน)

| รายการ | ประมาณการ (THB) |
|---|---|
| ค่าทีมงาน | 3,690,000 |
| ค่าใช้จ่ายอื่น (Infra/API/Tools) | 380,000–745,000 |
| **รวมโดยประมาณ** | **≈ 4,070,000–4,435,000 THB** |

## 18. ทางเลือกแบบประหยัดกว่า (Lean Option)

หากงบจำกัด สามารถลดทีมเหลือ ~6 คน (ตัด QA เต็มเวลาออก ให้ Dev ทดสอบเอง + PM ทำหน้าที่ QA บางส่วน, ใช้ DevOps แบบ Freelance/Managed Service แทนการจ้างประจำ) จะลดค่าทีมงานเหลือประมาณ **420,000–450,000 THB/เดือน** แต่ระยะเวลาพัฒนาอาจยืดเป็น 7–8 เดือนแทนเพื่อชดเชยกำลังคนที่ลดลง งบรวมท้ายที่สุดใกล้เคียงกันแต่กระจายเป็นระยะเวลานานกว่า

## 19. ความเสี่ยงด้านงบประมาณที่ควรระวัง
- **ต้นทุน LLM API หลัง Launch จริง** เป็นตัวแปรที่ควบคุมยากที่สุด เพราะผูกกับจำนวนผู้ใช้ Free Tier ที่เรียก AI Summary — แนะนำให้คำนวณ Unit Economics ก่อนเปิดตัวจริง (ตามที่เคยเสนอไว้ก่อนหน้านี้)
- **AI/ML Engineer หายาก** ในตลาดไทย ราคาที่ประเมินไว้อาจต้องปรับเพิ่มหากต้องการคนที่มีประสบการณ์ RAG/Production LLM โดยตรง

---

# ส่วนเพิ่มเติม v6: Unit Economics — Free Tier vs Paid Tier

**สมมติฐานต้นทุน AI ต่อการเรียกใช้ 1 ครั้ง** (อิง Rate การ์ดกลางของ LLM API ปัจจุบัน ~$3/ล้าน input token, ~$15/ล้าน output token, อัตราแลกเปลี่ยน ~35 บาท/USD):

| Action | Input โดยประมาณ | Output โดยประมาณ | ต้นทุนโดยประมาณ/ครั้ง (THB) |
|---|---|---|---|
| AI Summary (1 เล่ม/บทความ/วิดีโอ) | ~15,000 tokens | ~800 tokens | **≈ 2.0 บาท** |
| AI Chat with Book (1 คำถาม) | ~3,500 tokens (context+คำถาม) | ~500 tokens | **≈ 0.65 บาท** |
| Semantic Search (Embedding) | ต่ำมาก | – | **≈ 0.05 บาท หรือน้อยกว่า** |

## 20. คำนวณต้นทุนต่อผู้ใช้ต่อเดือน

**Free Tier** (โควตา AI Summary 3 ครั้ง/เดือน ตามที่กำหนดไว้):
- ต้นทุน AI: 3 × 2.0 = 6 บาท
- ต้นทุน Storage/Infra เฉลี่ย: ~8–10 บาท
- **รวมต้นทุน Free User ≈ 15 บาท/เดือน**

**Paid Tier** (สมมติผู้ใช้จริงเรียก AI Summary เฉลี่ย 20 ครั้ง/เดือน + AI Chat 30 ข้อความ/เดือน):
- ต้นทุน AI Summary: 20 × 2.0 = 40 บาท
- ต้นทุน AI Chat: 30 × 0.65 = 19.5 บาท
- ต้นทุน Storage/Infra: ~15–20 บาท
- **รวมต้นทุน Paid User ≈ 75–80 บาท/เดือน**

## 21. หาราคา Subscription ที่เหมาะสม

**ถ้าตั้งราคา 199 บาท/เดือน:** กำไรต่อ Paid User ≈ 199 − 80 = **119 บาท (Margin ~60%)** — ดีมาก แต่สมมติฐานนี้ยังไม่รวมต้นทุน Free User ที่ไม่ได้จ่ายเงินเลย

**คำนวณ Breakeven Conversion Rate** (ที่ราคา 199 บาท/เดือน):
รายได้จาก Paid ต้องครอบคลุมต้นทุนของ Free + ต้นทุนของ Paid เอง
→ ต้องการ **Conversion Rate ≥ 11%** (สัดส่วนผู้ใช้ที่จ่ายเงินต่อผู้ใช้ทั้งหมด) ระบบถึงจะ Breakeven เฉพาะในส่วนต้นทุน AI (ยังไม่รวมต้นทุนทีมงาน/การตลาด)

**ประเด็นสำคัญ:** Freemium App ทั่วไปมี Conversion Rate เฉลี่ยเพียง **2–5%** เท่านั้น ถ้า Conversion จริงอยู่ที่ 5% ราคา 199 บาท/เดือน **จะขาดทุนในส่วนต้นทุน AI** (ต้องขึ้นราคาเป็นราว 350–400 บาท/เดือนถึงจะ Breakeven ที่ Conversion 5%)

## 22. ข้อเสนอแนะเพื่อให้ Unit Economics คุ้มทุนจริง

1. **ราคาที่แนะนำ:** ตั้งราคาในช่วง **149–249 บาท/เดือน** และตั้งเป้า Conversion Rate อย่างน้อย 8–10% (สูงกว่าค่าเฉลี่ย Freemium ทั่วไป เพราะแอปนี้มี Data Lock-in สูง — ผู้ใช้สะสม Highlight/Note/Library ไว้เยอะ จะรู้สึกเสียดายถ้าเลิกใช้)
2. **Cache ผลลัพธ์ AI Summary ของเนื้อหายอดนิยม** — ถ้าหนังสือ/บทความเดียวกันถูกอัปโหลดโดยผู้ใช้หลายคน ควรสรุปครั้งเดียวแล้ว Cache ไว้ใช้ซ้ำ แทนที่จะเรียก AI ใหม่ทุกครั้ง จะลดต้นทุนได้มากในระยะยาวโดยเฉพาะหนังสือ Bestseller
3. **จำกัดโควตา "Unlimited" ของ Paid Tier ด้วย Fair-use Policy** (เช่น Soft cap ที่ 50 ครั้ง/เดือน แล้วค่อยชะลอ) เพื่อป้องกัน Heavy User ทำให้ต้นทุนบานปลาย
4. **ติดตาม Conversion Rate จริงตั้งแต่ MVP ผ่าน Admin Dashboard (Module 12)** เพื่อปรับราคา/โควตาให้ทันท่วงทีหากตัวเลขจริงต่ำกว่าเป้า

> ⚠️ ตัวเลขทั้งหมดในส่วนนี้เป็นการประมาณการเพื่อวางกรอบตัดสินใจเท่านั้น ราคา LLM API จริงและพฤติกรรมผู้ใช้จริงอาจแตกต่างจากสมมติฐาน แนะนำให้ทำ Cost Monitoring ตั้งแต่ MVP Launch เพื่อปรับราคา/โควตาให้แม่นยำขึ้นตามข้อมูลจริง

---

# ส่วนเพิ่มเติม v7: Lean PoC (Proof of Concept) — งบประมาณจำกัด

## 23. สิ่งที่เก็บไว้ vs ตัดออก สำหรับ PoC

| Feature | PoC (เก็บ) | เหตุผล |
|---|---|---|
| อัปโหลด PDF/EPUB | ✅ | แหล่งเนื้อหาหลัก ทดสอบ Core Value ได้เร็วสุด |
| เพิ่มบทความจากลิงก์ | ✅ | ต้นทุนพัฒนาต่ำ เพิ่ม Use case ได้ไว |
| YouTube / Physical Book / Course | ❌ ตัดออก | เพิ่ม Complexity สูง แต่ยังไม่จำเป็นต่อการพิสูจน์ไอเดียหลัก |
| AI Summary (Executive + Key Takeaways) | ✅ | **นี่คือ Core Value ที่ต้องพิสูจน์ก่อนสิ่งอื่นทั้งหมด** |
| Highlight/Note | ✅ (แบบง่าย) | ต้นทุนต่ำ ตอบโจทย์ "นำความรู้กลับมาใช้" |
| Reading Tracker (%, Dashboard พื้นฐาน) | ✅ (แบบง่าย) | ตอบโจทย์ "ไม่รู้ว่าเรียนอะไรไปแล้ว" |
| Goal / Streak | ✅ | ต้นทุนพัฒนาต่ำมาก แต่ช่วยเรื่อง Engagement |
| Keyword Search | ✅ | ใช้ Search พื้นฐานของ Database ได้เลย ไม่ต้องสร้าง AI Search |
| AI Semantic Search / Knowledge Graph | ❌ ตัดออก | ต้นทุน Dev สูง (ต้อง Vector DB + Embedding pipeline) |
| AI Chat with Book (RAG) | ❌ ตัดออก | ต้นทุนสูงสุดทั้งด้าน Dev (ต้องการ AI/ML Engineer) และ API Cost ต่อการใช้งาน |
| Flashcard / Quiz | ❌ ตัดออก | อยู่ในแผนเฟสหลังอยู่แล้ว |
| Admin Dashboard (UI เต็มรูปแบบ) | ❌ ใช้ Dashboard สำเร็จรูปของ Backend Platform แทน (เช่น Supabase Studio) | ไม่ต้องเขียน Admin Panel เอง |
| Cloud Backup/Data Export | ✅ (ได้ฟรีอยู่แล้วถ้าใช้ BaaS ที่เก็บข้อมูลบน Cloud ตั้งแต่ต้น) | ไม่ใช่ Feature เพิ่ม แต่เป็นผลพลอยได้จากสถาปัตยกรรม |
| Subscription | ✅ (Tier เดียว ไม่มี Freemium ซับซ้อน) | เริ่มจากราคาเดียว ไม่ต้องสร้างระบบ Quota/Tier ซับซ้อน |
| Platform | ✅ Mobile เดียว (Flutter ออกทั้ง iOS/Android จาก Codebase เดียว) | ไม่เพิ่มต้นทุนถ้าเลือก Framework ที่ถูกต้องตั้งแต่แรก |

## 24. สถาปัตยกรรมที่แนะนำ เพื่อลดต้นทุนทีม

**ใช้ Backend-as-a-Service (เช่น Supabase หรือ Firebase)** แทนการสร้าง Backend เอง:
- ได้ Database + Auth + Storage + Cloud Backup + Admin Dashboard สำเร็จรูปทันที
- ไม่ต้องจ้าง Backend Developer เต็มรูปแบบ — Full-stack Developer คนเดียวจัดการได้
- ไม่ต้องมี DevOps แยก เพราะ Platform จัดการ Infra ให้
- เรียก LLM API ตรงจาก Client/Cloud Function ง่ายๆ ด้วย Prompt พื้นฐาน — ไม่ต้องมี AI/ML Engineer เฉพาะทาง (RAG ที่ต้องใช้ AI/ML Engineer ถูกตัดออกไปแล้วในข้อ 23)

## 25. ทีมงาน PoC (แนะนำ)

| ตำแหน่ง | จำนวน | ลักษณะ | ประมาณการ |
|---|---|---|---|
| Full-stack Developer (Flutter + Supabase/Firebase + LLM API) | 1–2 | Full-time | 60,000–70,000 บาท/คน/เดือน |
| UI/UX Designer | 1 | Freelance ครั้งเดียว (ไม่ Full-time) | 30,000–50,000 บาท (เหมาจ่าย) |
| Product/BA | 1 | เจ้าของโปรเจกต์ทำเอง | 0 บาท (ไม่นับต้นทุน) |

## 26. งบประมาณ PoC โดยประมาณ (3 เดือน)

| รายการ | 1 Developer (ช้ากว่า ~4 เดือน) | 2 Developers (เร็วกว่า ~3 เดือน) |
|---|---|---|
| ค่าพัฒนา | 60,000 × 4 = 240,000 | 65,000 × 2 × 3 = 390,000 |
| UI/UX (เหมาจ่ายครั้งเดียว) | 40,000 | 40,000 |
| LLM API (ช่วงพัฒนา/ทดสอบ) | 10,000–20,000 | 10,000–20,000 |
| Infra (Supabase/Firebase Free–Starter Tier) | 0–5,000 | 0–5,000 |
| App Store/Play Store | 3,000–5,000 | 3,000–5,000 |
| **รวมโดยประมาณ** | **≈ 295,000–310,000 บาท** | **≈ 445,000–460,000 บาท** |

> ทั้งสองแบบอยู่ในงบ **ต่ำกว่า 500,000 บาท** ตามเป้าหมาย — แบบ 1 Developer ประหยัดสุดแต่ใช้เวลานานกว่า และเสี่ยงเรื่อง Developer ลาออก/ป่วยแล้วโปรเจกต์หยุดชะงัก แบบ 2 Developers เร็วกว่าและมี Backup กันเอง

## 27. เป้าหมายของ PoC และสิ่งที่ต้องวัดผล
เมื่อ PoC เปิดตัว ควรตั้ง KPI ที่ชัดเจนเพื่อตัดสินใจว่าจะลงทุนเฟสถัดไปหรือไม่ เช่น:
- อัตราการอัปโหลดเนื้อหาเฉลี่ยต่อผู้ใช้ (มีคนใช้งานจริงหรือไม่)
- อัตราการเปิดอ่าน AI Summary ที่สร้างแล้ว (Feature หลักถูกใช้จริงหรือไม่)
- อัตราการสมัคร Subscription จากผู้ใช้ที่ลองใช้ฟรี/ทดลอง (Willingness to pay)
- Retention หลัง 7 วัน / 30 วัน (คนกลับมาใช้ซ้ำหรือไม่)

ผลลัพธ์จาก KPI เหล่านี้จะเป็นข้อมูลจริงมาปรับ Scope เฟสถัดไป (กลับไปเพิ่ม AI Chat, Semantic Search, Multi-source ตามที่ออกแบบไว้ใน v1–v6) แทนการลงทุนเต็มจำนวนตั้งแต่แรกโดยไม่มีข้อมูลยืนยัน
