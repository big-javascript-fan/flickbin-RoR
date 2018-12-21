# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      ApplicationMailer::three_days_after_confirmation(resource).deliver_later(wait: 3.minutes)
      ApplicationMailer::four_days_after_confirmation(resource).deliver_later(wait: 4.minutes)
      ApplicationMailer::five_days_after_confirmation(resource).deliver_later(wait: 5.minutes)
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
  end

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    root_path
  end
end
