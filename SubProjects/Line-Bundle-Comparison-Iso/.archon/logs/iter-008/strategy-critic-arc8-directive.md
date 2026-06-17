# Strategy-critic directive — iter-008

Fresh-context soundness review of the project strategy. You see ONLY the artifacts below.

## STRATEGY.md (verbatim)
Read `/home/archon/proj/Line-Bundle-Comparison-Iso/.archon/STRATEGY.md` in full.

## Project goal (one paragraph)
Build the comparison-isomorphism substrate on line bundles — work package A.1.c.sub carved from
Christian Merten's Jacobian challenge (`references/challenge.lean.ref`). Final deliverables = three
seed nodes + their 108-node cone, zero inline sorry per seed cone, kernel-only axioms:
`lem:pullback_tensor_iso_loctriv` (pullback/tensor comparison iso on loc-triv bundles, D3′ route),
`lem:dual_isLocallyTrivial` (dual of loc-triv is loc-triv, DUAL route), and
`thm:rel_pic_addcommgroup_via_tensorobj` (the AddCommGroup on the relative Picard sheaf Pic♯_{C/k}).

## Reference index
Read `/home/archon/proj/Line-Bundle-Comparison-Iso/references/summary.md`.

## Blueprint chapters (titles + topic)
- `Picard_LineBundlePullback.tex` — Line-bundle pullback on a relative curve (IsLocallyTrivial.pullback).
- `Picard_RelPicFunctor.tex` — The relative Picard functor and its étale sheafification (consumer, PicSharp group).
- `Picard_TensorObjSubstrate.tex` — Relative Picard sheaf, Scheme.Modules.tensorObj substrate (A.1.c.SubT):
  tensor object, pullback tensorator δ (D3′), dual-inverse slice transport (DUAL), internal Hom/dual.

## Prior critique status
arc7 returned CHALLENGE ×2 (D3′ self-contradiction in route prose; format/stale-LOC) — both recorded
as addressed in iter-007 STRATEGY edits + a DUAL "deadlock broken" rebuttal. Confirm whether those are
genuinely resolved and whether the current two-route arc (DUAL + D3′ in parallel, then consumer) is sound.

Return SOUND / CHALLENGE / REJECT per route with specifics.
