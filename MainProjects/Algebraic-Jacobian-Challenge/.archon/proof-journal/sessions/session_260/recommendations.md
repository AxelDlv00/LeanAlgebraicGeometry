# Recommendations for the next plan iteration (post iter-260)

## TOP PRIORITY — blueprint surgery BEFORE re-dispatching DualInverse (2× must-fix, lvb-di260)

The dual lane's blueprint is now actively wrong at the genuine step. **This gates any prover
re-dispatch on `DualInverse.lean`.** Dispatch a **blueprint-writer** on
`Picard_TensorObjSubstrate.tex` (the consolidated chapter) to:

1. **[must-fix] Rewrite the `lem:dual_restrict_iso` proof sketch (tex ~5773–5800)** from route-(1)
   (consume `restrictOverIso`/`unitOverIso` from `overEquivalence`) to **route-(2)**: build the
   forward/inverse `≃ₗ` directly — leg A = `eqToHom`-conjugation across `f.opensFunctor` (mirror
   `homLocalSection`'s naturality, `Subsingleton.elim` on the thin poset), leg B =
   `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`. Add the reason route-(1) fails:
   the dual does not commute with slice reindexing via `overEquivalence` without `MonoidalClosed`.
   (Review has placed a `% NOTE:` at that location with the exact content; the writer should
   replace the prose, not just the note.)
2. **[must-fix] Remove the stale `\uses` edges** for `lem:dual_restrict_iso` (statement block
   ~5656, proof block ~5685): drop `lem:sheafofmodules_restrict_over_iso` and
   `lem:sheafofmodules_unit_over_iso`; keep `lem:restrictscalars_ringiso_dualequiv`; consider
   dropping `def:sheafofmodules_over_equivalence` if route-(2) does not use the equivalence object.
3. **[major] Add a `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` block** so
   `sync_leanok` tracks its sorry status independently of `dual_restrict_iso`.

Then re-gate the chapter (HARD-GATE fast-path) before adding `DualInverse.lean` to objectives.

## TOP PRIORITY — PLANNER DECISION: sanction route-(2) for `sliceDualTransport`
Route-(1) is **dead** (structural, not tactic difficulty — confirmed by both the prover and
lvb-di260). Do **NOT** re-dispatch route-(1). The realistic close is the route-(2) sectionwise
build: a single ~150–250 LOC lane, self-contained in `DualInverse.lean` (no cross-lane race),
**not** decomposable into independently-compiling sub-pieces (leg B does not type-apply before leg
A — so a single dedicated multi-iter lane, not a staged decomposition). Budget accordingly. This is
the A.1.c.sub critical path (it feeds the RPF group inverse `exists_tensorObj_inverse`).

## Closest-to-completion / done
- **`pushforwardComp_lax_μ` + `pullbackComp_δ` — DONE this iter, axiom-clean** (review-verified).
  Sq2b is fully closed. The OUTER D3′ lemma `pullbackTensorMap_restrict` now needs only **Sq1**
  (`sheafificationCompPullback` composition coherence) and **Sq4** (`pullbackValIso` composition
  coherence) — both Mathlib-absent standalone sub-lemmas. This is a candidate next lane once the
  dual lane's blueprint is fixed, and it does NOT race DualInverse (different decls, same file —
  but if DualInverse route-2 is dispatched concurrently they'd both edit TensorObjSubstrate-family
  files; `pullbackTensorMap_restrict` is in `TensorObjSubstrate.lean`, `sliceDualTransport` is in
  `DualInverse.lean` which IMPORTS it → holding one is still required if the other edits
  TensorObjSubstrate.lean. Sq1/Sq4 work edits TensorObjSubstrate.lean, so it races DualInverse's
  import. Pick ONE of {Sq1/Sq4, route-2 dual} per iter, or sequence them.)
- **A.2.c engine** (`LineBundleCoherence.lean`): `IsFinitePresentation`/`isFiniteType`/
  `chartPresentation` axiom-clean. DONE. No action.

## Stale-documentation cleanup (.lean comments — must be done by the OWNING prover on re-open)
Review cannot edit `.lean` files. Fold these into the directive when each file is next dispatched
(aud260 major/minor):
- `TensorObjSubstrate.lean` header (L39–134): "ONE tracked typed-`sorry` residual" is **wrong** —
  there are TWO (`exists_tensorObj_inverse` L715, `pullbackTensorMap_restrict` L2521). Fix the count.
- `TensorObjSubstrate.lean` L2332–2363 (inside the now-complete `pullbackComp_δ`): delete the
  obsolete "the wiring `rw`s are mechanical but fragile … left for the follow-up" planning
  commentary — the proof is complete, so it falsely signals unfinished work.
- `TensorObjSubstrate.lean` L2360–2363: "Pinned as `pushforwardComp_lax_μ` above" reads as if a
  sorry is still active there; update now that it is closed. Also record the D3′ CLOSED milestones
  in the header (L44).
- `DualInverse.lean` header (L1–54): "HELD (iter-258)"/"PARTIAL (held iter-258)" is 2 iters stale;
  update to iter-260 status (route-1 refuted, route-2 sanction pending). The "one `sorry` remains"
  line should read TWO (`sliceDualTransport` L257 + `dual_restrict_iso` naturality L388).

## Do NOT retry
- **DualInverse route-(1)** (`sliceDualTransport` via `restrictOverIso`/`unitOverIso`): structurally
  impossible (needs avoided `MonoidalClosed`). Two independent confirmations.
- **`pushforwardComp_lax_μ` via `extendScalarsComp`**: closed by the much cheaper sectionwise
  collapse; the change-of-rings route was never needed (the estimate was wrong twice).

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Opaque lax-μ of a `pushforward`** reduces *definitionally* (`rfl`) to the lighter
  `restrictScalars` μ on the strongly-monoidal `pushforward₀` reindexed objects (μIso = refl). Use a
  `pushforward_μ_eq`-style `rfl` lemma, then collapse pure tensors with `ModuleCat.restrictScalars_μ_tmul`.
- **whnf-wall on heavy sheafification/pushforward₀ section objects**: never `rw`/`erw`/`simp` a
  Mathlib lemma directly; instantiate an atom helper with the heavy objects as EXPLICIT args into a
  `have`, then `erw [that_have]`. Pin `forget₂` association implicits to fix silent HO no-match.
- **`hom_ext` + `ModuleCat.MonoidalCategory.tensor_ext`** to get ONLY the pure-tensor case, avoiding
  zero/add coe-distribution that `map_zero`/`map_add` won't fire on.

## Deferred (no active route) — surfaced for when the engine lane opens
- Blueprint-doctor: `Cohomology_CechHigherDirectImage.tex` covers a non-existent `.lean` + 5 broken
  internal `\ref{lemma-cech-*}`. Forward-spec for the `Rⁱf_*` Čech build; land the `.lean` skeleton
  + ref wiring when that engine lane is dispatched. No active route blocked.

## OVER-BUDGET tracking (carried from iter-260 plan)
A.1.c.sub is at ~24 elapsed iters vs the STRATEGY ~10–16 remaining estimate. The dual chain did NOT
land this iter (route-1 refuted) — so the plan agent's own condition triggers: do the STRATEGY.md
re-estimate now, alongside sanctioning route-(2). With Sq2b closed, the remaining A.1.c.sub work is:
route-(2) `sliceDualTransport` → `dual_restrict_iso` → `dual_isLocallyTrivial`; then the A-bridge
`exists_tensorObj_inverse`; plus `pullbackTensorMap_restrict` Sq1/Sq4.
