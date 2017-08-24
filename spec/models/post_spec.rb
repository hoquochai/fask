require "rails_helper"

RSpec.describe Post, type: :model do
  let(:user){FactoryGirl.create :user}
  let(:topic){FactoryGirl.create :topic}
  let(:post){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id}
  let(:post_x){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, created_at: DateTime.new(2016,01,01)}
  let(:post_y){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, created_at: DateTime.new(2016,02,01)}
  let(:post_z){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, created_at: DateTime.new(2016,03,01)}
  let(:post_1){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, count_view: 1}
  let(:post_2){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, count_view: 2}
  let(:post_3){FactoryGirl.create :post, user_id: user.id, topic_id: topic.id, count_view: 3}
  let(:answer_x){FactoryGirl.create :answer, user_id: user.id, post_id: post_x.id, created_at: DateTime.new(2016,01,01)}
  let(:answer_y){FactoryGirl.create :answer, user_id: user.id, post_id: post_y.id, created_at: DateTime.new(2016,02,01)}
  let(:answer_z){FactoryGirl.create :answer, user_id: user.id, post_id: post_z.id, created_at: DateTime.new(2016,03,01)}
  let(:comment_x){FactoryGirl.create :comment, user_id: user.id, commentable_id: post_x.id, commentable_type: "Post", created_at: DateTime.new(2016,01,01)}
  let(:comment_y){FactoryGirl.create :comment, user_id: user.id, commentable_id: post_y.id, commentable_type: "Post", created_at: DateTime.new(2016,02,01)}
  let(:comment_z){FactoryGirl.create :comment, user_id: user.id, commentable_id: post_z.id, commentable_type: "Post", created_at: DateTime.new(2016,03,01)}

  context "association" do
    it{is_expected.to have_many :comments}
    it{is_expected.to have_many :answers}
    it{is_expected.to have_many :reactions}
    it{is_expected.to have_many :clips}
    it{expect have_and_belong_to_many :tags}

    it{expect belong_to :user}
    it{is_expected.to belong_to :work_space}
    it{expect belong_to :topic}
  end

  context "validates" do
    it {is_expected.to validate_presence_of :title}
    it {is_expected.to validate_presence_of :content}

    it do
      is_expected.to validate_length_of(:title)
        .is_at_most Settings.post.max_title
    end

    it do
      is_expected.to validate_length_of(:title)
        .is_at_least Settings.post.min_title
    end

    it "is valid with a valid title" do
      expect(FactoryGirl.build(:post, user_id: user.id, topic_id: topic.id,
        title: "a" * Settings.post.max_title)).to be_valid
    end

    it "is invalid with a long title" do
      expect(FactoryGirl.build(:post, user_id: user.id, topic_id: topic.id,
        title: "a" * (Settings.post.max_title + 1))).not_to be_valid
    end

    it "is invalid with a short title" do
      expect(FactoryGirl.build(:post, user_id: user.id, topic_id: topic.id,
        title: "a" * (Settings.post.min_title - 1))).not_to be_valid
    end

    it "is invalid with a nil title" do
      expect(FactoryGirl.build(:post, user_id: user.id, topic_id: topic.id,
        title: nil)).not_to be_valid
    end
  end

  context "scope" do
    it "scope get post by topic by topic invalid" do
      expect(Post.get_post_by_topic(0).count).to eq 0
    end

    it "scope get post by topic by topic valid" do
      post
      expect(Post.get_post_by_topic(topic.id).count).to eq 1
    end

    it "scope create_at DESC by_date_newest" do
      expect_result = [post_z, post_y, post_x]
      expect(Post.newest).to eq(expect_result)
    end

    it "scope count_view DESC by_popular" do
      expect_result = [post_3, post_2, post_1]
      expect(Post.popular).to eq(expect_result)
    end

    it "scope recently_answer" do
      answer_x
      answer_y
      answer_z
      expect_result = [post_z, post_y, post_x]
      expect(Post.recently_answer).to eq(expect_result)
    end

    it "scope no_answer" do
      post
      expect(Post.no_answer.count).to eq 1
    end

    it "scope recently_comment" do
      comment_x
      comment_y
      comment_z
      expect_result = [post_z, post_y, post_x]
      expect(Post.recently_comment).to eq(expect_result)
    end
  end
end
