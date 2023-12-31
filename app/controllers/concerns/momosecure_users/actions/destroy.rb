# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Destroy
      include Helper

      def destroy
        render_unauthorized('Not Authorized.') unless profile_owner?

        if user.destroy
          render_success('success', user_auth, UserAuthSerializer)
        else
          render_error('Error in deleting: Something went wrong')
        end
      end
    end
  end
end
