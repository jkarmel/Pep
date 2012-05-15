exports.extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin
  obj

exports.include = (klass, mixin) ->
  extend klass.prototype, mixin