class UserFeaturesController < ApplicationController

  # GET /user_features
  # GET /user_features.json
  # def index
  #   @user_features = UserFeature.all
  # end

  # GET /user_features/1
  # GET /user_features/1.json
  def show
    @user = User.find(params[:id])
    @badges = User::Badges
  end

  # GET /user_features/new
  # def new
  #   @user_feature = UserFeature.new
  # end

  # GET /user_features/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /user_features
  # POST /user_features.json
  # def create
  #   @user_feature = UserFeature.new(user_feature_params)

  #   respond_to do |format|
  #     if @user_feature.save
  #       format.html { redirect_to @user_feature, notice: 'User feature was successfully created.' }
  #       format.json { render :show, status: :created, location: @user_feature }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user_feature.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /user_features/1
  # PATCH/PUT /user_features/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if not @user.earned(2) && @user.speed.nil? && @user.guide.nil?
        if @user.update_attributes(speed: params[:speed], guide: params[:guide]) && @user.add_badge(2)
          title = User::Badges[2][:title]
          format.html { redirect_to root_url, notice: "You've earned the #{title} badge" }
          format.json { render :show, status: :ok, location: "/user_features/#{@user.id}" }
        else
          format.html { render :edit }
          format.json { render json: @user_feature.errors, status: :unprocessable_entity }
        end
      else 
        if @user.update_attributes(speed: params[:speed], guide: params[:guide])
          format.html { redirect_to root_url, notice: 'User feature was successfully updated.' }
          format.json { render :show, status: :ok, location: "/user_features/#{@user.id}" }
        else
          format.html { render :edit }
          format.json { render json: @user_feature.errors, status: :unprocessable_entity }
        end
      end 
    end
  end

  # DELETE /user_features/1
  # DELETE /user_features/1.json
  # def destroy
  #   @user_feature.destroy
  #   respond_to do |format|
  #     format.html { redirect_to user_features_url, notice: 'User feature was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_user_feature
    #   @user = User.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def user_feature_params
    #   params.fetch(:user_feature, {})
    # end
end
