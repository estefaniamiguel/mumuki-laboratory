require 'spec_helper'

feature 'Exercise Flow' do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }
  let(:gobstones) { create(:gobstones) }

  let!(:problem_1) { build(:problem, name: 'Succ1', description: 'Description of Succ1', layout: :input_right, hint: 'lala') }
  let!(:problem_2) { build(:problem, name: 'Succ2', description: 'Description of Succ2', layout: :input_right, editor: :hidden, language: gobstones) }
  let!(:problem_3) { build(:problem, name: 'Succ3', description: 'Description of Succ3', layout: :input_right, editor: :upload, hint: 'lele') }
  let!(:problem_4) { build(:problem, name: 'Succ4', description: 'Description of Succ4', layout: :input_bottom, extra: 'x = 2') }
  let!(:problem_5) { build(:problem, name: 'Succ5', description: 'Description of Succ5', layout: :input_right, editor: :upload, hint: 'lele', language: gobstones) }
  let!(:playground_1) { build(:playground, name: 'Succ5', description: 'Description of Succ4', layout: :input_right) }
  let!(:playground_2) { build(:playground, name: 'Succ6', description: 'Description of Succ4', layout: :input_right, extra: 'x = 4') }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
        problem_1, problem_2, problem_3, problem_4, problem_5, playground_1, playground_2
      ])
    ]) }

  before { reindex_current_organization! }

  context 'not logged user' do
    scenario 'visit exercise from search' do
      visit '/test/exercises'

      click_on 'Succ1'

      expect(page).to have_text('Succ1')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by slug' do
      visit "/test/exercises/#{problem_1.slug}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/test/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end
  end


  context 'logged user' do
    before { set_current_user! user }

    scenario 'visit exercise by slug' do
      visit "/test/exercises/#{problem_1.slug}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by id, editor right layout' do
      visit "/test/exercises/#{problem_1.id}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, no editor layout, no hint, not queriable language' do
      visit "/test/exercises/#{problem_2.id}"

      expect(page).to have_text('Succ2')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/test/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')
    end

    scenario 'visit exercise by id, upload layout, not queriable language' do
      visit "/test/exercises/#{problem_5.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')
    end

    scenario 'visit exercise by id, input_bottom layout, extra, no hint' do
      visit "/test/exercises/#{problem_4.id}"

      expect(page).to have_text('Succ4')
      expect(page).to have_text('x = 2')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit playground by id, no extra, no hint' do
      visit "/test/exercises/#{playground_1.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit playground by id, with extra, no hint' do
      visit "/test/exercises/#{playground_2.id}"

      expect(page).to have_text('Succ6')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to have_text('x = 4')
      expect(page).to_not have_selector('.upload')
    end
  end
end
