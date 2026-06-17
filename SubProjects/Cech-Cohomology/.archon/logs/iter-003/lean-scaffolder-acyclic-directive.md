# Lean Scaffolder Directive

## Goal
Create the NEW file `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` and wire it into
the build. This file will hold the project's P4 abstract homological-algebra core: "an
acyclic resolution computes the right-derived functor" (Stacks Tag 015E). The prover will
build the hard content next (in `mathlib-build` mode); your job is a **minimal, COMPILING
skeleton** plus a rich strategy block — NOT a tree of sorry stubs.

## Sources to read first
- Blueprint chapter `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` — the full
  route and every declaration's intended statement (it `% archon:covers` this file).
- `.archon/analogies/p4-derived-les.md` — the Mathlib-alignment analysis with the concrete
  scaffold shape (read its "Recommendation" section carefully). Mirror its guidance.

## What to create (the file must `lake build` cleanly — sorry warnings OK, NO errors)

1. **Header + imports + namespace.** License header comment, then `import Mathlib`
   (project convention — the existing cohomology files use the blanket import; do not
   hand-narrow it), then `import AlgebraicJacobian.Cohomology.HigherDirectImage` only if
   needed (probably not). Open `namespace CategoryTheory` (the blueprint `\lean{}` pins are
   `CategoryTheory.Functor.IsRightAcyclic`, `CategoryTheory.InjectiveResolution.ofShortExact`,
   `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`,
   `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`).

2. **`Functor.IsRightAcyclic` (def:right_acyclic).** Scaffold this as a real, COMPILING
   declaration (it is certain and simple). Per the analogist, make it a
   `class Functor.IsRightAcyclic (G : 𝒜 ⥤ ℬ) (J : 𝒜) : Prop` (with the right
   `[Abelian 𝒜] [EnoughInjectives 𝒜] [Abelian ℬ] [Additive G]` instance context, matching
   the context under which `G.rightDerived` is defined) whose single field is the
   index-shifted vanishing `∀ k : ℕ, IsZero ((G.rightDerived (k+1)).obj J)` — mirroring the
   quantifier of `Functor.isZero_rightDerived_obj_injective_succ`. Add an `instance` deriving
   `IsRightAcyclic G J` for `[Injective J]` from
   `Functor.isZero_rightDerived_obj_injective_succ` (this should be a one-liner; if it does
   not immediately elaborate, leave the instance body `sorry` and note it — but the class
   itself must compile).

3. **Strategy block for the to-build content.** Above where the rest will go, place a
   `/- Planner strategy: ... -/` block (and per-target sub-blocks) capturing, for the
   prover building in `mathlib-build` mode:
   - The route (from the blueprint): horseshoe lift of a SES to a degreewise-split SES of
     injective resolutions → apply `G` degreewise (split ⇒ preserved) → complex-level
     homology LES → transport along `isoRightDerivedObj` → dimension shift → staircase.
   - The VERIFIED Mathlib building blocks (cite exact names; the plan agent confirmed all
     present): `CategoryTheory.InjectiveResolution.isoRightDerivedObj`,
     `Functor.rightDerivedZeroIsoSelf`, `Functor.isZero_rightDerived_obj_injective_succ`
     (all `Mathlib/CategoryTheory/Abelian/RightDerived.lean`);
     `ShortComplex.ShortExact.homology_exact₁/₂/₃` and `ShortComplex.ShortExact.δ`
     (`Mathlib/Algebra/Homology/HomologySequence.lean`).
   - The genuinely hard sub-task (per analogist): the horseshoe
     `InjectiveResolution.ofShortExact` — build `I_B` degreewise as the biproduct
     `I_A.cocomplex.X n ⊞ I_C.cocomplex.X n` with the TWISTED differential `[[d_A, τ],[0,d_C]]`;
     the off-diagonal `τ` and the augmentation `B → I_B^0` come stage-by-stage from
     `Injective.factorThru`. Model the recursion on Mathlib's
     `InjectiveResolution.ofCocomplex` / `exact_f_d` / `ofCocomplex_exactAt_succ`
     (`Mathlib/CategoryTheory/Abelian/Injective/Resolution.lean`). Expose the output as a
     `ShortComplex (CochainComplex C ℕ)` that is `.ShortExact`. Suggest the prover build this
     as its OWN standalone lemma chain (per-degree `τ`, chain-map laws, exactness), not one
     monolith.
   - The intended `\lean{}` target names for the remaining declarations
     (`InjectiveResolution.ofShortExact`, `Functor.rightDerivedShiftIsoOfAcyclic`,
     `Functor.rightDerivedIsoOfAcyclicResolution`) so the prover uses the blueprint's names.
   - Point the prover at `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` and
     `.archon/analogies/p4-derived-les.md` for full detail.

   Do NOT scaffold the horseshoe / dimension-shift / comparison theorem as live `sorry`
   stubs unless you can make their signatures elaborate cleanly against Mathlib — an
   un-elaborating signature would break the build. If you are confident a signature
   elaborates, you MAY scaffold it as a `sorry` stub (that is fine and helpful); if not,
   leave it as a commented target in the strategy block. Prefer compilation safety.

4. **Wire into the build.** Add `import AlgebraicJacobian.Cohomology.AcyclicResolution` to
   the root `AlgebraicJacobian.lean` so the new file is in the build graph.

## Verify before finishing
Run a build (or `lean_verify` / targeted compile) on `AcyclicResolution.lean` and confirm
it compiles with at most `sorry`/`declaration uses sorry` warnings and NO errors. Report
the exact final declaration names you created and any signature you could NOT make
elaborate (so the plan agent knows what the prover must construct from scratch).

## Constraints
- Do NOT attempt to prove anything (no real proofs); class def + the trivial injective
  instance are the only "content". Everything else is skeleton + strategy comments.
- Do NOT add `\leanok` or touch any `.tex` file (outside your write-domain anyway).
- Keep names EXACTLY as the blueprint `\lean{}` pins specify (1-to-1 correspondence).
