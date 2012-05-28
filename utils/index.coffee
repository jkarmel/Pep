exports.extend = (object, mixin) ->
  object[name] = method for name, method of mixin
  object

exports.include = (klass, mixin) ->
  exports.extend klass.prototype, mixin