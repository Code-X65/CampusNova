import { createClient } from '@supabase/supabase-js'

export const createSupabaseClient = (url: string, key: string) => {
    return createClient(url, key)
}

// Default instance for client-side use (requires env variables)
const supabaseUrl = import.meta.env?.VITE_SUPABASE_URL || ''
const supabaseAnonKey = import.meta.env?.VITE_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
