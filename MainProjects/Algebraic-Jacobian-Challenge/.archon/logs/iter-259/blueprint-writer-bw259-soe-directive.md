# blueprint-writer directive — bw259-soe

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

## Task
Expand the **proof sketch of `\begin{lemma}` `\label{lem:sheafofmodules_unit_over_iso}`**
(`\lean{AlgebraicGeometry.Scheme.Modules.unitOverIso}`) so it names the concrete construction the
formalizer needs. The current proof correctly identifies the *conceptual* approach but does not name
the canonical comparison map or the iso-reflection chain, leaving the prover to search. This was
flagged as a MAJOR adequacy gap by the iter-258 lean-vs-blueprint check.

Keep everything else in the chapter unchanged. Do NOT touch any other lemma block, the statement
block of `lem:sheafofmodules_unit_over_iso`, or any markers.

## What to add to the proof body
Augment the existing prose (do not delete the conceptual paragraph) with the explicit construction:

- The canonical comparison map is `SheafOfModules.unitToPushforwardObjUnit φ` (with φ the
  open-immersion ring-sheaf morphism underlying the over-equivalence's functor `pushforward φ`).
- Its section at an open `W` equals the section-level ring map `φ.hom.app W`
  (Lean: the characterisation lemma `unitToPushforwardObjUnit_val_app_apply`).
- Since φ is an isomorphism of ring sheaves, each `φ.hom.app W` is a ring isomorphism, hence the
  underlying additive-group map is an isomorphism.
- Therefore `unitToPushforwardObjUnit φ` is an isomorphism: reflect the sectionwise iso up through
  the forgetful functors `SheafOfModules.forget` then `PresheafOfModules.toPresheaf`, reducing to a
  natural-transformation-componentwise iso check (`NatTrans.isIso_iff_isIso_app`).
- The desired isomorphism `unitOverIso` is then `(asIso (unitToPushforwardObjUnit φ)).symm`.

Phrase this as mathematical prose (the named Lean identifiers may appear in `\mathtt{...}` as the
chapter already does for `pullbackObjUnitToUnitIso`/`pushforward`). No Lean tactic blocks. Keep the
existing "slice-site analogue of `pullbackObjUnitToUnitIso`" remark.

## Citation
This is an Archon-original / project-bespoke construction (a modules-level lift of
`Opens.overEquivalence`); no external source quote is required. Do not invent a citation.

## Out of scope
- Do NOT edit `restrictOverIso`, `overEquivalence`, or `chartOverIso` blocks.
- Do NOT add/remove `\leanok` or `\mathlibok` (managed deterministically).
- Do NOT edit any other chapter.
