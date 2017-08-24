require "rails_helper"

RSpec.describe Tag, type: :model do

  context "association" do
    it{expect have_and_belong_to_many :posts}
  end
end
