The library provides the `Exportable` class - a mixin providing an ability to
export objects to Maps or JSON. Useful for data models: storing in databases as
`Map`s, or passing between client/server as JSON.

Properties of a class that is mixed with `Exportable` and wanted to be
exportable should be annotated with `@export`, and could be

* any type supported by JSON (see [JsonEncoder.convert()](http://api.dartlang.org/docs/channels/stable/latest/dart_convert/JsonEncoder.html#convert))
* any class that mixes `Exportable`
* `DateTime`

Usage example:

    class Foo extends Object with Exportable {
      @export String bar;
    }

    void main() {
      Foo foo = new Exportable(Foo);
      // The same as
      // Foo foo = new Foo();
      foo.bar = 'Bar';
      print(foo.toMap());
      // => {bar: Bar}
      print(foo.toJson());
      // => {"bar":"Bar"}
      print(foo.toString());
      // => {"bar":"Bar"}
      Foo baz = new Exportable(Foo, '{"bar":"Baz"}');
      // The same as
      // Foo baz = new Foo();
      // baz.initFromJson('{"bar":"Baz"}');
      print(baz);
      // => {"bar":"Baz"}
      Foo baz2 = new Exportable(Foo, {'bar': 'Baz'});
      // The same as
      // Foo baz2 = new Foo();
      // baz2.initFromMap({'bar': 'Baz'});
      print(baz2);
      // => {"bar":"Baz"}
    }

##### Metadata: Dart VM vs dart2js

Metadata annotations are used to

* let the Exportable class know which properties could be exported or imported,
* allow tree-shaking of a code.

When running in JS context, there are some difficulties with type detecting. So,
here are some annotation rules.

If you plan to use exportable models with **Dart VM only**:

* Each exportable property of an exportable class should be annotated with
  `@export`.
* If you need a tree-shaking: annotate an exportable class itself. But this is
  not mandatory.

If you plan to use exportable models with **dart2js**:

* Each exportable property of a JSON supported class should be annotated with
  `@export`.
* Properties of a non JSON supported class
  (see [JsonEncoder.convert()](http://api.dartlang.org/docs/channels/stable/latest/dart_convert/JsonEncoder.html#convert))
  should be annotated with `@Export(<type>)`, where `<type>` is a type of a
  property.
* Exportable class itself should be annotated with `@export`.

##### TODO

* Provide more information/examples in the README.
* Check why dart2js says
  "Hint: X methods retained for use by dart:mirrors out of X total methods (X%)"
  (seems like we have 1 retained method for one exportable class... is this a
  constructor?)
* Write tests!
