📘 Books API

🎯 Purpose

This is the backend of Chapters, an online bookstore. It provides a RESTful
API for the book catalogue, user accounts, reading lists, and a real
checkout/payments flow integrated with Hellgate Commerce.

🧰 Technologies Used

    Elixir – functional programming language
    Phoenix – web framework for building APIs
    Ecto – database layer, changesets, and transactions
    PostgreSQL – database
    HTTPoison + Jason – HTTP client and JSON encoding for talking to Hellgate

🏗️ Architecture

The app is organized into Phoenix contexts, each owning its own schema(s):

    Books / Authors / BooksAuthors – catalogue data
    Users – accounts (auth is currently minimal — plaintext comparison,
      no real sessions — not production-ready)
    ReadingLists – per-user saved books
    Orders / OrderItems – persisted purchases, one Order with many
      OrderItems per checkout

Checkout/payments is handled by two collaborating pieces:

    CheckoutController – orchestrates the flow: looks up trusted prices
      from the database (never trusts client-supplied prices), then runs
      the Hellgate chain, then persists the result
    HellgateClient – a thin wrapper around Hellgate's Commerce v2 API
      (tokenization, token status, payment-data requests, forwarding)

The account runs on Hellgate's **Managed Ecosystem** model, which means
checkout involves a primary merchant (tokenization, payment-data requests)
and a separate sub-merchant (forwarding the charge to the downstream
acquirer) — each authenticates with its own API key. See
lib/books_api/hellgate_client.ex for the actual call chain.

⚠️ Known state: HellgateClient.forward_payment_data/2 currently returns a
mocked success response — the real implementation is commented out in the
same function. This is due to an unresolved sandbox auth issue on the
forward-payment-data endpoint specifically, not a bug in the surrounding
flow. Swap the mock back out once that's sorted.

🛠️ Environment Setup

📦 Prerequisites

    Elixir 1.15+
    Erlang/OTP 25+
    Phoenix 1.7+
    PostgreSQL 13+
    Node.js 18+ (for asset bundling)

🔑 Required environment variables (config/runtime.exs)

Checkout will not work without a real Hellgate sandbox account configured:

    HELLGATE_API_KEY           – primary merchant API key
    HELLGATE_API_BASE          – Hellgate API base URL (sandbox host)
    HELLGATE_MERCHANT_ID       – primary merchant UUID (Hellgate-side)
    HELLGATE_MERCHANT_ACCOUNT  – your acquirer account name (e.g. Adyen)
    HELLGATE_MERCHANT_API_KEY  – sub-merchant API key, used only for the
                                   forward-payment-data call

Each has a hardcoded fallback in runtime.exs for local dev — replace those
with real sandbox values from developer.hellgate.io.

🧪 Setup Steps

1. Install dependencies and set up the DB
   mix setup

2. Start the Phoenix server
   mix phx.server
   (or iex -S mix phx.server for interactive debugging)

3. Visit http://localhost:4000
