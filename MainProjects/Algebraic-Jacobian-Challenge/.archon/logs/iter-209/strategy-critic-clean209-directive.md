# Strategy Critic Directive

## Slug
clean209

## What to review
Read `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
(verbatim — it is your primary input; it was just rewritten this iter, both to
tighten it per a user "make it cleaner" hint and to record a construction pivot on
the sole active lane). Assess it as a fresh mathematician would, with no investment
in the project's momentum. The reference index, blueprint chapter map, and project
goal you need are below — do NOT read iter sidecars, task files, PROGRESS.md, or any
prover/review narrative.

## Project goal (one paragraph)
Formalize Christian Merten's "Jacobian challenge": construct the Jacobian / Albanese
object of a smooth proper geometrically irreducible curve `C` over an arbitrary field
`k` (no `C(k)≠∅`, no `CharZero`), as `J := Pic⁰_{C/k}`, and prove its Albanese
universal property uniformly over the `k`-rational pointing. Nine protected Lean
declarations (`AlgebraicGeometry.Jacobian`, `Jacobian.nonempty_jacobianWitness`, the
Abel–Jacobi map, …) are the end target; they must close with kernel-only axioms.

## Reference index (`references/summary.md`, compact)
- `challenge.lean.ref` — Merten's authoritative formal statement/skeleton.
- Kleiman, "The Picard scheme" (FGA Explained) — Route A source; §4 existence, §5 `Pic⁰`/Jacobian, §6 `Pic^τ`.
- Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained) — Quot/Hilbert engine behind representability.
- Milne, "Abelian Varieties" — rigidity Thm 1.1; Thm 3.2/Prop 3.10 (rational→AV constant); Albanese UP Prop 6.1/6.4; autoduality Thm 6.6.
- Mumford, "Abelian Varieties" — rigidity, theorem of the cube.
- Stacks Project — varieties (035U, 0BUG), fields (09HD, 030K), algebra (00T7), coherent (02KH), constructions (relative Spec 01L*), Picard/invertible (01CR, 01HK).
- Hartshorne — II.4.7 (valuative criterion), II.6 (divisors/Pic).
- `Mathlib.RingTheory.PicardGroup` — `Module.Invertible`, `CommRing.Pic = Units(Skeleton ModuleCat)` (the ⊗-invertibility idiom the iter-209 pivot adopts).

## Blueprint chapter map (titles, one line each)
- Picard_TensorObjSubstrate — relative Picard sheaf `Scheme.Modules.tensorObj` (the pivoted line-bundle group-law lane).
- Picard_LineBundlePullback — line-bundle pullback on a relative curve (`OnProduct`, `IsLocallyTrivial`).
- Picard_RelPicFunctor — relative Picard functor + étale sheafification.
- Picard_RelativeSpec — relative Spec (done, axiom-clean).
- Picard_FGAPicRepresentability — FGA representability of the Picard scheme.
- Picard_QuotScheme / Picard_FlatteningStratification — Quot scheme + flattening (the A.2.c engine).
- Picard_IdentityComponent / Picard_Pic0AbelianVariety — `Pic⁰` identity component + AV structure (gated A.2.c).
- Albanese_AlbaneseUP — Albanese UP of `Pic⁰` (Route 2, gated A.2.c).
- Albanese_{CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum, CoheightBridge} — EXCISED Route-1 codim cone.
- RiemannRoch_* (WeilDivisor, OCofP, OcOfD, RRFormula, H1Vanishing, RationalCurveIso) — Route C, PAUSED.
- Rigidity / RigidityKbar / AbelianVarietyRigidity / Genus / Genus0BaseObjects_* — rigidity + genus-0 substrate.
- Cohomology_* — sheaf cohomology with `ModuleCat k` coefficients (Čech, Mayer–Vietoris).
- Differentials / Cotangent_GrpObj — relative cotangent presheaf + tangent space at identity.

## What I want from you
Challenge the strategy as written. In particular:
1. Is the iter-209 ⊗-invertibility pivot on A.1.c.SubT sound, or does it merely relocate
   the hard fact ("sheafification/⊗ commutes with localization") rather than remove it?
   The strategy claims the coherence isos are mechanical (`sheafification.mapIso`) and the
   group law needs no restriction-compatibility lemma — is that a defensible reading of
   the `CommRing.Pic = Units(Skeleton)` idiom for SHEAVES of modules (vs modules over a
   fixed ring)?
2. Are the bottom-up critical path (TS→RelPic→A.2.c) and the option-(c) posture coherent
   with the goal, or is the group-law substrate over-invested relative to the genuinely
   hard Quot engine?
3. Any hallucinated dependency, missing prerequisite, or route that the references do not
   actually support (esp. the Route-2 autoduality RR-freeness claim and the Route-1 excision).
4. Is the file now clean and within the canonical skeleton, or still carrying per-iter
   narrative / bloat?

Render SOUND / CHALLENGE / REJECT per concern, with the reference each challenge rests on.
