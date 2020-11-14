class CatsController < ApplicationController
    before_action :require_user!, only: %i(new create edit update)
    before_action :require_cat_ownership!, only: %i(edit update)
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    # @cat = current_user.cats.new(cat_params)
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end
  
  private

  def current_cat
      @cat ||=
      Cat.find(params[:id])
  end
  
  def require_cat_ownership!
      return if current_cat.user_id == current_user.id
      redirect_to cat_url(current_cat)
  end

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
