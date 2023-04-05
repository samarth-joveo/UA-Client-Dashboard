view: publisher_name_override {
 sql_table_name: idp.modelled.publisher_management_publishers;;
#select publisher_id,agency_id,name  from idp.modelled.publisher_management_publishers where agency_id is not null
# SELECT p.publisher_id, p.agency_id, p.name
# FROM idp.modelled.publisher_management_publishers AS p
# JOIN idp.modelled.campaign_management_agencies AS a
# ON p.agency_id = a.id
# WHERE {% condition ${agency_info.agency_name_display} %} concat(display_name,' - ',a.currency)  {% endcondition %} ;;
dimension: publisher_id {
  type: string
  sql: ${TABLE}.publisher_id ;;
}
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
dimension: Publisher {
  type: string
  sql: ${TABLE}.name ;;
}


}
