Target: AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean

Action: Add TWO sorry-bodied declarations (compiling stubs with rich `/- Planner strategy: ... -/` comments) so the iter-080 prover lane can fill them. The blueprint chapter `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` is the source of truth (blueprint-reviewer-iter080 verdict: GREEN — launch). Signatures from the blueprint; verify they compile with `sorry` bodies via `lake build AlgebraicJacobian.Cohomology.FlatBaseChangeGlobal`.

1. `flatBaseChange_isIso_iff_gammaTensorComparison` — blueprint `lem:flat_base_change_reduce_global_sections` (tex lines ~3999–4036). Strategy: the base-change comparison being an isomorphism is local on S'; reduce to the tilde equivalence (`lem:pullback_spec_tilde_iso`, DONE) + the fully-faithful `tilde` functor. ~20 LOC. Put the local-on-S' + tilde-fully-faithful recipe in the strategy comment.

2. `baseChangeGammaPullbackEquiv` — blueprint `thm:fbcb_global_direct` (tex lines ~4502–4584), `\lean{AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv}`. Statement: `B ⊗_A Γ(X,F) ≅ Γ(X', g'^* F)` (the global FBC-B iso). 3-step proof recipe for the comment:
   (a) `lem:fbcb_baseChangeGammaEquiv` (`baseChangeGammaEquiv`, DONE at L241 in this file): `B⊗_A Γ(X,F) ≅ eqLocus(id_B⊗leftRes, id_B⊗rightRes)`.
   (b) per-chart identify the base-changed legs with the restriction legs of `F'` over `X'` via Tag 01I9 / `lem:pullback_spec_tilde_iso` + `lem:affine_base_change_pushforward` (both DONE in FlatBaseChange.lean).
   (c) recognize the RHS equalizer as `Γ(X', F')` via `lem:fbcb_gammaTopEquivEqLocus` (`gammaTopEquivEqLocus`, DONE in this file), over the finite affine cover `lem:finite_affine_cover_qcqs` (DONE).

Constraints: edit ONLY FlatBaseChangeGlobal.lean. Both decls end in `sorry`. Match the existing namespace/section of `baseChangeGammaEquiv`. Do NOT attempt proofs. Reuse the existing `baseChangeGammaEquiv` / `gammaTopEquivEqLocus` / `finite_affine_cover_qcqs` signatures already in-file for the hypothesis shapes (qcqs X, flat g, etc.). Use `lean_hover_info`/`lean_local_search` to read the real signatures before writing the stubs.
