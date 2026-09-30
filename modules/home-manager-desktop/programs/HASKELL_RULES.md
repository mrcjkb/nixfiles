## Language extensions

Typically, I use these language extensions:

- Core: `ApplicativeDo`, `BlockArguments`, `DataKinds`, `DefaultSignatures`, `DeriveAnyClass`, `DeriveGeneric`, `DerivingStrategies`, `DerivingVia`, `ExplicitNamespaces`, `ImportQualifiedPost`, `LambdaCase`, `NoImplicitPrelude`, `OverloadedLabels`, `OverloadedRecordDot`, `OverloadedStrings`, `RecordWildCards`, `RecursiveDo`, `ScopedTypeVariables`, `TypeApplications`, `TypeFamilies`, `ViewPatterns`.
- As needed: `ConstraintKinds`, `FlexibleContexts`, `FlexibleInstances`, `GeneralisedNewtypeDeriving`, `InstanceSigs`, `MultiParamTypeClasses`, `NamedFieldPuns`, `NumericUnderscores`, `TupleSections`, `TypeOperators`.

## Design for qualified import

Type and function names are _unprefixed_; the module carries the context, and call sites use qualified imports. No `FooBar`, but `Foo.Bar`.

Leaf types go in their own modules and are re-exported by the parent scope as _types only_.
Constructors and functions are reached through the submodule's qualifier.
Example `Foo` (the top-level module) re-exports `Config`, so the type and constructor are `Foo.Config`, while functions are `Foo.Config.<function>`.

## Code style

- NEVER write code comments.
  Code should be self-explanatory, but not overly verbose.
  Doc comments (e.g. haddock, rustdoc) are okay for public API, but should be kept concise, using the [diataxis REFERENCE format](https://diataxis.fr/reference/).
- Code line length must not exceed 99 characters.
- NEVER use `;` to put multiple expressions on the same line.
- Qualified imports after the module name; `NoImplicitPrelude` + explicit `import Prelude`.
- For a single-component module, `import X qualified` (the `as X` is redundant).
- No abbreviations that impair readability in qualified imports:
  Examples: `Effectful.FileSystem` as `FileSystem` (not `FS`), and `Effectful.FileSystem.IO.ByteString` as `FileSystem.IO`.
- When using a module that is designed for qualified import, refer to types via
  their  scope (e.g. `Foo.Status`, `Foo.Id`), not the submodule qualifier (`Status.Status`, `Id.Id`).
- Prefer `.` composition over `$` application over parentheses, except a single `$` application is fine (only chain with `.` when there are two or more `$`).
- Always prefer `fmap` over `map`; prefer `<$>` over `fmap` unless `fmap` helps with point-free; prefer `<&>` over `<$>` when it improves readability.
- Prefer `<&>`/`<$>` over list comprehensions for mapping; prefer `<&>` over `<$>` when it lets you drop the parentheses around a lambda.
- Prefer `RecordWildCards` (`{..}`) over explicit field lists in patterns and construction.
- Mix explicit field values with in-scope variables via `Constructor { field = value, .. }`, rather than listing the puns.
- Prefer `Constructor { field = ... }` over `let field = ...; x = Constructor {..}`, unless the fields are needed elsewhere.
- If an ADT variant has more than one constructor argument, prefer named record fields.
- A `Bool`/`Maybe` function argument that switches behaviour is a code smell; split into separate functions taking concrete values.
- Prefer pattern matches over `\case`, unless the `\case` improves readability (e.g. after a `>>=`).
- Avoid creating functions that take a `Maybe`/`Either` wrapper and `case` on it; unwrap it in the caller with `for_`/`traverse_`/`<$>` and pass the concrete value.
- Prefer `mempty`/`def` over `[]`; for `Maybe`, prefer `Nothing` over `mempty`.
- Prefer `mconcat` over chaining many `<>` to combine a list of lists.
- Don't add type annotations unless the compiler can't infer them.
- Avoid type annotations in lambdas and let bindings. Prefer type applications at call sites instead.
  Example: Instead of `\(foo :: Bla) -> doSomething foo`, prefer `\foo -> doSomething @Bla foo`.
- Single-use helper functions go in a `where` clause and should not take arguments already in scope from the enclosing function.
- Avoid nested `where` clauses; hoist helpers up a level when possible.
- In hspec specs, prefer `<$>` over `shouldSatisfy`; combine properties with `conjoin`/`.&&.` and use `property` rather than `=== True`.
- In property tests using QuickCheck, prefer `===` over `==`, etc.
- Record access via `OverloadedRecordDot`; `deriving stock (Generic)`; `Default` instances for config records.
- Prefer exporting everything in a module, if possible.
  Internal functions should go in a `where`.
  Exceptions:
    - If a type has constructors that should not leak their implementation details.
      Typically, these go in their own submodule, so that the type's functions can be scoped (see the design for qualified import section).
    - If a shared internal function can't go in a `where`.
