# frozen_string_literal: true

module MomosecureUsers
  module Actions
    module Show
      include Helper

      def show
        render_success('success', user_auth, UserAuthSerializer)
      end
    end
  end
end
