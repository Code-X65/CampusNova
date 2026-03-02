# Phase 0: Infrastructure & Product Definition

## 1. Tenancy Model
- **Model**: Multi-tenant (SaaS).
- **Tenant Scope**: One School = One Tenant.
- **Data Isolation**: Shared Database with `school_id` row-level isolation (RLS).

## 2. Environments
- **Local**: Development on local machine (Supabase CLI + Vite).
- **Staging**: Vercel preview deployments + Supabase staging project.
- **Production**: Vercel production deployment + Supabase production project.

## 3. Naming Conventions
- **Database Tables**: Snake case, pluralized (e.g., `schools`, `profiles`).
- **Database Columns**: Snake case (e.g., `school_id`, `created_at`).
- **TypeScript Types**: Pascal case (e.g., `School`, `UserMembership`).
- **React Components**: Pascal case (e.g., `AppShell`, `Button`).
- **File Paths**: Kebab case for directories and files (e.g., `src/components/user-profile.tsx`).

## 4. MVP Scope Boundaries (Phase 0)
- **Goal**: Foundation only.
- **Includes**: Monorepo setup, DB schema, RLS planning, app skeletons, CI/CD pipeline.
- **Excludes**: Authentication flows (Phase 1), feature logic, complex UI.
