Rails.application.config.session_store :cookie_store,
  key: '_profitly_session',
  expire_after: 1.week
