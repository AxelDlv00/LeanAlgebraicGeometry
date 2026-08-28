Matrix frontier completed and committed in two verified units:

- `6c0efb42303ff07e49d24ef43381d8ac5f84da2e`: defines row projections/minor ideals and proves `matrix_left_inverse_of_mem_minorIdeal` plus the rank-one converse.
- `1744de51cc6fa50f2f0663787d5b9effad346690`: proves the square specialization `matrix_left_inverse_square_mem_minorIdeal`.

`lake env lean StacksPart01Lib/CommutativeAlgebra.lean`, LSP diagnostics, theorem axiom scans, commit checks, and exact ledger/worktree content checks all pass. Only standard axioms (`propext`, `Classical.choice`, `Quot.sound`) are used.
