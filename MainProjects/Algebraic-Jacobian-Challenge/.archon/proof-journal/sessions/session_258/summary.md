# Session 258 (review of iter-258) — summary

## Metadata
- **Iteration / session**: 258
- **Prover model**: opus (mode `prove`)
- **Lane files actually edited**: `Picard/SheafOverEquivalence.lean` (NEW shared root),
  `Picard/LineBundleCoherence.lean` (engine redirect), `Picard/TensorObjSubstrate/DualInverse.lean`
  (comment-only cleanup).
- **Sorry movement (lane-local)**:
  - `SheafOverEquivalence.lean`: 4 → 2 (closed `overEquivalence` + `chartOverIso`-construction; open: `restrictOverIso`, `unitOverIso` leaf).
  - `LineBundleCoherence.lean`: 1 → 0 **local** (redirect; transitively sorry via the shared root).
  - `DualInverse.lean`: 2 → 2 (HELD; comment cleanup only).
- **Headline**: the **shared-root linchpin `Scheme.Modules.overEquivalence` is CLOSED axiom-clean**
  (`#print axioms` = `{propext, Classical.choice, Quot.sound}`, verified first-hand via `lean_verify`).
  This is the modules-level lift of `Opens.overEquivalence` that BOTH critical-path lanes
  (engine `chartOverIso`, dual `sliceDualTransport`) independently reduced to in iter-257.

## The defining outcome — the convergence wall is breached

iter-257's clearest signal was that the engine lane's sole sorry (`chartOverIso`) and the dual lane's
open chain (`sliceDualTransport → dual_restrict_iso → exists_tensorObj_inverse`) are the **same**
Mathlib-scale construction: the modules-level lift of `Opens.overEquivalence`. iter-258 built that
shared root once. The genuine content — the equivalence of sheaf-of-modules categories — is now
landed axiom-clean, and the engine consumer was redirected to it the same iter (so `LineBundleCoherence.lean`
is already locally sorry-free, a iter early).

What remains on the shared root is two consumer isomorphisms, both *mechanical finishes* of machinery
already developed in the same file (not Mathlib gaps):
- `restrictOverIso` (L235, full body) — mirror of `restrictFunctorAdjCounitIso` via
  `pushforwardComp (= Iso.refl)` + `pushforwardNatIso` along the `eqToIso` of the two `Over U ⥤ Opens X`
  index functors. ~30–60 LOC.
- `unitOverIso` (L276, ONE leaf) — construction complete, `IsIso (phiOver U)` proven, reflection chain
  done to one leaf: `IsIso` of the additive map underlying the sectionwise ring iso `(phiOver U).hom.app W`.
  ~5–10 LOC.

## Per-target detail

### `overEquivalence` — SOLVED axiom-clean (the linchpin)
Construction: `SheafOfModules.pushforwardPushforwardEquivalence (Opens.overEquivalence U) (phiOver U) (psiOver U) H₁ H₂`.
Three reusable recipes cracked (all now in the Knowledge Base):
1. **`↥↑U` vs `↥U` discrimination-tree mismatch.** The site carrier `↥(↑U : Scheme)` (Scheme→TopCat→Type
   coercion) is *definitionally* the subtype `↥U` but **keys differently** in the instance discrimination
   tree, so the project's `overEquivInverseIsDenseSubsite` (stated for bare top space `↥U`) is NOT found
   and the priority-900 `IsDenseSubsite → IsContinuous` chain silently fails. **FIX:** state the
   continuity instances on the scheme-carrier form and `change`-convert to `↥U` before `infer_instance`.
2. **`φ`/`ψ` sectionwise** = `X.ringCatSheaf.obj.map (eqToHom (image_overEquiv …)).op` (the two
   structure presheaves agree definitionally via `toScheme_presheaf_obj`).
3. **`Functor.map_comp` matching wall.** `rw [← Functor.map_comp]` REFUSES to combine `F.map a ≫ F.map b`
   for `F = X.ringCatSheaf.obj` (a `forget₂`-composite). Use `erw` when the `X.ringCatSheaf` leg is FIRST;
   otherwise peel `forget₂` via `change` then combine the inner maps with `Functor.map_comp` applied as a
   TERM. Use `X.ringCatSheaf.obj.map` UNIFORMLY (never `.val.map` — records as `Sheaf.val`, blocks combines).

### `chartOverIso` engine redirect — SOLVED (local)
`import AlgebraicJacobian.Picard.SheafOverEquivalence` + body `Scheme.Modules.chartOverIso U M e`.
`LineBundleCoherence.lean` is now locally sorry-free (`lake env lean` exit 0); the 5 pinned engine decls
(`chartPresentation`/`isFinitePresentation`/`isFiniteType`/…) become fully axiom-clean with NO further
edits to that file once the two shared-root consumer isos land.

### `restrictOverIso`, `unitOverIso` — PARTIAL (see milestones)
Both genuine partials, not Mathlib-blocked. Routes documented in-file and in milestones.

### D3′ `pullbackTensorMap_restrict` (TensorObjSubstrate.lean) — NOT WORKED
The plan listed D3′ Sq2b (analogist recipe `d3sq2b258.md`) as objective #2, but **no edits and no
task_result were produced** for `TensorObjSubstrate.lean` this iter. Prover capacity went to the shared
root + the two held-file finishes instead. D3′ must be re-dispatched.

### `sliceDualTransport` (DualInverse.lean) — HELD (sanctioned)
Comment-only cleanup per plan; the file remains at 2 typed sorries, gated on the shared root. An empirical
probe (`refine LinearEquiv.toModuleIso ?_`) confirmed the reduced `≃ₗ` goal is exactly the per-open
localization of `overEquivalence` at `V` — so it closes next iter as a consumer, not via the ~200 LOC
sectionwise build the plan pivoted away from.

## Subagent findings (full reports linked)
- **lean-vs-blueprint-checker / soe258** (`task_results/lean-vs-blueprint-checker-soe258.md`):
  SheafOverEquivalence chapter is adequate; `overEquivalence`/`chartOverIso` match pins. **MAJOR (not
  must-fix)**: the `unitOverIso` chapter sketch gives the conceptual route but does **not name**
  `SheafOfModules.unitToPushforwardObjUnit`, `_val_app_apply`, or the `isIso_iff_of_reflects_iso`
  reflection chain — blueprint should be expanded with these Lean API names.
- **lean-vs-blueprint-checker / lbc258** (`…-lbc258.md`): LineBundleCoherence chapter clean; the 5 pinned
  decls match. **MAJOR (not must-fix)**: a stale `% NOTE (review iter-257)` claiming `chartOverIso` is the
  SOLE remaining sorry — **FIXED this review** (updated to iter-258 reality; see manual markers below).
- **lean-auditor / iter258** (`task_results/lean-auditor-iter258.md`): 0 must-fix, 1 major, 2 minor.
  **MAJOR**: stale "WARM-CONTEXT WARNING" in `DualInverse.lean:287–315` (`dual_restrict_iso` outer
  strategy) — says "genuine new build, not a missing import" and points at the superseded iter-230
  `overSliceSheafEquiv` diagnostic; a prover reading only that outer strategy would follow the wrong path.
  Cannot be fixed by review (it is a `.lean` comment) → flagged for the next prover/refactor on re-open.
  **MINOR**: docstring overclaim at `SheafOverEquivalence.lean:22` (`chartOverIso` "closes" — it relocates);
  bare `exact sorry` at `restrictOverIso` L235 without an inline `-- OPEN` annotation.

## Blueprint-doctor (logs/iter-258/blueprint-doctor.md)
Findings are OUTSIDE this iter's lanes (Cohomology engine), surfaced for the planner:
- `Cohomology_CechHigherDirectImage.tex` `% archon:covers` a **non-existent** file
  `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`.
- 5 broken `\ref{…}` in that same chapter (no matching `\label`): `lemma-cech-cohomology-quasi-coherent`,
  `…-trivial`, `lemma-flat-base-change-cohomology`, `lemma-quasi-coherence-higher-direct-images-application`,
  `lemma-quasi-coherent-affine-cohomology-zero`.

## `\leanok` sync attribution
`sync_leanok-state.json`: iter 258, sha `246b6c77`, **+9 / −0**, chapters `Picard_LineBundleCoherence.tex`
+ `Picard_SheafOverEquivalence.tex`. A clean positive net — the new shared-root chapter's closed blocks
got their markers. No laundering: `overEquivalence` is genuinely axiom-clean (verified).

## Blueprint markers updated (manual)
- `Picard_LineBundleCoherence.tex`, `lem:lbc_chart_presentation` proof: replaced the stale
  `% NOTE (review iter-257)` (claimed `chartOverIso` was the SOLE remaining sorry + demanded a new
  blueprint block) with a `% NOTE (review iter-258)` recording that the bridge is now BUILT
  (`Scheme.Modules.chartOverIso`, linchpin `overEquivalence` closed axiom-clean; two consumer isos remain).

## Recommendations (see recommendations.md)
Prioritize the two shared-root consumer isos (small, unblock BOTH lanes), re-dispatch the un-run D3′,
expand the `unitOverIso` blueprint sketch, and fix the stale DualInverse WARM-CONTEXT WARNING on re-open.
