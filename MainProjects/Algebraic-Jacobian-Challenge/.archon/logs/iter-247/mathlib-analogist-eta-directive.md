# mathlib-analogist directive — η-bridge mate-identity API check (iter-247)

## Mode: api-alignment

This is a LIGHTWEIGHT, time-boxed API-surface check — NOT a research effort. Confirm whether the
Lean 4 / Mathlib API needed to close one specific mate-calculus goal is directly accessible, or
whether there is a genuine API gap. Answer PROCEED (API accessible, the named glue suffices) or
GAP (a required lemma/coherence is missing — name it).

## The situation
In `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` we must prove the "η-bridge":

    IsIso (a_Y.map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))

where `a_Y` is sheafification and `φ'` is the structure-sheaf comparison for a scheme morphism
`f : Y ⟶ X`. The whole pullback–tensor comparison iso on line bundles funnels through this goal
(reduction brick already landed, axiom-clean). It is the UNIT-side analog of an ALREADY-PROVEN,
axiom-clean lemma in the same file: `pullbackObjUnitToUnit_comp` (L904), which handled the
δ/counit side by adjunction-mate transport.

## The prover's reduction (verified to typecheck, reaches a concrete goal)
The η-bridge is the commuting square (right vertical `sheafifyUnitIso` already built axiom-clean):

    a_Y.map (η F) ≫ sheafifyUnitIso.hom
      = (pullbackValIso f 𝒪_X).hom ≫ SheafOfModules.pullbackObjUnitToUnit φ

with `pullbackValIso`, `sheafifyUnitIso`, `pullbackObjUnitToUnit φ` (= `pullbackUnitIso`) all isos,
so the square ⟹ `IsIso (a_Y.map (η F))`.

Transposing through the adjunction
(`apply (SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv _ _ |>.injective`, then rewrite
with `Adjunction.homEquiv_unit`, `Adjunction.leftAdjointOplaxMonoidal_η`, `Adjunction.homEquiv_counit`)
leaves the single concrete pushforward-side mate identity:

    sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map (
        (pullbackValIso f 𝒪_X).inv ≫
        a_Y.map (pullback_pre.map ε_pre ≫ presheafAdj.counit.app 𝟙_) ≫
        sheafifyUnitIso.hom)
      = unitToPushforwardObjUnit φ

where ε_pre = `Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ.hom)`,
presheafAdj = `PresheafOfModules.pullbackPushforwardAdjunction φ.hom`,
sheafAdj = `SheafOfModules.pullbackPushforwardAdjunction φ`.

## The glue the prover already located (please verify these exist + are usable for the chase)
- `Adjunction.homEquiv_leftAdjointUniq_hom_app`
- `Adjunction.unit_leftAdjointUniq_hom_app`
- `Adjunction.leftAdjointUniq_hom_app_counit`
  (`pullbackValIso` is built from `SheafOfModules.sheafificationCompPullback` =
  `Adjunction.leftAdjointUniq` of two composite adjunctions; these relate its components to the
  presheaf/sheaf adjunction units/counits.)
- `Functor.LaxMonoidal.ε (SheafOfModules.pushforward φ) = SheafOfModules.unitToPushforwardObjUnit φ`
  by `rfl` (prover verified).

## Questions (answer each crisply)
1. Do the four glue lemmas above exist in current Mathlib with usable signatures? (Check names; note
   any renames.)
2. Is the two-level `leftAdjointUniq` chase across the presheaf↔sheaf sheafification boundary
   closeable with the standard `Adjunction`/mate API (`homEquiv_unit`, `homEquiv_counit`,
   `leftAdjointOplaxMonoidal_η`, `NatTrans` naturality, `leftAdjointUniq_*`), or is there a missing
   coherence lemma? If the latter, name the missing lemma precisely.
3. Is there a SHORTER Mathlib idiom for "sheafification preserves the oplax-monoidal unit η up to the
   already-built unit isos" that sidesteps the manual mate chase entirely (e.g. a
   `Functor.Monoidal`/`OplaxMonoidal` transport-along-adjunction lemma, or an
   `Adjunction.leftAdjointUniq` monoidal-compatibility result)?

## Verdict format
- PROCEED: the named glue suffices; the chase is standard mate calculus closeable this iter.
- GAP: name the missing Mathlib lemma; say whether it is buildable from current Mathlib (mathlib-build
  candidate) or genuinely absent (route-pivot trigger).
