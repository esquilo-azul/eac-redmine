# frozen_string_literal: true

class Object
  ::EacFs::Contexts::TYPES.each do |type|
    define_method "fs_#{type}" do
      oid = fs_object_id_by_type(type)
      oid = [oid.to_s] unless oid.is_a?(::Enumerable)
      oid.inject(send("fs_#{type}_parent")) { |a, e| a.child(e.to_s) }
    end

    define_method "fs_#{type}_parent" do
      self.class.send("fs_#{type}")
    end
  end

  # @return [String, Array<String>]
  def fs_object_id
    raise 'Abstract method hit'
  end

  def fs_object_id_by_type(type)
    method = "fs_#{type}_object_id"
    respond_to?(method) ? send(method) : fs_object_id
  end
end
