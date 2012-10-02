module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder
    def link_to_add(name, association, model_object = nil, html_options = {})
      @fields ||= {}
      model_object ||= object.class.reflect_on_association(association).klass.new
      options = @fields[:options].merge(:child_index => "new_#{association}")
      data_template = CGI.escapeHTML(fields_for(association, model_object, options, &@fields[association])).html_safe
      link_options = { :class => "add_nested_fields", "data-association" => association, "data-fields" => data_template }
      link_options[:class] = "#{link_options[:class]} #{html_options.delete(:class)}"
      @template.link_to(name, "javascript:void(0)", link_options.merge(html_options))
    end

    def link_to_remove(name, html_options = {})
    	link_options = { :class => "remove_nested_fields" }
      link_options[:class] = "#{link_options[:class]} #{html_options.delete(:class)}"
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", link_options.merge(html_options))
    end

    def fields_for_with_nested_attributes(association_name, association, options, block)
      @fields ||= {}
      @fields[association_name] = block
      @fields[:options] = options.is_a?(Hash) ? options : {}
      @fields[:association_name] = association_name
      super
    end

    def fields_for_nested_model(name, association, options, block)
      wrapper = options[:wrapper_tag] || :div
      child_index = options[:child_index] || @nested_child_index["#{object_name}[#{@fields[:association_name]}_attributes]"]
      @template.content_tag(wrapper, super, :class => 'fields', 'data-row' => child_index)
    end
  end
end
