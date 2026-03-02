-- 02_rls_policies.sql
-- Goal: Initial Row Level Security (RLS) policies for tenant isolation

-- Enable RLS on all tables
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- 1. Schools: Users can only see schools they belong to
CREATE POLICY "Users can see their own schools" ON public.schools
    FOR SELECT
    USING (
        id IN (
            SELECT school_id FROM public.school_memberships
            WHERE user_id = auth.uid()
        )
    );

-- 2. Profiles: Users can see all profiles in their schools (simplified for Phase 0)
CREATE POLICY "Users can see profiles in their schools" ON public.profiles
    FOR SELECT
    USING (TRUE); -- Phase 1 will tighten this

-- 3. school_memberships: Users can see their own memberships
CREATE POLICY "Users can see their own memberships" ON public.school_memberships
    FOR SELECT
    USING (user_id = auth.uid());

-- 4. RBAC: System Admin can see everything, School members see their own roles
-- (These will be refined in Phase 1 with the actual hasPermission logic)
