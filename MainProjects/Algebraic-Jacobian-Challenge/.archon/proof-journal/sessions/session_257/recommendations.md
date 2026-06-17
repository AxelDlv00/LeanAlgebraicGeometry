# Recommendations for the next plan iteration (post iter-257)

## TOP PRIORITY — the convergence: build `SheafOfModules.overEquivalence` once, unblock two lanes

The single highest-leverage action. Both of these now reduce to the **same** missing
Mathlib-scale construction — the modules-level lift of `Opens.overEquivalence`
(`Over U ≌ Opens ↥U`) to an equivalence of sheaf-of-modules categories matching
`restrict ↦ over`, `unit ↦ unit`:

1. **Engine** `LineBundleCoherence.lean`: `chartOverIso` (the SOLE remaining sorry; closes
   `chartPresentation` / `isFinitePresentation` / `isFiniteType` = the A.2.c deliverable).
2. **Dual lane** `DualInverse.lean`: `sliceDualTransport` → `dual_restrict_iso` →
   `exists_tensorObj_inverse` (the ⊗-inverse / Picard group law).

Estimated ~200–350 LOC, Mathlib-scale, its own file. Full primitive list in
`informal/chartOverIso.md`. **Recommend** dispatching a focused build of
`SheafOfModules.overEquivalence` as a dedicated lane (and re-pointing both `chartOverIso`
and the dual `sliceDualTransport` body at it) rather than grinding the two sites' sectionwise
constructions independently. Confirm the unification with a mathlib-analogist consult first
(the dual prover currently builds `sliceDualTransport` *sectionwise*, not via the equivalence —
decide which route both lanes share before dispatching).

## HARD GATE — three prover-touched chapters now carry must-fix blueprint findings

Per the plan-phase gate, **do NOT re-dispatch provers on these files until a blueprint-writer
fixes the chapter and a scoped re-review clears it:**

- **`Picard_LineBundleCoherence.tex`** (lvb-lbc257, must-fix): `lem:lbc_chart_presentation`
  proof sketch elides the over↔restrict bridge (`chartOverIso`); add a block/`\lean{}` pin
  describing the bridge (state it's Mathlib-absent, same wall as the dual lane). A review
  `% NOTE:` was already added pointing at this.
- **`Picard_TensorObjSubstrate.tex`** (lvb-tos257, 2 must-fix): the D3′ Sq2 paragraph's
  "non-trivial transport / pseudofunctor coherence / bookkeeping atoms" claim is **FALSE**
  (reconcile is `rfl` — `toRingCatSheafHom_comp_hom_reconcile`); and Sq2b (the genuine
  Mathlib-absent blocker — `pullbackComp` monoidality, mirror `Adjunction.isMonoidal_comp`)
  is absent from the sketch. Rewrite both. A review `% NOTE:` was already added.
- **`Picard_TensorObjSubstrate.tex`** (lvb-dual257, major): the `dual_restrict_iso` Step-4
  assembly is stale — blueprint prescribes `isoMk (sliceDualTransport ≪≫ legB)` but the Lean
  folds leg(A)+leg(B) into `sliceDualTransport` and does `isoMk sliceDualTransport`. Adopt
  Option A (update prose to match Lean; less churn); optionally add a `\lean{sliceDualTransport}` pin.

The TensorObjSubstrate chapter `% archon:covers` BOTH `TensorObjSubstrate.lean` and
`DualInverse.lean`, so one writer pass against that chapter fixes the gate for both lanes.

## DO NOT re-dispatch without a structural change

- **D3′ `pullbackTensorMap_restrict` (TS-cmp):** do NOT send another prover at the same shape.
  The reconcile is done (rfl); the remaining content is Sq2b = `pullbackComp` monoidality,
  **Mathlib-absent**, with three documented statement-level frictions. This needs a **cross-domain
  mathlib-analogist** consult (port `Adjunction.isMonoidal_comp`'s mate calculus to `pullbackComp`)
  BEFORE a prover round — exactly the pattern that paid off (whisker252 → mapin255 → dualstep4-257).
  The pc257 "CONVERGING" read on this lane is now under pressure: the iter's "close" was a trivial
  rfl helper while the real blocker turned out Mathlib-scale. Flag for the next progress-critic.

## PROCESS — do not co-schedule a prover on a file and a prover on its importer

`DualInverse.lean` **imports** `TensorObjSubstrate.lean`. Running the TS-inv and TS-cmp provers
concurrently this iter left the import non-compiling for most of the session; the TS-inv LSP
returned empty goals (`failed_dependencies`), making iterative development of the ~200-LOC
`sliceDualTransport` body impractical (the prover explicitly cited this as decisive). When both
files have live prover work, **serialize them** (or freeze the importee's signature for the iter).

## Prover-fixable stale comments (low cost, do next prover pass on these files)

From lean-auditor `aud257` (all MAJOR, honest-but-misleading):
- `TensorObjSubstrate.lean:43` header: "ONE tracked sorry" → there are 2 (L715, L2220).
- `TensorObjSubstrate.lean:2199-2201` ROADMAP "ITER-257 FINDINGS (1)" describes the `rfl` work
  already realized by `toRingCatSheafHom_comp_hom_reconcile` — reads as still-open.
- `DualInverse.lean:18` header: "one sorry remains" → 2 (L210, L323); stale "~L254" (also L355,357).
- `DualInverse.lean:207-209`: reframe "concurrently-broken dependency" as the mathematical gap
  (the sectionwise build), not a CI-timeline note (borderline excuse-comment).
- `DualInverse.lean:639`: stale comment inside the *closed* `homOfLocalCompat` claiming a sorry remains.

## Structural / tooling (not agent-fixable in normal lanes)

- **Recurring `sync_leanok` placement bug** at `Picard_RelPicFunctor.tex:144-146`: the deterministic
  marker-sync inserts a proof-block `\leanok` INSIDE the `\uses{…}` argument, splitting the label
  list (this iter's +1 marker IS the corruption). The planner's plan-phase manual fix is reverted
  by sync each iter. Needs a fix to the sync_leanok script itself (maintainer). Surfaced to user.
- **`Cohomology_CechHigherDirectImage.tex`** (new): `% archon:covers` a non-existent `.lean` + 5
  broken `\ref`. Have the writer either scaffold the labels or mark the chapter as forward-looking;
  the Lean file scaffold is the cheapest unblock when engine capacity frees.

## Closest-to-completion / momentum
- **Engine** is closest: one iso (`chartOverIso`) from a fully-closed A.2.c deliverable. Prioritise
  the `overEquivalence` build.
- **Dual Step-4** is fully scaffolded (verified signature + wired assembly); ready to fill once the
  shared `overEquivalence` exists OR once dispatched serially with a stable dep.

## Reusable patterns discovered (also in PROJECT_STATUS Knowledge Base)
- `IsFinitePresentation` of a `SheafOfModules`: build `QuasicoherentData`, `q.shrink` to the
  site-object universe, `apply …IsFinitePresentation.mk` + `inferInstanceAs (…).IsFinite`.
- `unit R` finite presentation: `free PUnit ≅ unit R` (`coproductUniqueIso`); presentation with
  `PEmpty` relations, epi from `Limits.isZero_kernel_of_mono` (precede with `have : Mono π := inferInstance`).
- Sq2 ring-map reconcile for composite pullback is `rfl` (Scheme comp defeqs at default transparency).
