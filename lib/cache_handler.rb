# frozen_string_literal: true

module CacheHandler
  class VerificationCode
    attr_accessor :user_block, :code, :wait_time, :code_match, :tries_left

    VERIFY_ATTEMPT = 5
    RESEND_ATTEMPT = 5
    CODE_LENGTH = 6
    RELEASE_BLOCK_TIME = 2

    def initialize(tag, id, phone_no)
      @id = id
      @phone_no = phone_no
      @cache_key = "user_#{id}_#{phone_no}_#{tag}"
    end

    def get_code
      # this method returns the three values,
      # 1- [true, false] if user is blocked
      # 2- code - if result is false
      # 3- wait time - if user is blocked

      # Get cached value
      verify_cache = Rails.cache.read(@cache_key)

      return if verify_cache.blank?

      # Check if user is temporary blocked
      if verify_cache[:is_blocked] == true
        self.user_block = true
        self.wait_time = ((Time.now.utc - verify_cache[:release_block_time]) / 1.minute).round(1)
      else
        self.code = verify_cache[:code]
      end
    end

    def verify_code(code, check_limit = true)
      # this method returns the three values,
      # 1- [true, false] if user is blocked
      # 2- code_match?
      # 3- tries_left
      # 4- wait time
      # if check_limit is true, we make sure user is not hitting limit for verify code.

      self.tries_left = VERIFY_ATTEMPT

      # Get cached value
      verify_cache = Rails.cache.read(@cache_key)

      # #Return if cache does not exists
      return if verify_cache.blank?

      # Check if user is temporary blocked
      if verify_cache[:is_blocked] == true
        self.user_block = true
        self.wait_time = ((verify_cache[:release_block_time].to_time - Time.now.utc) / 1.minute).round(1)
        return
      end

      # #Check if code matches
      if code == verify_cache[:code].to_s
        self.code_match = true
      else
        # Update the respective count based on the request type
        verify_cache[:verify_try_count] += 1

        # #Check if any of the count has exceeded limit. If yes block the user temporarily till cache expires.
        if check_limit && verify_cache[:verify_try_count] >= VERIFY_ATTEMPT
          verify_cache[:is_blocked] = true
          verify_cache[:release_block_time] = (Time.zone.now + RELEASE_BLOCK_TIME.minutes)

          self.user_block = true
          self.wait_time = RELEASE_BLOCK_TIME.round(1)
        end

        Rails.cache.write(@cache_key, verify_cache, expires_in: 1.day)

        self.tries_left = (VERIFY_ATTEMPT - verify_cache[:verify_try_count])
      end

      nil
    end

    def generate_code
      # this method returns the three values,
      # 1- [true, false] if user is blocked
      # 2- code - if result is false
      # 3- wait time

      # Get cached value
      verify_cache = Rails.cache.read(@cache_key)

      # #Check if verification cache exists
      if verify_cache.blank?
        # #If it is new code request and cache does not exist create new verification hash
        self.code = case CODE_LENGTH
                    when 6
                      rand(100_000..999_999)
                    else
                      rand(1000..9999)
                    end

        verify_cache = {
          id: @id,
          code:,
          resend_count: 0,
          verify_try_count: 0,
          is_blocked: false,
          release_block_time: nil
        }

        Rails.cache.write(@cache_key, verify_cache, expires_in: 10.minutes)

        return
      end

      # Check if user is temporary blocked
      if verify_cache[:is_blocked] == true
        self.user_block = true
        self.wait_time = ((verify_cache[:release_block_time].to_time - Time.now.utc) / 1.minute).round(1)
      end

      # Update the respective count based on the request type
      verify_cache[:resend_count] += 1
      self.code = verify_cache[:code]

      # #Check if any of the count has exceeded limit. If yes block the user temporarily till cache expires.
      if retries_exceeded?
        verify_cache[:is_blocked] = true
        verify_cache[:release_block_time] = (Time.zone.now + RELEASE_BLOCK_TIME.minutes)

        self.user_block = true
        self.code = ''
        self.wait_time = RELEASE_BLOCK_TIME.round(1)
      end

      # Update cache with new values
      Rails.cache.write(@cache_key, verify_cache, expires_in: 10.minutes)

      self.tries_left = (RESEND_ATTEMPT - verify_cache[:resend_count])
    end

    def delete_code
      Rails.cache.delete(@cache_key)
    end

    def retries_exceeded?
      verify_cache = Rails.cache.read(@cache_key)
      verify_cache[:resend_count] >= RESEND_ATTEMPT
    end
  end
end
