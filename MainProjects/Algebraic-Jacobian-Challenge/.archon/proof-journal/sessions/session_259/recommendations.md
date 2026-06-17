# Recommendations for the next plan iteration (iter-260)

## Subagent findings (HIGH first)
- **[MUST-FIX, blueprint] `Picard_TensorObjSubstrate.tex` Sq2b proof paragraph is materially wrong**
  (lvb-tos259). It claims the lax-μ residual `pushforwardComp_lax_μ` "holds definitionally, exactly
  as the unit twin `unitToPushforwardObjUnit_comp`" — the Lean empirically disproves this (it is a
  ~150-LOC ModuleCat coherence, an open `sorry`). I added a `% NOTE:` at ~L3998 flagging it.
  **Action:** dispatch a blueprint-writer on this chapter to rewrite the Sq2b paragraph (drop the
  "definitional / same template as `isMonoidal_comp`" claim; state the genuine residual + the
  `ModuleCat.restrictScalarsComp`/`extendScalarsComp` requirement). The full
  `pullbackTensorMap_restrict` lane should not be re-dispatched until this is corrected.
  Report: `task_results/lean-vs-blueprint-checker-tos259.md`.
- **[MAJOR, .lean stale comments] lean-auditor (iter259) — 3 stale-status comments** to fix when the
  relevant lanes re-open (review agent cannot edit `.lean`):
  1. `TensorObjSubstrate.lean:43–45` — header says "ONE tracked typed-`sorry`" but there are now
     THREE (`exists_tensorObj_inverse` L715, `pushforwardComp_lax_μ` L2169,
     `pullbackTensorMap_restrict` L2399). Fix the count.
  2. `DualInverse.lean:303–308` — STATUS NOTE says `restrictOverIso`/`unitOverIso` are "not yet
     green / in-flight"; both are now fully proven. Route (1) is no longer gated — update before the
     prover re-reads it (else it will wrongly believe the lane is still held).
  3. `SheafOverEquivalence.lean:22` — "Next iter: redirect `LineBundleCoherence.chartOverIso`" — the
     redirect is already done. Stale directive.
  - Minor: `TensorObjSubstrate.lean:2167` embeds a tooling note ("Informal agent unavailable…MOONSHOT
    401") in a math proof comment — remove; `LineBundleCoherence.lean:63` future-tense framing of a
    now-completed close. Report: `task_results/lean-auditor-iter259.md`.
- **[OK] lvb-soe259 — no must-fix.** Two minor wording imprecisions in the `restrictOverIso` sketch
  ("pushforwardComp = Iso.refl" is proved-not-definitional; the `set_option respectTransparency`
  technicality is unmentioned). Optional writer polish, not blocking. Report:
  `task_results/lean-vs-blueprint-checker-soe259.md`.

## Closest-to-completion targets — PRIORITIZE
1. **`sliceDualTransport` → `dual_restrict_iso` (`DualInverse.lean`) — route-(1) consumer one-liner.**
   The shared root `SheafOverEquivalence.{restrictOverIso,unitOverIso}` is now green and STABLE, so
   the cross-lane race that held this file is gone. Re-open Lane TS-inv: add
   `import AlgebraicJacobian.Picard.SheafOverEquivalence`, bridge `f ≅ (f.opensRange).ι`, and close
   `sliceDualTransport` as the per-`V` localization of `overEquivalence` (consume `restrictOverIso`/
   `unitOverIso`). `dual_restrict_iso` then closes for free (`cat_disch`/`Subsingleton.elim`).
   - **Recorded gotcha:** LHS `Module 𝒪_Y(V)` is NOT auto-synthesized — `letI` via
     `Module.compHom (β.app V)`, exactly as `restrictScalarsRingIsoDualEquiv`
     (`PresheafInternalHom.lean:234`).
   - **Do NOT** route through `overSliceSheafEquiv` (fixed value cat — cannot carry the varying ring).
   - This advances the canonical critical-path `exists_tensorObj_inverse` (the ⊗-inverse).

2. **A.2.c engine `LineBundleCoherence.lean` — now fully axiom-clean; confirm + mark.**
   `chartOverIso` is closed, so `isFinitePresentation`/`isFiniteType`/`chartPresentation` are
   transitively axiom-clean with no edits. No prover work needed — verify `#print axioms` and let
   sync add the `\leanok`s. This is a completed engine deliverable; the plan agent should record it
   closed.

## Promising, needs a dedicated fine-grained round
3. **`pushforwardComp_lax_μ` (`TensorObjSubstrate.lean`) — the genuine D3′ residual.**
   It is the "pushforwardComp is monoidal" ModuleCat base-change coherence (`extendScalarsComp` /
   `restrictScalarsComp` / `homEquiv_extendScalarsComp`), ~150 LOC; the `ext W x` leaf is in place.
   - **DO NOT re-dispatch with the "rfl / short ext" recipe** — the prover empirically refuted it
     this iter (tested rfl, ext;rfl, ext;simp, dsimp;rfl — all fail). The blueprint sketch (bw258-d3)
     was wrong; a writer pass should correct the Sq2/Sq2b paragraph (the lvb-tos259 check confirms).
   - Recommend a `mathlib-build`/fine-grained prover mode, or a **mathlib-analogist (api-alignment)**
     consult on the right ModuleCat change-of-rings interchange lemma before dispatch. Once it lands,
     `pullbackComp_δ` is fully axiom-clean and Sq2 of `pullbackTensorMap_restrict` is discharged.

4. **`pullbackTensorMap_restrict` (D3′) — 4-square assembly.** Gated on (3) + Sq1/Sq3/Sq4
   (`sheafificationCompPullback`-comp, `sheafifyTensorUnitIso`, `pullbackValIso`-comp;
   `toRingCatSheafHom_comp_hom_reconcile` already rfl-closed). Sequence after (3).

## Do NOT retry without a structural change
- **`pushforwardComp_lax_μ` via rfl/short-ext** — disproven this iter (see #3).
- **`sliceDualTransport` via `overSliceSheafEquiv`** — fixed value cat, cannot carry varying ring.
- **Adding `import …SheafOverEquivalence` mid-edit** — was a deliberate race-avoidance; now safe
  because the shared root is stable.

## Blueprint / structural
- **bw257/bw258 D3′ Sq2b sketch is now disproven by the Lean.** Dispatch a blueprint-writer on
  `Picard_TensorObjSubstrate.tex` to correct the Sq2/Sq2b paragraph: the residual is the
  pushforwardComp-monoidality ModuleCat coherence, NOT a definitional transport. (Confirm against the
  lvb-tos259 report folded below.)
- **`Cohomology_CechHigherDirectImage.tex`** — orphan forward-spec chapter covering a non-existent
  `.lean` with 5 broken `\ref`s. Either create the file/labels or mark the chapter as a not-yet-started
  forward spec so the doctor stops flagging it.
- **`sync_leanok` −17 net removal** — plan agent should spot-check that no genuinely-closed proof
  block in `Picard_TensorObjSubstrate.tex` lost a legitimate `\leanok` (likely a correct deterministic
  re-eval after the new `pushforwardComp_lax_μ` sorry, but worth a glance).

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- Continuity discrim-tree wall fix: `set_option backward.isDefEq.respectTransparency false in` +
  `@Functor.isContinuous_comp … hF1 hF2`; supply `pushforwardComp`'s ψ explicitly (metavar → whnf
  timeout).
- `unitToPushforwardObjUnit` sectionwise iso leaf = `change` to `forget₂.map ((phiOver U).hom.app W)`
  + `infer_instance` (after app-wise `IsIso (phiOver U).hom`).
- Duplicate monoidal-vs-base Category instance: `erw` + pin `(C := …⋙forget₂)` + `exact Category.assoc`.
- `conjugateEquiv` / `unit_conjugateEquiv` are BARE; `CategoryTheory.Functor.map_id` (not bare).
