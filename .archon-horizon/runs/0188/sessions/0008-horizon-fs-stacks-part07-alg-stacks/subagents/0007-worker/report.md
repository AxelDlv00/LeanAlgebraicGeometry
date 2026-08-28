Completed `StacksPart07Lib/RelationFunctor.lean` as an exact Part04 port with:

- `StacksPart07Lib` namespace and copyright/header updates
- `import StacksPart07Lib.RelationGroupoid`
- All relation functor and quotient map definitions/theorems preserved

Verification succeeded:

- LSP diagnostics: clean
- `$HORIZON_BIN check --lean StacksPart07Lib/RelationFunctor.lean`: passed
- `lake env lean StacksPart07Lib/RelationFunctor.lean`: exit 0
- Source scan: no `sorry`, `admit`, or `axiom`
- `lean_verify`: only standard axioms (`propext`, `Classical.choice`, `Quot.sound`)

The file remains untracked for the lead agent.
