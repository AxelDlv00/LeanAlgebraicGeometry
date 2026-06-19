- **K1 μ-side narrowed to ONE residual (iter-029):** the asymmetric mate-vs-composition tensorator
  comparison is now a proven assembly + proven RHS half; the sole open piece is the LHS mate
  pure-tensor value (`pushforward_lax_mu_comparison_lhs_tmul`). η-side already closed (iter-028).
- **Build is transiently RED (iter-029) with a one-token fix already identified and queued** —
  `DualInverse.lean:219` uses unqualified `map_smul` (shadowed by a project-local decl under full
  imports); next iter qualifies it to `LinearMap.map_smul`, which re-greens the tree and lands the
  iter-029 B1/hN/cocycle closures (currently written-but-blocked). No user action needed.
