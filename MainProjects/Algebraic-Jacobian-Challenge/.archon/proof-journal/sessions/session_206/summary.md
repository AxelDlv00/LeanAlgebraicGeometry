# Session 206 — review of iter-206

## Metadata

- **Single prover lane**: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (Lane TS), mode `prove`, status `done`.
- **Sorry trajectory**: TS file **4 → 3** (net −1). Global ~81 → ~80. Build GREEN (`lake env lean` exit 0; only deprecation + 3 `sorry` warnings). **Zero `axiom` declarations** (blueprint-doctor confirms none project-wide).
- **COE**: not dispatched (escalation pause honored, now its 3rd consecutive iter).
- **Targets attempted**: `tensorObj_restrict_iso` (advanced, still residual sorry); `monoidalCategory` instance + 2 transport lemmas (removed — net −1); `exists_tensorObj_inverse` / `addCommGroup_via_tensorObj` (untouched, blocked).

## The defining event: the iter-206 plan's pre-committed reversal signal FIRED

The iter-206 plan adopted the **TS flat/line-bundle pivot** (`## Decision made`) on the
premise that `tensorObj_restrict_iso`, re-scoped to line bundles, reduces to
"elementary flat-exactness already available in Mathlib," bypassing the
`MonoidalClosed (PresheafOfModules R₀)` wall. The plan explicitly pre-committed:
*"the TS prover finding that the comparison-map construction `(L⊗M)|_f → L|_f ⊗ M|_f`
cannot be built at the sheaf level without the monoidal machinery after all … re-evaluate
next iter."*

**That signal fired this iter.** The prover (and, independently, lean-vs-blueprint-checker
ts-iter206) found:

- `PresheafOfModules.pullback φ` is an **abstract left adjoint** (`(pushforward φ).leftAdjoint`,
  `Mathlib/.../Presheaf/Pullback.lean:44`) with **no sectionwise formula**, so the
  base-change comparison **map itself is absent** from Mathlib — it is the oplax-monoidal
  structure (mate of the strong-monoidal `pushforward`), not yet constructed.
- **Flatness does NOT shortcut this**: it only upgrades an already-existing map to an iso.
  Re-scoping the signature to line bundles is therefore **not** sufficient to unblock; the
  blocker is upstream of the flatness step.

So the flat-pivot's central premise is partially **disproven**. TS now sits on the **same
class of multi-file absent-Mathlib gap** as COE (which is paused): a monoidal/oplax structure
on a pullback/localization of presheaves of modules. The gap is a *lift* (the sectionwise
`ModuleCat.extendScalars.Monoidal` exists at `.../ModuleCat/Monoidal/Adjunction.lean:42`),
not an invention — but it is a `mathlib-build`-scale lane, not a single prove lane.

## Real progress this iter (genuine, but not a critical-path sorry closure)

1. **Removed the dead `monoidalCategory := sorry` instance** + the two off-path
   `MonoidalClosed`-route supplements (`isMonoidal_W_of_whiskerLeft`,
   `monoidalCategoryOfIsMonoidalW`) and the `MathlibSupplementMonoidalSheafification`
   section. This **clears the iter-203/204/205 contamination guard** (the sorry-bearing
   `instance` flowing `sorryAx` to consumers). Net −1 sorry. lean-auditor confirmed no
   dangling references to the removed decls.
2. **`tensorObj_restrict_iso` advanced** from a bare-sorry-with-comment to **two genuine
   Mathlib reduction steps** before its residual `sorry`:
   - Step 1: `Scheme.Modules.restrictFunctorIsoPullback f` (restrict ≅ pullback).
   - Step 2: `SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom` — **this IS in
     Mathlib**, correcting the prior multi-iter docstring claim that
     "sheafification commutes with pullback" was absent. Discharges half the obstruction.
   - Residual goal: `sheafify ((PresheafOfModules.pullback φ.hom).obj (M.val ⊗ N.val)) ≅
     (M.restrict f).tensorObj (N.restrict f)` — the missing presheaf base-change iso.
   Full write-up: `informal/tensorObj_restrict_iso.md`.

This is the same *progress shape* that defined COE's stall: each iter lands "the foundational
input" (a precisely-pinned residual) while the visible critical-path sorry count does not
move. Net −1 this iter is a dead-declaration removal, not a critical-path closure.

## Dead-ends recorded (do NOT retry — see recommendations.md)

- Adding `IsLocallyTrivial`/`Module.Invertible` hyps to close via flatness: does not reach
  the comparison-map construction (upstream of flatness).
- Relating `(M.restrict f).val` to `(PresheafOfModules.pullback φ.hom).obj M.val` at the pure
  presheaf level: adjoint on opposite sides, iso only after sheafification — circular without
  the base-change instance.

## Subagent findings (full reports linked; do not re-read raw here)

- **lean-vs-blueprint-checker ts-iter206** (`task_results/lean-vs-blueprint-checker-ts-iter206.md`):
  1 **must-fix (F1)** — the blueprint `lem:tensorobj_restrict_iso` proof sketch is **not
  formalizable as written** (claims flat-exactness closes the goal; omits the comparison-map
  construction that is the real blocker). 4 **major** (M1 missing `\lean{}` pin on
  `lem:tensorobj_restrict_iso` — *fixed this review*; M2 `lem:scheme_modules_tensorobj_functoriality`
  overpromises λ/ρ/α/β with no Lean decls; M3 `lem:tensorobj_lift_onproduct` scope mismatch;
  M4 four blocked blocks lack `\lean{}` pins + blocking annotations). All are **blueprint-writer**
  tasks for the iter-207 plan.
- **lean-auditor iter206** (45 files, `task_results/lean-auditor-iter206.md`): **0 new
  must-fix**; the iter-206 pivot is honest (removal clean, residual sorry honestly marked).
  2 **major** pre-existing excuse-comments: `RelPicFunctor.lean:266` TODO on the `addCommGroup`
  sorry (HELD lane) and `Genus0BaseObjects/BareScheme.lean:220` — a **`sorry` *instance***
  (`projectiveLineBar_geomIrred`) that propagates silently via `inferInstance` (long-standing
  since iter-165). Re-confirmed the two HELD `RelPicFunctor.lean` placeholders (L330 `PicSharp :=
  const PUnit`, L377 `functorial := 0`) persist unchanged. 1 minor: stale "iter-202" labels in
  the TS module docstring.

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_restrict_iso`: added
  `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` pin (was prose-only; lvb M1).
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_restrict_iso`: added `% NOTE:` recording that
  the flat-exactness proof sketch does not formalize as written (comparison map absent; flatness
  is downstream), pointing to the task_result + `informal/tensorObj_restrict_iso.md` (lvb F1).
- No `\leanok` added/removed (sync_leanok owns it; ran iter-206, added 0 / removed 0).
- No `\mathlibok` added (no pure Mathlib re-exports this iter).

## Blueprint doctor

No structural findings (every chapter `\input`'d, all `\ref`/`\uses` resolve, no `axiom`
declarations).

## Recommendations for next session

See `recommendations.md`. Headline: **do NOT autopilot another TS prove lane** — the
pre-committed reversal signal fired; TS is now in the COE-class multi-file-Mathlib-gap regime.
