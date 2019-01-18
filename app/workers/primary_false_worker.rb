class PrimaryFalseWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform
    DataEncryptingKey.where(primary: true) do |record|
      record.primary = false
      record.save
    end
  end

end