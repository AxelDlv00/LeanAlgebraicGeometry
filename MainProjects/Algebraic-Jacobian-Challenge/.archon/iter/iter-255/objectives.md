# Iter-255 — per-lane prover recipes

Both lanes have CONCRETE, verified recipes this iter (the 4-iter no-close streak's blockers are both
now resolved at the planner level). M=2.

## Lane TS-cmp — close D1′ `pullbackTensorMap_natural` (`Picard/TensorObjSubstrate.lean`, sorry ~L2064)

**Recipe = mathlib-analogist mapin255 option (A), VERIFIED LIVE via `lean_multi_attempt` this iter.**
Read `analogies/mapin255.md` IN FULL.

The blocker was `δ_natural (F := pullback φ')` failing `synthesize MonoidalCategory (PresheafOfModules
X.ringCatSheaf.obj)` after `simp only [pullbackTensorMap]` zeta-reduces the canonically-ascribed `let
φ'` to the bare `(Hom.toRingCatSheafHom f).hom`, re-exposing the `ringCatSheaf.obj` spelling. The fix
re-establishes the canonical spelling AT the `F :=` argument itself (NOT a `(C := …)` slot — that
device does not transfer to `δ_natural`; a `show … from` ascription on `F`'s ring map does):

```lean
erw [← Functor.OplaxMonoidal.δ_natural
  (F := PresheafOfModules.pullback
    (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
      from (Hom.toRingCatSheafHom f).hom))
  a.val b.val]
```

- **`erw` not `rw`** — the ascription pretty-prints as `have this := …; this`; plain `rw` misses the
  pattern, `erw`'s reducible-defeq match bridges the zeta gap and fires.
- After the `erw`, Square 2 (δ-commutation, `M'.val N'.val ⇝ M.val N.val` with `Fp a.val ⊗ Fp b.val`)
  is DONE. Residual = assemble Square 3 (`sheafifyTensorUnitIso_hom_natural`, CLOSED iter-254) + Square
  4 (`pullbackValIso_hom_natural`, CLOSED) + bifunctoriality `tensorHom_comp_tensorHom`, via the STEP-A
  `(C := …)`-pinned TERM-level device. The cosmetic `have this := …; this` wrapper the `erw` leaves is
  defeq to the bare hom — discharge with `show`/`change`/`dsimp only []` as surrounding steps do.
- **Guardrails**: option (A) touches NO def, so D2′ `pullbackTensorMap_unit_isIso` (L1848) stays GREEN —
  do NOT restate `pullbackTensorMap`/helpers. Do NOT touch `exists_tensorObj_inverse` (L712). Do NOT
  revive the general Lan build.
- **Minor cleanup** (you own this file): stale comment ~L2019-2020 ("S3 … the one open sorry") — S3 is
  CLOSED; update.
- **Bar**: close D1′ `pullbackTensorMap_natural`. D3′/D4′ NOT this iter.
- **Reversing signal**: mapin255 verified the `erw` FIRES live, so D1′ should close. If the residual
  Sq3/Sq4 assembly hits a genuinely NEW obstacle → STOP, leave the file COMPILING (restore the sorry),
  report the exact residual + which step failed. Do NOT invent a 4th pivot, do NOT attempt a structural
  refactor (mapin255 confirmed none is needed). No user escalation.

## Lane TS-inv — close `homOfLocalCompat` ring-bridge (`DualInverse.lean`, sorry ~L636)

**Recipe = the iter-254 prover's fully-mapped inline handoff.** sub-steps (a)+(b) CLOSED, (c) ~90%
built; ONLY the open-immersion carrier-duality ring-bridge at L636 remains.

At L636 the inner leg `((toPresheaf _).map (f i).val).app (op P)` is `Ab`-additive only; its
`(U i)`-linearity must be reinterpreted at the `ModuleCat` level via the structure-ring iso
`((U i).ι.appIso P)`:
1. Prove `r₂ •_X z₂ = (appIso.hom r₂) •_{Ui} z₂` — likely `rfl` modulo `appIso.inv_hom_apply` + the
   `restrictScalars`-smul-is-`rfl` fact (`PresheafOfModules.pushforward_obj_obj`).
2. `erw [map_smul]` (or `LinearMap.map_smul`) on `(f i).val.app (op P)` at the `(U i)` ModuleCat level
   ⟹ `(f i).app (s •_{Ui} z) = s •_{Ui} (f i).app z`.
3. N-leg `map_smul` + reconcile the `eqToHom`-transported scalars (`X.ring.map (eqToHom e₁)`,
   `X.ring.map (eqToHom e₂)` compose to `id` on `W` since `e₂ = e₁.symm`).

- **Keep INLINE** — a standalone `homLocalSection_app_smul` helper FAILS instance synthesis (the
  `Module (↑X.ringCatSheaf.obj.obj (op W)) (↑M.val.obj (op W))` instance is not found standalone).
- Use **`erw`** for the wrapped `AddCommGrpCat.Hom.hom` (`rw`/`simp [comp_apply]` do NOT fire).
- **NO new helper** (pc255 CHURNING corrective: extra scaffolding around the ring-bridge IS the pattern
  to break — close it inline).
- **Then** attempt `dual_restrict_iso` Step-4 (~L256) ONLY if `homOfLocalCompat` closes
  (`analogies/dual252.md`: shortcut from CLOSED `tensorObj_restrict_iso` first; dual is NOT sectionwise).
- **Bar**: CLOSE `homOfLocalCompat`.
- **Reversing signal**: if the ring-bridge does NOT close as diagnosed (a NEW defeq/instance obstacle) →
  STOP, report the exact goal + the spelling chosen, do NOT proceed to Step-4, do NOT add a wrapper.

## Guardrails (both lanes)
- Leave both files COMPILING at session end (DualInverse imports TensorObjSubstrate). If TS-cmp's D1′
  does not close, restore its sorry and leave the file GREEN.
- No new axioms.
