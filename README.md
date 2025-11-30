# RabbitMQ with Delayed Message Exchange Plugin

Custom RabbitMQ image with the [delayed message exchange plugin](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange) pre-installed.

## Base Image

`docker.io/library/rabbitmq:4.2.1-management`

## Plugin

The `rabbitmq_delayed_message_exchange` plugin (v4.2.0) is included but **not enabled by default**. This allows developers to opt-in when needed.

### Enable the Plugin
```bash
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

Or via `docker-compose.yml`:
```yaml
services:
  rabbitmq:
    image: cilerler/rabbitmq:4.2.1-management-delayed
    command: >
      bash -c "rabbitmq-plugins enable rabbitmq_delayed_message_exchange && rabbitmq-server"
```

## Usage

Once enabled, declare an exchange with type `x-delayed-message`:
```csharp
channel.ExchangeDeclare(
    exchange: "my-delayed-exchange",
    type: "x-delayed-message",
    durable: true,
    arguments: new Dictionary<string, object>
    {
        { "x-delayed-type", "direct" }
    });
```

Publish messages with the `x-delay` header (milliseconds):
```csharp
var properties = channel.CreateBasicProperties();
properties.Headers = new Dictionary<string, object>
{
    { "x-delay", TimeSpan.FromSeconds(5) }
};

channel.BasicPublish(
    exchange: "my-delayed-exchange",
    routingKey: "my-routing-key",
    basicProperties: properties,
    body: messageBody);
```

## Limitations

- Delayed messages are stored in Mnesia with a single disk replica
- Designed for delays of seconds, minutes, or hours—not days or weeks
- Messages are lost if the node goes down or the plugin is disabled before delivery

See the [official documentation](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange#limitations) for details.
