//
//  TestObject.m
//  Kinvey Quickstart
//
//  Created by Michael Katz on 11/12/12.
//
//  Copyright 2013 Kinvey, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "{{ entity_class_name }}.h"

@implementation {{ entity_class_name }}

- (NSDictionary *)hostToKinveyPropertyMapping
{
		NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    return  @{ @"objectId" : KCSEntityKeyId
    	{% for entity_field in entity_fields %}
    	, @"{{ entity_field.name }}" : @"{{ entity_field.name }}" 
    	{% endfor %}
    };
}

@end


