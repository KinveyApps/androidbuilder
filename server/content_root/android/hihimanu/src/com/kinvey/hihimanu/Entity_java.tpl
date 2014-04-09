package com.kinvey.hihimanu;

import com.google.api.client.json.GenericJson;
import com.google.api.client.util.Key;

public class {{entity_class_name}} extends GenericJson {
	
	{% for entity_field in entity_fields %}
	@Key public {{ entity_field.type }} {{ entity_field.name }};
	{% endfor %}

	{% for entity_field in entity_fields %}
	public get{{ entity_field.name }}() { return this.{{entity_field.name}}; }
	{% endfor %}

}
