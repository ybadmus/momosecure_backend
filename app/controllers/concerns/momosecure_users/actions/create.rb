# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Create
      include Helper

      def create
        user = model.new(user_params)

        if user.save
          render_created('Successfully created', user.user_auth, UserAuthSerializer)
        else
          render_error(error_messages(user.errors.full_messages))
        end
      end
    end
  end
end
