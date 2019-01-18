
class DataEncryptionKeysController < ApplicationController

  def rotate
    # make old primary key false
    # PrimaryFalseWorker.perform_async
    # make a new primary key
    DataEncryptingKey.create(key: params[:key], primary: true).save
    # re encypt all data
    EncryptStringsWorkerTest.perform_async
    render status: 200, json: { message: "Key Rotation job has been created"}
  end

  def encryption_key_params
    params.permit(:key)
  end

end