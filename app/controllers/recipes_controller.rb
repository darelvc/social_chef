class RecipesController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@recipe = Recipe.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 12)
	end

	def show
		@recipe = Recipe.find(params[:id])
		@comments = @recipe.comments.with_state([:draft, :published])

		#@category = Category.find(params[:id])

		@random_recipe = Recipe.where.not(id: @recipe).order("RANDOM()").first
	end

	def new
		@recipe = Recipe.new
	end

	def create
		#@recipe = Recipe.new(recipe_params)
		#@chef = Chef.find(1)

		@recipe = current_user.recipes.build(recipe_params)

		if @recipe.save
			redirect_to @recipe, notice: "Новый рецепт создан успешно."
		else
			render 'new'
		end
	end

	def edit
		@recipe = Recipe.find(params[:id])
	end

	def update
		@recipe = Recipe.find(params[:id])
		if @recipe.update(recipe_params)
			redirect_to recipe_path(@recipe), notice: "Ваш рецепт обновлен успешно!"
		else
			render 'edit'
		end
	end

	private

	def recipe_params
		params.require(:recipe).permit(:title, :summary, :description, :difficulty, :pre_time, :cook_time, :servers, :recipe_image, :user_id, ingredients_attributes: [:id, :name, :quantity, :_destroy], category_ids: [])
	end

end