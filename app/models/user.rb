require 'bcrypt'

class User < ApplicationRecord
    attr_reader :password

    validates :user_name, presence: true, uniqueness: true
    validates :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: { message: 'Password can\'t be blank' }
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    has_many :cats,
        class_name: 'Cat',
        foreign_key: :user_id,
        primary_key: :id,
        dependent: :destroy

    has_many :requests,
        class_name: 'CatRentalRequest',
        foreign_key: :user_id,
        primary_key: :id,
        dependent: :destroy


    def self.find_by_credentials(user_name, password)
        user = User.find_by(username: username)
        return nil if user.nil?
        user.password_digest.is_password?(password) ? user : nil
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token    
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def owns_cat?(cat)
        cat.user_id == self.id
    end

    private
    def ensure_session_token
        self.session_token ||= SecureRandom.urlsafe_base64(16)
    end

















end