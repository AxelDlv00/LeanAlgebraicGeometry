# blueprint-writer — slug ts-routee214

Rewrite ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Two jobs: (1) pivot the
associator/group-law realization to **route (e)** (instantiate Mathlib's abstract monoidal-
localization API instead of hand-assembling the associator); (2) clear the must-fix items the
iter-213 lean-vs-blueprint review flagged. Do NOT touch any other chapter. Do NOT add/remove
`\leanok` or `\mathlibok` markers (the deterministic sync owns `\leanok`).

## Strategy context (the slice that matters)

The chapter builds the line-bundle ⊗-group law (`Pic = Units` of the ⊗-iso-classes / Skeleton of
`Scheme.Modules`, mirroring Mathlib's `CommRing.Pic`). The substrate is UNCHANGED:
`tensorObj M N := sheafification (PresheafOfModules.Monoidal.tensorObj M.val N.val)`, with
`Scheme.Modules X = SheafOfModules X.ringCatSheaf`.

Over iters 209–213 the associator was hand-assembled as a 3-step absorb→associate→absorb composite
resting on a residual lemma. A fresh Mathlib-API audit (verified against on-disk Mathlib source this
iter) found this is the WRONG ALTITUDE: Mathlib already provides the entire monoidal scaffolding, so
the hand-assembled associator and the bespoke residual framing should be REPLACED by instantiating
the abstract API. This is an API realization change; the substrate design is not pivoted.

## Verified Mathlib API (confirmed on disk this iter — cite these as the formalization vehicle)

- `PresheafOfModules.monoidalCategory : MonoidalCategory (PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat))`
  — `Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean` (instance at L125; `monoidalCategoryStruct`
  at L104). Tensor is the sectionwise relative tensor `(M⊗N)(U) = M(U) ⊗_{R(U)} N(U)`. The base
  `R ⋙ forget₂ CommRingCat RingCat` is exactly the project's `Sheaf.val X.ringCatSheaf` carrier
  (equal by `rfl`, established iter-213). So the presheaf-level monoidal structure for the
  **varying** structure sheaf already exists — no project work.
- `CategoryTheory.MorphismProperty.IsMonoidal` — `Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean`
  (`class IsMonoidal extends W.IsMultiplicative`, L44), with FIELDS
  `whiskerLeft (X) {Y₁ Y₂} (g) (hg : W g) : W (X ◁ g)` and `whiskerRight`, plus lemmas
  `whiskerLeft_mem` (L58), `whiskerRight_mem`, and `(W.inverseImage F).IsMonoidal` (L72).
  **The project's `isLocallyInjective_whiskerLeft_of_W` IS the `whiskerLeft` field of this class.**
- `CategoryTheory.Localization.Monoidal.LocalizedMonoidal` (same file, L82+): given
  `[MonoidalCategory C]`, `[W.IsMonoidal]`, `L : C ⥤ D` with `[L.IsLocalization W]`, and
  `ε : L.obj (𝟙_ C) ≅ unit`, the localized category `LocalizedMonoidal L W ε` is a `MonoidalCategory`
  with ALL coherence (associator, unitors, pentagon, triangle, naturalities) derived. **No
  `MonoidalClosed` anywhere in the hypothesis chain.**
- `Sites/Point/IsMonoidalW.lean`: `instance [J.HasSheafCompose (forget A)] [HasEnoughPoints J] :
  (J.W (A := A)).IsMonoidal` — proves the W-monoidality stalkwise (via `hP.W_iff` +
  `Functor.Monoidal.map_tensor` + `infer_instance`) for presheaves valued in a FIXED monoidal
  concrete category `A` (`Cᵒᵖ ⥤ A`). This is the TEMPLATE for the proof technique, but it does NOT
  apply to `PresheafOfModules R` (modules over a varying ring are not `Cᵒᵖ ⥤ A` for fixed `A`).
- `Sites/Point/Monoidal.lean`: the fiber functor `Φ.presheafFiber : (Cᵒᵖ ⥤ A) ⥤ A` is
  `OplaxMonoidal` — the per-point monoidality `IsMonoidalW` relies on.
- **Genuinely Mathlib-absent (the real gap):** there is NO monoidal `SheafOfModules` in Mathlib, and
  NO `PresheafOfModules` stalk/fiber/point infrastructure (only `Presheaf/ColimitFunctor.lean`). So
  `(J.W).IsMonoidal` for the `PresheafOfModules` sheafification localizer must be built project-side.

## Route (e) — the realization to write into the chapter

The end-state monoidal structure on `Scheme.Modules`/`SheafOfModules` comes from `LocalizedMonoidal`
applied to: `C := PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)` (already monoidal),
`L := PresheafOfModules.sheafification`, `W := J.W` the locally-bijective localizer (sheafification
is the localization at it). The associator/unitors/braiding/coherence are then FREE from the API —
the hand-assembled `tensorObj_assoc_iso` 3-step composite is no longer the construction; it is
superseded by the API-derived associator.

The SOLE genuinely-new obligation is the instance `(J.W).IsMonoidal` for the `PresheafOfModules`
sheafification localizer. Its two fields:
- `whiskerLeft : J.W g → J.W (F ◁ g)` for arbitrary `F` — this is the project's existing
  `W_whiskerLeft_of_W`, whose load-bearing half is `isLocallyInjective_whiskerLeft_of_W`.
- `whiskerRight` — the project's `W_whiskerRight_of_W` (braiding-conjugate).

Proof technique (flatness-free): a `J.W`-map `g` is a stalkwise iso, so `(F ◁ g)_x = id_{F_x} ⊗ g_x`
is an iso for ANY `F` (tensoring with an iso preserves iso — NO flatness, NO local triviality). This
is the same argument Mathlib's `Sites/Point/IsMonoidalW.lean` uses for fixed-base presheaves; the
project ports it to `PresheafOfModules` by supplying (d.1) the stalkwise-iso characterisation of the
module-level `J.W` on `Opens X`, and (d.2) the commutation of the stalk (filtered colimit) with the
relative module-presheaf tensor `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x` — both Mathlib-absent at the
`PresheafOfModules` level (verified this iter).

Record explicitly that the earlier section-level cover attempt (preserving local injectivity ALONE)
is a dead end: without flatness `ker(id⊗g)` is not generated by `F ⊗ ker g` (needs Tor₁). The
combined local bijectivity (`J.W`) avoids this precisely by routing through the stalk iso.

## Required edits (be precise)

1. **`lem:tensorobj_assoc_iso` (lines ~673–855) — rewrite the proof.** State that the associator is
   obtained from `CategoryTheory.Localization.Monoidal.LocalizedMonoidal` once `(J.W).IsMonoidal`
   holds (cite the Mathlib decls above), NOT from a bespoke 3-step composite. Keep the `\lean{}` pin.
   The retained `IsLocallyTrivial` hypotheses are not proof ingredients — note they are vestigial /
   may be dropped when the API-derived associator lands. Remove the dead flatness/route-(c)/route-(d)
   prose. Make the dependency `\uses{}` reference the new `(J.W).IsMonoidal` lemma block (below) and
   the Mathlib-API survey.

2. **ADD a new lemma block** (in the `\otimes`-invertibility / group-law section, or a new
   subsection) for the sole obligation, pinned to the Lean decls that realize it:
   - `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` — the load-bearing residual
     (currently a `sorry`). Document it as the `whiskerLeft`-field content of `(J.W).IsMonoidal`,
     proved by the stalkwise argument, with the two Mathlib-absent ingredients (d.1, d.2) named as
     the residual. Mark it as THE sole remaining open obligation for the whole group-law engine.
   - `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}` — the
     closed flatness-free whisker lemmas (surjectivity free via `isLocallySurjective_whiskerLeft`;
     injectivity via the residual). Explain they are the `whiskerLeft`/`whiskerRight` data for the
     `MorphismProperty.IsMonoidal (J.W)` instance.
   - If you judge it cleaner, add a wrapper lemma block for the `(J.W).IsMonoidal` instance itself
     and the `LocalizedMonoidal` instantiation as the route-(e) target (no `\lean{}` if no decl
     exists yet — leave it unpinned and unmarked, as a stated-but-unformalized obligation).

3. **`lem:tensorobj_lift_onproduct` (lines ~979–1037) — fix the prose (must-fix).**
   `LineBundle.OnProduct πC πT` is the `IsLocallyTrivial` subtype (defined in `LineBundlePullback`),
   NOT the `IsInvertible` subtype. The Lean `tensorObjOnProduct` uses `tensorObj_isLocallyTrivial`
   directly. Correct the prose and the `\uses{...}` (drop `def:scheme_modules_isinvertible` and
   `lem:tensorobj_isoclass_commgroup` if the Lean body does not use them).

4. **`lem:tensorobj_isoclass_commgroup` / `tensorObjIsoclassCommMonoid` (lines ~1162+).** Reframe:
   once `LocalizedMonoidal` gives `MonoidalCategory (SheafOfModules X.ringCatSheaf)`, the iso-class
   commutative monoid and its `Units` follow as in Mathlib's `CommRing.Pic` (`Units (Skeleton …)`).
   Keep the carrier pinned; do not invent a new carrier.

5. **API survey section (lines ~113–196).** Refresh it to record the verified route-(e) API
   (`PresheafOfModules.monoidalCategory`, `Localization.Monoidal.LocalizedMonoidal`,
   `MorphismProperty.IsMonoidal`, `Sites/Point/IsMonoidalW` as template) and that monoidal
   `SheafOfModules` + `PresheafOfModules` stalk infra are Mathlib-absent.

6. **`rem:scheme_modules_monoidal_off_path` (line ~288)** and the flat-whisker block
   `lem:flat_whisker_localizer` (line ~553): keep `W_whiskerLeft/Right_of_flat` documented as
   closed-but-off-path (they are valid standalone, superseded by the `_of_W` variants on the
   critical path). Update any prose that still calls the flat route the live associator route.

## Citation discipline

Route (e) is a Mathlib-API-driven project construction; the formalization vehicle is the verified
Mathlib decls above (you may quote the on-disk Mathlib source files verbatim in `% SOURCE`/`% SOURCE
QUOTE` comments if you cite a specific statement). The underlying mathematics — "Pic = group of
invertible sheaves under ⊗, realized as `Units` of the monoidal Skeleton" — is standard (mirrors
`CommRing.Pic`; classical: Hartshorne II.6 / Kleiman). If you need a verbatim external quote you do
not already have locally, dispatch the reference-retriever (authorized in your write-domain) and
wait for it before writing that block. Do NOT fabricate citations.

## Out of scope

Do not edit other chapters. Do not change the substrate definition `def:scheme_modules_tensorobj`.
Do not touch markers. Do not rewrite the `tensorObj_restrict_iso` / `exists_tensorObj_inverse`
off-path blocks except where their prose mislabels the live route.
