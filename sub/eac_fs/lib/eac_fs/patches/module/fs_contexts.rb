# frozen_string_literal: true

class Module
  ::EacFs::Contexts::TYPES.each do |type|
    method_name = "fs_#{type}"
    define_method method_name do
      ::EacFs::Contexts.send(type).current.child(method_name, *name.split('::'))
    end
  end
end
