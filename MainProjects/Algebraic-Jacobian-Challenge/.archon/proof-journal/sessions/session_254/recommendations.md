# Recommendations — for the iter-255 plan agent

## TOP PRIORITY (HARD-GATE blocker before the next D1′ prover round)

1. **Blueprint must-fix (tscmp254): `lem:pullback_tensor_map_natural` proof is Lean-inadequate.**
   The proof says "δ is natural for any oplax monoidal functor" — correct, but UNFORMALIZABLE as
   written: `Functor.OplaxMonoidal.δ_natural` needs `MonoidalCategory (PresheafOfModules
   X.ringCatSheaf.obj)`, which is not registered (only on `X.presheaf ⋙ forget₂ CommRingCat RingCat`).
   **Action:** dispatch a blueprint-writer on `Picard_TensorObjSubstrate.tex` to add the spelling-pin
   guidance (the carrier-spelling constraint + the prescribed structural refactor of `pullbackTensorMap`).
   A review `% NOTE:` already flags this at the proof of `lem:pullback_tensor_map_natural`. This gates
   the HARD GATE for `TensorObjSubstrate.lean`'s D1′ work — do NOT re-dispatch a D1′ prover until the
   chapter is patched and re-reviewed (the same-iter fast path applies).
   This dovetails with the planner's already-committed **spelling-pin refactor** decision (iter-254
   plan, "Next-iter setup" / STEP-B reversing-signal routing): the structural restatement of
   `pullbackTensorMap` + helper isos onto the canonical `⋙ forget₂` domain-ring spelling is the actual
   unblocking move for D1′. Suggest a `refactor`-subagent for the Lean restatement (must keep D2′
   `pullbackTensorMap_unit_isIso` GREEN), then a blueprint-writer to match.

2. **Blueprint-doctor: relocate the misplaced `\leanok` in `Picard_RelPicFunctor.tex:145`.**
   `sync_leanok` inserted `\leanok` INSIDE the `\uses{...}` block of the `lem:rel_pic_sharp_groupoid`
   proof (between `def:pullback_along_projection,` and `thm:relative_pic_quotient_well_defined`),
   corrupting the `\uses` parse — the doctor reports `thm:relative_pic_quotient_well_defined` as a
   broken ref (the label IS defined, at `Picard_LineBundlePullback.tex:331`; the corruption is the only
   cause). **Action (plan agent — owns `\leanok` placement via prose edit):** move the `\leanok` to its
   own line OUTSIDE the `\uses{...}` braces (e.g. right after `\begin{proof}`). This is the recurring
   `\leanok`-in-`\uses{}` defect; the iter-250 relocation fix held for `Picard_TensorObjSubstrate.tex`
   but the same guard is needed for `Picard_RelPicFunctor.tex`.

## Closest-to-completion targets to prioritize

3. **`homOfLocalCompat` (DualInverse.lean L636) — ONE isolated ring-bridge sorry.** Everything else is
   proved (separatedness, naturality/`map_smul`, the hard gluing-transport `hconn`, composite
   decomposition, M-leg `map_smul`). The residual is the open-immersion carrier-duality: prove the inner
   leg `((toPresheaf _).map (f i).val).app (op P)` is `(U i).ringCatSheaf(P)`-linear. **Mapped route**
   (next prover): at L636 prove `r₂ •_X z₂ = (appIso.hom r₂) •_{Ui} z₂` (likely `rfl` modulo
   `appIso.inv_hom_apply` via `PresheafOfModules.pushforward_obj_obj` + `restrictScalars`-smul-is-`rfl`),
   then `erw [map_smul]` on `(f i).val.app (op P)` at the `(U i)` level, then N-leg `map_smul`, then
   reconcile the `eqToHom`-transported scalars (`e₂ = e₁.symm`). **DEAD END (do not retry):** a
   standalone `homLocalSection_app_smul` helper — fails instance synthesis (`Module (↑X.ringCatSheaf(W))
   (↑M.val(W))` not found abstractly); keep the proof INLINE. This is a clean single-lane target for
   iter-255 (no blueprint blocker — dualinv254 found 0 must-fix; the chapter matches the re-signed `hf`).

## Reusable proof patterns discovered (this iter)

- **`(C := …)` term-level monoidal-lemma device** dissolves the non-canonical-`MonoidalCategory`-instance
  poisoning (closed the 5-iter STEP-A wall). Apply monoidal lemmas as TERMs (`refine (… (C := X.presheaf
  ⋙ forget₂ CommRingCat RingCat) _ _ _ _).trans ?_ / exact (…).symm`), NOT via `rw`/`erw`. Reusable for
  the remaining D1′ squares — but does NOT transfer to `δ_natural` (no instance slot in its domain ring),
  which is exactly why D1′ now needs the spelling-pin refactor.
- **Name trap:** `MonoidalCategory.tensor_comp` does NOT exist; use `MonoidalCategory.tensorHom_comp_tensorHom`.
- **`erw [← Functor.map_comp_assoc]`** (reassoc form) merges right-associated `a.map A ≫ (a.map B ≫ rest)`
  — plain `← Functor.map_comp` cannot (the iter-253 "maps don't unify" diagnosis was wrong).
- **`erw [ConcreteCategory.comp_apply]`** (not `rw`/`simp`) to decompose composites at the
  `AddCommGrpCat.Hom.hom` element level.
- **Verify "PROTECTED" against `archon-protected.yaml`, not stale in-file comments** — the iter-253
  `hf:HEq` self-imposed throttle cost an iter; re-signing to the sectionwise form closed sub-step (a).

## Blocked / do-NOT-retry

- **`pullbackTensorMap_natural` (D1′) against the current `X.ringCatSheaf.obj` spelling** — `δ_natural`
  cannot synthesize `MonoidalCategory`. Needs the spelling-pin refactor FIRST (see #1). Do not re-dispatch
  a tactic-only prover.
- **`dual_restrict_iso` Step-4 (L256)** — defer until `homOfLocalCompat` fully closes; the dual-pushforward
  presheaf residual is a separate equally-hard build.

## Lower-severity (lean-auditor aud254 + checkers, non-blocking)

- **MAJOR (aud254): `set_option backward.isDefEq.respectTransparency false` at `TensorObjSubstrate.lean:1661`**
  (scoped to `epsilonPresheafToSheafUnit`). Kernel-level defeq hack — could silently break on a Mathlib
  bump. Pre-existing; schedule a polish pass to remove it, but not blocking.
- **MINOR:** stale in-Lean comment `TensorObjSubstrate.lean:2019-2020` (refers to S3 as an open sorry; S3
  closed this iter) — the next prover touching that file should update it. Off-path
  `PullbackLanDecomposition` section + nested planner-strategy block-comments (readability only).
- **MINOR (dualinv254):** consider `\lean{}` pins for `dualUnitIsoGen` and `image_preimage_of_le`, and
  clarify the blueprint `hf` shorthand at `Picard_TensorObjSubstrate.tex:5886` ("equates the middle terms
  directly" → "...the eqToHom-conjugated composites in the fixed type M(V)→N(V)"). All non-blocking.

## Engine 3rd-lane commitment (iter-254 plan carried forward)
- The iter-254 planner committed to dispatching a blueprint-writer for the engine 3rd lane
  (`IsLocallyTrivial ⟹ IsFinitePresentation`, engine252-scoped, new chapter) at iter-255 to enable M=3
  per the standing PARALLELISM directive (the pc254 avoidance-clock). Honor this — un-blueprinted phases
  should not accumulate.
