class Admin::BannedEmailsController < Admin::BaseController

  def index
    @admin_banned_email = AdminBlacklistedEmail.new
    if params[:query]
      @admin_banned_emails = AdminBlacklistedEmail.where(["email LIKE ?", '%' + params[:query] + '%'])
      @admin_banned_emails = @admin_banned_emails.paginate(page: params[:page], per_page: ArchiveConfig.ITEMS_PER_PAGE)
    end
  end

  def new
    @admin_banned_email = AdminBlacklistedEmail.new
  end

  def create
    @admin_banned_email = AdminBlacklistedEmail.new(admin_banned_email_params)

    if @admin_banned_email.save
      flash[:notice] = ts("Email address #{@admin_banned_email.email} added to banned list.")
      redirect_to admin_banned_emails_path
    else
      render action: "index"
    end
  end

  def destroy
    # byebug
    @admin_banned_email = AdminBlacklistedEmail.find(params[:id])
    @admin_banned_email.destroy

    flash[:notice] = ts("Email address #{@admin_banned_email.email} removed from banned list.")
    redirect_to admin_banned_emails_path
  end

  private

  def admin_banned_email_params
    params.require(:admin_blacklisted_email).permit(
      :email
    )
  end
end
