Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins "http://localhost:5173", "http://localhost:3004"
        resource "/api/*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: false
    end
end