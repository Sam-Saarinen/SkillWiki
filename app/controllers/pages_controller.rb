class PagesController < ApplicationController
  def home
    if user_signed_in? && (not current_user.earned(1))
      current_user.add_badge(1)
    end 
  end

  def about
  end
  
  def contact
  end
  
  def not_found
  end
end
