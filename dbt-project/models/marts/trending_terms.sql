with source as (

    select * from {{ ref('int_google_trends__itop_per_country') }}

),

final as (

    select

        week_start_date,
        country_code,
        ranking,
        search_term,
        max_score as score

    from
        source

)

select * from final