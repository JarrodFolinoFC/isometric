# Iso todos
## V1

* e2e regression test with rest
* DB queue version
* github actions
* add citations
* discovery rake task
* final overmind file
* centralize rabbit config
* more logging
* exception manager

* project generator V1
  * person 
    * name
  * UK address

## V2
* strong etags: https://gemdocs.org/gems/grape-app/0.10.1/Grape/App/Helpers/Caching.html
* after_send_confirmation
* make publishers a gem
* code generators
* proper cli https://github.com/rails/thor/wiki 
* jwt




Philosphy: MADPA

* Making Development Fun And Productive For the Common Developer => Developer productivity and fun over performance/edge cases 
* For the everyday developer => Simplify proven patterns and reference them
* Ease of configuration => One Central location for all config with sensible defaults
* Ease of understanding => Code as documentation

Concepts:
* Isometric::Reconcile
* Isometric::Fetch
  * HTTP Fetch
    * ETag cache
* Isometric::Publish
* Isometric::Listen

What is IPC? Inter process communication
What is sem var? Maj.Min.Patch

What is a partition in kafka
What is AMQP or STOMP
What is Avro or Protocol Buffers
What is the robustness principle?
What are the differences between RPI and HTTP?
What is the REST maturity model?
What is GraphQL and Falcor?
What are disadvantages of REST?

|              | 1 to 1                                         | 1 to M                                        |
|--------------|------------------------------------------------|-----------------------------------------------|
| Synchronous  | Request/Response                               |                                               |
| Asynchronous | 1 way notifications and async request/response | Publish/subscribe and Publish/async responses |


## Patterns

### Remote procedure invocation

### Circuit breaker
A circuit breaker acts as a proxy for operations that might fail. The proxy should monitor the number of recent failures that
have occurred, and use this information to decide whether to allow the operation to proceed, or simply return an exception immediately.

The basic idea behind the circuit breaker is very simple. You wrap a protected function call in a circuit breaker object, 
which monitors for failures. Once the failures reach a certain threshold, the circuit breaker trips, 
and all further calls to the circuit breaker return with an error, without the protected call being made at all. 
Usually you'll also want some kind of monitor alert if the circuit breaker trips.

* Client-side discovery
* Self registration
* Server-side discovery
* Third party registration
* Asynchronous messaging
* Transactional outbox
* Transaction log tailing
* Polling publisher