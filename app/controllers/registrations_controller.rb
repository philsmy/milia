module Milia

  class RegistrationsController < Devise::RegistrationsController

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# create -- intercept the POST create action upon new sign-up
# new tenant account is vetted, then created, then proceed with devise create user
# ------------------------------------------------------------------------------
    def create
      
      sign_out_session!

      @tenant = Tenant.create_new_tenant(params)
      if @tenant.errors.empty?   # tenant created
        
        initiate_tenant( @tenant )    # first time stuff for new tenant
        super   # do the rest of the user account creation
      
      else
        @user = User.new(params[:user])
        render :action => 'new'
      end
            
    end   # def create

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
  private
# ------------------------------------------------------------------------------
# sign_out_session! -- force the devise session signout
# ------------------------------------------------------------------------------

    def sign_out_session!()
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name) if user_signed_in?
    end

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

  end   # class Registrations

end  # module Milia