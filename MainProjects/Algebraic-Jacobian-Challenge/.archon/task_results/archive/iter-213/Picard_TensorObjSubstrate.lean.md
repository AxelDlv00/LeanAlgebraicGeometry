# Picard/TensorObjSubstrate.lean — iter-213 (Lane TS, prover)

## Headline

**The 8-iter-stuck associator `tensorObj_assoc_iso` is now CLOSED modulo a single,
clean, mathematically-TRUE abstract residual** (`isLocallyInjective_whiskerLeft_of_W`,
line ~411). The monolithic `sorry` is gone: the full 3-step composite, both
surjectivity halves, the localization bridge, the presheaf associator, the
braiding-conjugate right-whisker, AND the iter-212 `X.ringCatSheaf.val` defeq
friction are all RESOLVED. Net file sorry count unchanged (4), but the critical-path
sorry is replaced by one true lemma + 2 newly-closed helper lemmas.

`lean_verify` on `tensorObj_assoc_iso`: axioms = `{propext, sorryAx,
Classical.choice, Quot.sound}` — only `sorryAx` from the one residual; **NO project
axioms**. (The `opaque`-pattern warning at line 796 is a comment-scan false positive:
the `tensorObj_restrict_iso` docstring literally contains the word "OPAQUE".)

## What was built (all axiom-clean except the one residual)

### `tensorObj_assoc_iso` (line ~659) — re-scoped + CLOSED modulo residual
- Re-scoped hypotheses `IsInvertible → LineBundle.IsLocallyTrivial M N P` (decl is
  NOT protected; consumers use `IsLocallyTrivial`). Matches blueprint `lem:tensorobj_assoc_iso`.
- **ROUTE (d), not (c)** (see below): the three-step composite
  `(@asIso _ _ _ _ _ hi1).symm ≪≫ a.mapIso α ≪≫ (@asIso _ _ _ _ _ hi3)`:
  1. `hi1 : IsIso (a.map (η_{M♭⊗N♭} ▷ P♭))` via `isIso_sheafification_map_of_W` (closed
     iter-212) fed by `hW1` = `W_whiskerRight_of_W P.val (η.app MN) hηMN`.
  2. `a.mapIso ((monoidalCategoryStruct (R:=X.presheaf)).associator M.val N.val P.val)`.
  3. `hi3 : IsIso (a.map (M♭ ◁ η_{N♭⊗P♭}))` via the bridge fed by `hW3` =
     `W_whiskerLeft_of_W M.val (η.app NP) hηNP`.
- `η_A = toSheafify ∈ J.W` via `toPresheaf_map_sheafificationAdjunction_unit_app`
  (rfl) + `GrothendieckTopology.W_toSheafify`.
- **Carrier friction RESOLVED**: `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂
  CommRingCat RingCat` holds by `rfl`; bridged the missing
  `MonoidalCategoryStruct (PresheafOfModules (Sheaf.val X.ringCatSheaf))` with
  `letI ... := inferInstanceAs (... (X.presheaf ⋙ forget₂ _ _))`. This is the
  iter-212 "ringCatSheaf.val defeq / heartbeat" wall — it is GONE.
- The `IsLocallyTrivial` hypotheses are UNUSED (linter warns `hM hN hP`): ROUTE (d)
  proves the whiskered-unit `J.W` fact for ARBITRARY modules, so the associator is
  actually STRONGER than the blueprint statement. Kept the hyps to match the pin.

### NEW closed helpers (section `WhiskerOfW`, after `W_whiskerRight_of_flat`)
- `W_whiskerLeft_of_W` — CLOSED. `J.W (toPresheaf g) → J.W (toPresheaf (F ◁ g))` for
  ARBITRARY `F`. Surjectivity free (`isLocallySurjective_whiskerLeft`); injectivity
  delegated to the residual.
- `W_whiskerRight_of_W` — CLOSED. Braiding-conjugate of the above (mirrors
  `W_whiskerRight_of_flat`).

### THE SINGLE RESIDUAL — `isLocallyInjective_whiskerLeft_of_W` (line ~411, typed sorry)
Statement (substantive, TRUE): for arbitrary `F` and `g` with `J.W (toPresheaf g)`
(locally bijective), `IsLocallyInjective J (F ◁ g)`.

**Why it is true (ROUTE (d), the Mathlib-blessed flatness-free technique):**
stalkwise `(F ◁ g)_x = id_{F_x} ⊗_{R_x} g_x`; a `J.W`-map on the topological site of
`X` is a *stalkwise isomorphism* (`TopCat.hasEnoughPoints` + `hP.W_iff`,
`Sites.Point.*`, 2026), and `id ⊗ (iso)` is an iso — so `F ◁ g` is a stalkwise iso,
hence locally bijective, hence locally injective. **No flatness, no local
triviality.** This is precisely why iters 206–212 were stuck: they split `J.W` into
inj+surj and tried to preserve *injectivity alone*, which genuinely needs flatness
(FALSE for invertibles over non-affine opens). Preserving the *combined iso* needs no
flatness — the root-cause fix the analogist `ts-monoidal213.md` identified.

## Why the residual could NOT be closed this iter (precise residual, per reversal clause)

The stalkwise argument needs two ingredients, both **verified Mathlib-absent at the
`PresheafOfModules` level** this iter (LSP/leansearch):
- **(d.1)** stalk characterisation of the *module-level* `J.W` on `Opens X`
  (`J.W (toPresheaf f) ↔ ∀ x, IsIso (stalkFunctor x).map (toPresheaf f)`). Mathlib has
  `TopCat.Presheaf.app_injective_iff_stalkFunctor_map_injective` and
  `locally_surjective_iff_surjective_on_stalks` only for the TopCat-sheaf notions, not
  bridged to `CategoryTheory.Presheaf.IsLocallyInjective (Opens.grothendieckTopology X)`.
- **(d.2)** stalk commutes with the relative module-presheaf tensor:
  `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x`. Mathlib has only the SECTIONWISE
  `PresheafOfModules.Monoidal.tensorObj_obj` (`(A⊗ᵖB).obj U = A.obj U ⊗ B.obj U`); the
  stalk (filtered colimit) version over the varying ring `R(U)` does NOT exist.

Building both is a ~200–400 LOC stalk-infrastructure port (filtered colimit commutes
with relative tensor over a colimit of rings) — **mathlib-build scale**, exactly the
fallback case the analogist flagged ("if d.1 turns out to be heavy infrastructure").
Route (c) (sub-site restriction + right-unitor on a trivialising cover) was assessed
equally heavy and gives a *messier* residual (local-triviality-scoped, needs
restriction-to-sub-site infra also absent). ROUTE (d) yields the CLEANEST residual.

This is NOT "all realizations exhausted / substrate dead". The path EXISTS and is
Mathlib-blessed (`Sites.Point.IsMonoidalW` + `TopCat.hasEnoughPoints`, 2026); it just
needs a dedicated infra-build iteration to port d.1+d.2 to `PresheafOfModules`. The
associator is fully assembled and waiting on that one lemma.

## Attempt log

### tensorObj_assoc_iso
- Attempt 1: ROUTE (d) 3-step composite with `letI` carrier bridge. RESOLVED modulo
  residual. Key insights: `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂ _ _ := rfl`
  (kills iter-212 friction via `inferInstanceAs`); `toPresheaf (unit.app) = toSheafify`
  (rfl) + `W_toSheafify` give `η ∈ J.W` cheaply; `isIso_sheafification_map_of_W`
  (closed iter-212) inverts both whiskered units.

### isLocallyInjective_whiskerLeft_of_W (residual)
- Attempt 1 (stalk/route-d): blocked on Mathlib-absent (d.1)+(d.2). Documented.
- Attempt 2 (pure-section, route-c style): FAILED — without flatness,
  `ker(id_F ⊗ g_U)` is NOT generated by `F ⊗ ker(g_U)` (needs Tor₁ vanishing), so the
  `Module.Flat.lTensor_exact` step of `isLocallyInjective_whiskerLeft_of_flat` has no
  flatness-free section-level replacement; the trivialisation genuinely needs
  sub-site restriction infra (also absent). Dead end for section-only.
- Negative searches: "stalk of tensor of presheaves of modules" → nothing;
  "locally injective iff stalk injective (categorical, Opens)" → only sheaf/separated
  versions (`app_injective_iff_stalkFunctor_map_injective`).

## Flags for plan / review / blueprint

- **Blueprint `lem:tensorobj_assoc_iso`**: implementation uses ROUTE (d) (stronger:
  arbitrary modules), so the `IsLocallyTrivial` hypotheses are unused. Blueprint prose
  (currently route-c, local-triviality + right-unitor-on-cover) could be simplified to
  route (d) (stalkwise iso, no local triviality). `lem:flat_whisker_localizer` stays
  off-path. The new helpers `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` /
  `isLocallyInjective_whiskerLeft_of_W` are not yet blueprint-pinned — a writer should
  add `\lean{}` pins.
- **\leanok**: leave to `sync_leanok` (associator still transitively `sorry` via the
  residual).
- **Escalation (per reversal clause)**: the residual is a single feasibility-confirmed
  infra lemma, NOT a substrate dead-end. Recommend EITHER a dedicated infra-build
  iteration for d.1+d.2 (stalk-tensor port), OR USER decision. Do not pivot the
  substrate a fifth time — ROUTE (d) is sound and the associator is built around it.
- Pre-existing off-path sorries untouched: `tensorObj_restrict_iso` (760),
  `exists_tensorObj_inverse` (868), `addCommGroup_via_tensorObj` (908).
