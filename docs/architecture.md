# CampusNova Architecture Overview (Phase 0)

## Overview
CampusNova is a multi-tenant school management system designed for scalability and security. Phase 0 establishes the foundation with two React applications and a robust Supabase backend structure.

## Frontend
- **Applications**:
  - `CampusNova_Schools_Portals`: For school-level management (tenants).
  - `CampusNova_System_Admin_Dashboard`: For global system administration.
- **Stack**: React, TypeScript, Vite, React Router, TanStack Query, React Hook Form, Zod.
- **Styling**: Vanilla CSS with custom utility classes for a premium, fast-loading UI.

## Backend (Supabase)
- **Database**: PostgreSQL with Row Level Security (RLS) for tenant isolation.
- **Auth**: Supabase Auth for identity management.
- **RBAC**: Custom B2b RBAC model (Roles, Permissions).

## Folder Structure
```
/apps
  /CampusNova_Schools_Portals
  /CampusNova_System_Admin_Dashboard
/supabase
  /migrations
  /seed
  /policies
/docs
```
