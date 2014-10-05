/**
 * Provides the [Exportable] mixin class.
 */
library exportable;

@MirrorsUsed(metaTargets: const[Export], override: 'exportable')
import 'dart:mirrors';
import 'dart:convert' show JSON;

/**
 * A mixin providing an ability to export objects to [Map]s or JSON.
 *
 * Object properties should be annotated with @export, and could be
 *
 * * any type supported by JSON (see [JsonEncoder.convert()])
 * * any class that mixes [Exportable]
 * * [DateTime]
 *
 * Usage example:
 *
 *     @Export(Foo)
 *     class Foo extends Object with Exportable {
 *       @export String bar;
 *     }
 *
 *     void main() {
 *       Foo foo = new Exportable(Foo); // The same as "new Foo()".
 *       foo.bar = 'Bar';
 *       print(foo.toMap());
 *       // => {bar: Bar}
 *       print(foo.toJson());
 *       // => {"bar":"Bar"}
 *       print(foo.toString());
 *       // => {"bar":"Bar"}
 *       Foo baz = new Exportable(Foo, '{"bar":"Baz"}');
 *       print(baz);
 *       // => {"bar":"Baz"}
 *       Foo baz2 = new Exportable(Foo, {'bar': 'Baz'});
 *       print(baz2);
 *       // => {"bar":"Baz"}
 *     }
 *
 */
class Exportable {

  List<PropertyData> __propertiesData;
  List<PropertyData> get _propertiesData {
    if (__propertiesData == null) {
      __propertiesData = _collectExportableProperties(this);
    }
    return __propertiesData;
  }

  /**
   * Creates a new objects instance, calling the default constructor.
   *
   * If [init] (could be [String] or [Map]) is passed, it's used to initialize
   * object properties.
   */
  factory Exportable(Type type, [init]) {
    var instance = reflectClass(type).newInstance(const Symbol(''), []).reflectee;
    if (instance is! Exportable) {
      throw new Exception('Type $type is not mixing Exportable.');
    }
    if (init is Map) {
      instance.initFromMap(init);
    } else if (init is String) {
      instance.initFromJson(init);
    }
    return instance;
  }

  void initFromMap(Map map) {
    InstanceMirror thisMirror = reflect(this);
    for (PropertyData propertyData in _propertiesData) {
      if (map.containsKey(propertyData.name)) {
        if (propertyData.type != null && _isExportableType(propertyData.type)) {
          thisMirror.setField(propertyData.symbol, new Exportable(propertyData.type, map[propertyData.name]));
        } else {
          thisMirror.setField(propertyData.symbol, _importSimpleValue(propertyData.type, map[propertyData.name]));
        }
      }
    }
  }

  void initFromJson(String json) {
    try {
      var map = JSON.decode(json);
      if (map is Map) {
        initFromMap(map);
      }
    } catch (e) {}
  }

  Map toMap() {
    Map map = {};
    for (PropertyData propertyData in _propertiesData) {
      var value = reflect(this).getField(propertyData.symbol).reflectee;
      map[propertyData.name] = value is Exportable
          ? value.toMap() : _exportSimpleValue(value);
    }
    return map;
  }

  String toJson() {
    return JSON.encode(toMap());
  }

/**
   * An alias for [toJson].
   */
  String toString() {
    return toJson();
  }

  static dynamic _exportSimpleValue(value) {
    if (_isJsonSupported(value)) {
      return value;
    } else if (value is DateTime) {
      return (value as DateTime).toUtc().toString();
    }
    return null;
  }

  /**
   * [type] could be null here.
   */
  static dynamic _importSimpleValue(Type type, value) {
    if (type == DateTime && value is String) {
      return DateTime.parse(value).toLocal();
    } else if (_isJsonSupported(value)) {
      return value;
    }
    return null;
  }

  static bool _isJsonSupported(value) {
    if (value == null
        || value is bool
        || value is num
        || value is String
        || value is List
        || value is Map) {
      return true;
    }
    return false;
  }

  static bool _isExportableType(Type type) {
    for (ClassMirror classMirror in _getAllClassMirrors(reflectClass(type))) {
      if (classMirror.hasReflectedType
          && classMirror.reflectedType == Exportable) {
        return true;
      }
    }
    return false;
  }

  static List<VariableMirror> _collectExportableVariableMirrors(ClassMirror classMirror) {
    List<VariableMirror> list = [];
    for (ClassMirror classMirror_ in _getAllClassMirrors(classMirror)) {
      for (DeclarationMirror declaration in classMirror_.declarations.values) {
        if (declaration is VariableMirror
            && !declaration.isPrivate
            && !declaration.isStatic
            && !declaration.isFinal) {
          for (InstanceMirror meta in declaration.metadata) {
            if (meta.reflectee is Export) {
              list.add(declaration);
              break;
            }
          }
        }
      }
    }
    return list;
  }

  static List<ClassMirror> _getAllClassMirrors(ClassMirror classMirror) {
    List<ClassMirror> list = [];
    if (!list.contains(classMirror)) {
      list.add(classMirror);
    }
    if (classMirror.superclass is ClassMirror) {
      list.addAll(_getAllClassMirrors(classMirror.superclass));
    }

    // When running in JS, the ClassMirror.mixin getter does not exists.
    // Basically, if we have
    //     class A extends B with C {}
    //     class B {}
    //     class C {}
    // in JS context it looks like
    //     class A extends B {}
    //     class B extends C {}
    //     class C {}
    // So, actually, we have the same class list in the end.
    // This is described in http://dartbug.com/14713
    if (identical(1, 1.0)) {
      return list;
    }

    if (classMirror.mixin != classMirror && classMirror.mixin is ClassMirror) {
      list.addAll(_getAllClassMirrors(classMirror.mixin));
    }
    return list;
  }

  /**
   * May return null if there is no way to detect type.
   */
  static Type _getTypeFromVariableMirror(VariableMirror declaration) {
    // First try to fetch the Type from the declaration itself. This works in
    // Dart VM context: for some reason VariableMirror.type is the ClassMirror,
    // but not the TypeMirror as said in the documentation. We need exactly
    // ClassMirror, because there is no way to fetch the Type from the
    // TypeMirror.
    if (declaration.type is ClassMirror) {
      ClassMirror classMirror = declaration.type;
      if (classMirror.hasReflectedType) {
        return classMirror.reflectedType;
      }
    }
    // Now try to fetch the Type from the metadata, if it was specified.
    for (InstanceMirror meta in declaration.metadata) {
      if (meta.reflectee is Export) {
        return (meta.reflectee as Export).type;
      }
    }
    // We should newer reach this line.
    return null;
  }

  static List<PropertyData> _collectExportableProperties(Exportable instance) {
    List<PropertyData> list = [];
    InstanceMirror thisMirror = reflect(instance);
    List<VariableMirror> declarations = _collectExportableVariableMirrors(thisMirror.type);
    for (VariableMirror declaration in declarations) {
      for (InstanceMirror meta in declaration.metadata) {
        if (meta.reflectee is Export) {
          list.add(new PropertyData(
            type: _getTypeFromVariableMirror(declaration),
            symbol: declaration.simpleName,
            name: MirrorSystem.getName(declaration.simpleName)
          ));
          break;
        }
      }
    }
    return list;
  }
}

const export = const Export();
class Export {
  final Type type;

  const Export([this.type]);
}

class PropertyData {
  final Type type;
  final Symbol symbol;
  final String name;

  const PropertyData({this.type, this.symbol, this.name});
}
