view: source_wise_spend {
  derived_table:{
    sql: WITH
      agency_info AS (
          SELECT id,concat(name,' - ',currency) name
          FROM idp.modelled.campaign_management_agencies where {% condition agency_name %} concat(display_name,' - ',currency)  {% endcondition %}
      ),
      client_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_clients where {% condition client_name %} name {% endcondition %}
      ),
      cam_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_campaigns where {% condition campaign_name %} name {% endcondition %}
      ),
      jg_info AS (
          SELECT id, name
          FROM idp.modelled.campaign_management_jobgroups where {% condition jg_name %} name {% endcondition %}
      ),
      stats AS (
          SELECT
              agency_id, client_id, campaign_id, job_group_id, publisher_id, event_publisher_date,
              SUM(cd_spend) AS CDSpend,
              SUM(clicks) AS clicks,
              SUM(applies) AS applies
          FROM
              tracking.modelled.VIEW_GROUPED_COMBINED_EVENTS vte
              JOIN client_info ON vte.client_id = client_info.id
              JOIN cam_info ON vte.campaign_id = cam_info.id
              JOIN jg_info ON vte.job_group_id = jg_info.id
              JOIN agency_info ON vte.agency_id = agency_info.id
          WHERE
             {% condition date_filter %} event_publisher_date {% endcondition %}
              AND should_contribute_to_joveo_stats = TRUE
          GROUP BY
              agency_id, client_id, campaign_id, job_group_id, publisher_id, event_publisher_date
      ),
      stats2 AS (
          SELECT
              publisher_id
          FROM
              stats
          WHERE
              EXISTS (
                  SELECT
                      1
                  FROM
                      (
                          SELECT
                              publisher_id, SUM(cdspend) AS total_cdspend
                          FROM
                              stats
                          GROUP BY
                              publisher_id
                          ORDER BY
                              total_cdspend DESC
                          LIMIT
                              4
                      ) AS top_4_publishers
                  WHERE
                      top_4_publishers.publisher_id = stats.publisher_id
              )
      ),
      stats_grouped AS (
          SELECT
              CASE
                  WHEN publisher_id IN (SELECT publisher_id FROM stats2) THEN publisher_id
                  ELSE 'Other'
              END AS publisher_group,
              event_publisher_date,
              SUM(CDSpend) AS total_cdspend,
              SUM(clicks) AS total_clicks,
              SUM(applies) AS total_applies,
              agency_id
          FROM
              stats
          GROUP BY
              agency_id,publisher_group, event_publisher_date
      )
      SELECT
          publisher_group,
          event_publisher_date,
          total_cdspend,
          total_clicks,
          total_applies,
          agency_id
      FROM
          stats_grouped ;;
  }
  filter: agency_name {
    type: string
  }
  filter: client_name {
    type: string
  }
  filter: campaign_name {
    type: string
  }
  filter: jg_name {
    type: string
  }
  filter: date_filter {
    type: date
  }
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: event_publisher_date {
    type: date
    sql: ${TABLE}.event_publisher_date  ;;
  }
  dimension: publisher {
    type: string
    sql: ${TABLE}.publisher_group  ;;
  }
  measure: spend {
    type: sum
    sql: ${TABLE}.total_cdspend ;;
  }
  measure: clicks {
    type: sum
    sql: ${TABLE}.total_clicks ;;
  }
  measure: applies {
    type: sum
    sql: ${TABLE}.total_applies ;;
  }
  measure: cpc {
    type: number
    sql: iff(${clicks}=0,0,${spend}/${clicks}) ;;
  }
  measure: cpa {
    type: number
    sql: iff(${applies}=0,0,${spend}/${applies}) ;;
  }
  measure: cta {
    type: number
    sql: iff(${clicks}=0,0,${applies}/${clicks}) ;;
  }
  dimension: publisher_name {
    type: string
    sql: coalesce(${publisher_name_override.name},${publisher_name.name},${publisher}) ;;
  }
 }
