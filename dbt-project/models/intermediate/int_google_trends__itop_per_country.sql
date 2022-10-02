with s_itop_terms as (

    select * from {{ ref('stg_google_trends__itop_terms') }}

),

filtered_ranks_and_scores as (

    select *
    from s_itop_terms
    where ranking is not null
    and score is not null

),

unique_search_terms as (

    select
      week_start_date,
      country_code,
      search_term,
      min(ranking) as ranking
    from filtered_ranks_and_scores
    group by week_start_date,
             country_code,
             search_term

),

base as (

    select
        week_start_date,
        country_code,
        ranking,
        search_term,
    from (
      select
        week_start_date,
        country_code,
        row_number() over ( partition by week_start_date,
                                         country_code
                            order by ranking asc ) as ranking,
        search_term
      from unique_search_terms
    )
    where ranking <= 10
    -- is order by a good practice here?
    -- order by week_start_date,
    --          country_code,
    --          ranking asc

)

select * from base
