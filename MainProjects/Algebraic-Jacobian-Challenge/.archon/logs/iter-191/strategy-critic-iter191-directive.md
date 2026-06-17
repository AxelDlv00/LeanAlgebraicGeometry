# Strategy critic iter191 directive

## Mandate

Fresh-context re-validation of `STRATEGY.md`. iter-190 plan-phase
substantively revised the strategy:
- Lane M↓ Option (c) REJECTED (permanent-named-sorry incompatible
  with `kernel-only axioms` clause); Lane M↓ RE-OPENED as project-side
  Option (a) build (~8-15 iters / ~150-300 LOC).
- A.3.0 substrate added (scheme-level tangent space ↔ first-order
  deformations; shared by A.3.iii + A.3.iv).
- A.4.d.0 substrate added (Pic^d component + universal effective
  divisor; reuse path enumerated).
- A.3.v/A.3.vi dependency graph corrected (parallel-startable with
  A.3.iii/iv).
- Format compliance: iter-NNN provenance tags stripped; 12.2 KB / 145
  lines.

Read the STRATEGY.md verbatim from disk, the references summary, and
the blueprint summary inline below. **You must NOT read iter sidecars,
task_pending.md, task_done.md, or any task_results — your value is the
fresh-mathematician view.**

---

## Current `STRATEGY.md` (verbatim)

(Read from
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
directly. SHA may have shifted since iter-190 if any edits happened
plan-phase iter-191 — read live.)

## References summary

(Read from
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`
verbatim.)

## Blueprint summary (chapter titles)

31 chapter files under `blueprint/src/chapters/` (+1 since iter-190 →
`RiemannRoch_H1Vanishing.tex` landed):

- AbelJacobi.tex, AbelianVarietyRigidity.tex
- Albanese_AlbaneseUP.tex, Albanese_AuslanderBuchsbaum.tex,
  Albanese_CodimOneExtension.tex, Albanese_CoheightBridge.tex,
  Albanese_Thm32RationalMapExtension.tex
- AlgebraicJacobian_Cotangent_GrpObj.tex
- Cohomology_MayerVietoris.tex, Cohomology_SheafCompose.tex,
  Cohomology_StructureSheafAb.tex, Cohomology_StructureSheafModuleK.tex
- Differentials.tex, Genus.tex,
  Genus0BaseObjects_Cross01Substrate.tex, Jacobian.tex
- Picard_FGAPicRepresentability.tex,
  Picard_FlatteningStratification.tex,
  Picard_IdentityComponent.tex, Picard_LineBundlePullback.tex,
  Picard_QuotScheme.tex, Picard_RelPicFunctor.tex,
  Picard_RelativeSpec.tex
- RiemannRoch_H1Vanishing.tex (NEW iter-190 plan-phase),
  RiemannRoch_OCofP.tex, RiemannRoch_OcOfD.tex,
  RiemannRoch_RRFormula.tex, RiemannRoch_RationalCurveIso.tex,
  RiemannRoch_WeilDivisor.tex
- Rigidity.tex, RigidityKbar.tex

Unstarted-phase chapters committed in STRATEGY.md but not yet written:
- A.3.iii–vi `Pic⁰_{C/k}` AV wrap (tangent iso, smoothness, properness,
  geom-irreducibility) — slated for `Picard_Pic0AbelianVariety.tex`.
- A.4.d divisor-map Albanese UP — `Albanese_AlbaneseUP.tex` exists but
  carries the old Sym^g content; rewrite deferred iter-191+.

## Project goal (verbatim)

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean`): nine protected declarations headlined
by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`
— existence of an Albanese / Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible
curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis. End-state: zero
inline `sorry`, kernel-only axioms (`propext`, `Classical.choice`,
`Quot.sound`). **Char-general:** the protected signatures take
`[Field k]` only — NO `CharZero`.

## What I need from you

Verdict: SOUND / CHALLENGE / REJECT. For each CHALLENGE, name the
specific load-bearing assumption and the cheaper or sounder
alternative. Focus areas this iter:

1. **Lane M↓ Option (a) viability**: iter-190 re-opened the route as
   project-side Stacks 00TT build (~8-15 iters / ~150-300 LOC). Is
   this estimate honest given that Mathlib b80f227 also lacks several
   intermediate substrates (graded ring `gr_𝔪(R)` ≅ polynomial ring
   for regular local rings, Cohen structure theorem)? Or is the
   ~150-300 LOC plausible because the smooth → flat → polynomial
   presentation chain at the stalk level is shorter than the full
   00NQ proof?

2. **A.3.0 substrate enumeration**: scheme-level tangent space ↔
   first-order deformations, ~200-400 LOC, shared by A.3.iii and
   A.3.iv. Is the granularity right (single shared substrate), or
   does the substrate itself need further decomposition before
   bodies can start?

3. **A.4.d divisor-map UP pivot**: the chapter rewrite is still
   pending (deferred iter-189 → iter-190 → iter-191 plan-phase).
   With the iter-190 strategy revision enumerating A.4.d.0 (Pic^d +
   universal effective divisor) as a shared substrate reused from
   A.2.b and A.3.vii, is the pivot fully specified, or are there
   hidden gaps (e.g. how does one EXTRACT the universal degree-g
   morphism from the Quot-scheme representability without writing
   a separate Hilbert-of-points construction)?

4. **Lane A.3.i CHURNING (4 iters, 0 closures iter-189-190)**: the
   route enters iter-191 with the mathlib-analogist `lane-a3i-
   isconnected-prod` consult queued. The substrate needed is
   `Scheme.isConnected_pullback_of_isGeometricallyConnected` (EGA
   IV₂ 4.5.8 analog). If the analogist returns "no Mathlib analog,
   build project-side, ~80-150 LOC", does Lane A.3.i still close in
   <20 iters total (it has spent 4 already), or is the route too
   wedge-deep and should the IdentityComponent definition be
   refactored to avoid the connectedness-of-products substrate
   altogether?

5. **Genus-0 RR.2.H¹ project-side build**: `RR_H1Vanishing.tex`
   chapter landed iter-190 (560 lines). The file `H1Vanishing.lean`
   does NOT yet exist (flagged by blueprint-doctor iter-190).
   Estimated ~8-12 iters / ~200-400 LOC. Is the cohomology framework
   `H^Module k̄`-Ext consistent with the planned flasque-resolution
   approach, or does the `H^Module k̄`-flavoured cohomology pipeline
   need its own substrate work before bodies can start?

6. **Total positive-genus envelope** ~290-520 iters / 9200-16400 LOC:
   given that iter-190 landed at 79 sorries (integration RED) after
   190 iters, with ~5-10 substrate sub-phases still gated, is the
   envelope still credible, or is the multi-iter A.2 / A.4 cost
   systematically underestimated?

I am dispatching this as a re-validation of iter-190 revisions. If
you find the revision SOUND, name the specific iter-190 CHALLENGE
findings and confirm each was addressed in the current STRATEGY.md.

NO iter-by-iter narrative in your output — that's iter sidecar
content. Stay focused on strategic shape.
