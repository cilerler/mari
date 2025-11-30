FROM docker.io/library/rabbitmq:4.2.1-management

# Download the delayed message exchange plugin
ADD --chmod=444 \
    https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v4.2.0/rabbitmq_delayed_message_exchange-4.2.0.ez \
    /opt/rabbitmq/plugins/
