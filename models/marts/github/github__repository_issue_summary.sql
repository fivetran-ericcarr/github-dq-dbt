with issues as (
    select
        repository_id,
        count(*)                          as total_issues,
        count_if(state = 'open')          as open_issues,
        count_if(state = 'closed')        as closed_issues,
        max(created_at)                   as last_issue_created_at
    from {{ ref('stg_github__issue') }}
    group by 1
),

pull_requests as (
    select
        base_repository_id as repository_id,
        count(*)           as total_pull_requests
    from {{ ref('stg_github__pull_request') }}
    where base_repository_id is not null
    group by 1
)

select
    r.repository_id,
    r.repository_full_name,
    r.language,
    coalesce(i.total_issues, 0)         as total_issues,
    coalesce(i.open_issues, 0)          as open_issues,
    coalesce(i.closed_issues, 0)        as closed_issues,
    coalesce(p.total_pull_requests, 0)  as total_pull_requests,
    i.last_issue_created_at
from {{ ref('stg_github__repository') }} as r
left join issues as i on r.repository_id = i.repository_id
left join pull_requests as p on r.repository_id = p.repository_id
