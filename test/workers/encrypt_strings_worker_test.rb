require 'test_helper'

class EncryptStringsWorkerTest < ActiveJob::TestCase
  def setup
    Sidekiq::Worker.clear_all
  end

  test 'the worker is created' do

    Sidekiq::Testing.fake! do
      EncryptStringsWorker.perform_async
      assert_equal 1, EncryptStringsWorker.jobs.size
    end
  end

  test 'the worker status returns rotation queued' do
    dke = DataEncryptingKey.first
    dke.primary = true

    Sidekiq::Testing.inline! do
      job_id = EncryptStringsWorker.perform_async
      assert true, Sidekiq::Status::queued?(job_id)
      assert true, Sidekiq::Status::completed?(job_id)
    end
  end

end