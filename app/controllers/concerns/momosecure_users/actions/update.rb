# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Update
      include Helper

      def update
        ActiveRecord::Base.transaction do
          user.update!(user_params)
          render_success('Successfully updated', user_auth.reload, UserAuthSerializer)
        end
      end
    end
  end
end
