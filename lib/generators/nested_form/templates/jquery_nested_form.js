$(function() {  
$('form a.add_nested_fields').each(function(i){
  
  $(this).data('fields', $(this).attr('data-fields'));
  $(this).removeAttr('data-fields');
  
}).live('click', function() {
  // Setup
  var assoc   = $(this).attr('data-association');           // Name of child
  //var content = $('#' + assoc + '_fields_blueprint .fields').outerHTML(); // Fields template
  var content = $(this).data('fields');

  // Make the context correct by replacing new_<parents> with the generated ID
  // of each of the parent objects
  var context = ($(this).parents('.fields').children('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

  // context will be something like this for a brand new form:
  // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
  // or for an edit form:
  // project[tasks_attributes][0][assignments_attributes][1]
  if(context) {
    var parent_names = context.match(/[a-z_]+_attributes/g) || [];
    var parent_ids   = context.match(/[0-9]+/g);

    for(i = 0; i < parent_names.length; i++) {
      if(parent_ids[i]) {
        content = content.replace(
          new RegExp('(\\[' + parent_names[i] + '\\])\\[.+?\\]', 'g'),
          '$1[' + parent_ids[i] + ']'
        )
      }
    }
  }

  // Make a unique ID for the new child
  var regexp  = new RegExp('new_' + assoc, 'g');
  var new_id  = new Date().getTime();
  content     = content.replace(regexp, new_id);
  content     = $(content).data('row',new_id);
  var add_fields_link_container = $(this).parents('.add_fields_link_container');
  var field;
  if (add_fields_link_container.length > 0){
  	field = $(content).insertBefore(add_fields_link_container);
  } else {
    field = $(content).insertBefore(this);
  }

  $(this).closest("form").trigger({type: 'nested:fieldAdded', field: field});
  return false;
});

$('form a.remove_nested_fields').live('click', function() {
  var hidden_field = $(this).prev('input[type=hidden]')[0];
  if(hidden_field) {
    hidden_field.value = '1';
  }
  $(this).closest('.fields').hide();
  $(this).closest("form").trigger('nested:fieldRemoved');
  return false;
});
});
