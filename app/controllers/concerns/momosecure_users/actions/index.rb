# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Index
      include Helper

      def index
        results = apply_scopes(UserAuth.includes(:user)).where(user_type: model).all
        users = optional_paginate(results)
        render_success_paginated(users, UserAuthSerializer)
      end
    end
  end
end
