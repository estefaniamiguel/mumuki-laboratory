class HomeController < ApplicationController
  def index
    if current_user? && current_user.permissions.present?
      redirect_to organizations_path
    else
      redirect_to [Organization.central, Organization.central.book]
    end
  end
end
