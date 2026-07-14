# AI Reading & Learning Hub

ระบบ AI Reading & Learning Hub — เครื่องมือจัดการความรู้ส่วนบุคคล ช่วยแก้ปัญหา "ซื้อหนังสือเยอะ อ่านไม่จบ ไม่รู้ว่าเรียนอะไรไปแล้ว และนำความรู้เก่ากลับมาใช้ไม่ได้"

## โครงสร้างเอกสาร

| ไฟล์ | คำอธิบาย |
|---|---|
| [`docs/00-Lean-PoC-Scope.md`](docs/00-Lean-PoC-Scope.md) | ขอบเขต Feature ของเฟส Proof of Concept |
| [`docs/01-Requirement.md`](docs/01-Requirement.md) | Requirement ฉบับเต็ม (Business Model, Pricing, Team, Budget) |
| [`docs/02-Business-Flow.md`](docs/02-Business-Flow.md) | Business Flow และ Use Case แยกตาม Module พร้อม Flowchart |
| [`docs/03-Service-Architecture.md`](docs/03-Service-Architecture.md) | รายละเอียด Service และ Endpoint ที่ต้องพัฒนา |
| [`docs/04-System-Architecture.md`](docs/04-System-Architecture.md) | ภาพรวมสถาปัตยกรรมระบบ, Tech Stack, Security, Deployment |
| [`docs/05-Database-Design.md`](docs/05-Database-Design.md) | ER Diagram และคำอธิบายโครงสร้างฐานข้อมูล |
| [`db/initial-db.sql`](db/initial-db.sql) | SQL สร้างฐานข้อมูลเริ่มต้น (ทดสอบรันแล้วบน PostgreSQL 16) |
| [`api/openapi.yaml`](api/openapi.yaml) | OpenAPI 3.0 (Swagger) Specification ของ Backend API |

## Tech Stack สรุป
Web App + Node.js/TypeScript Backend + Supabase (Auth/DB/Storage) + Claude API + 2C2P Payment Gateway

รายละเอียดเพิ่มเติมดูที่ `docs/04-System-Architecture.md`
