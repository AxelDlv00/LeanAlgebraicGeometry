# Mathlib Analogist: dualnat006
**Mode:** cross-domain | **Iter:** 006

## Analogues Found
- **`IsIso.inv_comp_eq` (`Mathlib.CategoryTheory.Iso`) + `CommSq.horiz_inv` (`Mathlib.CategoryTheory.CommSq`)**:
  rotate the `inv ε` (`dualUnitRingSwap`) edge across the square → goal becomes the FORWARD `ε`
  square. Morphism-level; NO `ext z`/`dualUnitRingSwap_apply`, so `whnf` never touches `inv ε`.
  Directly kills the documented heartbeat timeout. **LOW cost** (`isIso_ε_restrictScalars_appIso`
  already supplies `IsIso`). ANALOGUE_FOUND.
- **`NatTrans.IsMonoidal.unit` / `.unit_assoc` (`Mathlib.CategoryTheory.Monoidal.NaturalTransformation`)**:
  `ε F₁ ≫ τ.app 𝟙 = ε F₂` IS the project's pointwise ε-commutation, stated as ONE coherence axiom.
  Recognize leg-B as a monoidal-nat-trans unit cell; ε carrier formula
  `ModuleCat.restrictScalars_η : ε(restrictScalars f) r = f r`
  (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`). **LOW-MED**. ANALOGUE_FOUND.
- **`ModuleCat.restrictScalarsComp` (`…ChangeOfRings`) + `RingCat.moduleCatRestrictScalarsPseudofunctor`
  (`…ModuleCat.Pseudofunctor`)**: restrictScalars is a pseudofunctor `RingCatᵒᵖ→Cat`; the wanted
  naturality is the image of `Scheme.Hom.appIso_inv_naturality` under it. Consume packaged
  `restrictScalarsComp'App`/`restrictScalarsId'App` (project ALREADY uses these in
  `sliceDualTransportInv.collapse`). **MED**. ANALOGUE_FOUND.
- **`conjugateEquiv_comp` / `mateEquiv_vcomp` (`Mathlib.CategoryTheory.Adjunction.Mates`)**: mate of a
  commuting square commutes free; needs per-section `extendRestrictScalarsAdj` scaffolding. **HIGH**,
  overkill. PARTIAL_ANALOGUE.

## Top Suggestion
Rewrite both `naturality` holes in `DualInverse.lean` (`sliceDualTransport` ~L547,
`sliceDualTransportInv` ~L398) at the morphism level: `apply PresheafOfModules.hom_ext; intro W`,
then `haveI := isIso_ε_restrictScalars_appIso f _; rw [IsIso.inv_comp_eq]` to push the
`dualUnitRingSwap` (`= inv ε`) edge to the RHS, converting the goal into the FORWARD `ε`-naturality
square. Close it by gluing `hφ := φ.naturality i.op` (already in hand) to the ε-leg via
`ModuleCat.restrictScalars_η` + `restrictScalarsComp'App`. This deletes the `dualUnitRingSwap_apply`
rewrite that forces `inv ε` through `whnf` per element — the documented timeout cause (failed
approach #1). First file: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`.

## Structural problem
Naturality of a sectionwise family `T_V = legA_V ≫ (inv ε)_V` over the thin poset `Opens Y`,
assembling into a `PresheafOfModules.isoMk`; `ε` = lax-monoidal unit comparison of `restrictScalars`.
Pointwise reduction times out at `whnf` on the deep `inv ε` composite.

## Analogues (summary)
| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `IsIso.inv_comp_eq` + `CommSq.horiz_inv` | cat theory (iso calculus) | low | ANALOGUE_FOUND |
| `NatTrans.IsMonoidal.unit` | monoidal cat theory | low-med | ANALOGUE_FOUND |
| `restrictScalarsComp` + `moduleCatRestrictScalarsPseudofunctor` | change-of-rings / 2-cat | med | ANALOGUE_FOUND |
| `conjugateEquiv_comp` / `mateEquiv_vcomp` | adjunction / mate calculus | high | PARTIAL_ANALOGUE |

## Top suggestion
Try `IsIso.inv_comp_eq` / `CommSq.horiz_inv` first (analogue #1), glued with the pseudofunctor
coherence (#3). The whole 30-iter blockage is that leg-B is `inv ε` and every attempt applies it to
a section element (`dualUnitRingSwap_apply`), forcing `whnf` on the deep `inv ε` composite. The
inverse-edge rotation lemmas let you discharge the square WITHOUT ever applying `inv ε`: move it to
the far side via `rw [IsIso.inv_comp_eq]`, leaving a forward-`ε` square that `φ.naturality` plus
`ModuleCat.restrictScalars_η`/`restrictScalarsComp'App` close. Read
`Mathlib.CategoryTheory.CommSq` (`horiz_inv`) and `Mathlib.CategoryTheory.Iso` (`inv_comp_eq`);
touch `DualInverse.lean` L398 + L547.

## Discarded
- `subsingleton` (failed approach #2): only the OUTER dual-valued square, not these section squares.
- Pointwise `ext z; simp [dualUnitRingSwap_apply]` (failed approach #1): the whnf-timeout path itself.
- Full mate/conjugate port: HIGH scaffolding; overlaps the directive's "build adjunctions by hand".

## Persistent file
- `analogies/dualnat006.md` — written.

Overall verdict: the blockage is structural (leg-B is `inv ε`, reduced pointwise); the fix is the
inverse-edge rotation lemmas (`IsIso.inv_comp_eq`/`CommSq.horiz_inv`), which discharge the square at
the morphism level so `whnf` never reduces `inv ε`.
