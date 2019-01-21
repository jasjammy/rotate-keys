require 'test_helper'

class EncryptedStringTest < ActiveSupport::TestCase

  test '#create succeeds with valid attributes and primary key present' do
    primary_key = DataEncryptingKey.generate!(primary: true)
    es = EncryptedString.
        create(
            value: "decrypted string",
            data_encrypting_key_id:primary_key.id
        )
    assert es.save
  end

  test '#create does not succeed when there is no primary Data Encrypting Key' do
    assert_raises {
      EncryptedString.
        create(
            value: "decrypted string"
        )
    }
  end

  test "#update reencrypts the value with new primary key" do
    primary_key = DataEncryptingKey.generate!(primary: true)
    es = EncryptedString.
        create(
            value: "decrypted string",
            data_encrypting_key_id:primary_key.id
        )
    primary_key.primary = false
    primary_key.save
    encrypted_value = es.encrypted_value
    another_primary_key = DataEncryptingKey.generate!(primary: true)
    another_primary_key.save
    assert_not_same another_primary_key.key, es.encryption_key

    assert es.reencrypt!(another_primary_key)
    assert_equal another_primary_key.key, es.encryption_key
    assert_not_equal encrypted_value, es.encrypted_value
  end
end
