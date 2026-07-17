-- ============================================================================
-- QriboBook — Initial Database Schema (PoC)
-- Target: PostgreSQL 15+ on Supabase
-- ============================================================================
-- หมายเหตุ: รันไฟล์นี้ผ่าน Supabase SQL Editor หรือ `supabase db push`
-- ตาราง auth.users มีอยู่แล้วจาก Supabase Auth — ไม่ต้องสร้างเอง
-- ============================================================================

create extension if not exists "pgcrypto";   -- สำหรับ gen_random_uuid()
create extension if not exists "pg_trgm";    -- เผื่อใช้ fuzzy search เพิ่มเติมในอนาคต

-- ============================================================================
-- Helper Function: อัปเดต updated_at อัตโนมัติ
-- ============================================================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ============================================================================
-- Table: content
-- ============================================================================
create table content (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('pdf', 'epub', 'article')),
  title text not null default 'Untitled',
  source_url text,
  storage_path text,
  extracted_text text,
  status text not null default 'pending_summary' check (status in ('pending_summary', 'summarized')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Full-text search column (ภาษาไทย/อังกฤษ — ใช้ 'simple' config เพื่อรองรับหลายภาษาโดยไม่พึ่ง dictionary เฉพาะภาษา)
  search_vector tsvector generated always as (
    to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(extracted_text, ''))
  ) stored
);

create index idx_content_user_id on content(user_id);
create index idx_content_status on content(status);
create index idx_content_search_vector on content using gin(search_vector);

create trigger trg_content_updated_at
  before update on content
  for each row execute function set_updated_at();

-- ============================================================================
-- Table: ai_summaries
-- ============================================================================
create table ai_summaries (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null unique references content(id) on delete cascade,
  executive_summary text not null,
  key_takeaways jsonb not null default '[]'::jsonb,
  generated_at timestamptz not null default now()
);

create index idx_ai_summaries_content_id on ai_summaries(content_id);

-- ============================================================================
-- Table: ai_summary_usage — นับโควตา Fair-use รายเดือน
-- ============================================================================
create table ai_summary_usage (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  period_month date not null,  -- เก็บเป็นวันที่ 1 ของเดือน เช่น 2026-07-01
  count integer not null default 0,
  updated_at timestamptz not null default now(),
  unique (user_id, period_month)
);

create index idx_ai_summary_usage_user_period on ai_summary_usage(user_id, period_month);

create trigger trg_ai_summary_usage_updated_at
  before update on ai_summary_usage
  for each row execute function set_updated_at();

-- ============================================================================
-- Table: highlights
-- ============================================================================
create table highlights (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null references content(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  text text not null,
  "position" text not null,
  created_at timestamptz not null default now(),
  search_vector tsvector generated always as (to_tsvector('simple', coalesce(text, ''))) stored
);

create index idx_highlights_content_id on highlights(content_id);
create index idx_highlights_user_id on highlights(user_id);
create index idx_highlights_search_vector on highlights using gin(search_vector);

-- ============================================================================
-- Table: notes
-- ============================================================================
create table notes (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null references content(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  text text not null,
  "position" text not null,
  created_at timestamptz not null default now(),
  search_vector tsvector generated always as (to_tsvector('simple', coalesce(text, ''))) stored
);

create index idx_notes_content_id on notes(content_id);
create index idx_notes_user_id on notes(user_id);
create index idx_notes_search_vector on notes using gin(search_vector);

-- ============================================================================
-- Table: progress
-- ============================================================================
create table progress (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null unique references content(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  percent_complete numeric(5,2) not null default 0 check (percent_complete >= 0 and percent_complete <= 100),
  last_position text,
  updated_at timestamptz not null default now()
);

create index idx_progress_user_id on progress(user_id);

create trigger trg_progress_updated_at
  before update on progress
  for each row execute function set_updated_at();

-- ============================================================================
-- Table: goals
-- ============================================================================
create table goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  target_count integer not null check (target_count > 0),
  period text not null default 'monthly' check (period in ('monthly')),
  period_start date not null default date_trunc('month', now())::date,
  progress_count integer not null default 0,
  created_at timestamptz not null default now()
);

create index idx_goals_user_id on goals(user_id);

-- ============================================================================
-- Table: reading_streaks
-- ============================================================================
create table reading_streaks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  current_streak integer not null default 0,
  longest_streak integer not null default 0,
  last_active_date date,
  updated_at timestamptz not null default now()
);

create trigger trg_reading_streaks_updated_at
  before update on reading_streaks
  for each row execute function set_updated_at();

-- ============================================================================
-- Table: subscriptions — Tier เดียว + Free Trial 7 วัน
-- ============================================================================
create table subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  status text not null default 'trial' check (status in ('trial', 'active', 'expired', 'cancelled')),
  plan text check (plan in ('monthly', 'yearly')),
  trial_ends_at timestamptz not null default (now() + interval '7 days'),
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_subscriptions_user_id on subscriptions(user_id);
create index idx_subscriptions_status on subscriptions(status);

create trigger trg_subscriptions_updated_at
  before update on subscriptions
  for each row execute function set_updated_at();

-- ============================================================================
-- Table: billing_transactions — บันทึกทุกธุรกรรมจาก 2C2P
-- ============================================================================
create table billing_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  order_id text not null unique,
  amount numeric(10,2) not null,
  currency text not null default 'THB',
  status text not null default 'pending' check (status in ('pending', 'success', 'failed')),
  provider text not null default '2c2p',
  provider_payload jsonb,
  created_at timestamptz not null default now()
);

create index idx_billing_transactions_user_id on billing_transactions(user_id);
create index idx_billing_transactions_order_id on billing_transactions(order_id);

-- ============================================================================
-- Table: notification_log
-- ============================================================================
create table notification_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('reminder', 'trial_expiry', 'quota_warning')),
  sent_at timestamptz not null default now()
);

create index idx_notification_log_user_id on notification_log(user_id);

-- ============================================================================
-- Table: event_log — บันทึกเหตุการณ์สำคัญของระบบ (ใช้ติดตาม KPI และพฤติกรรมผู้ใช้)
-- ============================================================================
create table event_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,  -- nullable: บาง event เป็นของระบบ ไม่ผูกกับผู้ใช้
  event_type text not null,
  -- ตัวอย่างค่า event_type ที่ใช้ในระบบ:
  -- 'content_uploaded', 'ai_summary_generated', 'ai_summary_failed',
  -- 'quota_warning_triggered', 'quota_cap_reached', 'highlight_created', 'note_created',
  -- 'goal_created', 'search_performed', 'trial_started', 'trial_expired',
  -- 'subscription_started', 'subscription_cancelled', 'payment_success', 'payment_failed'
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index idx_event_log_user_id on event_log(user_id);
create index idx_event_log_event_type on event_log(event_type);
create index idx_event_log_created_at on event_log(created_at);

-- ============================================================================
-- Table: error_log — บันทึก Error ของระบบเพื่อ Debug และติดตามความเสถียร
-- ============================================================================
create table error_log (
  id uuid primary key default gen_random_uuid(),
  service_name text not null,
  -- ตัวอย่างค่า service_name: 'content-service', 'ai-summary-service',
  -- 'annotation-service', 'progress-service', 'notification-service', 'billing-service'
  error_level text not null default 'error' check (error_level in ('info', 'warning', 'error', 'critical')),
  error_message text not null,
  stack_trace text,
  request_context jsonb,  -- เช่น {"endpoint": "/ai/summarize", "method": "POST", "content_id": "..."}
  user_id uuid references auth.users(id) on delete set null,
  occurred_at timestamptz not null default now(),
  resolved boolean not null default false,
  resolved_at timestamptz
);

create index idx_error_log_service_name on error_log(service_name);
create index idx_error_log_error_level on error_log(error_level);
create index idx_error_log_occurred_at on error_log(occurred_at);
create index idx_error_log_resolved on error_log(resolved);

-- ============================================================================
-- Trigger: สร้าง subscription (status = trial) อัตโนมัติเมื่อมีผู้ใช้สมัครใหม่
-- ============================================================================
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into public.subscriptions (user_id, status, trial_ends_at)
  values (new.id, 'trial', now() + interval '7 days');

  insert into public.reading_streaks (user_id)
  values (new.id);

  return new;
end;
$$ language plpgsql security definer;

create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

-- ============================================================================
-- Row Level Security (RLS)
-- ============================================================================

alter table content enable row level security;
alter table ai_summaries enable row level security;
alter table ai_summary_usage enable row level security;
alter table highlights enable row level security;
alter table notes enable row level security;
alter table progress enable row level security;
alter table goals enable row level security;
alter table reading_streaks enable row level security;
alter table subscriptions enable row level security;
alter table billing_transactions enable row level security;
alter table notification_log enable row level security;
alter table event_log enable row level security;
alter table error_log enable row level security;

-- content: เข้าถึงได้เฉพาะเจ้าของ
create policy "content_owner_all" on content
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ai_summaries: ตรวจสอบสิทธิ์ผ่าน content.user_id (join)
create policy "ai_summaries_owner_select" on ai_summaries
  for select using (
    exists (select 1 from content c where c.id = ai_summaries.content_id and c.user_id = auth.uid())
  );
create policy "ai_summaries_owner_insert" on ai_summaries
  for insert with check (
    exists (select 1 from content c where c.id = ai_summaries.content_id and c.user_id = auth.uid())
  );

-- ai_summary_usage: เข้าถึงได้เฉพาะเจ้าของ
create policy "ai_summary_usage_owner_all" on ai_summary_usage
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- highlights: เข้าถึงได้เฉพาะเจ้าของ
create policy "highlights_owner_all" on highlights
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- notes: เข้าถึงได้เฉพาะเจ้าของ
create policy "notes_owner_all" on notes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- progress: เข้าถึงได้เฉพาะเจ้าของ
create policy "progress_owner_all" on progress
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- goals: เข้าถึงได้เฉพาะเจ้าของ
create policy "goals_owner_all" on goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- reading_streaks: เข้าถึงได้เฉพาะเจ้าของ (read-only จากฝั่ง client แนะนำให้เขียนผ่าน backend เท่านั้น)
create policy "reading_streaks_owner_select" on reading_streaks
  for select using (auth.uid() = user_id);

-- subscriptions: เข้าถึงได้เฉพาะเจ้าของ (read-only จากฝั่ง client — เขียนผ่าน Service Role เท่านั้น)
create policy "subscriptions_owner_select" on subscriptions
  for select using (auth.uid() = user_id);

-- billing_transactions: เข้าถึงได้เฉพาะเจ้าของ (read-only จากฝั่ง client — เขียนผ่าน Service Role/Webhook เท่านั้น)
create policy "billing_transactions_owner_select" on billing_transactions
  for select using (auth.uid() = user_id);

-- notification_log: เข้าถึงได้เฉพาะเจ้าของ (read-only)
create policy "notification_log_owner_select" on notification_log
  for select using (auth.uid() = user_id);

-- event_log และ error_log: ไม่เปิด Policy ให้ Client เข้าถึงเลยโดยเจตนา
-- ทั้งสองตารางนี้เขียน/อ่านได้เฉพาะผ่าน Backend ด้วย Service Role Key เท่านั้น
-- (Service Role Key Bypass RLS โดยอัตโนมัติ ไม่ต้องสร้าง Policy เพิ่ม)
-- ทีมงานดูข้อมูลผ่าน Supabase Studio ซึ่ง Connect ด้วยสิทธิ์ Superuser อยู่แล้ว

-- หมายเหตุ: ตาราง subscriptions, billing_transactions, reading_streaks, ai_summary_usage
-- ที่ต้องเขียนจาก Backend (เช่น ตอนรับ Webhook จาก 2C2P หรือคำนวณ Streak)
-- ให้ Backend ใช้ Supabase Service Role Key ซึ่ง Bypass RLS ได้ ไม่ต้องเปิด insert/update policy ให้ client โดยตรง

-- ============================================================================
-- จบ Initial Schema
-- ============================================================================
