# Picard/TensorObjSubstrate.lean — iter-217 fine-grained pass (H1 build + linchpin closure)

## Objective
BUILD the de-risked H1 ingredient (presheaf-level pushforward adjunction) and CLOSE the substrate
linchpin `tensorObj_restrict_iso`. Target: project sorry **81 → 80** (first elimination in 7 iters).

## RESULT: TARGET MET. `tensorObj_restrict_iso` is CLOSED, axiom-clean.
- File sorry count **4 → 3** (linchpin eliminated). Project **81 → 80**.
- `#print axioms tensorObj_restrict_iso` = `{propext, Classical.choice, Quot.sound}` — NO `sorryAx`,
  no project axioms. (The lean_verify "opaque" warning at L1294 is a source-scan hit on the word in a
  comment, not a real `opaque`.)
- File compiles: `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` → EXIT 0.

## Sentence-by-sentence (blueprint `lem:tensorobj_restrict_iso`, Steps 1–4)

### Step 1 "reduce restriction to the abstract pullback" → `restrictFunctorIsoPullback`
- **RESOLVED** — Mathlib decl, applied in the proof (`refine (restrictFunctorIsoPullback f).app _ ≪≫ ?_`).

### Step 2 "sheafification commutes with pullback" → `SheafOfModules.sheafificationCompPullback`
- **RESOLVED** — Mathlib decl, applied.

### Step 3 "strip the outer sheafification" → `sheafification.mapIso`
- **RESOLVED** — reduces the goal to the presheaf-level
  `(pullback φ).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.

### Step 4 H1 (sole Mathlib-ABSENT ingredient) — `pushforward β ≅ pullback φ`
Built the three presheaf-level helpers (de-sheafified from `Sheaf/PushforwardContinuous.lean`,
exactly per `analogies/ts217.md`), then closed via `leftAdjointUniq`:
- `PresheafOfModules.pushforwardNatTrans` (mirror `:154`) — **RESOLVED, axiom-clean**.
- `PresheafOfModules.pushforwardCongr` (mirror `:73`, via `isoMk` + `ModuleCat.restrictScalarsCongr`) — **RESOLVED**.
- `PresheafOfModules.pushforwardPushforwardAdj` (mirror `:226`) — **RESOLVED**. Open-immersion
  `H₁`/`H₂` discharged verbatim from Mathlib's sheaf `restrictAdjunction` (`f.app_appIso_inv`,
  `f.appIso_inv_app_presheafMap`). KEY: `φ`/`β` kept as `let` (zeta-transparent) and the adjunction
  `f.isOpenEmbedding.isOpenMap.adjunction` INLINED — a `have`/`set` makes `adj.unit` opaque and breaks
  the `congr` defeq (this matched the inline style of Mathlib's sheaf `restrictAdjunction`).
- Closure `hadj.leftAdjointUniq (pullbackPushforwardAdjunction φR)` — **RESOLVED**. Used the EXISTING
  `pullbackPushforwardAdjunction`, did NOT re-derive it (per analogist directive).

### Step 4 H2 (strong-monoidal tensorator, "bounded no-gap") — RESOLVED
- `PresheafOfModules.isIso_of_isIso_app` (sectionwise-iso ⇒ iso, via `isoMk`) — **RESOLVED**.
- `PresheafOfModules.restrictScalarsMonoidalOfBijective` (presheaf strong-monoidal `restrictScalars`
  for sectionwise-bijective base change, via `Functor.Monoidal.ofLaxMonoidal` over the file's lax
  instance + the closed `restrictScalars_isIso_{μ,ε}_of_bijective`) — **RESOLVED**.
- μIso closure — **RESOLVED**. CRITICAL technique: built `Functor.Monoidal.μIso` for the composite
  `pushforward₀OfCommRingCat F X.presheaf ⋙ restrictScalars β'` over the SYNTACTIC `_ ⋙ forget₂`
  base form (where the `MonoidalCategory` instance is found canonically), then `exact`-ed it against
  the goal whose base `X.ringCatSheaf.obj` is only DEFEQ (not syntactic) `X.presheaf ⋙ forget₂`.
  This avoids the `⊗`-vs-`Monoidal.tensorObj` instance DIAMOND that adding local `MonoidalCategory`
  instances on the `ringCatSheaf.obj` form produced (kernel-rejected). `(pushforward β).obj M.val =
  (M.restrict f).val` is definitional, so the final `exact (μIso …).symm` matches by defeq.

### Assembly `tensorObj_restrict_iso` — RESOLVED, axiom-clean (see top).

## New reusable declarations added (all axiom-clean, compile)
1. `PresheafOfModules.pushforwardNatTrans` (+ `_app_app_apply` simp)
2. `PresheafOfModules.pushforwardCongr` (+ `_hom_app_app`, `_inv_app_app` simps)
3. `PresheafOfModules.pushforwardPushforwardAdj`
4. `PresheafOfModules.isIso_of_isIso_app`
5. `PresheafOfModules.restrictScalarsMonoidalOfBijective`

These are clean candidates for an upstream Mathlib PR (the presheaf-level analogues of the existing
sheaf-level `Sheaf/PushforwardContinuous.lean` API).

## Remaining sorries in this file (3, all pre-existing, NOT this iter's target)
- L600 `isLocallyInjective_whiskerLeft_of_W` — route-(e) stalkwise residual; VESTIGIAL (the live
  associator `tensorObj_assoc_iso` already compiles green via route-(d)). Deletion-safe per memory.
- L1375 `exists_tensorObj_inverse` — the ⊗-dual / inverse existence (separate lemma).
- L1415 `PicSharp.addCommGroup_via_tensorObj` — the RPF consumer (downstream of the group law).

## Blueprint markers (for review agent / sync)
- `lem:tensorobj_restrict_iso` proof block → now `\leanok`-eligible (closed, no sorry).
- `lem:restrictscalars_ringiso_tensorequiv`, `lem:restrictscalars_ringiso_strongmonoidal` — unchanged,
  still backing H2. The plan agent may wish to add `\lean{}` pins for the 5 new presheaf helpers above.

## Why I stopped
**Real progress: linchpin CLOSED (1/1 target sentence + 8 supporting sub-lemmas closed); file sorry
4 → 3, project 81 → 80.** The single highest-value, explicitly-Mathlib-absent obligation of this
chapter (H1 `pushforward β ≅ pullback φ`) is built and the linchpin `tensorObj_restrict_iso` is fully
closed and axiom-clean. The 3 remaining file sorries are out of this iteration's scope (the vestigial
route-(e) lemma + the inverse-existence + the RPF consumer).
