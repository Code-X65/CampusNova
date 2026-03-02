export interface School {
    id: string;
    name: string;
    slug: string;
    status: 'active' | 'inactive' | 'pending';
    created_at: string;
}

export interface Profile {
    id: string;
    user_id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
}

export interface UserRole {
    user_id: string;
    role_id: string;
    school_id: string;
}
