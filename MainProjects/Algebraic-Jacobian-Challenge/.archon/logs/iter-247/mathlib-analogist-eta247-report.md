# Mathlib Analogist Report

## Mode
api-alignment

## Slug
eta247

## Iteration
247

## Question
Confirm whether the Lean 4 / Mathlib API needed to close the η-bridge goal
`IsIso (a_Y.map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))` is directly accessible
(named glue suffices) or whether there is a genuine API gap. Answer PROCEED or GAP.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 — four named glue lemmas exist + usable | PROCEED | informational |
| Q2 — two-level leftAdjointUniq mate chase closeable with standard API | PROCEED | informational |
| Q3 — shorter monoidal-transport idiom that sidesteps the chase | PROCEED (none; planned chase is the idiom) | informational |

## Answers

**Q1 — Do the four glue lemmas exist with usable signatures? YES (no renames).**
All three categorical glue lemmas are present verbatim in `Mathlib.CategoryTheory.Adjunction.Unique`
(verified via loogle at the pinned commit):
- `CategoryTheory.Adjunction.homEquiv_leftAdjointUniq_hom_app` —
  `(adj1.homEquiv x (F'.obj x)) ((adj1.leftAdjointUniq adj2).hom.app x) = adj2.unit.app x`.
- `CategoryTheory.Adjunction.unit_leftAdjointUniq_hom_app` —
  `adj1.unit.app x ≫ G.map ((adj1.leftAdjointUniq adj2).hom.app x) = adj2.unit.app x`.
- `CategoryTheory.Adjunction.leftAdjointUniq_hom_app_counit` —
  `(adj1.leftAdjointUniq adj2).hom.app (G.obj x) ≫ adj2.counit.app x = adj1.counit.app x`.
Bonus: `_assoc` re-association variants also exist (`unit_leftAdjointUniq_hom_app_assoc`,
`leftAdjointUniq_hom_app_counit_assoc`, `leftAdjointUniq_trans_app_assoc`) — these are what the
sibling `pullbackObjUnitToUnit_comp` needed to fire under longer composites, so they will be needed
here too. The fourth item — `LaxMonoidal.ε (SheafOfModules.pushforward φ) = unitToPushforwardObjUnit φ`
by `rfl` — is a project-side defeq claim (prover-verified), not a Mathlib lemma; nothing to check
upstream.

**Q2 — Is the two-level leftAdjointUniq chase closeable with the standard Adjunction/mate API, or is a
coherence lemma missing? CLOSEABLE — no missing lemma.**
The reduction lemmas the prover transposes through all exist:
- `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal_η` (`Mathlib.CategoryTheory.Monoidal.Functor`):
  `Functor.OplaxMonoidal.η F = (adj.homEquiv _ _).symm (Functor.LaxMonoidal.ε G)` — the lemma that
  turns the η-bridge into the pushforward-side ε identity; it is *why* the mate chase is the route.
- `CategoryTheory.Adjunction.homEquiv_unit`, `homEquiv_counit` (`Mathlib.CategoryTheory.Adjunction.Basic`).
The η-bridge is the UNIT-side mirror of `pullbackObjUnitToUnit_comp` (TensorObjSubstrate.lean:904–990),
which closed the COUNIT/δ-side mate transport AXIOM-CLEAN in the same file with exactly this machinery.
The only new ingredient — pushing `pullbackValIso.inv` (= `sheafificationCompPullback.hom`
= `leftAdjointUniq.hom`, post-composed with a counit `mapIso`) through the chase — is precisely what
the three `leftAdjointUniq_*_app` glue lemmas exist for. No coherence lemma is absent.

**Q3 — Is there a SHORTER idiom that sidesteps the manual chase? NO.**
The only candidate is `CategoryTheory.Functor.Monoidal.instIsIsoη`
(`Mathlib.CategoryTheory.Monoidal.Functor`): `[F.Monoidal] → IsIso (Functor.OplaxMonoidal.η F)`. It
does not apply: (a) the goal is `a_Y.map (η F)`, sheafification applied to the oplax unit of a
*different* functor, not `η` of one monoidal functor; (b) `F = PresheafOfModules.pullback φ'` is only
OPLAX, not strong, monoidal — supplying the strong structure on this composite is exactly the general
build the project deliberately abandoned as unnecessary (memory `pullback-tensor-loctriv-pivot`). No
`leftAdjointUniq` monoidal-compatibility lemma exists either. The mate chase via
`leftAdjointOplaxMonoidal_η` is the canonical and shortest available route.

## Informational
- **Expected friction (not a gap):** the same defeq-but-not-syntactic mismatch
  `pullbackObjUnitToUnit_comp` absorbed with `erw` (`Scheme.Modules.pullback f` vs
  `SheafOfModules.pullback f.toRingCatSheafHom`; here additionally `sheafificationCompPullback`
  unfolding to `leftAdjointUniq`). Budget for `erw`-driven re-association; it is an elaboration
  nuisance, not a missing API.
- **Verification method:** loogle (name + signature) at the pinned commit. `lean_local_search` indexes
  only the current project, so Mathlib names return empty there — loogle is authoritative here.

## Persistent file
- `analogies/eta247.md` — design-rationale + full citation list captured for future iters.

Overall verdict: **PROCEED** — every named glue lemma and reduction lemma exists in current Mathlib
with usable signatures, the two-level mate chase is the axiom-clean unit-side mirror of the already-
landed `pullbackObjUnitToUnit_comp`, and no shorter monoidal-transport shortcut applies; the chase is
standard mate calculus closeable this iter (expect the known `erw` defeq friction).
