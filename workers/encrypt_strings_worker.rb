class EncryptStringsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  # sidekiq_options retry: false

  def perform
    # reencrypt all records in the database

    EncryptedString.in_batches.each do |record|
      record.set_data_encrypting_key
      record.save
    end
  end
end
