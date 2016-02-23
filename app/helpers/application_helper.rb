module ApplicationHelper

  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]), class:"btn btn-primary btn-sm")
      if current_user.admin?
        del =  link_to('Destroy', item, method: :delete,
                  data: { confirm: 'Are you sure?' }, class:"btn btn-danger btn-sm" )
      end
      raw("#{edit}#{del}")

    end
  end

  def round(param)
    rounded = number_with_precision(param, precision:1)
  end

end
