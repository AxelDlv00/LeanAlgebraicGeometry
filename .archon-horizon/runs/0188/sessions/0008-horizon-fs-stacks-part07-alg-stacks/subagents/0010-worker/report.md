Port complete in the two owned files:

- `StacksPart07Lib/QuotientFoundations.lean`
- `StacksPart07Lib/ActionQuotient.lean`

The ports are byte-for-byte identical to the current Part04 sources after the intended `StacksPart04Lib` → `StacksPart07Lib` substitutions, including the newer `TypeQuotient` section. `lake build StacksPart07Lib` passed all 2446 jobs; both Horizon file checks passed; source scan found no `sorry`/`admit`/`axiom`; representative theorem verification reports only `propext` and `Quot.sound`. No compatibility issues. Files remain untracked and uncommitted for `/root`.
