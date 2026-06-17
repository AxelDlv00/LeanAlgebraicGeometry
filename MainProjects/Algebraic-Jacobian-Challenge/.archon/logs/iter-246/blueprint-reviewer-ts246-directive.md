# Blueprint-reviewer — iter-246 (whole-blueprint audit; gate clearance for two prover-bound chapters)

Run your standard whole-blueprint per-chapter audit (do not scope-limit your reading — the cross-chapter
view is the point). In addition, this iter I need explicit HARD-GATE clearance verdicts on the two
chapters about to feed prover lanes:

## Chapter 1 — `Picard_TensorObjSubstrate.tex` (feeds `Picard/TensorObjSubstrate.lean`)
This chapter was cleared complete+correct last iter (slug loctriv-regate). This iter a writer added ONE
new lemma block `\label{lem:isiso_pullbacktensormap_of_sheafifydelta}`
(`\lean{...isIso_pullbackTensorMap_of_isIso_sheafifyDelta}` — a landed, axiom-clean reduction lemma) in
`sec:tensorobj_pullback_monoidality`, and refined the D2' proof sketch (`lem:pullback_tensor_iso_unit`)
to apply that brick first. The edit is purely additive/clarifying (documents an already-proven lemma).
Confirm: does the chapter remain complete+correct with no must-fix? The prover target this iter is D2'
(the η-bridge `IsIso (a_Y.map (η (pullback φ')))`) then D3'/D4'/`IsInvertible.pullback` as far as
reachable.

## Chapter 2 — `Picard_RelPicFunctor.tex` (feeds `Picard/RelPicFunctor.lean`) — NEEDS A FRESH VERDICT
This chapter's `\label{lem:rel_pic_sharp_groupoid}` proof sketch was REWRITTEN this iter into a four-step
locally-trivial-substrate construction of the `AddCommGroup` on the relative-Picard quotient
(`AlgebraicGeometry.Scheme.PicSharp.addCommGroup`, RelPicFunctor.lean:269, currently `exact sorry`):
(1) `AddCommGroup` on `OnProduct` via `tensorObjOnProduct` + loc-triv assoc/comm/unit isos + inverse from
`exists_tensorObj_inverse` (loc-triv witness); (2) pullback hom `π_T^*` with `map_zero` ← `pullbackUnitIso`,
`map_add` ← the loc-triv comparison iso `\cref{lem:pullback_tensor_iso_loctriv}` (built concurrently in
A.1.c.sub); (3) setoid reconciliation `preimage_subgroup` = left-coset relation of `im(π_T^*)`;
(4) transport via `Equiv.addCommGroup`. A blueprint-clean pass then stripped the stale "Gate annotation
(iter-198)" paragraph that previously framed the gate as the now-resolved Mathlib `b80f227`
`Scheme.Modules` monoidal-structure gap.

Assess: is this construction sketch complete + correct + detailed enough for a prover to formalize the
`addCommGroup` instance against typed-sorry bridges for `lem:pullback_tensor_iso_loctriv` and
`exists_tensorObj_inverse`? Is the four-step decomposition mathematically sound (in particular step 3,
the setoid reconciliation)? Are there residual stale-gate contradictions left in the chapter? Give a
clear complete/correct/must-fix verdict for this chapter so I can decide whether to dispatch the RPF
prover this iter or defer it.

Report your per-chapter checklist and any unstarted-phase proposals as usual.
