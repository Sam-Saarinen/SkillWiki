class ApplicationController < ActionController::Base
  
  # Redirects to 'Edit User Features' page if questions haven't been answered
  def after_sign_in_path_for(resource)
    if current_user.speed == nil || current_user.guide == nil
       "/user_features/#{current_user.id}/edit"
    else
       root_url
    end 
  end
  
  # Handles CanCan::AccessDenied error
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, alert: "#{exception.message} You aren't allowed to do this!" }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
  
end
