with source as (

    select * from {{ source('s_google_trends', 's_international_top_terms') }}

),

base as (

    select
        cast( week as date ) as week_start_date,
        lower( cast( country_code as string ) ) as country_code,
        lower( cast( region_name as string ) ) as region_name,
        lower( cast( term as string ) ) as search_term,
        cast( score as numeric ) as score,
        cast( rank as numeric ) as ranking

    from source
    where week > '2020-12-31'

)

select * from base
