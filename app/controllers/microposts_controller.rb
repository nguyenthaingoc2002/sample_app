class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def index
    # Fix pagy va reload loi khi submit form bi loi
    redirect_to root_path page: params[:page]
  end

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "microposts.created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed.newest
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted_successfully"
    else
      flash[:danger] = t "microposts.delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.not_found_or_not_yours"
    redirect_to request.referer || root_url
  end
end
