class Import < ActiveRecord::Base
  extend WithAsyncAction
  include WithStatus

  belongs_to :guide

  schedule_on_create ImportGuideJob

  def run_import!
    run_update! do
      guide_json = JSON.parse RestClient.get(guide.url)
      import_from_json! guide_json
      {result: '', status: :passed}
    end
  end

  def import_from_json!(json)
    guide.import_from_json!(json)
  end
end
