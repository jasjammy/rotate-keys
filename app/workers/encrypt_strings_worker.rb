class EncryptStringsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :queue => :background

  def perform
    # find the primary key and make it false
    if !DataEncryptingKey.primary.nil?
      DataEncryptingKey.primary.update_attributes!(primary: false)
    end

    # generate a new key
    new_key = DataEncryptingKey.generate!(primary: true)

    # reencrypt all records in the database
    EncryptedString.all.in_batches.each do |record|
      record.first.reencrypt!(new_key)
    end
  end
end
