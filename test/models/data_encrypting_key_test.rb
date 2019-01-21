require 'test_helper'

class DataEncryptingKeyTest < ActiveSupport::TestCase

  test ".generate!" do
    assert_difference "DataEncryptingKey.count" do
      key = DataEncryptingKey.generate!
      assert key
    end
  end

  test "#create fails when key is blank" do
    new_key = DataEncryptingKey.create(primary: true)
    new_key.save
    assert_not new_key.save
    assert_includes new_key.errors[:key], "can't be blank"
  end

  test "#create fails when iv is blank" do
    new_key = DataEncryptingKey.create(key:"thisiskey", primary: true)
    new_key.encrypted_key_iv = nil
    assert_not new_key.save
    assert_includes new_key.errors[:encrypted_key_iv], "can't be blank"
  end

  test "#create succeeds when attributes are valid" do
    new_key = DataEncryptingKey.
        create(
            key: "thisisakey",
            primary: true
        )
    assert new_key.save
  end
end
