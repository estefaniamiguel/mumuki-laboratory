module WithOrganization
  def set_organization!
    Organization.find_by!(name: params[:organization]).switch!
  end

  def visit_organization!
    current_user.visit!(Organization.current)
  end
end
