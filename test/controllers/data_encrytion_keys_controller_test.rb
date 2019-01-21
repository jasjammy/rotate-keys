require 'test_helper'

class DataEncryptionKeysControllerTest < ActionController::TestCase

  def setup
    # set up with a primary key in the system
    data_encrypting_keys(:three).primary = true
  end

  test "POST #rotate responds with success" do
    post :rotate

    assert_response :success
  end

  test "POST #rotate creates the job" do
    post :rotate

    assert_response :success

    assert_difference "EncryptStringsWorker.jobs.size" do
      post :rotate
    end
    json = JSON.parse(response.body)
    assert_equal true, Sidekiq::Status::working?(json["job_id"])
  end
end
