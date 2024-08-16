class PizzasController < ApplicationController
  before_action :set_pizza, only: [:show, :edit, :update, :destroy]

  def index
    @pizzas = Pizza.all
  end

  def new
    @pizza = Pizza.new
    @pizza.toppings.build
  end

  def create
    @pizza = Pizza.new(pizza_params)

    if @pizza.save
      redirect_to @pizza
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pizza.toppings.build
  end

  def update
    if @pizza.update(pizza_params)
      redirect_to @pizza
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pizza.destroy

    redirect_to pizzas_path, status: :see_other
  end

  private

    def pizza_params
      params.require(:pizza)
            .permit(:name, :description, topping_ids: [], toppings_attributes: [:name, :id, :_destroy])
    end

    def set_pizza
      @pizza = Pizza.find(params[:id])
    end
end
