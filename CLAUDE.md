# CLAUDE.md

คำแนะนำสำหรับ Claude Code เมื่อทำงานในโปรเจกต์นี้ อ่านไฟล์นี้ทุกครั้งก่อนเริ่มงานในทุก Session

## ภาพรวมโปรเจกต์

**QriboRead** คือเครื่องมือจัดการความรู้ส่วนบุคคล (Personal Knowledge Management Tool) แก้ Pain Point: ซื้อหนังสือเยอะแต่ไม่ได้อ่าน, อ่านไม่จบ, ไม่รู้ว่าเรียนอะไรไปแล้ว, นำความรู้เก่ากลับมาใช้ไม่ได้

**Core Value ที่สำคัญที่สุด: "ช่วยอ่านแทน"** — ทุกการตัดสินใจเรื่อง AI Summary (ความยาว, Prompt, UX) ต้องยึดหลักนี้ ผู้ใช้ต้องรู้สึกเหมือน "อ่านจบแล้ว" ไม่ใช่แค่ได้ข้อความย่อสั้นๆ

สถานะปัจจุบัน: กำลังพัฒนาเฟส **Proof of Concept (PoC)** — งบและ Scope จำกัดโดยตั้งใจ ห้ามเพิ่ม Feature เกินกว่าที่ระบุใน `docs/01-Requirement.md` โดยไม่ถามก่อน

## เอกสารอ้างอิง (อ่านก่อนเริ่มงานทุกครั้งที่เกี่ยวข้อง)

| ต้องการรู้เรื่องอะไร | อ่านไฟล์ |
|---|---|
| Scope, Business Model, ราคา, ทีม/งบ | `docs/01-Requirement.md` |
| Flow การทำงานของแต่ละ Module + Use Case | `docs/02-Business-Flow.md` |
| Endpoint ที่ต้องสร้าง แบ่งตาม Service | `docs/03-Service-Architecture.md` |
| ภาพรวมสถาปัตยกรรม, Tech Stack, Security | `docs/04-System-Architecture.md` |
| โครงสร้างฐานข้อมูล, RLS Policy | `docs/05-Database-Design.md` |
| API Contract (Request/Response Schema) | `api/openapi.yaml` |
| SQL Schema ที่ใช้งานจริง | `db/initial-db.sql` |

**อย่าเดา Endpoint หรือ Schema เอง — อ้างอิงจากไฟล์เหล่านี้เสมอ** ถ้าสิ่งที่ต้องทำไม่มีในเอกสาร ให้ถามก่อนเขียนโค้ด

## Tech Stack

| Layer | เทคโนโลยี |
|---|---|
| Backend | **Java + Spring Boot** (Standalone Service, ไม่ใช้ Supabase Edge Functions เพราะรองรับแค่ Deno/TypeScript) |
| Database/Auth/Storage | Supabase (PostgreSQL) |
| Frontend | Web App (Responsive, รองรับ Desktop + Mobile Browser) |
| AI | Claude API (Anthropic) — ใช้สำหรับ AI Summary เท่านั้นใน PoC นี้ (ไม่มี RAG/Vector Search) |
| Payment | 2C2P |
| Full-text Search | PostgreSQL `tsvector`/GIN Index ในตัว Supabase (ไม่ใช้ Elasticsearch หรือ Search Engine แยก) |

**ไม่มี Supabase Java SDK อย่างเป็นทางการ** — เรียก Supabase ผ่าน REST API โดยตรง (ใช้ RestTemplate/WebClient) หรือ JDBC ตรงกับ PostgreSQL สำหรับ Query ที่ซับซ้อน ส่วน Auth (Sign up/Login) ทำฝั่ง Frontend ด้วย Supabase JS SDK โดยตรง ไม่ผ่าน Backend

## Business Rule สำคัญที่ห้ามลืม

- **Fair-use Soft Cap:** AI Summary จำกัด **25 ครั้ง/เดือน/ผู้ใช้** แจ้งเตือนตั้งแต่ครั้งที่ **18**
- **Free Trial:** 7 วัน นับจากสมัครสมาชิก ไม่มี Free Tier ถาวร
- **ราคา:** 179 บาท/เดือน (รายเดือน), 149 บาท/เดือน เฉลี่ย (รายปี) — Subscription Tier เดียว
- **หลัง Trial หมดและไม่สมัคร:** ผู้ใช้ยังดูข้อมูล/สรุปเดิมได้ (Read-only) แต่เพิ่มเนื้อหา/สร้าง AI Summary ใหม่ไม่ได้
- **Physical Book และ Course:** ไม่มี Full AI Summary อัตโนมัติ (ไม่มีการดึงเนื้อหาเต็ม) — AI สรุปได้เฉพาะจาก Note ที่ผู้ใช้พิมพ์เอง — **อย่าสร้าง Feature ที่พยายาม OCR หรือดึงเนื้อหาคอร์สอัตโนมัติ** เพราะไม่อยู่ใน Scope PoC

## Security ที่ต้องทำตามเคร่งครัด

- ตาราง `subscriptions`, `billing_transactions`, `reading_streaks`, `ai_summary_usage`, `event_log`, `error_log` เขียนได้เฉพาะผ่าน **Backend ด้วย Supabase Service Role Key เท่านั้น** ห้าม Client เขียนตรงเด็ดขาด (RLS ไม่อนุญาต insert/update จาก Client อยู่แล้ว แต่ต้อง Enforce ใน Backend Logic ด้วย)
- Webhook จาก 2C2P (`/billing/webhook`) **ต้องตรวจสอบ Signature ทุกครั้ง** ก่อนอัปเดตฐานข้อมูล ห้าม Trust Payload โดยไม่เช็ค
- ห้าม Hardcode API Key ใดๆ ในโค้ด ใช้ Environment Variable เท่านั้น (`.env` ต้องอยู่ใน `.gitignore`)
- ทุก Error ที่เกิดขึ้นต้องเขียนลง `error_log` พร้อม `service_name`, `error_level`, `occurred_at` — ทุก Event สำคัญที่สำเร็จให้เขียนลง `event_log` (ดู `docs/04-System-Architecture.md` หัวข้อ Logging & Observability)

## ลำดับการพัฒนาที่แนะนำ

1. Auth (ใช้ Supabase Auth SDK ฝั่ง Frontend ตรงๆ ไม่ต้องเขียน Backend Logic)
2. Content Service (Upload PDF/EPUB, Add Article via URL)
3. **AI Summary Service** — ทำให้ Demo ได้เร็วที่สุด เพราะเป็น Core Value ที่ต้องพิสูจน์ก่อน
4. Annotation Service (Highlight/Note)
5. Progress Tracking Service (Dashboard, Goal, Streak)
6. Search Service
7. Billing Service (2C2P) — ทำได้ทีหลังสุดเพราะมี Trial 7 วันเป็นบัฟเฟอร์เวลา แต่ต้องเสร็จก่อน Launch จริง
8. Notification Service — ทำคู่ขนานไปกับข้อ 5-7

รายละเอียด Endpoint ของแต่ละ Service ดูที่ `docs/03-Service-Architecture.md` และ `api/openapi.yaml`

## Coding Convention

- ใช้ Java 17+ และ Spring Boot 3.x
- โครงสร้าง Package แนะนำ: แยกตาม Service/Domain ไม่ใช่ตาม Layer (เช่น `com.qriboread.content`, `com.qriboread.aisummary`, `com.qriboread.billing` แทนที่จะแยกเป็น `controller/`, `service/`, `repository/` รวมกันทั้งโปรเจกต์)
- ทุก Endpoint ต้อง Validate Request Body ก่อนประมวลผล (ใช้ Bean Validation / `@Valid`)
- เขียน Unit Test คู่กับ Logic ที่ซับซ้อน โดยเฉพาะ Fair-use Quota Counting, Trial Expiry Logic, และ Webhook Signature Verification — จุดเหล่านี้กระทบรายได้โดยตรงถ้าผิดพลาด

## สิ่งที่ห้ามทำโดยไม่ถามก่อน

- ห้ามเพิ่ม Feature นอก Scope PoC (เช่น AI Chat with Book, Knowledge Graph, Flashcard/Quiz, Kindle Integration) แม้จะดูทำง่ายก็ตาม — Feature เหล่านี้ถูกตัดออกโดยเจตนาแล้ว ดู `docs/01-Requirement.md` หัวข้อ "Feature ที่ตัดออกจาก PoC"
- ห้ามเปลี่ยน Backend-as-a-Service จาก Supabase ไปเจ้าอื่น
- ห้ามเปลี่ยนโครงสร้างตารางใน `db/initial-db.sql` โดยไม่อัปเดต `docs/05-Database-Design.md` ให้ตรงกันด้วย
