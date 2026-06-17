# Strategy Critic Directive

## Slug
ts219

## What to read (and ONLY these)
- `.archon/STRATEGY.md` (verbatim — just updated this iter; read it fresh).
- `references/summary.md` (the reference index).
- The blueprint chapter titles below (one-line topic each). Do NOT read iter sidecars,
  PROGRESS.md, task_*.md, or recent prover/review narrative.
- You MAY read `analogies/ts219dual.md` (the analogist finding that drove this iter's
  strategy change) and `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` if you want
  to verify the dual-block claim.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine
protected declarations headed by `AlgebraicGeometry.Jacobian` /
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]`
only). `J := Pic⁰_{C/k}`. End-state: zero inline `sorry` in each protected decl's dependency
cone, 0 project axioms, kernel-only axioms.

## Blueprint chapter topics (titles)
- Picard_TensorObjSubstrate: relative Picard sheaf — `Scheme.Modules.tensorObj` (the ⊗-substrate, active lane)
- Picard_RelPicFunctor: relative Picard functor + étale sheafification
- Picard_FGAPicRepresentability: FGA representability of the Picard scheme
- Picard_QuotScheme / Picard_FlatteningStratification: Quot scheme + flattening (the representability engine)
- Picard_IdentityComponent / Picard_Pic0AbelianVariety: Pic⁰ identity component + AV structure
- Picard_RelativeSpec / Picard_LineBundlePullback: relative Spec; line-bundle pullback
- Albanese_AlbaneseUP: Albanese universal property of Pic⁰ (Route 2)
- Albanese_{CodimOneExtension,Thm32RationalMapExtension,AuslanderBuchsbaum,CoheightBridge}: Route-1 codim cone (EXCISED)
- RiemannRoch_{WeilDivisor,OcOfD,OCofP,RRFormula,RationalCurveIso,H1Vanishing}: RR chain (USER-PAUSED — Route C)
- AbelianVarietyRigidity / Rigidity / RigidityKbar: rigidity lemmas
- Jacobian / AbelJacobi / Genus / Genus0BaseObjects: top-level Jacobian assembly
- Cohomology_* / Differentials / Cotangent_GrpObj: cohomology + cotangent substrate

## The decision to vet (the reason for this dispatch)

This iter the strategy changed materially. iter-218's prover hit an INCOMPLETE gate on the
⊗-inverse (`exists_tensorObj_inverse`). A mathlib-analogist consult (`analogies/ts219dual.md`)
then established that the inverse object requires a **sheaf internal-hom of 𝒪_X-modules**,
which is Mathlib-absent at presheaf, sheaf, AND general-categorical level, is *contravariant*
(so NOT a "build presheaf then sheafify" mirror of the existing `tensorObj`), and is a
**~6–12 iter / ~300–500 LOC build — comparable to or larger than the d.2 stalk-⊗ block the
project previously deemed too large to fund and abandoned.** STRATEGY.md has been updated to
split out a new `A.1.c.SubT.dual` sub-phase with this estimate.

The planner's DECISION (recorded, to be vetted by you): under the standing USER constraints
(ROUTE C PAUSE is permanent until the USER lifts it; PRIMARY GOAL = `Pic_{C/k}`
representability A.2.c, built bottom-up on Route A), the planner cannot itself pivot to the
cheaper route. So it will **COMMIT to building the Decision-1 sheaf internal-hom block** (the
gradient strategy: build the missing Mathlib infrastructure project-side, one step per iter),
while SHARPENING the standing escalation to the USER that the divisor-class `Pic⁰` route (via
the USER-paused Riemann–Roch chain; `WeilDivisor`/`OcOfD` already exist) would avoid the
entire ⊗-substrate at ~5× lower cost.

**Questions for you (fresh strategic view):**
1. Is committing to the d.2-scale internal-hom build the right call given the substrate is
   route-A-specific and a ~5× cheaper divisor route exists behind the (USER-controlled) RR
   pause? Or is there a structural reason the planner is missing that the ⊗-route is
   necessary regardless of the RR fork (e.g. the relative Picard FUNCTOR needs the ⊗-group
   even on the divisor route)?
2. Is there a THIRD option the planner has not considered — a way to get the group structure
   on `Pic` (the iso-class `AddCommGroup`) WITHOUT constructing an abstract tensor-inverse
   object? (E.g. defining `Pic X` on a representation where inverses are free, or reusing
   Mathlib's existing `Scheme.Pic`/`CommRing.Pic`, or getting `Pic⁰` directly as a scheme
   from representability so the group law comes from the group-scheme structure rather than
   from a hand-built ⊗-monoid.)
3. Is the decomposition sound — is Decision 1 (presheaf slice/end internal-hom → sheafify)
   genuinely smaller than Decision 3 (`Pseudofunctor.IsStack` descent), as the analogist
   claims, and is the first sub-step (the presheaf internal-hom OBJECT) the right place to
   start?
4. Is the sharpened USER escalation framed correctly, or is the planner over/under-stating
   the cost asymmetry between the ⊗-route and the divisor route?

Render SOUND / CHALLENGE / REJECT on the committed decision, and flag any structural error.
