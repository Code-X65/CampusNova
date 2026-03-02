-- =========================================================
-- CAMPUSNOVA — Phase 0 (Infrastructure) Supabase Setup
-- Tenancy + RBAC foundation + Audit + Baseline RLS
-- =========================================================

-- 0) Extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- 1) Helper function: updated_at trigger
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================================================
-- 2) System Admin Identification (Phase 0)
-- =========================================================
-- We identify "System Admin" by a whitelist table of auth user IDs.
-- You will manually insert your auth user id into this table (outside editor via dashboard/SQL).
create table if not exists public.system_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.system_admins enable row level security;

-- Only system admins can see/manage the list of system admins.
create or replace function public.is_system_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists(
    select 1 from public.system_admins sa
    where sa.user_id = auth.uid()
  );
$$;

revoke all on function public.is_system_admin() from public;
grant execute on function public.is_system_admin() to anon, authenticated;

create policy "system_admins_select_system_only"
on public.system_admins
for select
to authenticated
using (public.is_system_admin());

create policy "system_admins_write_system_only"
on public.system_admins
for all
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

-- =========================================================
-- 3) Core Tenancy Tables
-- =========================================================

-- 3.1 schools (one tenant = one school)
create table if not exists public.schools (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null,
  status text not null default 'active', -- active | suspended | archived (expand later)
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists schools_slug_unique on public.schools (slug);

create trigger trg_schools_updated_at
before update on public.schools
for each row execute function public.set_updated_at();

alter table public.schools enable row level security;

-- 3.2 profiles (app user profile linked to auth.users)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;

-- 3.3 school_memberships (user belongs to school)
create table if not exists public.school_memberships (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'active', -- invited | active | suspended
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (school_id, user_id)
);

create index if not exists school_memberships_user_id_idx on public.school_memberships (user_id);
create index if not exists school_memberships_school_id_idx on public.school_memberships (school_id);

create trigger trg_school_memberships_updated_at
before update on public.school_memberships
for each row execute function public.set_updated_at();

alter table public.school_memberships enable row level security;

-- Helper: is member of school
create or replace function public.is_school_member(p_school_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists(
    select 1
    from public.school_memberships sm
    where sm.school_id = p_school_id
      and sm.user_id = auth.uid()
      and sm.status = 'active'
  );
$$;

revoke all on function public.is_school_member(uuid) from public;
grant execute on function public.is_school_member(uuid) to anon, authenticated;

-- =========================================================
-- 4) RBAC Foundation (B2b)
-- =========================================================

-- 4.1 permissions (global registry)
create table if not exists public.permissions (
  id uuid primary key default gen_random_uuid(),
  key text not null,
  description text,
  is_protected boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists permissions_key_unique on public.permissions (key);

create trigger trg_permissions_updated_at
before update on public.permissions
for each row execute function public.set_updated_at();

alter table public.permissions enable row level security;

-- 4.2 roles (tenant roles; allow system roles with school_id null + is_system true)
create table if not exists public.roles (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete cascade, -- nullable for system roles
  name text not null,
  is_system boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint roles_system_requires_null_school check (
    (is_system = true and school_id is null) or (is_system = false and school_id is not null)
  )
);

-- unique role name per school (tenant)
create unique index if not exists roles_school_name_unique
on public.roles (school_id, lower(name))
where school_id is not null;

-- unique system role name
create unique index if not exists roles_system_name_unique
on public.roles (lower(name))
where is_system = true;

create trigger trg_roles_updated_at
before update on public.roles
for each row execute function public.set_updated_at();

alter table public.roles enable row level security;

-- 4.3 role_permissions
create table if not exists public.role_permissions (
  role_id uuid not null references public.roles(id) on delete cascade,
  permission_id uuid not null references public.permissions(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (role_id, permission_id)
);

alter table public.role_permissions enable row level security;

-- 4.4 user_roles (assignment within a school context)
create table if not exists public.user_roles (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role_id uuid not null references public.roles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (school_id, user_id, role_id)
);

create index if not exists user_roles_user_id_idx on public.user_roles (user_id);
create index if not exists user_roles_school_id_idx on public.user_roles (school_id);

alter table public.user_roles enable row level security;

-- =========================================================
-- 5) Audit Logs
-- =========================================================
create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references public.schools(id) on delete set null,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  target_type text,
  target_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists audit_logs_school_id_idx on public.audit_logs (school_id);
create index if not exists audit_logs_actor_user_id_idx on public.audit_logs (actor_user_id);
create index if not exists audit_logs_action_idx on public.audit_logs (action);

alter table public.audit_logs enable row level security;

-- =========================================================
-- 6) BASELINE RLS POLICIES (Phase 0)
-- Secure by default: users can read their own + their school scope.
-- Writes are System Admin only (Phase 1 expands with permission-based writes).
-- =========================================================

-- ---------- schools ----------
-- Select: user can see schools they are active member of; system admin can see all.
create policy "schools_select_member_or_system"
on public.schools
for select
to authenticated
using (
  public.is_system_admin()
  or exists (
    select 1 from public.school_memberships sm
    where sm.school_id = schools.id
      and sm.user_id = auth.uid()
      and sm.status = 'active'
  )
);

-- Writes: system admin only
create policy "schools_write_system_only"
on public.schools
for insert
to authenticated
with check (public.is_system_admin());

create policy "schools_update_system_only"
on public.schools
for update
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

create policy "schools_delete_system_only"
on public.schools
for delete
to authenticated
using (public.is_system_admin());

-- ---------- profiles ----------
-- Select: user can read own profile; system admin can read all
create policy "profiles_select_own_or_system"
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_system_admin());

-- Update: user can update own profile; system admin can update all
create policy "profiles_update_own_or_system"
on public.profiles
for update
to authenticated
using (id = auth.uid() or public.is_system_admin())
with check (id = auth.uid() or public.is_system_admin());

-- Insert: system admin only for Phase 0 (Phase 1 can add trigger auto-provision)
create policy "profiles_insert_system_only_phase0"
on public.profiles
for insert
to authenticated
with check (public.is_system_admin());

-- Delete: system admin only
create policy "profiles_delete_system_only"
on public.profiles
for delete
to authenticated
using (public.is_system_admin());

-- ---------- school_memberships ----------
-- Select: user can see own memberships; system admin can see all
create policy "memberships_select_own_or_system"
on public.school_memberships
for select
to authenticated
using (user_id = auth.uid() or public.is_system_admin());

-- Writes: system admin only (Phase 1 expands)
create policy "memberships_write_system_only"
on public.school_memberships
for insert
to authenticated
with check (public.is_system_admin());

create policy "memberships_update_system_only"
on public.school_memberships
for update
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

create policy "memberships_delete_system_only"
on public.school_memberships
for delete
to authenticated
using (public.is_system_admin());

-- ---------- permissions ----------
-- Select: all authenticated can read permission registry
create policy "permissions_select_all_authenticated"
on public.permissions
for select
to authenticated
using (true);

-- Writes: system admin only (protects protected permissions too)
create policy "permissions_write_system_only"
on public.permissions
for insert
to authenticated
with check (public.is_system_admin());

create policy "permissions_update_system_only"
on public.permissions
for update
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

create policy "permissions_delete_system_only"
on public.permissions
for delete
to authenticated
using (public.is_system_admin());

-- ---------- roles ----------
-- Select: system roles visible to all authenticated; tenant roles visible to members of that school; system admin sees all.
create policy "roles_select_scoped"
on public.roles
for select
to authenticated
using (
  public.is_system_admin()
  or (is_system = true)
  or (school_id is not null and public.is_school_member(school_id))
);

-- Writes: system admin only in Phase 0
create policy "roles_write_system_only"
on public.roles
for insert
to authenticated
with check (public.is_system_admin());

create policy "roles_update_system_only"
on public.roles
for update
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

create policy "roles_delete_system_only"
on public.roles
for delete
to authenticated
using (public.is_system_admin());

-- ---------- role_permissions ----------
-- Select: if user can see the role, they can see its permissions (system admin override)
create policy "role_permissions_select_scoped"
on public.role_permissions
for select
to authenticated
using (
  public.is_system_admin()
  or exists (
    select 1
    from public.roles r
    where r.id = role_permissions.role_id
      and (
        r.is_system = true
        or (r.school_id is not null and public.is_school_member(r.school_id))
      )
  )
);

-- Writes: system admin only in Phase 0
create policy "role_permissions_write_system_only"
on public.role_permissions
for insert
to authenticated
with check (public.is_system_admin());

create policy "role_permissions_delete_system_only"
on public.role_permissions
for delete
to authenticated
using (public.is_system_admin());

-- ---------- user_roles ----------
-- Select: user can see their own role assignments; members can read roles in their school; system admin sees all
create policy "user_roles_select_scoped"
on public.user_roles
for select
to authenticated
using (
  public.is_system_admin()
  or user_id = auth.uid()
  or public.is_school_member(school_id)
);

-- Writes: system admin only in Phase 0
create policy "user_roles_write_system_only"
on public.user_roles
for insert
to authenticated
with check (public.is_system_admin());

create policy "user_roles_update_system_only"
on public.user_roles
for update
to authenticated
using (public.is_system_admin())
with check (public.is_system_admin());

create policy "user_roles_delete_system_only"
on public.user_roles
for delete
to authenticated
using (public.is_system_admin());

-- ---------- audit_logs ----------
-- Select: system admin can read all; members can read logs for their school (optional)
create policy "audit_logs_select_scoped"
on public.audit_logs
for select
to authenticated
using (
  public.is_system_admin()
  or (school_id is not null and public.is_school_member(school_id))
);

-- Insert: system admin only in Phase 0 (Phase 1 expands to write logs on RBAC changes)
create policy "audit_logs_insert_system_only_phase0"
on public.audit_logs
for insert
to authenticated
with check (public.is_system_admin());

-- No updates/deletes for anyone (append-only)
create policy "audit_logs_no_update"
on public.audit_logs
for update
to authenticated
using (false);

create policy "audit_logs_no_delete"
on public.audit_logs
for delete
to authenticated
using (false);

-- =========================================================
-- END Phase 0
-- =========================================================
