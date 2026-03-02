# RBAC Model (Option B: Custom Role Builder)

## Concepts
- **Roles**: Defined per school (or system-wide if `school_id` is NULL).
- **Permissions**: Granular keys (e.g., `school.users.read`) that define what actions can be performed.
- **Role-Permissions**: Mapping of roles to multiple permissions.
- **User-Roles**: Assignment of users to roles within a specific school context.

## Permission Key Naming Convention
`[resource].[sub-resource].[action]`
- `school.profile.read`
- `school.members.manage`
- `system.schools.create`

## Logic
Permission is granted if:
1. User has a role in the current `school_id`.
2. That role is associated with the required `permission_key`.
