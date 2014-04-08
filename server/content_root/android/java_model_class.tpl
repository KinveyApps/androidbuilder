{{ package_name }}

{% for _import_ in _imports_ %}
{{ _import_ }}
{% endfor %}

public class {{ class_name }} { }