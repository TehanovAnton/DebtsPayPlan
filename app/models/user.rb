# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :group_members,
           as: :group_memberable,
           dependent: :destroy,
           class_name: 'GroupMember'
  has_many :groups,
           through: :group_members

  has_many :group_owner_members,
           as: :group_memberable,
           dependent: :destroy,
           class_name: 'GroupOwnerMember'
  has_many :own_groups,
           through: :group_owner_members,
           source: :group

  has_many :costs,
           as: :costable,
           dependent: :destroy

  has_many :debts,
           dependent: :destroy

  has_many :group_user_step_states,
           dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  def group_user_costs(group)
    costs.joins(:group)
         .where(
           costs: { costable_type: self.class.name, costable_id: id },
           groups: { id: group.id }
         )
  end

  def group_rejection_notifications(group)
    Notification.where(
      id: notifications.where(type: GroupJoinRejectionNotification.name)
                        .map { |n| n if n.params[:group].id == group.id }
                        .compact
                        .pluck(:id)
    )
  end

  def group_user_costs_sum(group); end

  def group_user_debt(group)
    debts.joins(:group)
         .where(group_members: { group_id: group.id })
         .first
  end
end
