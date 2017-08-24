require "rails_helper"

RSpec.describe User, type: :model do

  context "association" do
    it{expect have_many :posts}
    it{is_expected.to have_many :clips}
    it{is_expected.to have_many :comments}
    it{is_expected.to have_many :reactions}
    it{is_expected.to have_many :answers}

    it{expect have_and_belong_to_many :work_spaces}
    it{expect have_and_belong_to_many :topics}
  end
end
