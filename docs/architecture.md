# Architecture Overview

## Monorepo Structure
- **apps/admin**: System Admin Dashboard (React + Vite).
- **apps/school**: School Portal (React + Vite).
- **packages/config**: Shared ESLint, TypeScript, and Prettier configurations.
- **packages/types**: Shared TypeScript domain models.
- **packages/ui**: Shared React component library (Tailwind CSS v4).
- **packages/api-client**: Shared Supabase client and API wrappers.
- **packages/auth**: Shared authorization engine (`hasPermission`).

## Technology Stack
- **Frontend**: React 19, Vite, Tailwind CSS v4, React Router, TanStack Query.
- **Backend/Database**: Supabase (PostgreSQL, Auth, RLS).
- **Tooling**: pnpm Workspaces, Turborepo.

## Tenancy Model
- Multi-school system using **ID-based isolation (RLS)** in a shared database.
- Every tenant-scoped table must include a `school_id`.
