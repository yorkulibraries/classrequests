module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info',
      primary: 'alert-primary',
      secondary: 'alert-secondary',
      dark: 'alert-dark',
      light: 'alert-light'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def page_title(title)
    content_for(:page_title) { h(title.to_s) }
  end

  def active_class(link_path)
    current_page?(link_path) ? 'active font-weight-bold' : ''
  end

  def is_active(status, element)
    if element == 'btn'
     params[:sort] == status ? 'btn-dark active font-weight-bold' : 'btn-light'
   else
     params[:sort] == status ? 'active font-weight-bold' : ''
   end
  end

  def user_avatar(user)
    "https://www.gravatar.com/avatar/ #{Digest::MD5.hexdigest(user.email.downcase)}?default=identicon&size=150"
  end


  def gravatar_for(user)
      if user.email?
          gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
          gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
          image_tag(gravatar_url, alt: user.first_name, class: 'gravatar rounded', height: 24, width: 24)
      else
          puts "<i class='fas fa-user-circle'></i>"
          # image_tag("/img/avatar_default.png", alt: user.name, class: "gravatar")
      end
  end

end
