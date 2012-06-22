module Campaign
  module Status
    extend ActiveSupport::Concern

    INCOMPLETE = "Incomplete"
    WAITING_APPROVAL = "Waiting approval"
    WAITING_PAY = "Waiting for pay"
    NOT_APPROVED = "Not approved"
    INACTIVE = "Inactive"
    EXPIRED = "Expired"
    NOT_BEGIN_YET = "Not begin yet"
    OUT_OF_MONEY = "Out of money"
    ACTIVE ="Active"
    ERROR ="Error"

    module InstanceMethods

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

      def visitable?
        self.status == ACTIVE
      end

      def editable?
        self.status != INCOMPLETE
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

      def expired?
        have_end_date && Date.today > end_date
      end

      def expired!
        self.status = EXPIRED
      end

      def unstarted?
        Date.today < begin_date
      end

      def unstarted!
        self.status = NOT_BEGIN_YET
      end

      def check_status
        if valid? == false
          self.status = INCOMPLETE
        elsif unstarted?
          unstarted!
        elsif expired?
          expired!
        elsif out_of_money?
          out_of_money!
        else
          #nothing
        end

        return self.status
      end
    end

  end
end