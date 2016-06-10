module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
	if @user.picture
		gravatar_url = "/uploads/"+@user.picture
	end
	image_tag(gravatar_url, alt: user.name, class: "gravatar", style: "width:52px; height: 52px;")
  end

end
