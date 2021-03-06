//
//  TestObject.h
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

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface {{ entity_class_name }} : NSObject <KCSPersistable>

@property (nonatomic, retain) NSString*  objectId;

{% for entity_field in entity_fields %}
@property (nonatomic, retain) {{ entity_field.type }}* {{ entity_field.name }};
{% endfor %}

@end
