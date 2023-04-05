view: trend_comparison {
  derived_table: {
    sql:
    {% if period_selection._parameter_value == 'sp_mdw' %}
        select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,
          case when event_publisher_date between date({% date_start event_publisher_date %}) and date({% date_end event_publisher_date %})
          then event_publisher_date
          else dateadd(day,date({% date_start event_publisher_date %})-dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(year,-1,date({% date_start event_publisher_date %}))),dateadd(year,-1,date({% date_start event_publisher_date %}))),event_publisher_date)
          end as modified_date,
          case when event_publisher_date between date({% date_start event_publisher_date %}) and date({% date_end event_publisher_date %})
          then 'Current'
          else 'Previous'
          end as prev_current,
             sum(cd_spend) as CDSpend
          from tracking.modelled.view_grouped_combined_events
          where  (( event_publisher_date >= date({% date_start event_publisher_date %})  and event_publisher_date <= date({% date_end event_publisher_date %} )) or
          ( event_publisher_date >= dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(year,-1,date({% date_start event_publisher_date %}))),dateadd(year,-1,date({% date_start event_publisher_date %}))) and event_publisher_date <=dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(year,-1,date({% date_start event_publisher_date %}))),dateadd(year,-1,{% date_end event_publisher_date %})) ))
          and should_contribute_to_joveo_stats = TRUE
          group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
    {% elsif period_selection._parameter_value == 'pp_mdw' %}
       select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,
        case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
        then event_publisher_date
        else dateadd(day,date({% date_start event_publisher_date %})-dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,date({% date_start event_publisher_date %}))),dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,date({% date_start event_publisher_date %}))),event_publisher_date)
        end as modified_date,
        case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
        then 'Current'
        else 'Previous'
        end as prev_current,
           sum(cd_spend) as CDSpend
        from tracking.modelled.view_grouped_combined_events
        where (( event_publisher_date >= date({% date_start event_publisher_date %})  and event_publisher_date <= date({% date_end event_publisher_date %} )) or
        ( event_publisher_date >= dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,date({% date_start event_publisher_date %}))),dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,date({% date_start event_publisher_date %}))) and event_publisher_date <=dateadd(day,dayofweek(date({% date_start event_publisher_date %}))-dayofweek(dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,date({% date_start event_publisher_date %}))),dateadd(day,date({% date_start event_publisher_date %})-{% date_end event_publisher_date %}-1,{% date_end event_publisher_date %})) ))
        and should_contribute_to_joveo_stats = TRUE
        group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
    {% elsif period_selection._parameter_value == 'pp' %}
      select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,
          case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
          then event_publisher_date
          else dateadd(day,date({% date_start event_publisher_date %})-dateadd(day,date({% date_start event_publisher_date %})-date({% date_end event_publisher_date %})-1,date({% date_start event_publisher_date %})),event_publisher_date)
          end as modified_date,
          case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
          then 'Current'
          else 'Previous'
          end as prev_current,
             sum(cd_spend) as CDSpend
          from tracking.modelled.view_grouped_combined_events
          where (( event_publisher_date >= date({% date_start event_publisher_date %})  and event_publisher_date <= date({% date_end event_publisher_date %} )) or
          ( event_publisher_date >= dateadd(day,date({% date_start event_publisher_date %})-date({% date_end event_publisher_date %})-1,date({% date_start event_publisher_date %})) and event_publisher_date <=dateadd(day,date({% date_start event_publisher_date %})-date({% date_end event_publisher_date %})-1,{% date_end event_publisher_date %}) ))
          and should_contribute_to_joveo_stats = TRUE
          group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
    {% elsif period_selection._parameter_value == 'sp' %}
      select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,
      case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
      then event_publisher_date
      else dateadd(day,date({% date_start event_publisher_date %})-dateadd(year,-1,date({% date_start event_publisher_date %})),event_publisher_date)
      end as modified_date,
      case when event_publisher_date between date({% date_start event_publisher_date %}) and {% date_end event_publisher_date %}
      then 'Current'
      else 'Previous'
      end as Prev_Current,
         sum(cd_spend) as CDSpend
      from tracking.modelled.view_grouped_combined_events
      where  (( event_publisher_date >= date({% date_start event_publisher_date %})  and event_publisher_date <= date({% date_end event_publisher_date %} )) or
      ( event_publisher_date >= dateadd(year,-1,date({% date_start event_publisher_date %})) and event_publisher_date <=dateadd(year,-1,{% date_end event_publisher_date %}) ))
      and should_contribute_to_joveo_stats = TRUE
      group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
      {% endif %};;
  }

  filter: event_publisher_date {
    type: date
  }
  dimension: date_output {
    type: date
    sql: ${TABLE}.event_publisher_date ;;
  }
  dimension: modified_date {
    type: date
    sql: ${TABLE}.modified_date ;;
  }
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }
  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: job_group_id {
    type: string
    sql: ${TABLE}.job_group_id ;;
  }
  dimension: publisher_id {
    type: string
    sql: ${TABLE}.publisher_id ;;
  }
  dimension: Prev_Current {
    type: string
    sql: ${TABLE}.Prev_Current ;;
  }
  measure: Spend {
    type: sum
    sql: ${TABLE}.cdspend ;;
  }

  parameter: period_selection {
    type: unquoted
    allowed_value: {
      label: "Preceeding Period (Match day of week)"
      value: "pp_mdw"
    }
    allowed_value: {
      label: "Same Period Last Year (Match day of week)"
      value: "sp_mdw"
    }
    allowed_value: {
      label: "Preceeding Period"
      value: "pp"
    }
    allowed_value: {
      label: "Same Period Last Year"
      value: "sp"
    }


  }
  }
