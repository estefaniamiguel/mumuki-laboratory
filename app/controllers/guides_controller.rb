class GuidesController < ApplicationController

  before_action :authenticate!

  def new
    @guide = Guide.new
  end

  def create
    @guide = Guide.new(guide_params.merge(author: current_user))
    @guide.imports.build
    if @guide.save
      redirect_to @guide, notice: t(:guide_created)
    else
      render :new
    end
  end

  def show
    @guide = Guide.find(params[:id])
    @stats = @guide.stats(current_user)
    @next_exercise = @guide.next_exercise(current_user)
  end

  def details
    @guide = Guide.find(params[:id])
  end

  def index
    @q = params[:q]
    @guides = paginated Guide.by_full_text(@q).at_locale
  end

  private

  def guide_params
    params.require(:guide).permit(:github_repository, :name, :description)
  end
end
