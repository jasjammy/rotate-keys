
class DataEncryptionKeysController < ApplicationController
  @job_id = 0

  def rotate
    @job_id = EncryptStringsWorker.perform_async
    render status: :ok, json: { job_id: @job_id }
  end

  def status
    workers = Sidekiq::Workers.new
    if workers == 0 then
      @job_id = 0
      render status: 200 , json: { message: "No key rotation queued or in progress" }
    end

    message = ""
    if Sidekiq::Status::queued? @job_id
      message = "Key rotation has been queued"
    elsif Sidekiq::Status::working? @job_id
      message = "Key rotation is in progress"
    end

    render status: 200 , json: { message: message }
  end
end
