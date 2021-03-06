require 'securerandom'

class Submission
  attr_accessor :content

  def id
    @id ||= SecureRandom.hex(8)
  end

  def setup_assignment!(assignment)
    assignment.solution = content
    assignment.save!
  end

  def evaluate_against!(exercise)
    try_evaluate_against! exercise
  rescue => e
    {status: :errored, result: e.message}
  end

  def save_results!(results, assignment)
  end
end