# nxpress

Manage your resources decoupled from your code

## Getting Started

Create your environment:

```
flutter pub run nxpress:init
```

this command creates the following folder structure:
- nxres/
    - custom/
        - schemas.nx
    - resources/ 
        - strings/



## Nxpress notation basics

Nxpress has it's own **notation** and file **extension**. The files are ending with the ***.nx*** prefix. A Nxpress file contains ***nodes*** with ***keys*** and ***values***. Values are always inside double quotes. Arrays are defined with suqare bracktes. Values in arrays are also inside double quotes. The only allowed special char in node names is an underscore. 

```

my_node_name {
    key: "text"
}
my_node_name_2 {
    key: "2"
}
my_node_name_3 {
    key: "["ArrayValue","ArrayValue1"]"
}

```
One **important** point of Nxpress is that every resource follows a strict Schema. Some Schemas are predefined by this library others can be customized by yourself. One of the predefined resources which comes with this library are string resources. The ***.nx*** files for string resources are placed under **nxres/resources/strings**. The Schema of the string resources follows the ISO-3691-1 country code standard. This means that every node can only take specific key names. In this case all codes from the ISO-3691-1 standard. Otherwise Nxpress will throw an error.

Example:

```
// nxres/resources/strings/home.nx

hello_message {
    en: "Hi",
    de: "Hallo"
}

```

**TIPP:** Best practice for Nxpress is to create one source for each target. Let's say we have the view home.dart and we want to create a string resources for this view. Then we will create a ***home.nx*** file under ***strings*** folder.

## Creating your first string resource


Create a ***home.nx*** file under ***nxpress/strings*** and add this content to the file:

```
//nxress/strings/home.nx

hello_world {
    en: "Hello world",
    de: "Hallo Welt"
}
welcome {
    en: "Welcome to Nxpress",
    de: "Wilkommen zu Nxpress"
}

```

Run:
```
flutter pub run nxpress:build
```
This command merges all your nx files of your string resources to a single dart file named ***nxstrings.dart***.

## Plurals and placeholder

The string resources also allows placeholders and plurals:

```
plural {
    en: "["apple","apples"]",
    de: "["apfel","äpfel"]"
}

```

Placeholders are defined with double opening and closing curly braces:

```
placeholders {
    en: "I like {{name}}",
    de: "Ich mag {{name}}"
}

```
inside the braces you have to add an identifier like name.

you can also use placeholders in plurals:

```
plural {
    en: "["apple from {{name}}","apples from {{name}}"]",
    de: "["apfel von {{name}}","äpfel von {{name}}"]"
}
```

## Using string resources in Code

After generating you can use your strings as follows:

```dart
// get the text
NxString.hello_world.text()

// get text with placeholders
NxString.hello_world.text(placeholders: {
    "name": "Pink Lady"
})

// get plural 
NxString.hello_world.plural(0)

// get plural with placeholders
NxString.hello_world.plural(0,placeholders: {
    "name": "Pink Lady"
})
```

## Changing Language

To change the language you can call the NxConfig.lang value. Change it to the target language:

```dart
NxConfig.lang = "en"
```

The standart language is english. **IMPORTANT** the change of this value will not have an immediate effect. You need to update your UI to see the effect. For this you have multiple solutions in Flutter. For example you can use the didChangeLocales() functions from the WidgetBindingObserver. There you could change the NxConfig.lang. 

## Creating custom Nxpress Schemas

You can create custom Nxpress Schemas for your needs.

1. Go to ***nxres/custom/schemas.nx*** and add your schema:
```
    my_resource_name {
        requiredKeys: "["key1","key2"]",
        oprionalKeys: "["key3",key4]",
        customScript: "my_resource.dart",
        resourceName: "MyResource"
    }
```

2. Add your custom script under ***nxres/custom/*** and named it like you named it in the schema at the **customScript** key:

```dart

//nxres/custom/my_resource.dart

import 'package:nxpress/nxpress.dart';

class MyResource extends NxpressResource {

  // call the super class of NxpressResource  
  NxString(Map<String, Object> keys) : super(keys: keys);

  // your custom code

}

```
**Important** the class name must match the **resourceName** key from your schema. In this case the class name needs to be MyResource.

3. Run the build command:

```
flutter pub run nxpress:build
```
This will generate your resource folder under the **nxres/resources** directory.  Now you can add your nx resource files in this directory. Furthermore you can find a dart file which updates after your generating your resources. From this file you can call your resources in your dart code by importing it: 

```dart
MyResources.hello_world.myCustomFunc()
```
