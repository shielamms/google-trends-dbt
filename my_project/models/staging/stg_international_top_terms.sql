with source as (

    select * from {{ source('s_google_trends', 's_international_top_terms') }}

),

base as (

    select
        cast( week as date ) as itop_terms_week_start_date,
        lower( cast( country_code as string ) ) as itop_terms_country_code,
        lower( cast( region_name as string ) ) as itop_terms_region_name,
        cast( score as numeric ) as itop_terms_score,
        cast( rank as numeric ) as itop_terms_rank,

    from source
    where week > '2020-12-31'

)

select * from base
