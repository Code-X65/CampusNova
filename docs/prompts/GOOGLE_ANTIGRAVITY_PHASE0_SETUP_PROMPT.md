# GOOGLE ANTIGRAVITY — CAMPUSNOVA PHASE 0 (INFRASTRUCTURE) MASTER SETUP PROMPT

You are a Senior SaaS Infrastructure Architect.

Your task is to set up **Phase 0 (Infrastructure Foundation)** for a production-grade multi-tenant LMS called **CAMPUSNOVA**.

This is NOT an MVP hack.
This must be scalable, secure, and enterprise-ready.

---

## PROJECT OVERVIEW

CAMPUSNOVA is a multi-tenant school management system.
Each school is a tenant.

**LOCKED architecture decisions:**
- Monorepo (single GitHub repository)
- Two React + TypeScript applications:
  - `/apps/admin`
  - `/apps/school`
- Shared packages under `/packages/*`
- Supabase (Postgres + Auth + Storage)
- RBAC Option **B2b**: custom roles per school + **protected permissions**
- Single **Super Admin (root)** with strong security
- Deployed using Vercel as **two separate projects** from the same repo

**IMPORTANT:** Implement Phase 0 only.
NO school modules (students/classes/fees/etc).
Infrastructure only.

---

## WHAT YOU MUST SET UP IN CODE

### 1) Monorepo Structure
Create this structure:

- /apps/admin
- /apps/school
- /packages/types
- /packages/ui
- /packages/config
- /packages/api-client
- /supabase (migrations, seed, policies)
- /docs

Use:
- pnpm workspaces
- Turborepo
- TypeScript project references

Install and configure:
- ESLint
- Prettier
- Husky (pre-commit hooks)
- lint-staged
- EditorConfig

Both apps must build independently.

---

### 2) Frontend Stack (Both Apps)
Use:
- React
- TypeScript
- React Router
- TanStack Query
- React Hook Form
- Zod

Create:
- App shell layout
- Basic route skeletons
- Placeholder pages
- `ProtectedRoute` scaffold (placeholder)
- Error boundary

NO styling focus.
Structure only.

---

### 3) Supabase Setup (Schema + Structure)
Generate SQL migrations for these tables:

**Tenancy + Identity**
- schools
- profiles (linked to auth.users)
- school_memberships

**RBAC (B2b)**
- roles
- permissions
- role_permissions
- user_roles

**Audit**
- audit_logs

Rules:
- Every tenant-scoped table must include `school_id`
- `permissions` must include `is_protected boolean`
- Proper foreign keys
- Proper unique constraints (e.g. schools.slug unique, permissions.key unique)

Enable Row Level Security (RLS).
Do NOT leave any tenant table without RLS.

Create baseline RLS policies for:
- Tenant isolation (user can only access rows for schools they belong to)
- Profile ownership (user can read/write their own profile)
- Membership visibility (user can read their membership)
- RBAC tables restricted appropriately

---

### 4) RBAC Foundation (Engine Shell)
Implement shared utilities in `/packages`:

- `getUserPermissions(schoolId)`
- `hasPermission(permissionKey)`
- `requirePermission(permissionKey)`
- `hasRole(roleName)` (optional convenience)

Permission keys must follow a structured naming convention such as:
- `school.users.read`
- `school.users.write`
- `rbac.roles.manage`

**Protected permissions rule (B2b):**
- `permissions.is_protected = true` can only be created/updated by System Admin.
- Enforce this at the database level (RLS/policies/constraints), not only UI.

---

### 5) Supabase Client Setup
Create `/packages/api-client` with:
- Supabase client initialization
- Centralized query helpers
- Environment validation (fail fast at startup)

No duplicate client logic across apps.

---

### 6) Environment Configuration
Create an env contract and enforce it at runtime.

Required:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `NODE_ENV`

Prepare separation for:
- staging
- production

---

### 7) Deployment Configuration (Vercel)
Prepare Vercel deployments:
- `campusnova-admin` → root: `apps/admin`
- `campusnova-school` → root: `apps/school`

Build pipeline must include:
- lint
- typecheck
- build

Add preview deployments for PRs.

---

### 8) Documentation (Mandatory)
Generate `/docs` content:
- Architecture overview
- Tenancy model explanation
- RBAC model (B2b)
- RLS strategy
- Contribution guide (branching + PR rules)
- Environment setup instructions

Documentation is not optional.

---

## WHAT I MUST DO OUTSIDE THE CODE EDITOR (YOU MUST MENTION THIS)

### Accounts & Platforms
1. Create a GitHub repository (private initially).
2. Create Supabase projects:
   - `campusnova-staging`
   - `campusnova-production`
3. Configure Supabase Auth settings:
   - Site URL
   - Redirect URLs for Admin + School apps (staging + prod)
4. Configure email provider (SMTP / Supabase email settings) so auth emails work.
5. Create Vercel account:
   - Create TWO projects connected to same repo
   - Set root directories correctly
6. Set environment variables in Vercel dashboard for each project and environment.
7. (Optional) Buy domains and configure DNS records for admin + school subdomains.

### Security actions outside code
1. Enable 2FA on:
   - GitHub
   - Supabase
   - Vercel
2. Store Supabase keys securely (password manager).
3. Confirm database backups are enabled in Supabase (prod).
4. Review and validate RLS policies in Supabase dashboard manually.

### Operational setup
1. Define branching strategy:
   - `main` (production)
   - `staging` (pre-prod)
2. Protect `main` branch:
   - Require PR reviews
   - Require CI checks
3. Confirm Vercel preview deployments work for PRs.

---

## FINAL REQUIREMENTS / ACCEPTANCE
Phase 0 is complete only when:
- Both apps run locally
- Both apps deploy independently on Vercel
- Supabase migrations are repeatable (CLI)
- RLS prevents cross-tenant access
- Shared packages are used (no duplication)
- Documentation exists
- Infrastructure is secure by default

Do NOT implement feature modules.
Do NOT skip RLS.
Do NOT bypass RBAC structure.

This is a 5–7 year SaaS foundation.
Build accordingly.
