class Event::Submission < Event::Base
  def initialize(assignment)
    @assignment = assignment
  end

  def queue_name
    'submissions'
  end

  def event_json
    @assignment.
      as_json(except: [:exercise_id, :submission_id, :id, :submitter_id, :solution, :created_at, :updated_at],
              include: {
                guide: {
                  only: [:slug, :name],
                  include: {
                    lesson: {only: [:number]},
                    language: {only: [:name]}},
                  },
                exercise: {only: [:id, :name, :number]},
                submitter: {only: [:name, :email, :image_url], methods: [:social_id]}}).
      deep_merge(
            'id' => @assignment.submission_id,
            'created_at' => @assignment.updated_at,
            'content' => @assignment.solution,
            'guide' => { 'parent' => {
                          'type' => @assignment.exercise.navigable_parent.class.to_s,
                          'name' => @assignment.exercise.navigable_parent.name,
                          'position' => @assignment.exercise.navigable_parent.try(:number),
                          'chapter' => @assignment.guide.chapter.as_json(only: [:id], methods: [:name])
                        }})
  end
end
