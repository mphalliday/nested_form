module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder
    def link_to_add(name, association, model_object = nil)
      @fields ||= {}
      model_object ||= object.class.reflect_on_association(association).klass.new
      options = @fields[:options].merge(:child_index => "new_#{association}")
      data_template = CGI.escapeHTML(fields_for(association, model_object, options, &@fields[association]))
      @template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association, "data-fields" => data_template)
    end

    def link_to_remove(name)
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      @fields[:options] = args.last.is_a?(Hash) ? args.last : {}
      @fields[:association_name] = association
      super
    end

    def fields_for_nested_model(name, association, options, block)
      wrapper = options[:wrapper_tag] || :div
      child_index = options[:child_index] || @nested_child_index["#{object_name}[#{@fields[:association_name]}_attributes]"]
      @template.content_tag(wrapper, super, :class => 'fields', 'data-row' => child_index)
    end
  end
end
