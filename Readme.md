# Iso todos
## V1

* Everything from json schema
* e2e regression test with rest
* More abstraction
* DB queue version
* add citations
* discovery rake task
* final overmind file
* centralize rabbit config
* more logging
* exception manager

* project generator V1
  * person 
    * first_name
    * surname
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


Application architecture patterns
Monolithic architecture (40) Microservice architecture (40)
Decomposition patterns
Decompose by business capability (51) Decompose by subdomain (54)

Messaging style patterns
Messaging (85)
Remote procedure invocation (72)

Reliable communications patterns
Circuit breaker (78)

Service discovery patterns
3rd party registration (85) Client-side discovery (83) Self-registration (82) Server-side discovery (85)

Transactional messaging patterns
Polling publisher (98) Transaction log tailing (99) Transactional outbox (98)

Data consistency patterns
Saga (114)

Business logic design patterns
Aggregate (150) Domain event (160) Domain model (150) Event sourcing (184) Transaction script (149)

Querying patterns
API composition (223)
Command query responsibility segregation (228)

External API patterns
API gateway (259)
Backends for frontends (265)

Testing patterns
Consumer-driven contract test (302) Consumer-side contract test (303) Service component test (335)

Security patterns
Access token (354)

Cross-cutting concerns patterns
Externalized configuration (361) Microservice chassis (379)

Observability patterns
Application metrics (373) Audit logging (377) Distributed tracing (370) Exception tracking (376) Health check API (366) Log aggregation (368)

Deployment patterns
Deploy a service as a container (393) Deploy a service as a VM (390) Language-specific packaging format (387) Service mesh (380)
Serverless deployment (416) Sidecar (410)

Refactoring to microservices patterns
Anti-corruption layer (447) Strangler application (432)

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