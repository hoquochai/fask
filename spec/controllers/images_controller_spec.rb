require "rails_helper"

RSpec.describe ImagesController, type: :controller do
  describe "POST #upload_image" do
    context "when upload not file" do
      before {post :upload_image}
      let(:response_body) {{link: nil}}
      it {expect(subject.status).to eq 200}
      it {expect(subject.response_body).to eq [response_body.to_json]}
    end

    context "when upload success" do
      params = {
        file: Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "images", "default.png")
        )
      }
      before {post :upload_image, params: params}
      it {expect(response).to be_success}
    end
  end

  describe "GET #access_file" do
    context "when access file not exists" do
      before {get :access_file, params: {name: "default.png"}}
      it {expect(response.body).to be_blank}
    end

    context "when upload success" do
      FileUtils.cp(
      File.join(Rails.root, "spec", "support", "images", "default.png"),
      Rails.root.join("public/uploads/floala/default_tmp.png")
      )
      before {get :access_file, params: {name: "default_tmp.png"}}
      it {expect(response).to be_success}
    end
  end
end
