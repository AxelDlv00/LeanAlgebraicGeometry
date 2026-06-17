# Recommendations for the next plan iteration (iter-004)

## Closest-to-completion — prioritize

1. **FBC: `base_change_mate_generator_trace` (L4) is the single live crux for the whole
   FBC-A mate close.** The parent `pushforward_base_change_mate_cancelBaseChange` is a
   proved assembly modulo this one leaf — closing L4 closes the parent automatically.
   The obstacle is now CONCRETE (a tensor-module map, not an abstract sheaf-map):
   - Build the R'-linear regrouping equiv `(A⊗_R R')⊗_A M ≅ R'⊗_R M` as a single bundled
     `≃ₗ[R']` via heterobasic `AlgebraTensorModule.comm` (×2, R'-linear) +
     `TensorProduct.AlgebraTensorModule.cancelBaseChange`.
   - Then `suffices conjugate = regroupEquiv.toModuleIso.hom` and close `IsIso` via
     `rw` + `infer_instance`.
   - **effort-break recommended (fine granularity)** before re-dispatch — blueprint
     effort 2011, flagged a fine-break candidate. Do NOT re-assign the parent monolith;
     only L4 remains.

2. **GF: `exists_free_localizationAway_of_torsion` (L1) is DONE (axiom-clean).** The next
   GF leaf to attack is **L3 `exists_free_localizationAway_of_shortExact`** — it gates the
   L5 inductive step and the whole `genericFlatnessAlgebraic` assembly. The 3 sub-steps are
   identified; the real cost is the **module-side localization plumbing** (build
   `M'_{f'} →ₗ M'_f` with its `IsLocalizedModule (powers (image f'')) _` instance via
   `IsLocalizedModule.lift`, using that `f'` is a unit in `A_f`). **effort-break L3** into
   {localised-SES exactness, free-transport plumbing, split-with-free-quotient} before
   re-dispatch — the monolithic sorry is too large.

## Blueprint-adequacy must-address (blocks faithful prover work on the affected decls)

3. **GF L4 `lem:gf_noether_clear_denominators` — DECIDE the encoding and re-blueprint.**
   The Lean signature is faithful but bulky (anonymous instance-existentials). I added a
   `% NOTE` flagging it. **Dispatch a blueprint-writer** to add a `% LEAN SIGNATURE` block
   and choose:
   - (a) document the instance-existential encoding + how to destructure it downstream, OR
   - (b) **re-state with an explicit AlgHom** target
     `φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)`
     with `Module.Finite` over `φ.toAlgebra` — cleaner for L5 / `genericFlatnessAlgebraic`
     consumption (the gf checker recommends (b)). The L4 prover body is `sorry`, so the
     consumption is untested; the auditor independently flagged this interface as fragile.
   See `task_results/lean-vs-blueprint-checker-gf.md` (major 1) and `lean-auditor-iter003.md` (major).

4. **GF `lem:gf_free_moduleFinite` — prose understates hypotheses.** Already `% NOTE`'d.
   **Dispatch a blueprint-writer** to restate: B a module-finite A-algebra (`[Module.Finite A B]`),
   M a finite B-module (`[Module.Finite B M]`) with the scalar tower; A-finiteness of M is
   DERIVED, not assumed. See `task_results/lean-vs-blueprint-checker-gf.md` (major 2).

## 1-to-1 coverage debt (planner must blueprint these — review agent does not author prose)

`archon dag-query unmatched` = **2 `lean_aux` nodes** (both in `Cohomology/FlatBaseChange.lean`,
both proved, axiom-clean, no blueprint block):

- `AlgebraicGeometry.pullbackIsoEquivalenceOfIso` (~line 750) —
  `(f : X ⟶ Y) [IsIso f] → Y.Modules ≌ X.Modules`. Lean depends on:
  `Scheme.Modules.pullbackComp`, `pullbackCongr`, `pullbackId`, `IsIso.inv_hom_id`/`hom_inv_id`,
  `CategoryTheory.Equivalence.mk` (coherence via default `aesop_cat`).
- `AlgebraicGeometry.pullback_isEquivalence_of_iso` (~line 759) — instance
  `(f : X ⟶ Y) [IsIso f] → (Scheme.Modules.pullback f).IsEquivalence`, via
  `(pullbackIsoEquivalenceOfIso f).isEquivalence_functor`.

Add `\label` + `\lean{}` + `\uses{}` blocks for both in `Cohomology_FlatBaseChange.tex`
(thin infrastructure entries) to restore 1:1 graph correspondence — they are otherwise
invisible to the dependency graph.

## Blocked — do NOT re-assign as-is

- **`genericFlatnessAlgebraic` assembly (line 370):** do NOT dispatch a prover to wire the
  prime-filtration induction until L3/L4/L5 are closed — the assembly merely relocates the
  sorry otherwise. The hard part is reconciling a `Module A N` (via `Module.compHom`) on
  every B-module of the induction, defeq-compatible with the given `IsScalarTower A B M`.
- **`genericFlatness` geo wrapper (line 432):** deferred by design; do NOT dispatch until
  `genericFlatnessAlgebraic` lands.
- **`exists_free_localizationAway_polynomial` d≥1 step (line 307):** the true Mathlib-absent
  generic-rank core; depends on L3 splice. effort-break after L3 closes.
- **`affineBaseChange_pushforward_iso` (line 951) / `flatBaseChange_pushforward_isIso`
  (line 973):** downstream of the mate close / deferred Čech-free lane respectively — not
  the live frontier this iter.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)

- Section-level mate read via the two proved tilde dictionaries + `toTildeΓNatIso` reduces
  "abstract sheaf-map's Γ is iso" to a concrete tensor map.
- `(pullback f).IsEquivalence` for iso `f` makes the per-object adjunction-unit-iso fire;
  use the functor-iso `.app` form (`(asIso adj.unit).app x`), not `asIso (adj.unit.app x)`.
- A-over-B scalar commutation (`f•(b•x)=b•(f•x)`, `f:A, b:B`) is NOT automatic — route
  through `algebraMap A B` (`IsScalarTower.algebraMap_smul` + `smul_smul` + `mul_comm`).
- `induction d` mis-generalizes `d`-dependent module instances; `rcases Nat.eq_zero_or_pos d`
  (or a ∀-quantified-N induction) is required.

## Hygiene (low priority, not blocking)

- 21-site `CategoryTheory.Sheaf.val` deprecation in `FlatBaseChange.lean` — schedule a
  `refactor` to `ObjectProperty.obj` before the next Mathlib pin bump (will break the build).
- Strip predecessor-project iter numbers (iter-173…iter-241) from comments across all files.
- Add `set_option autoImplicit false` to the `FlatBaseChange.lean` header for consistency.
