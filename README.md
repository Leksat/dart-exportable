The library provides the `Exportable` class - a mixin providing an ability to
export objects to Maps or JSON. Useful for data models: storing in databases as
`Map`s, or passing between client/server as JSON.

Properties of a class that is mixed with `Exportable` and wanted to be
exportable should be annotated with `@export`, and could be

* any type supported by JSON (see [JsonEncoder.convert()](http://api.dartlang.org/docs/channels/stable/latest/dart_convert/JsonEncoder.html#convert))
* any calss that mixes `Exportable`
* `DateTime`

Usage example:

    @observable
    class Foo extends Object with Exportable {
      @observable String bar;
    }

    void main() {
      Foo foo = new Exportable(Foo); // The same as "new Foo()".
      foo.bar = 'Bar';
      print(foo.toMap());
      // => {bar: Bar}
      print(foo.toJson());
      // => {"bar":"Bar"}
      print(foo.toString());
      // => {"bar":"Bar"}
      Foo baz = new Exportable(Foo, '{"bar":"Baz"}');
      print(baz);
      // => {"bar":"Baz"}
      Foo baz2 = new Exportable(Foo, {'bar': 'Baz'});
      print(baz2);
      // => {"bar":"Baz"}
    }

##### TODO

* Refactor: provide a property which will contain all information about types,
  declarations, etc. Should be initialized once on the first call.
* Provide more information/examples in the README.
* Describe annotation difference of Dart VM and dart2js modes.
