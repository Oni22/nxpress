# nxpress

Manage your string resources decoupled from your code

## Getting Started

Create your environment:

```
flutter pub run nxpress:init
```

this command creates the ***nxres*** folder with the ***resources*** and ***custom*** folders within it and other needed files.

## Nxpress notation basics

Nxpress has it's own notation and file extension. The notations are following specific schemas which are predefined (more in the next sections). The files are ending with the ***.nx*** extension. 

A Nxpress file contains ***nodes*** with ***keys*** and ***values***. Values are always string types. Nxpress can parse them into other types if possible and needed. The only allowed special char in node names is a underscore.

```

node {
    key: "text"
}
node_2 {
    key: "2"
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

The string namepsace follows a strict schema which is predefined. This is one of the benefits of Nxpress. You can define Nxpress schemas with required keys and optional keys. The predefined schema for the string namespace follows the ISO-3691-1 standart for country codes. If you add keys which are not inside the defined schema Nxpress will throw an error.  

## Plurals and placeholder

The string namespace also allows placeholders and plurals:

```
plural {
    en: "["apple","apples"]",
    de: "["apfel","äpfel"]"
}

```

For plurals you can use nxpress arrays. Arrays are inside "" and only contains strings too.

Placeholders are defined with double opening and closing curly braces:

```
placeholders {
    en: "I like {{name}}",
    de: "Ich mag {{name}}"
}

```
inside the barces you have to add an identifier.

you can also use placeholders in plurals:

```
plural {
    en: "["apple from {{name}}","apples from {{name}}"]",
    de: "["apfel von {{name}}","äpfel von {{name}}"]"
}
```

## Generate resources

After you setup your string resources you can generate them via the command:

```
flutter pug run nxpress:str
```

This command merges all your nx files of your string namespace to a single dart file named ***nxstrings.dart***.

# Using in Code

After generating you can use your strings as follows:

```dart
// get the text
RString.hello_world.text()

// get text with placeholders
RString.hello_world.text(placeholders: {
    "name": "Pink Lady"
})

// get plural 
RString.hello_world.plural(0)

// get plural with placeholders
RString.hello_world.plural(0,placeholders: {
    "name": "Pink Lady"
})

```

# Creating custom Nxpress Schemas

You can create custom Nxpress Schemas for your needs.

1. Create a schema under the ***nxres/custom/schemas.json***:
```json
    [
        {
            "resourceName": "MyResource",
            "customScript": "my_resource.dart",
            "requiredKeys": ["1","2"],
            "optionalKeys": [],
            "namespace": "mynamespace"
        }
    ]
```

2. Add your custom script under ***nxres/custom/*** and named it like you named it in the schema at the customScript key:

```dart

//nxres/custom/my_resource.dart

import 'package:nxpress/nxpress.dart';

class MyCustomResource extends NxpressResource {

  // call the super class of NxpressResource  
  NxString(Map<String, Object> keys) : super(keys: keys);

  // your custom code

}

```

3. Create ***myresources*** folder under ***nxres/resources/*** and add your nx resources

4. Run the build command:

```
flutter pub run nxpress:build

```