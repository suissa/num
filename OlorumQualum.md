# OlorumQualum - Semantic Behavior-Typed Language

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Semantic Behavior-Typed Language that compiles to Zig for high-performance, event-driven systems.

## Overview

OlorumQualum is a programming language designed for building event-driven, agent-centric, immutable-by-default architectures with semantic typing. It combines:

- **Haskell + Prolog + Agda** for high-level logic, type inference, and formal verification
- **Zig** for low-level control, memory safety, and performance

## Key Features

### Atomic Behavior Types (ABT)
- Properties with base types + semantics + constraints + behaviors
- Semantic Nominal Typing with behavioral characteristics
- Business rules embedded in type definitions

### Deductive Logic Types (Wittgenstein-Tractatus-engine)
- Haskell-style: Hindley-Milner type inference
- Prolog-style: Selective Linear Definite clause resolution
- Agda-style: Curry-Howard Correspondence

### Event-Driven Architecture
- Private event buses per module
- Actor model with supervisors (BEAM-style)
- Immutable-by-default data
- Linear memory management

### Proof-Carrying Code
- Identity proofs (PQC-Dilithium)
- Capability proofs (Linear tokens)
- Legality proofs (Prolog certificates)
- Zero-trust execution model

### Semantic Module Kinds
22 predefined module types with specific plane and storage policies:
- monetary_module, identity_module, auth_module, etc.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OlorumQualum Compiler                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Haskell    │  │   Haskell    │  │   Haskell    │       │
│  │   Parser     │→ │ TypeChecker  │→ │ IRGenerator  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              Semantic Algebra Resolver                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Prolog      │  │   Agda       │  │  Haskell     │       │
│  │  Resolver    │  │  Prover      │  │  TypeChecker │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Zig Runtime                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Module     │  │   EventBus   │  │   Actor      │       │
│  │   Manager    │  │   System     │  │   Model      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Supervisor  │  │  MemoryMgr   │  │  Stateful    │       │
│  │              │  │              │  │  Sidecar     │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites

- Haskell (GHC 9.0+)
- Stack or Cabal
- Zig 0.11+
- Bash/Linux shell

### Building

```bash
# Build the compiler
cd compiler/haskell
stack build

# Build the runtime
cd runtime/zig
zig build
```

### Running

```bash
# Type check a file
./compiler/haskell/.stack-work/dist/*/build/olorum-qualum/olorum-qualum check examples/ecommerce/main.um

# Generate Zig code
./compiler/haskell/.stack-work/dist/*/build/olorum-qualum/olorum-qualum zig examples/ecommerce/main.um

# Run the runtime
./runtime/zig/zig-out/bin/olorum-qualum
```

## Language Syntax

### Property Definition

```be2e
property UserEmail {
  type string

  semantics {
    sensitive
    indexable
    cacheable
    auditable
  }

  constraints {
    required
    unique
    format email
  }

  behaviors {
    normalize {
      input string
      output string
      flow {
        trim
        to_lowercase
      }
    }

    validate {
      input string
      output boolean
      flow {
        check_format
        check_mx_record
      }
    }
  }

  modifiers {
    readonly
    index
    unique
    sensitive_data
  }
}
```

### Entity Definition

```be2e
import property UserId from "../properties/user.id.um"
import property UserEmail from "../properties/user.email.um"

@capability(legal_basis:contractual)
entity User {
  identity {
    id: UserId
  }

  properties {
    email: index unique UserEmail
  }

  actions {
    register ->
      email.normalize +
      email.validate +
      User.created
  }
}
```

### Graflow DSL

```graflow
/**
 * Checkout Flow
 */
CheckoutFlow -> [ ValidateUser, ValidateProducts ] -> ProcessPayment -> CompleteOrder
```

## Examples

See `examples/ecommerce/` for a complete implementation with:
- User management (registration, login, profile)
- Product catalog (CRUD, search)
- Order processing (create, update, cancel)
- Payment handling (authorize, capture, refund)
- Delivery management (address, tracking)
- Stock management (reserve, release, update)

## Project Structure

```
OlorumQualum/
├── compiler/          # Haskell compiler
│   └── haskell/
│       ├── src/      # Source files
│       │   ├── OlorumQualum/
│       │   │   ├── AST.hs          # Abstract Syntax Tree
│       │   │   ├── Parser.hs       # Parser
│       │   │   ├── TypeChecker.hs  # Type checking
│       │   │   ├── SemanticResolver.hs
│       │   │   ├── IRGenerator.hs  # IR generation
│       │   │   ├── CodeGen.hs      # Zig code generation
│       │   │   └── Main.hs         # Entry point
│       ├── package.yaml
│       └── stack.yaml
├── runtime/          # Zig runtime
│   └── zig/
│       ├── src/
│       │   ├── main.zig
│       │   ├── module.zig
│       │   ├── event_bus.zig
│       │   ├── actor.zig
│       │   ├── supervisor.zig
│       │   └── memory.zig
│       └── build.zig
├── examples/         # Example implementations
│   └── ecommerce/
│       ├── properties/
│       ├── modules/
│       ├── flows/
│       └── main.um
├── docs/            # Documentation
├── tests/           # Test suite
├── LICENSE
└── PROJECT_README.md
```

## Architecture Details

### Runtime Planes

The AllasCode Standard Runtime has 14 Planes:
- Gateway, Service, Data, Cache, Search, Vector
- Graph, Analysis, Security, File, DeepCold
- Write, Read, Test

### Memory Management

- Each module gets exactly 1MB of memory
- Linear allocation with automatic zeroing
- No garbage collector
- Explicit memory control

### Actor Model

- Each module runs as an actor
- Supervisors manage actor lifecycle
- Message passing via event bus
- Isolated execution contexts

## Development

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

### Testing

```bash
# Run parser tests
stack test --test-arguments="parser"

# Run type checker tests
stack test --test-arguments="typechecker"

# Run semantic tests
stack test --test-arguments="semantic"
```

## License

MIT License - see [LICENSE](LICENSE) file for details

## Acknowledgments

- Inspired by Haskell's type system
- Prolog's logic programming
- Agda's dependently typed language
- Zig's memory safety
- BEAM's actor model

## Future Work

- Complete parser implementation
- Full type checker with Hindley-Milner inference
- Prolog resolver integration
- Agda proof verification
- Zig code generation optimization
- Runtime performance tuning
- Comprehensive test suite
- Documentation generation
