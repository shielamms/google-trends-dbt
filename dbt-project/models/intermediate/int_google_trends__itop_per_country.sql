with s_itop_terms as (

    select * from {{ ref('stg_google_trends__itop_terms') }}

),

ordered_terms_by_rank_and_score as (

  select
    week_start_date,
    country_code,
    region_name,
    score,
    ranking,
    search_term
  from s_itop_terms
  -- where week_start_date >= '2022-01-01' -- already defined in staging
    where score is not null
    and ranking is not null
  order by week_start_date,
           country_code,
           ranking asc,
           score desc,
           region_name

),

max_scores_per_rank as (

  select
    week_start_date,
    country_code,
    ranking,
    max(score) as max_score,
  from
    ordered_terms_by_rank_and_score
  group by week_start_date, country_code, ranking
  order by week_start_date, country_code, ranking

),

base as (

  select
    mx.week_start_date as week_start_date,
    mx.country_code as country_code,
    mx.ranking as ranking,
    oirs.search_term as search_term,
    max(mx.max_score) as max_score
  from ordered_terms_by_rank_and_score oirs
  inner join max_scores_per_rank mx on mx.ranking = oirs.ranking
                                and mx.max_score = oirs.score
                                and mx.country_code = oirs.country_code
                                and mx.week_start_date = oirs.week_start_date
  group by mx.week_start_date, mx.country_code, oirs.search_term, mx.ranking
  order by mx.week_start_date, mx.country_code, mx.ranking

)

select * from base
