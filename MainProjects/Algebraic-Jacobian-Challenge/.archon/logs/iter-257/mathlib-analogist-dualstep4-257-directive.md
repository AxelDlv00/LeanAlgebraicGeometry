# mathlib-analogist dualstep4-257

## Mode: api-alignment

## Context

`dual_restrict_iso` (`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean:233`) has ONE residual
`sorry` (Step-4, ~L259). Steps 1–3 + H1 are closed. The residual is a PresheafOfModules-level iso:
```
(pushforward β).obj (PresheafOfModules.dual M.val) ≅ PresheafOfModules.dual ((pushforward β).obj M.val)
```
where `β` is the sectionwise open-immersion ring iso `𝒪_Y(V) ≅ 𝒪_X(fV)`, and
`PresheafOfModules.dual M = internalHom M 𝟙_` is the project's slice internal-hom (value
`(dual M)(U) = Hom_{Over U}(restr U M, restr U 𝟙_)`, NOT a sectionwise linear dual).

A prior api-alignment consult (`analogies/dual252.md`) established: the residual decomposes into
**leg (B)** = ring-iso reconciliation of the unit codomain (`restrictScalarsRingIsoDualEquiv`, CLOSED,
axiom-clean — the right atom) **and leg (A)** = a slice-site transport of the DOMAIN presheaf
(`restr V (pushβ M.val)` over `Over V ⊂ Opens Y` ↔ `restr fV M.val` over `Over fV ⊂ Opens X`, under the
open immersion's `f.opensFunctor` fully-faithfulness on the down-set). Leg (A) — a presheaf-level
`restr`-vs-`f.opensFunctor` base-change / Beck–Chevalley square over the slice down-set — is a genuine
new build, NOT a Mathlib import. dual252 also FLAGGED-BUT-DID-NOT-VERIFY a cheaper alternative.

This residual has resisted closure across ~iters 228–256 (slice-site equivalence wall; the project's
`overSliceSheafEquiv` was built but proven INAPPLICABLE here — it lives at the Sheaf / fixed-value-cat
level, while this residual is presheaf-level + varying-ring).

## Two precise questions

**(1) The cheaper alternative — derive `dual_restrict_iso` from the CLOSED `tensorObj_restrict_iso` via
inverse-uniqueness.** dual252 flagged: "dual = ⊗-inverse, so derive `dual_restrict_iso` from the already-
closed `tensorObj_restrict_iso` by uniqueness of monoidal inverses, using eval/coeval naturality — this
sidesteps leg (A) entirely if the inverse-uniqueness glue is cheaper than leg (A)." Is there a Mathlib
idiom that makes this work at the PresheafOfModules level WITHOUT a registered `MonoidalCategory` +
rigid/`MonoidalClosed` structure on `PresheafOfModules` (which is absent — `loogle "MonoidalClosed
(PresheafOfModules ?R)"` returns nothing)? Concretely: does Mathlib have a "right duals are unique up to
canonical iso" / "a functor that is strong monoidal preserves chosen right duals" lemma that could be
applied to the restriction-along-open-immersion functor and the evaluation/coevaluation of the project's
`dual`, given that `dual` here is `internalHom(–,𝟙_)` (NOT necessarily a categorical right dual unless we
also have the rigidity coherences)? If yes, name the exact lemma(s) and the minimal coherence the project
must supply. If no (the rigid-category machinery requires structure the project does not have), say so
decisively so we commit to leg (A) instead.

**(2) If leg (A) is unavoidable — the cleanest Mathlib idiom for the slice Beck–Chevalley.** Leg (A) is:
for an open immersion `f : Y ↪ X` and `V : Opens Y`, identify the restriction of `(pushforward β) M.val`
to the slice `Over V` (a presheaf over `Opens Y` restricted below `V`) with the restriction of `M.val`
to `Over fV` (over `Opens X` below `fV`), transported across `f.opensFunctor`. Does Mathlib have a
Beck–Chevalley / base-change idiom for presheaf restriction along a fully-faithful (open-immersion-induced)
functor of `Opens` posets — e.g. `CategoryTheory.Functor.…` left/right Kan extension base-change, or the
`Opens.map`/`IsOpenImmersion.opensFunctor` adjunction commuting with `restr`? Name the most direct atom
to build `sliceDualTransport` (the leg-A `≃ₗ`), and whether it should be assembled as an `isoMk` with
thin-poset (`Subsingleton.elim`) naturality (as in `dualUnitIsoGen`).

## Deliverable

A clear PROCEED/ALIGN verdict on route (1) (viable & cheap → blueprint it and drop leg A; or not viable →
commit leg A) and, for route (2), the named Mathlib atom(s) + the minimal `sliceDualTransport` skeleton.
Persist to `analogies/dualstep4-257.md`.
