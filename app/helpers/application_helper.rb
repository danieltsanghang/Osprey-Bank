module ApplicationHelper
  def redirect_to_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404 # Render 404 page
  end
end
