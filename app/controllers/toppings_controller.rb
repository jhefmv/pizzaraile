class ToppingsController < ApplicationController
  before_action :set_topping, only: [:show, :edit, :update, :destroy]

  def index
    @toppings = Topping.all
  end

  def new
    @topping = Topping.new
  end

  def create
    @topping = Topping.new(topping_params)

    if @topping.save
      redirect_to @topping
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @topping.update(topping_params)
      redirect_to @topping
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @topping.destroy

    redirect_to toppings_path, status: :see_other
  end

  private

    def set_topping
      @topping = Topping.find(params[:id])
    end

    def topping_params
      params.require(:topping).permit(:name)
    end
end
