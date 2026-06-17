# Effort Breaker Report

## Slug
fbc-l4

## Target
`lem:base_change_mate_generator_trace`
(`\lean{AlgebraicGeometry.base_change_mate_generator_trace}`) in
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`.

## Status
COMPLETE — the leaf is re-expressed as the requested 3-sub-lemma `\uses`-linked
chain. The pinned `IsIso` leaf is now a thin corollary; its `\lean{}` pin and
`IsIso`-form `% NOTE` are preserved. No broken `\uses{}` (graph re-query
`error: None`).

## Effort before → after
- target `lem:base_change_mate_generator_trace` `effort_local`: **2011 → 619**
  (now `dep_count: 2`, pulling the two new sub-lemmas; transitive
  `effort_total` 4561 across the new chain).
- sub-lemmas added: **2** (regroup equiv + generator identification); target
  rewritten as the corollary.

## Chain added (target ← L3 ← L2 ← L1)

- **L1 — `\label{lem:base_change_mate_regroupEquiv}`**
  `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}`
  (`effort_local 1610`, `dep_count 1`).
  Pure-tensor-algebra bundled `R'`-linear iso
  `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`, generator `(r'⊗1)⊗m ↦ r'⊗m` (inverse
  `r'⊗m ↦ (r'⊗1)⊗m`). Proof states the explicit Lean-orientation route
  `(A⊗_R R')⊗_A M ─comm→ M⊗_A(A⊗_R R') ─cancelBaseChange→ M⊗_R R' ─comm→ R'⊗_R M`
  (two heterobasic `AlgebraTensorModule.comm` + `cancelBaseChange`).
  `\uses{lem:cancelBaseChange_mathlib}`. The buildable, no-geometry piece — prover
  should close outright.

- **L2 — `\label{lem:base_change_mate_generator_trace_eq}`**
  `\lean{AlgebraicGeometry.base_change_mate_generator_trace_eq}`
  (`effort_local 2332`, `dep_count 4`).
  The conjugate `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ : R'⊗_R M ⟶ (R'⊗_R A)⊗_A M` sends
  `r'⊗m ↦ (r'⊗1)⊗m`, i.e. equals `regroup⁻¹`. Informal proof = the original
  three-step adjoint-mate trace (unit / restriction-reindex / transpose), kept
  verbatim, now closing with "= the inverse generator of L1".
  `\uses{def:pushforward_base_change_map, lem:base_change_mate_domain_read,
  lem:base_change_mate_codomain_read, lem:base_change_mate_regroupEquiv}`.

- **L3 (target) — `\label{lem:base_change_mate_generator_trace}`** (unchanged pin).
  `IsIso(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`. Proof: by L2 the conjugate equals
  `regroup⁻¹` (L1), a `LinearEquiv`, hence an iso — `rw` along L2 +
  `infer_instance`. `\uses{lem:base_change_mate_regroupEquiv,
  lem:base_change_mate_generator_trace_eq}`.

Parent `lem:pushforward_base_change_mate_cancelBaseChange` left untouched — it
still `\uses` the (unchanged) `lem:base_change_mate_generator_trace`, which now
transitively carries the chain. No `\uses` extension was needed.

## Comment preservation
- `% NOTE (iter-003)` IsIso-form note → carried onto **L3** (lightly updated to
  reference the now-landed generator identification; IsIso-corollary semantics
  intact).
- `% NOTE (iter-003)` tensor-order convention (`pullbackSpecIso` orientation
  `A ⊗[R] R'`) → carried onto **L1** (where the concrete tensor order is fixed).
- `% SOURCE` / `% SOURCE QUOTE` / `\textit{Source:}` ("boils down to the
  equality") → carried onto **both L1 and L2** (both blocks derive from that
  source step; the quoted "equality as R'-modules" is L1's content, the trace is
  L2's). Verbatim quote unchanged.

## Still hard (re-break candidates)
- `lem:base_change_mate_generator_trace_eq` (L2) — by the effort heuristic this
  is the heaviest piece (2332); it retains the genuine adjoint-mate content (the
  three-step unit/restriction/transpose trace). This is **by design** per the
  directive ("Keep that trace as this sub-lemma's informal proof") — it is now a
  single isolated claim (conjugate = `regroup⁻¹`). If the prover stalls on it,
  re-dispatch the breaker to split the trace sentence-by-sentence (unit value →
  restriction-reindex → transpose formula as three named steps). Not done now
  since the directive scoped L2 as one claim.

## Could not decompose (strategy items)
- None. The chain conserves the mathematics: L1 supplies the iso, L2 identifies
  the conjugate with `regroup⁻¹`, L3 is the formal `IsIso` corollary.

## References consulted
- None newly retrieved — the only source pointer in the block (Stacks "Affine
  base change", "boils down to the equality" step) was already present verbatim
  in the target and was carried onto L1/L2 unchanged.

## Notes for dispatcher
- `\lean{}` names assigned by convention (need scaffolding by the plan/prover):
  - `AlgebraicGeometry.base_change_mate_regroupEquiv` (L1) — a `LinearEquiv`
    over `R'`; build = `comm ≪≫ cancelBaseChange ≪≫ comm` (Lean order
    `A ⊗[R] R'`).
  - `AlgebraicGeometry.base_change_mate_generator_trace_eq` (L2) — an equality
    of `R'`-linear maps `… = regroupEquiv.symm` (or the generator formula).
  - `AlgebraicGeometry.base_change_mate_generator_trace` (L3) — **unchanged**
    existing pin; body becomes `rw [generator_trace_eq]; infer_instance`-style.
- L3 keeps its statement-level `\leanok` (same decl, restructured block only);
  `sync_leanok` will reconcile. No `\leanok` added to L1/L2 (unproved).
- LaTeX verified balanced (28/28 lemma, 26/26 proof envs). `\ggg` used in L3 for
  the `≫` left-to-right composition; `amssymb` is loaded in both `web.tex` and
  `print.tex`, so it renders.
- `archon dag` full re-elaboration timed out at 600s in this sandbox;
  verification used `archon dag-query node/ancestors`, which re-parse the `.tex`
  live and confirmed the effort drop and clean `\uses` resolution.
