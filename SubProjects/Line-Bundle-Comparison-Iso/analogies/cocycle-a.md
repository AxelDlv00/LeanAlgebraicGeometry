# Analogy: signatures + Mathlib idiom for the two overlap-cocycle helper lemmas

## Mode
api-alignment

## Slug
cocycle-a

## Iteration
027

## Question
The open residual in `exists_tensorObj_inverse` (TensorObjInverse.lean L194–239) is the
overlap cocycle `hf` of `homOfLocalCompat`. iter-026 isolated two missing helpers
(`trivialisation_restrict_compat` = "iso-chain natural in the open"; and
`tensorObj_unit_self_duality_collapse` = the `g·g⁻¹=1` cancellation). Need: (1) the canonical
Mathlib idiom for restriction-functor naturality + a precise consumable Lean signature; (2)
confirm the `dualIsoOfIso t` orientation and check the rigid/closed-monoidal evaluation precedent.

## Project artifact(s)
- TensorObjInverse.lean L149–262 — `exists_tensorObj_inverse`; the `set`s `eM/eN/e/uι/f/ε` and the cocycle `sorry`.
- TensorObjInverse.lean L34–122 — `tensorObjIsoOfIso_trans/refl`, `dualIsoOfIso_trans/refl` (iso-level functoriality, CLOSED).
- TensorObjSubstrate.lean L258–315 — `dualIsoOfIso` (contravariant), `tensorObjIsoOfIso` (bifunctor), `tensorObj_unit_iso`.
- TensorObjSubstrate.lean L424–446 — `restrictIsoUnitOfLE` (refine trivialisation to a smaller open) — the existing project idiom for restriction-compat.
- TensorObjSubstrate.lean L476–553 — `tensorObj_restrict_iso`; L1021 `pullbackUnitIso`.
- DualInverse.lean L172–229 — `dual_restrict_iso`, `presheafDualUnitIso`, `dual_unit_iso`.
- DualInverse.lean L463–632 — `homOfLocalCompat`; its `hf` cocycle hypothesis is the exact target shape (L466–472).

## Key facts established (definitions inspected)

- `dualIsoOfIso (e : M ≅ M') : dual M' ≅ dual M` — contravariant; sectionwise = precomposition by `pushforward₀.map e.hom` (per `presheaf_dualIsoOfIso_trans` body).
- `eN x := dual_restrict_iso ≫ (dualIsoOfIso (eM x)).symm ≫ dual_unit_iso : (dual L).restrict (U x).ι ≅ 𝒪_{U x}`. So the N-leg carries `(dualIsoOfIso (eM x))⁻¹`.
- `e x := tensorObj_restrict_iso ≫ tensorObjIsoOfIso (eM x) (eN x) ≫ tensorObj_unit_iso`; `f x := (e x).hom ≫ (uι x).inv`.
- `dual_unit_iso : dual 𝒪 ≅ 𝒪` = `sheafification.mapIso presheafDualUnitIso ≪≫ counit`; `presheafDualUnitIso` = eval-at-`1` (`PresheafOfModules.dualUnitIsoGen`).

### Transition algebra (worked out)
Over `V ≤ U i ⊓ U j`, write `t := (eM i|_V).symm ≪≫ (eM j|_V) : 𝒪_V ≅ 𝒪_V` (transition unit on the 𝒪 side), so `eM j|_V = eM i|_V ≪≫ t`.
- M-leg discrepancy: `t`.
- N-leg: `dualIsoOfIso (eM j|_V) = dualIsoOfIso t ≪≫ dualIsoOfIso (eM i|_V)` (by `dualIsoOfIso_trans`, order flips), hence `(dualIsoOfIso (eM j|_V))⁻¹ = (dualIsoOfIso (eM i|_V))⁻¹ ≪≫ (dualIsoOfIso t)⁻¹`. The extra factor `(dualIsoOfIso t)⁻¹` sits at the `dual 𝒪_V` node, just before `dual_unit_iso`. Conjugating it through `dual_unit_iso` gives an auto `s := dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso : 𝒪_V ≅ 𝒪_V`.
- Eval semantics (`presheafDualUnitIso` = eval at 1; dual = precomp): `dual` of "mult-by-unit-u" is again "mult-by-u" ⇒ `s = t.symm = t⁻¹`. **The pair is the symmetric `t ⊗ t⁻¹`.**
- By bifunctoriality (`tensorObjIsoOfIso_trans`): `e j|_V = e i|_V` reduces to `tensorObjIsoOfIso t s ≪≫ tensorObj_unit_iso = tensorObj_unit_iso`, i.e. the multiplication map kills `u ⊗ u⁻¹`.

**ORIENTATION VERDICT: the comment's `(dualIsoOfIso t)⁻¹` on the N-leg is CORRECT**, given `t := (eM i|_V).symm ≪≫ (eM j|_V)` (M-side post-composition). The comment's one-line form `tensorObjIsoOfIso t (dualIsoOfIso t)⁻¹ ≫ tensorObj_unit_iso = tensorObj_unit_iso` is a **type-incorrect shorthand**: the second leg `(dualIsoOfIso t)⁻¹` is an auto of `dual 𝒪_V`, but `tensorObj_unit_iso` needs `𝒪_V ⊗ 𝒪_V`. The `dual_unit_iso` conjugation (sub-fact B1) must appear explicitly.

## Decisions identified

### Decision 1: shape of `trivialisation_restrict_compat`

- **Mathlib idiom**: restriction-functor naturality lives in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`. The canonical pattern is to state structural compatibilities as **`Iso` of functors** (`NatIso`) plus a sectionwise `_hom_app_app` rfl-lemma giving the `eqToHom` form:
  - `Scheme.Modules.restrictFunctorComp : restrictFunctor (f ≫ g) ≅ restrictFunctor g ⋙ restrictFunctor f` (Sheaf.lean:392) with `restrictFunctorComp_hom_app_app : ((restrictFunctorComp f g).hom.app M).app U = M.presheaf.map (eqToHom (by simp)).op := rfl` (Sheaf.lean:401).
  - `Scheme.Modules.restrictFunctorCongr` (Sheaf.lean:409, `_hom_app_app` rfl at 415).
  - `Scheme.Modules.restrictFunctorIsoPullback : restrictFunctor f ≅ pullback f` (Sheaf.lean:371).
  So "an iso-chain is natural in the open" = a commuting square obtained by factoring `W.ι = j ≫ U.ι` and rewriting via `restrictFunctorComp`/`restrictFunctorCongr`. The project ALREADY uses exactly this idiom in `restrictIsoUnitOfLE` (TensorObjSubstrate.lean L424: `restrictFunctorIsoPullback ≫ pullbackCongr ≫ pullbackComp.symm ≫ …`).
- **Project's current path**: none yet — the cocycle `sorry` tries to attack the `.val.app` sectionwise goal directly, where the iso-level `tensorObjIsoOfIso_trans`/`dualIsoOfIso_trans` cannot fire.
- **Gap**: NEEDS_MATHLIB_GAP_FILL (the specific contraction-chain naturality is project infra; the *idiom* is Mathlib-aligned and must be followed).
- **Verdict**: PROCEED, but state it Mathlib-idiomatically (see Recommendation). Reuse `restrictFunctorComp_hom_app_app`/`restrictFunctorCongr_hom_app_app` and mirror `restrictIsoUnitOfLE`.

### Decision 2: shape + orientation of `tensorObj_unit_self_duality_collapse`; reuse Mathlib rigid idiom?

- **Mathlib idiom**: the rigid-category evaluation machinery in `Mathlib/CategoryTheory/Monoidal/Rigid/Basic.lean`:
  - `ExactPairing X Y` (L77) with `evaluation`/`coevaluation` and the triangle identities `coevaluation_evaluation` (L111) / `evaluation_coevaluation` (L115) — these ARE the abstract `g·g⁻¹=1` cancellation (B2).
  - `rightAdjointMate f := fᘁ` (L184); `rightAdjointMate_id : (𝟙 X)ᘁ = 𝟙 Xᘁ` (L195); `rightAdjointMate_comp` (L202). These are the abstract versions of the project's `dualIsoOfIso_refl`/`dualIsoOfIso_trans`, and `rightAdjointMate_id` is exactly sub-fact B1 specialized.
- **Project's current path**: bespoke `dualIsoOfIso`/`tensorObjIsoOfIso`/`tensorObj_unit_iso` + the already-CLOSED iso-level functoriality lemmas (`*_trans`/`*_refl`, TensorObjInverse.lean L34–122).
- **Gap**: divergent-WITH-REASON. The entire rigid idiom requires `MonoidalCategory (X.Modules)` + `HasRightDual` — which the project **deliberately does NOT build** (TensorObjSubstrate.lean §2 L264–276, blueprint `rem:scheme_modules_monoidal_off_path`), because it routed through the **verified-ABSENT** `MonoidalClosed (PresheafOfModules R₀)` (re-confirmed this iter: zero hits in Mathlib). Adopting the rigid idiom would mean building the full monoidal-closed + rigid tower for the *varying* structure sheaf — the abandoned d.2 / monoidal wall.
- **Cost of NOT aligning**: ~2 small bespoke lemmas (B1, B2), each provable from the existing `*_trans`/`*_refl` + sectionwise eval. Cost of aligning instead: re-open the entire MonoidalClosed wall. Bespoke is overwhelmingly cheaper.
- **Verdict**: DIVERGE_INTENTIONALLY. The project's bespoke `dualIsoOfIso_trans`/`_refl` are already the correct stand-ins for `rightAdjointMate_comp`/`_id`; finish with two bespoke unit-only lemmas. Do NOT pull in `Rigid/Basic`.

## Recommendation

Scaffold THREE lemmas (split the comment's "(B)" into the two genuine sub-facts; orientation as confirmed above), all over a single scheme `V := (Vopen : Scheme)`:

1. `trivialisation_restrict_compat` — naturality of the contraction *leg* in the open, landing exactly on the `hf` shape (so it is consumable per-index, applied to `i` and `j`):

```lean
-- M := tensorObj L (dual L),  N := SheafOfModules.unit X.ringCatSheaf
-- fOver U eM := (tensorObj_restrict_iso U.ι L (dual L) ≪≫
--                 tensorObjIsoOfIso eM (dualLeg eM) ≪≫ tensorObj_unit_iso).hom ≫ (uι U).inv
lemma trivialisation_restrict_compat {X : Scheme.{u}} {L : X.Modules}
    {U V : X.Opens} (hVU : V ≤ U)
    (eM : L.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    (tensorObj L (dual L)).val.presheaf.map
        (eqToHom (congrArg op (image_preimage_of_le U hVU).symm)) ≫
      ((PresheafOfModules.toPresheaf _).map (fOver U eM).val).app (op (U.ι ⁻¹ᵁ V)) ≫
      (SheafOfModules.unit X.ringCatSheaf).val.presheaf.map
        (eqToHom (congrArg op (image_preimage_of_le U hVU)))
    = ((PresheafOfModules.toPresheaf _).map (fOver V (restrictIsoUnitOfLE hVU eM)).val).app (op V)
```
   Proof idiom: factor `V.ι = j ≫ U.ι`, push each leg (`tensorObj_restrict_iso`, `restrictFunctorIsoPullback`, `pullbackUnitIso`) through `restrictFunctorComp`/`restrictFunctorCongr` using their `_hom_app_app` rfl lemmas — exactly the `restrictIsoUnitOfLE` chase. **After applying it to `i` and `j`, the cocycle `hf` collapses to the single-open-`V` equation `fOver V (eM i|_V) = fOver V (eM j|_V)`** (no more `(U i).ι⁻¹` vs `(U j).ι⁻¹` reindexing), where `eM x|_V := restrictIsoUnitOfLE hVx (eM x)`.

2. `dualUnitIso_dualIsoOfIso` (sub-fact B1; degenerate `rightAdjointMate_id`):
```lean
lemma dualUnitIso_dualIsoOfIso {V : Scheme.{u}}
    (t : SheafOfModules.unit V.ringCatSheaf ≅ SheafOfModules.unit V.ringCatSheaf) :
    dual_unit_iso.symm ≪≫ dualIsoOfIso t ≪≫ dual_unit_iso = t   -- (⇒ the .symm version is t.symm)
```
   "dual of a unit-automorphism is itself" via `presheafDualUnitIso` = eval-at-`1` + `dual` = precomposition.

3. `tensorObj_unit_self_duality_collapse` (sub-fact B2; degenerate `coevaluation_evaluation`), TYPE-CORRECT form:
```lean
lemma tensorObj_unit_self_duality_collapse {V : Scheme.{u}}
    (t : SheafOfModules.unit V.ringCatSheaf ≅ SheafOfModules.unit V.ringCatSheaf) :
    tensorObjIsoOfIso t t.symm ≪≫ tensorObj_unit_iso = tensorObj_unit_iso
```
   The `g·g⁻¹=1` cancellation: needs naturality of `tensorObj_unit_iso` (the multiplication `𝒪⊗𝒪 → 𝒪`) against the bifunctor `tensorObjIsoOfIso`, then `t ≪≫ t.symm = Iso.refl` via the already-closed `tensorObjIsoOfIso_trans`/`tensorObjIsoOfIso_refl`. With B1 rewriting the N-leg residual to `t.symm`, lemma 3 closes the V-level equation from step 1.

Note: if a monolithic single-lemma form is preferred, fuse B1+B2 as
`tensorObjIsoOfIso t (dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso) ≪≫ tensorObj_unit_iso = tensorObj_unit_iso`
(type-correct; this is the faithful version of the comment's shorthand). Splitting is recommended — each piece is independently provable and B1 is reusable.
