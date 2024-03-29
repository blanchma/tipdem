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
      aasm :column => :status do  # defaults to aasm_state
        #on creation
        state :incomplete, :initial => true

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
          transitions :to => :active, :from => [:waiting_approval, :waiting_pay]
        end

         event :disapprove do
          transitions :to => :not_approved, :from => [:waiting_approval]
        end

        event :paid do
          transitions :to => :active, :after => :update_status, :from => [:waiting_pay, :out_of_money]
        end
      end
      aasm_initial_state Proc.new { |campaign| campaign.errors.any?  ? :incomplete : :waiting_pay  }
    end

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
      status != "active"
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
      status
    end
  end
end
