# nxpress

Manage your string resources decoupled from your code

## Getting Started

Create your environment and namespaces:

```
flutter pub run nxpress:init
```

this command creates the ***nxres*** folder with the namespace folder ***strings***. Inside the ***strings*** folder we will place our ***.nx*** files later.

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

**TIPP:** Best practice for Nxpress is to create one source for each view. Let's say we have the view home.dart and we want to create a string resource for this view. Then we will create a ***home.nx*** file under ***strings*** folder.

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

1. Create a ***bin*** folder under the root folder of your project. 

2. Add a new dart file named ***mynamespace.dart*** with the code:

```dart

import 'package:nxpress/nxpress.dart';

main(List<String> args) async {

  final creator = NxpressCreator(
    namespace: "mynamespace", 
    schema: NxpressSchema(
        requiredKeys: ["key1","key2"]
        optionalKeys: ["key3","key4"]
        ), 
    resourceName: "MyCustomResource"
  );

  creator.build();
}

```

3. Create the resource ***MyCustomResource***

```dart

import 'package:nxpress/nxpress.dart';

class MyCustomResource extends NxpressResource {

  // call the super class of NxpressResource  
  NxString(Map<String, Object> keys) : super(keys: keys);

  // your custom code

}

```

4. Add your nx resources under ***nxres/mynamespace/*** and run:

```
flutter pub run nxpress:mynamespace
```