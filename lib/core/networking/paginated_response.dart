import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/models/product.dart';

part 'paginated_response.g.dart';

@JsonSerializable()
class PaginatedResponse<T> {
  int total;

  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @ModelConverter()
  final List<T> data;

  PaginatedResponse({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResponseFromJson(json);
}

/* Source: https://stackoverflow.com/questions/55306746/how-to-use-generics-and-list-of-generics-with-json-serialization-in-dart#answer-70949314 */
/// This JsonConverter class holds the toJson/fromJson logic for generic type
/// fields in our Object that will be de/serialized.
/// This keeps our Object class clean, separating out the converter logic.
///
/// JsonConverter takes two type variables: <T,S>.
///
/// Inside our JsonConverter, T and S are used like so:
///
/// T fromJson(S)
/// S toJson(T)
///
/// T is the concrete class type we're expecting out of fromJson() calls.
/// It's also the concrete type we're inputting for serialization in toJson() calls.
///
/// Most commonly, T will just be T: a variable type passed to JsonConverter in our
/// Object being serialized, e.g. the "T" from OperationResult<T> above.
///
/// S is the JSON type.  Most commonly this would Map<String,dynamic>
/// if we're only de/serializing single objects.  But, if we want to de/serialize
/// Lists, we need to use "Object" instead to handle both a single object OR a List of objects.
class ModelConverter<T> implements JsonConverter<T, Object> {
  const ModelConverter();

  /// fromJson takes Object instead of Map<String,dynamic> so as to handle both
  /// a JSON map or a List of JSON maps.  If List is not used, you could specify
  /// Map<String,dynamic> as the S type variable and use it as
  /// the json argument type for fromJson() & return type of toJson().
  /// S can be any Dart supported JSON type
  /// https://pub.dev/packages/json_serializable/versions/6.0.0#supported-types
  /// In this example we only care about Object and List<Object> serialization
  @override
  T fromJson(Object json) {
    /// start by checking if json is just a single JSON map, not a List
    if (json is Map<String, dynamic>) {
      /// now do our custom "inspection" of the JSON map, looking at key names
      /// to figure out the type of T t. The keys in our JSON will
      /// correspond to fields of the object that was serialized.
      if (json.containsKey('id') && json.containsKey('name')) {
        /// In this case, our JSON contains both an 'items' key/value pair
        /// and a 'customer' key/value pair, which I know only our Order model class
        /// has as fields.  So, this JSON map is an Order object that was serialized
        /// via toJson().  Now I'll deserialize it using Order's fromJson():
        return Product.fromJson(json) as T;

        /// We must cast this "as T" because the return type of the enclosing
        /// fromJson(Object? json) call is "T" and at compile time, we don't know
        /// this is an Order.  Without this seemingly useless cast, a compile time
        /// error will be thrown: we can't return an Order for a method that
        /// returns "T".
      }
    } else if (json is List) {
      /// here we handle Lists of JSON maps
      if (json.isEmpty) return [] as T;

      /// Inspect the first element of the List of JSON to determine its Type
      Map<String, dynamic> first = json.first as Map<String, dynamic>;
      bool isProduct = first.containsKey('id');

      if (isProduct) {
        return json.map((p) => Product.fromJson(p)).toList() as T;
      }
    }

    /// We didn't recognize this JSON map as one of our model classes, throw an error
    /// so we can add the missing case
    throw ArgumentError.value(
        json,
        'json',
        'OperationResult._fromJson cannot handle'
            ' this JSON payload. Please add a handler to _fromJson.');
  }

  /// Since we want to handle both JSON and List of JSON in our toJson(),
  /// our output Type will be Object.
  /// Otherwise, Map<String,dynamic> would be OK as our S type / return type.
  ///
  /// Below, "Serializable" is an abstract class / interface we created to allow
  /// us to check if a concrete class of type T has a "toJson()" method. See
  /// next section further below for the definition of Serializable.
  /// Maybe there's a better way to do this?
  ///
  /// Our JsonConverter uses a type variable of T, rather than "T extends Serializable",
  /// since if T is a List, it won't have a toJson() method and it's not a class
  /// under our control.
  /// Thus, we impose no narrower scope so as to handle both cases: an object that
  /// has a toJson() method, or a List of such objects.
  @override
  Object toJson(T object) {
    /// First we'll check if object is Serializable.
    /// Testing for Serializable type (our custom interface of a class signature
    /// that has a toJson() method) allows us to call toJson() directly on it.

    try {
      /// otherwise, check if it's a List & not empty & elements are Serializable
      if (object is List) {
        if (object.isEmpty) return [];

        return object.map((t) => t.toJson()).toList();
      }

      return (object as dynamic).toJson();
    } catch (e) {
      /// It's not a List & it's not Serializable, this is a design issue
      throw ArgumentError.value(
          object,
          'Cannot serialize to JSON',
          'OperationResult._toJson this object or List either is not '
              'Serializable or is unrecognized.');
    }
  }
}
