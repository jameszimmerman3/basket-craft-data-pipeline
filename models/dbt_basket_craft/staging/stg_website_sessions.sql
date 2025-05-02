with source as (
    select * 
    from raw.website_sessions
),

renamed as (
    select
        website_session_id,
        user_id,
        utm_source,
        is_repeat_session,
        created_at as website_session_created_at,
        current_timestamp as loaded_at
    from source
)

select * from renamed
