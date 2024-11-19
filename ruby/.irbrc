if Object.const_defined?(:ApplicationRecord)
  if ApplicationRecord.instance_methods(false).include?(:inspect)
    class ApplicationRecord
      def inspect
        # We check defined?(@attributes) not to issue warnings if the object is
        # allocated but not initialized.
        inspection = if defined?(@attributes) && @attributes
          attribute_names.filter_map do |name|
            if _has_attribute?(name)
              "#{name}: #{attribute_for_inspect(name)}"
            end
          end.join(", ")
        else
          "not initialized"
        end

        "#<#{self.class} #{inspection}>"
      end
    end
  end
end
