# Lean ↔ Blueprint Check Report

## Slug
soe259

## Iteration
259

## Files audited
- Lean: `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
- Blueprint: `blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.overEquivalence}` (chapter: `def:sheafofmodules_over_equivalence`)
- **Lean target exists**: yes (L178–207, `noncomputable def overEquivalence`)
- **Signature matches**: yes — `SheafOfModules ((↑U : Scheme).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U)` matches the blueprint's `overEquivalence : SheafOfModules(Ũ.ringCatSheaf) ≃ SheafOfModules(X.ringCatSheaf.over U)` exactly.
- **Proof follows sketch**: yes — `pushforwardPushforwardEquivalence` is instantiated at `e = Opens.overEquivalence U`, `φ = phiOver U`, `ψ = psiOver U`, with H₁/H₂ proved by `Sheaf.hom_ext`-style sectionwise goals exactly as described. The blueprint says H₁/H₂ are "proved from the `appIso` round-trips"; the Lean closes them via `Subsingleton.elim _ _` on `op`-morphism equalities (since `Opens` is thin), which is the correct content.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — kernel only. ✓
- **notes**: Two continuity instances (`overEquivInverseIsContinuous`, `overEquivFunctorIsContinuous`, L105–118) appear in the Lean but are not separately pinned in the blueprint. The blueprint prose says "both continuity legs follow by inference" and names no separate declaration; these are expected implementation artifacts, not a coverage gap. The private helpers `phiOver`/`psiOver`/`image_overEquiv_functor_obj`/`left_overEquiv_inverse_obj` are all consistent with the blueprint's informal descriptions of φ and ψ.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictOverIso}` (chapter: `lem:sheafofmodules_restrict_over_iso`)
- **Lean target exists**: yes (L257–281, `noncomputable def restrictOverIso`)
- **Signature matches**: yes — `(M : X.Modules) → (overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U`. The blueprint states "canonical isomorphism `overEquivalence.functor.obj(M|_ι) →~ M.over U`" for `M : Scheme.Modules X`. Match is exact.
- **Proof follows sketch**: yes (partial note below). The Lean executes the three-step composite described in the blueprint:
  1. `(SheafOfModules.pushforwardComp (phiOver U) (psiRestrict U)).app M` — matches "identified by `pushforwardComp`".
  2. `(SheafOfModules.pushforwardNatIso _ (overForgetNatIso U)).app M` — matches "`pushforwardNatIso` along the `eqToIso` of the equality of the two index functors".
  3. `(SheafOfModules.pushforwardCongr ?heq).app M` where `?heq` is closed by `simp [phiOver, psiRestrict, overForgetNatIso]; erw [...]; simp` — matches "the composite ring map is the identity".
  The mirror to `restrictFunctorAdjCounitIso` (mentioned in the blueprint) is realised via `psiRestrict` and `restrictFunctor_eq_pushforward_psiRestrict`. Match is accurate.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — kernel only. ✓
- **notes**: (1) The Lean requires `set_option backward.isDefEq.respectTransparency false` (L256) to make typeclass search for the composite-pushforward continuity instance succeed in the slice site. The blueprint does not mention this. This is a typeclass-resolution technicality, not a proof step; the mathematical route is correctly described. (2) The blueprint says "`pushforwardComp = Iso.refl`", implying the iso is trivially/definitionally the identity. In Lean, `pushforwardComp (phiOver U) (psiRestrict U)` is NOT syntactically `Iso.refl`; it is proved equal to the identity via the `?heq` goal (sectionwise the composite ring maps cancel to `𝟙` by `simp`+`erw`). The claim is mathematically correct — the isomorphism is equal to refl — but the wording is slightly overstrong about definitional triviality. **Minor imprecision only.**
- **Private helpers** `psiRestrict` (L236–243) and `overForgetNatIso` (L250–254): Signatures are consistent with the blueprint prose ("reconstructed so that `restrictFunctor U.ι = SheafOfModules.pushforward (psiRestrict U)` holds definitionally" and "the equality of the two underlying index functors"). No signature drift.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.unitOverIso}` (chapter: `lem:sheafofmodules_unit_over_iso`)
- **Lean target exists**: yes (L295–336, `noncomputable def unitOverIso`)
- **Signature matches**: yes — `(overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf) ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`. Blueprint states the same isomorphism. Match is exact.
- **Proof follows sketch**: yes. The blueprint prescribes:
  1. Build `IsIso (phiOver U)` via sectionwise `eqToHom` components. ✓ (L304–311)
  2. Build `IsIso (SheafOfModules.unitToPushforwardObjUnit (phiOver U))` by reflecting through `SheafOfModules.forget` then `PresheafOfModules.toPresheaf`, applying `NatTrans.isIso_iff_isIso_app`, then using the sectionwise `(phiOver U).hom.app W` isomorphism. ✓ (L312–335, including the `change IsIso ((forget₂ RingCat AddCommGrpCat).map ((phiOver U).hom.app W))` step matching the blueprint's "`unitToPushforwardObjUnit_val_app_apply`" characterisation).
  3. Return `(asIso ...).symm`. ✓ (L336)
  The blueprint's explicit formula `(asIso (unitToPushforwardObjUnit φ))⁻¹` is reproduced verbatim. Match is faithful.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — kernel only. ✓
- **notes**: The blueprint cites "`unitToPushforwardObjUnit_val_app_apply`" as the key characterisation; in the Lean the corresponding fact is used via `change IsIso ((forget₂ RingCat AddCommGrpCat).map ((phiOver U).hom.app W)); infer_instance`, which is the correct sectionwise unfolding. No issue.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.chartOverIso}` (chapter: `lem:chart_over_iso`)
- **Lean target exists**: yes (L358–361, `noncomputable def chartOverIso`)
- **Signature matches**: yes — `(M : X.Modules) → (e : M.restrict U.ι ≅ SheafOfModules.unit (↑U : Scheme).ringCatSheaf) → M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`. Blueprint states the same with input `e : M|_ι →~ unit Ũ.ringCatSheaf`. Match is exact.
- **Proof follows sketch**: yes. The blueprint specifies the three-step composite:
  - `(restrictOverIso)⁻¹` then `overEquivalence.functor.mapIso e` then `unitOverIso`.
  The Lean body is exactly: `(restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U`.
- **No sorry**: correct (one-liner, no gaps).
- **notes**: none.

---

## Red flags

None.

- No `:= sorry` anywhere in the file.
- No suspect bodies (no `:= True`, no `:= Classical.choice _`).
- No excuse-comments (`-- TODO`, `-- temporary`, `-- placeholder`, `-- wrong but`).
- No `axiom` declarations introduced.
- The `set_option backward.isDefEq.respectTransparency false in` at L256 is a typeclass-resolution transparency hint required for slice-site typeclass lookup; it is not a sorry or a soundness bypass.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` pin in the chapter. All are private or typeclass instances serving the main declarations; none suggests a missing blueprint entry.

| Declaration | Kind | Serves |
|---|---|---|
| `overEquivInverseIsContinuous` | `instance` | `overEquivalence` continuity leg |
| `overEquivFunctorIsContinuous` | `instance` | `overEquivalence` continuity leg |
| `image_overEquiv_functor_obj` | `private lemma` | `phiOver`, `overForgetNatIso` |
| `phiOver` | `private def` | `overEquivalence`, `restrictOverIso`, `unitOverIso` |
| `left_overEquiv_inverse_obj` | `private lemma` | `psiOver` |
| `psiOver` | `private def` | `overEquivalence` |
| `psiRestrict` | `private def` | `restrictOverIso` |
| `restrictFunctor_eq_pushforward_psiRestrict` | `private lemma` | `restrictOverIso` (definitional bridge) |
| `overForgetNatIso` | `private def` | `restrictOverIso` |

The directive specifically asked about `psiRestrict` and `overForgetNatIso`: both signatures are consistent with the blueprint prose (see per-declaration notes above) and reveal **no signature drift**.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 public declarations have `\lean{...}` pins. All 9 unreferenced declarations are private helpers or instances (acceptable).
- **Proof-sketch depth**: **adequate**. All four proof sketches accurately describe the mathematical route taken in the Lean. The `restrictOverIso` and `unitOverIso` sketches are especially detailed — they name the Mathlib primitives used (`pushforwardComp`, `pushforwardNatIso`, `pushforwardCongr`, `unitToPushforwardObjUnit`, the two forgetful reflections, `NatTrans.isIso_iff_isIso_app`), and the Lean routes follow them step-for-step.
- **Hint precision**: **precise**. Each `\lean{...}` names the correct fully-qualified Lean declaration with the correct type.
- **Generality**: **matches need**. All declarations are stated in the right generality (`variable (U : X.Opens)` for full generality in U).
- **Recommended chapter-side actions** (minor only — no must-fix):
  - In `lem:sheafofmodules_restrict_over_iso` proof, soften "pushforwardComp = Iso.refl" to "pushforwardComp is isomorphic to `Iso.refl` (proved sectionwise by the `appIso` cancellation)" to reflect that the equality is proved, not definitionally obvious.
  - Optionally add a parenthetical noting that `restrictOverIso` requires `set_option backward.isDefEq.respectTransparency false` due to the `↥(↑U : Scheme)` vs `↥U` discrimination-tree mismatch in the slice site, so future consumers are forewarned.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint says "pushforwardComp = Iso.refl" (slightly overstrong — it's proved, not definitional) | **minor** |
| Blueprint does not mention `set_option backward.isDefEq.respectTransparency false` in `restrictOverIso` | **minor** |

**No must-fix-this-iter findings. No major findings.**

Overall verdict: The file is sorry-free and axiom-clean (kernel axioms only); all four public declarations match their `\lean{...}` blueprint pins exactly in both statement and proof strategy; the blueprint chapter is adequately detailed and guided the formalization faithfully. Two minor imprecisions in the `restrictOverIso` proof sketch are noted but do not block downstream work.
