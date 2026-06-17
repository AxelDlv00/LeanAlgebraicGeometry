# Strategy critic iter190 directive

## Mandate

Fresh-context audit of `STRATEGY.md`. The iter-189 dispatch hung and was
killed, so this is effectively the first re-validation of the iter-188
revisions:
- A.3 decomposed into 7 sub-phases.
- A.4.d pivoted from Sym^g to divisor-map Albanese UP.
- RR.2 H¹ promoted from "off path" to committed sub-phase.
- Lane M↓ Option (c) committed (`isRegularLocalRing_stalk_of_smooth`
  accepted as permanent until Mathlib upstream).
- Axiomatise-then-replace REMOVED.

Read the STRATEGY.md inline below, the references summary inline below,
and the blueprint summary inline below. **You must NOT read iter sidecars,
task_pending.md, task_done.md, or any task_results — your value is the
fresh-mathematician view.**

---

## Current `STRATEGY.md` (verbatim)

(See `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
at SHA 93460872a01577b78fca233445ea963726297d438135658cc71f1d1240583c97 —
unchanged from iter-188 plan-phase revision.)

## References summary

(See `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`
verbatim.)

## Blueprint summary (chapter titles)

29 chapter files under `blueprint/src/chapters/`:

- AbelJacobi.tex, AbelianVarietyRigidity.tex
- Albanese_AlbaneseUP.tex, Albanese_AuslanderBuchsbaum.tex, Albanese_CodimOneExtension.tex,
  Albanese_CoheightBridge.tex, Albanese_Thm32RationalMapExtension.tex
- AlgebraicJacobian_Cotangent_GrpObj.tex
- Cohomology_MayerVietoris.tex, Cohomology_SheafCompose.tex, Cohomology_StructureSheafAb.tex,
  Cohomology_StructureSheafModuleK.tex
- Differentials.tex, Genus.tex, Genus0BaseObjects_Cross01Substrate.tex (NEW iter-189), Jacobian.tex
- Picard_FGAPicRepresentability.tex, Picard_FlatteningStratification.tex,
  Picard_IdentityComponent.tex, Picard_LineBundlePullback.tex, Picard_QuotScheme.tex,
  Picard_RelPicFunctor.tex, Picard_RelativeSpec.tex
- RiemannRoch_OCofP.tex, RiemannRoch_OcOfD.tex, RiemannRoch_RRFormula.tex,
  RiemannRoch_RationalCurveIso.tex, RiemannRoch_WeilDivisor.tex
- Rigidity.tex, RigidityKbar.tex

Unstarted-phase chapters NOT yet written but committed in STRATEGY.md
phases table:
- A.3.ii–vi `Pic⁰_{C/k}` AV wrap (tangent iso, smoothness, properness,
  geom-irreducibility) — would land in `Picard_Pic0AbelianVariety.tex`
- RR.2.H¹ skyscraper-flasque vanishing — would land in
  `RiemannRoch_H1Vanishing.tex`
- A.2.a.* skeleton chapters present but bodies gated.

## Project goal (verbatim)

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms (`propext`,
`Classical.choice`, `Quot.sound`). **Char-general:** the protected
signatures take `[Field k]` only — NO `CharZero`.

## What I need from you

Verdict: SOUND / CHALLENGE / REJECT, per the strategy as written. For each
CHALLENGE, name the specific load-bearing assumption and the cheaper or
sounder alternative. Focus areas:

1. Is the **A.3 decomposition into 7 sub-phases** the right granularity?
   (A.3.iii tangent iso, A.3.iv smoothness, A.3.v properness, A.3.vi
   geom-irreducibility — are these independent enough to schedule
   separately, or is the cotangent-at-identity substrate so load-bearing
   it forces a different decomposition?)
2. Is the **divisor-map A.4.d pivot** sound? (Replacing Sym^g symmetric-
   power UP with universal-effective-divisor-to-Pic^d morphism + degree-g
   translate. Avoids S_g-quotient gap. But what new gaps does it open?)
3. Is **RR.2 H¹ promotion to a committed project-side sub-phase** the
   right call, given that H¹ is on the genus-definition critical path?
   (As opposed to e.g. accepting a Mathlib upstream wait, or pivoting
   the genus definition to a Čech form.)
4. Is the **single-route monolithic positive-genus arm** sound, or
   should there be a parallel fallback route in case A.4.a or A.2 blows
   up multi-iter?
5. Are **iters-left estimates** in the phases table broadly consistent
   with realized velocity, or is the total positive-genus envelope
   (~280-500 iters / 9000-16000 LOC) systematically underestimating
   the substrate cost of the route?
6. Have any **rejected alternatives** become MORE attractive in light of
   the difficulty of the chosen route (e.g. the `Pic⁰`-functor-of-points
   UP, even though it shifts codim-1 content)? If the chosen route blows
   past its envelope, is there a sound retreat path?

I am dispatching this as a re-validation of an unsupervised iter-188
revision. If you find the revision SOUND, name the specific iter-188
CHALLENGE findings and confirm each was addressed in the current
STRATEGY.md.
