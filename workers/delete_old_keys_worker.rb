class DeleteOldKeysWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform
    DataEncryptingKey.where(primary: false) do |record|
      record.destroy
    end
  end
end