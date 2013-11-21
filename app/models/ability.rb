class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.is?(:admin)
      # admin
      can :manage, :all
    elsif user.is?(:manager)
      # manager
      can :manage, Message
      can :manage, Product
    elsif user.is?(:user)
      # user
      can :create, Message
      can :update, Message do |message|
        message.user_id == user.id
      end
      can :destroy, Message do |message|
        message.user_id == user.id
      end
      basic_read_only
    end
  end

  protected
    def basic_read_only
      can :read, Message
      can :read, Product
    end
end