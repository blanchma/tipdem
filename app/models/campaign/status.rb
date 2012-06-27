module Campaign
  module Status
    extend ActiveSupport::Concern

    INCOMPLETE        = "incomplete"
    WAITING_PAY       = "waiting_pay"
    WAITING_APPROVAL  = "waiting_approval"
    UNSTARTED         = "unstarted"
    EXPIRED           = "expired"
    OUT_OF_MONEY      = "out_of_money"
    ACTIVE            = "active"
    INACTIVE          = "inactive"
    ERROR             = "error"

    included do
      include AASM
      aasm :column => :status do  # defaults to aasm_state
        #on creation
        state :incomplete

        #initial states
        state :waiting_pay
        state :waiting_approval
        state :unstarted

        #final states
        state :expired
        state :out_of_money

        #running state
        state :active
        state :error

        event :approve do
          transitions :to => :active, :from => [:waiting_approval]
        end

         event :disapprove do
          transitions :to => :not_approved, :from => [:waiting_approval]
        end

        event :paid do
          transitions :to => :active, :after => :update_status, :from => [:waiting_pay, :out_of_money]
        end
      end
      aasm_initial_state Proc.new { |campaign| campaign.valid? ? campaign.update_status() : :incomplete }

    end

    module InstanceMethods

      def unstarted?
        Date.today < begin_date
      end

      def expired?
        have_end_date && Date.today > end_date
      end

       def visitable?
         active?
       end

      def editable?
        incomplete?
      end

      def inactive?
        return inactive? || incomplete? || waiting_approval? || waiting_pay? || not_approved? || expired? ||
        unstarted? || out_of_money? || error?
      end

      def update_status(_update=false)
        if valid? == false
          status = "incomplete"
        elsif unstarted?
          status = "unstarted"
        elsif expired?
          status = "expired"
        elsif out_of_money?
          status = "out_of_money"
        else

        end
        self.save if _update

        return status
      end
    end

  end
end

=begin
      def incomplete!
        self.status = INCOMPLETE
      end

      def completed!
        self.status = WAITING_PAY
      end

      def paid!
        self.status = WAITING_APPROVAL
      end

      def disapprove!
        self.status = NOT_APPROVED
      end

      def active?
        self.status == ACTIVE
      end


      def approve!
        self.status = ACTIVE
        CampaignStatusMailer.approval(self.id).deliver if status_changed?
      end

      def out_of_money?
        restante = budget.current
        if mode == CampaignMode::PayPerHit
          return budget.pay_per_client_page_hit > restante
        elsif mode == CampaignMode::PayPerClick
          return budget.pay_per_landing_page_hit > restante
        else
          return nil
        end
      end

      def out_of_money!
        self.status = OUT_OF_MONEY
        CampaignStatusMailer.out_of_money(self.id).deliver if status_changed?
      end



      def expired!
        self.status = EXPIRED
      end



      def unstarted!
        self.status = NOT_BEGIN_YET
      end
=end