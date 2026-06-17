Target: `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`

Action: Scaffold TWO new declarations with `sorry` bodies (do NOT prove). The file currently
ends at `baseChangeGammaEquiv` (~L241). Append these after the existing FBC-B infra. This file
0-sorry → the prover noop'd last iter; your stubs give it real sorries to fill.

Blueprint (source of truth for signatures + proof): `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`:
- `lem:flat_base_change_reduce_global_sections` (L3999) → `\lean{AlgebraicGeometry.flatBaseChange_isIso_iff_gammaTensorComparison}`
- `thm:fbcb_global_direct` (L4503) → `\lean{AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv}`

Decl 1 — `flatBaseChange_isIso_iff_gammaTensorComparison` (namespace `AlgebraicGeometry`, NOT `.Modules`):
the sheaf-level base-change map `g^*(f_*F) → f'_* g'^*F` IsIso ↔ the module comparison
`Γ(X,F) ⊗_A B → Γ(X_B,F_B)` IsIso, after reducing to affine bases. Match the existing
`pushforward_base_change_map` def's signature shape in FlatBaseChange.lean (read it for the leg names).

Decl 2 — `baseChangeGammaPullbackEquiv` (namespace `AlgebraicGeometry.Modules`): for `X` qcqs,
`A := Γ(X,O_X)`, `F : X.Modules` quasi-coherent, `B` a flat `A`-algebra, `X' = X_B`, `F' = g'^*F`,
a `B`-linear `≃ₗ` `Γ(X,F) ⊗_A B ≃ Γ(X',F')`. Reuse the existing file decls as the assembly bricks:
`baseChangeGammaEquiv`, `gammaTopEquivEqLocus`, `toCoverEqLocus`, `leftRes`/`rightRes`. Mirror their
implicit/explicit binder + universe conventions exactly.

Strategy comment (inject `/- Planner strategy: -/` above Decl 2): 3-step assembly per `thm:fbcb_global_direct`
proof — (1) `baseChangeGammaEquiv` gives `B⊗Γ ≅ eqLocus(id_B⊗leftRes, id_B⊗rightRes)`; (2) per-chart
identify base-changed legs with restriction legs of F' over the base-changed cover via
`pullback_spec_tilde_iso` (Stacks 01I9) + `affine_base_change_pushforward` [both DONE]; (3) RHS eqLocus
= `Γ(X',F')` via `gammaTopEquivEqLocus` applied to F' and cover {(U_i)_B}. For Decl 1: being-iso local
on S' → reduce to affine → tilde-equivalence fully-faithful (Stacks 02KH reduction "(1) from (2)").

Constraints: signatures must typecheck against existing file decls (use lean search / read the file to
confirm binder shapes). Do NOT touch FlatBaseChange.lean. Do NOT prove — `sorry` bodies only. All 6 `\uses`
deps are DONE/\leanok per the blueprint.
