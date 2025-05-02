{% macro generate_schema_name(custom_schema, node) -%}
  {% if target.schema in ['dev', 'staging'] %}
    {{ target.schema ~ '_' ~ custom_schema }}
  {% else %}
    {{ custom_schema }}
  {% endif %}
{%- endmacro %}
