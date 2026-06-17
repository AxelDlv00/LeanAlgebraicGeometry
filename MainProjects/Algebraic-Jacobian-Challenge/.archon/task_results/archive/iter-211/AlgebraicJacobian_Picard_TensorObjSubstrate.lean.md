# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary (iter-211 prover)

**The go/no-go gate `W_whiskerLeft_of_flat` is CLEARED.** It is a genuine,
axiom-clean proof (`lean_verify`: only `propext`, `Classical.choice`, `Quot.sound`
— NO `sorryAx`). The reversal trigger was **NOT** hit: the flat-whiskering route
needs **no** `MonoidalClosed` / strong-monoidal-pushforward. Realization (2) of
`analogies/ts-assoc-gate210.md` is confirmed buildable from present Mathlib.

New proven declarations this iter (all axiom-clean):
1. `PresheafOfModules.W_whiskerLeft_of_flat` — **the gate** (`lem:flat_whisker_localizer`).
2. `AlgebraicGeometry.Scheme.Modules.IsInvertible` — `def:scheme_modules_isinvertible`.
3. `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor` — `lem:tensorobj_unit_iso` (left).
4. `AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor` — `lem:tensorobj_unit_iso` (right).
5. `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding` — `lem:tensorobj_comm_iso`.

Plus a **bug fix**: `PresheafOfModules.isLocallyInjective_whiskerLeft_of_flat`
(one half of the gate) was **erroring** at file open (Mathlib bump broke a `simp`
on `x ⊗ₜ 0 = 0` — the factor is a `restrictScalars`-image module so `tmul_zero`'s
instance search fails on the displayed type). Fixed via `erw [TensorProduct.tmul_zero]; rfl`.

Remaining scaffolded typed `sorry` (new): `tensorObj_assoc_iso` (`lem:tensorobj_assoc_iso`).
Pre-existing off-path sorries left as-is per objective: `tensorObj_restrict_iso`,
`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`.

## W_whiskerLeft_of_flat (line ~332, FlatWhisker section) — RESOLVED
### Attempt 1
- **Approach:** The two halves (`isLocallySurjective_whiskerLeft`,
  `isLocallyInjective_whiskerLeft_of_flat`) already existed in the file. Package
  into `J.W` via `GrothendieckTopology.W_iff_isLocallyBijective` (needs
  `[J.WEqualsLocallyBijective Ab.{u}]`). `PresheafOfModules.IsLocallySurjective J g`
  is *defeq* to `Presheaf.IsLocallySurjective J ((toPresheaf _).map g)`, so the
  helper outputs slot directly into the `W_iff` unfolding.
- **Result:** RESOLVED.
- **Key insight:** the localizer is over `Ab.{u}` (= `AddCommGrpCat`, the target of
  `PresheafOfModules.toPresheaf`); the instance binder **must** be `Ab.{u}` with the
  explicit universe or synthesis fails (`Ab` defaulted to a different universe).
- **Placement note for review agent:** the lemma is in the `PresheafOfModules`
  namespace (where its `C/R/J` variables live), full name
  `PresheafOfModules.W_whiskerLeft_of_flat`. Blueprint `lem:flat_whisker_localizer`
  pins `\lean{AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat}` — that
  `\lean{...}` should be **corrected** to `PresheafOfModules.W_whiskerLeft_of_flat`.

## isLocallyInjective_whiskerLeft_of_flat (line ~291, tmul case) — RESOLVED (bug fix)
### Attempt 1
- **Approach:** the `simp` closing `(F.map f.op) a ⊗ₜ 0 = 0` stopped firing after a
  Mathlib bump. The first tensor factor elaborates in
  `(ModuleCat.restrictScalars (R.map f.op)).obj (F.obj X)`, so
  `TensorProduct.tmul_zero`'s instance `Module (R.obj (op V)) (restrictScalars…)`
  cannot be synthesized on the displayed type; `rw`/`exact`/`simp` all fail.
- **Result:** RESOLVED via `erw [TensorProduct.tmul_zero]; rfl` (erw matches up to
  the restrictScalars defeq; the trailing `0 = 0` needs an explicit `rfl`).
- **Dead end:** `rw [TensorProduct.tmul_zero]`, `exact TensorProduct.tmul_zero _`,
  `simp [TensorProduct.tmul_zero]`, `module`, `abel` — all fail on the wrapped module.

## Unitors / braiding (lines ~451–479) — RESOLVED
### Attempt 1
- **Approach:** mirror `tensorObj_unit_iso`'s `sheafification.mapIso (coherence) ≪≫
  (asIso counit).app M` pattern.
- **Dead end:** `λ_ M.val` / `ρ_ M.val` / `β_ M.val N.val` and even type-ascribing
  `(M.val : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ …))` all FAIL: the
  `MonoidalCategory` instance lives on `PresheafOfModules (R ⋙ forget₂ CommRingCat
  RingCat)`, but `M.val : PresheafOfModules X.ringCatSheaf.obj` is not *syntactically*
  that form, so the instance is not synthesized (a type ascription is transparent and
  does not redirect instance resolution). This mirrors why `tensorObj` itself writes
  `PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) …` explicitly.
- **Result:** RESOLVED. Force the instance:
  - unitors: `(PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val`
    / `.rightUnitor M.val`;
  - braiding: `BraidedCategory.braiding (C := _root_.PresheafOfModules (X.presheaf ⋙
    forget₂ CommRingCat RingCat)) M.val N.val`  — a `BraidedCategory (PresheafOfModules
    …)` instance **does** exist in Mathlib (verified by compilation).

## tensorObj_assoc_iso (line ~506) — IN PROGRESS (typed sorry, recipe scaffolded)
### Attempt 1
- **Approach:** the blueprint 3-step composite. Steps 1 and 3 each need an
  **absorption iso** `a(a(A).val ⊗ B) ≅ a(A ⊗ B)`, obtained as `a.mapIso?` / `asIso`
  of `a` applied to a whiskered sheafification-unit `η = toSheafify`, which lies in
  `J.W`; `W_whiskerLeft_of_flat` (and its right-whiskered symmetric version) keeps it
  in `J.W` for the flat whiskering object. Step 2 is `a.mapIso α` of the presheaf
  associator.
- **Result:** IN PROGRESS. **Single residual = the bridge `IsIso (a.map f)` from
  `J.W ((toPresheaf _).map f)`** (a, the PresheafOfModules sheafification). This is
  **NOT** a Mathlib one-liner: there is no `PresheafOfModules.sheafification`-level
  "map is iso iff underlying in `J.W`" lemma. It must be built from:
  - `PresheafOfModules.toPresheaf` *reflecting* isomorphisms (a PoM morphism is iso
    iff its underlying additive presheaf map is sectionwise iso), and
  - the underlying `AddCommGrpCat`-sheafification being a localization at `J.W`
    (`GrothendieckTopology.W_iff_isIso_map_of_adjunction` /
    `W_iff` / `instIsLocalizationFunctorOppositeSheafPresheafToSheafW`), plus a
    compatibility `toPresheaf ∘ sheafification ≅ AddCommGrp-sheafify ∘ toPresheaf`.
  - **Plus** the `IsInvertible ⇒ sectionwise Module.Flat` derivation that feeds
    `W_whiskerLeft_of_flat`'s `[∀ X, Module.Flat (R.obj X) (P.val.obj X)]` instance
    (invertible ⇒ locally free rank 1 ⇒ sections flat).
- **Next step:** build `lemma isIso_sheafification_map_of_W : J.W ((toPresheaf _).map
  f) → IsIso ((sheafification …).map f)` (the topology `J` is the small-site one of
  `X.ringCatSheaf`, NOT `Scheme.zariskiTopology` — that probe failed, wrong type) and
  a `W_whiskerRight_of_flat` (cheap, conjugate `W_whiskerLeft_of_flat` by the
  braiding). Est. ~80–150 LOC of sheafification-localization plumbing — a focused
  follow-up, not a blocker on the gate.

## tensorObjIsoclassCommMonoid (`lem:tensorobj_isoclass_commgroup`) — NOT YET DECLARED
- Deliberately **not** introduced as a hollow typed sorry: its faithful Lean type is
  genuinely undetermined (the carrier — `Units (Skeleton …)`-shaped iso-classes of
  `IsInvertible` objects — is a design decision) and it *consumes*
  `tensorObj_assoc_iso`, which is still a sorry. Declaring it now would either need a
  fabricated carrier or depend on the unbuilt associator. Recommend the plan agent
  pin a precise carrier type (mirroring `CommRing.Pic = Units (Skeleton (ModuleCat
  R))`) once the associator's bridge lands.

## Blueprint marker guidance (for review agent / sync_leanok)
- `def:scheme_modules_isinvertible`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`,
  `lem:flat_whisker_localizer` — now backed by **real, sorry-free** Lean ⇒ eligible
  for `\leanok` on both statement and proof (sync_leanok will confirm).
- `lem:tensorobj_assoc_iso` — statement formalized, proof is `sorry` ⇒ statement-only.
- `lem:flat_whisker_localizer` `\lean{...}` path correction noted above
  (`AlgebraicGeometry.Scheme.Modules.` → `PresheafOfModules.`).
- The unitor lemma pins TWO names (`tensorObj_left_unitor, tensorObj_right_unitor`) —
  both now exist; good.

## File compiles cleanly (0 errors). Active code sorries: 4
- `tensorObj_assoc_iso` (NEW, scaffolded), `tensorObj_restrict_iso` (pre-existing off-path),
  `exists_tensorObj_inverse` (pre-existing off-path),
  `addCommGroup_via_tensorObj` (pre-existing consumer; did not close — needs the
  iso-class group law engine, i.e. associator + commMonoid).
