# frozen_string_literal: true

module Mutations
  module Tickets
    class ContemplateTicket < Mutations::BaseMutation
      description 'Contemplate Ticket'

      argument :quantity, Int, required: false
      argument :ticket_id, Int, required: false
      argument :promotion_id, Int, required: true

      field :success, Boolean, null: true
      field :completed_challenges, [Types::Challenges::ChallengeType], null: true
      field :errors, String, null: true

      def resolve(input)
        @ticket_id = input[:ticket_id]
        @promotion_id = input[:promotion_id]
        @quantity = input[:quantity] || 1
        @completed_challenges = []

        validate!

        tickets.update_all(contempled_promotion_id: promotion.id)
        upade_progress!

        { success: true, completed_challenges: completed_challenges }
      rescue GraphQL::ExecutionError, ActiveRecord::ActiveRecordError => e
        { success: false, errors: e.to_s }
      end

      private

      attr_accessor :ticket_id, :promotion_id, :quantity, :completed_challenges

      def upade_progress!
        return if challenges.blank?

        # move to service
        ChallengeProgress.transaction do
          challenges.each do |challenge|
            challenge_progress = find_or_create_progress(challenge)
            next if challenge_progress.completed_datetime.present?

            challenge_progress.increanse_progress(quantity)

            if challenge_progress.progress >= challenge.goal
              challenge_progress.completed_datetime = Time.zone.now
              # trigers chalenge goal
              @completed_challenges << challenge
            end

            challenge_progress.save!
          end
        end
      end

      def find_or_create_progress(challenge)
        ChallengeProgress.find_by(challenge: challenge, customer: customer) ||
          ChallengeProgress.new(challenge: challenge, customer: customer)
      end

      def tickets
        @tickets ||= begin
                       ticket_relation = customer.wallet.tickets.where(promotion_type: promotion.promotion_type)
                       ticket_relation = ticket_relation.where(partner_id: promotion.partner)
                       ticket_relation = ticket_relation.where(id: ticket_id) if ticket_id
                       ticket_relation.limit(quantity)
                     end
      end

      def challenges
        @challenges ||= Challenge.where(promotion_type: promotion.promotion_type)
      end

      def promotion
        @promotion ||= Promotion.find(promotion_id)
      end

      def customer
        @customer ||= context[:current_user].source
      end

      def validate!
        raise(GraphQL::ExecutionError, 'invalid user') unless customer.is_a?(Customer)
        raise(GraphQL::ExecutionError, '30 is the ticket limit') if quantity > 30
        raise(GraphQL::ExecutionError, 'fill just quantity or ticket id') if quantity > 1 && ticket_id
        raise(GraphQL::ExecutionError, 'invalid ticket') if tickets.none? && ticket_id
        raise(GraphQL::ExecutionError, 'You do\'t have tickets enough') if tickets.size != quantity
      end
    end
  end
end
