require 'spec_helper'

feature 'menu bar' do
  let(:chapter) { create(:chapter, lessons: [create(:lesson)]) }
  let(:book) { create(:book, chapters: [chapter], name: 'private', slug: 'mumuki/mumuki-the-private-book') }
  let(:private_organization) { create(:organization, name: 'private', book: book) }
  let(:organization) do
    create(:organization,
           name: 'private',
           book: create(:book, name: 'private', slug: 'mumuki/mumuki-the-private-book'))
  end

  before { organization.switch! }

  context 'anonymous user' do
    scenario 'should not see any app' do
      visit "/#{organization.name}"

      expect(page).not_to have_text('Office')
      expect(page).not_to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end
  end

  context 'logged user' do
    let(:visitor) { create(:user) }
    let(:student) { create(:user, permissions: {student: 'private/*'}) }
    let(:teacher) { create(:user, permissions: {student: 'private/*', teacher: 'private/*'}) }
    let(:writer) { create(:user, permissions: {student: 'private/*', writer: 'private/*'}) }
    let(:janitor) { create(:user, permissions: {student: 'private/*', janitor: 'private/*'}) }
    let(:owner) { create(:user, permissions: {student: 'private/*', owner: 'private/*'}) }

    scenario 'visitor should not see any app' do
      set_current_user! visitor

      visit "/#{organization.name}"

      expect(page).not_to have_text('Office')
      expect(page).not_to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end

    scenario 'teacher should see classroom' do
      set_current_user! teacher

      visit "/#{organization.name}"

      expect(page).not_to have_text('Office')
      expect(page).to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end

    scenario 'janitor should see office' do
      set_current_user! janitor

      visit "/#{organization.name}"

      expect(page).to have_text('Office')
      expect(page).to have_text('Classroom')
      expect(page).not_to have_text('Bibliotheca')
    end
    scenario 'writer should see bibliotheca' do
      set_current_user! writer

      visit "/#{organization.name}"

      expect(page).not_to have_text('Office')
      expect(page).not_to have_text('Classroom')
      expect(page).to have_text('Bibliotheca')
    end
    scenario 'owner should see all' do
      set_current_user! owner

      visit "/#{organization.name}"
      expect(page).to have_text('Office')
      expect(page).to have_text('Classroom')
      expect(page).to have_text('Bibliotheca')
    end
  end
end
