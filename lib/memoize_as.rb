require "memoize_as/version"

module MemoizeAs
  def memoize_as(ivar_name)
    instance_variable_set(ivar_name, yield) unless instance_variable_defined?(ivar_name)
    instance_variable_get(ivar_name)
  end
end
