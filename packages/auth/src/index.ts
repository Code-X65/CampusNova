import { supabase } from '@campusnova/api-client'
import { UserRole } from '@campusnova/types'

/**
 * Checks if a user has a specific permission in a school.
 * This is a shell implementation for Phase 0.
 */
export const hasPermission = async (
    userId: string,
    permissionKey: string,
    schoolId: string
): Promise<boolean> => {
    // Placeholder logic: In Phase 0, we just return true for now
    // Phase 1 will implement actual DB check against user_roles -> role_permissions
    console.log(`Checking permission ${permissionKey} for user ${userId} in school ${schoolId}`)
    return true
}

export const getSession = async () => {
    return supabase.auth.getSession()
}

export const signOut = async () => {
    return supabase.auth.signOut()
}
