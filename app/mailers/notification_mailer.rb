class NotificationMailer < ApplicationMailer

    default from: "varunvatsal963@gmail.com"

    def welcome_email(user)
        @user = user
        mail(to: "varunvatsal963@gmail.com", subject: "welcome to optistock")
    end

    def low_inventory_warning(inventory)
        @inventory = inventory
        mail(to: "varunvatsal963@gmail.com", subject: "inventory warning!")
    end
end
