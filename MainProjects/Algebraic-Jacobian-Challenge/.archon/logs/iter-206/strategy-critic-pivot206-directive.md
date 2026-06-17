# Strategy Critic Directive

## Slug
pivot206

## What to read (and ONLY this)
- `.archon/STRATEGY.md` — read it verbatim; it is the object under review.
- `references/summary.md` — the reference index (below, also on disk).
- The blueprint chapter title list below (one line per chapter).
- The project goal paragraph below.

Do NOT read: iter sidecars (`.archon/iter/**`), `task_pending.md`,
`task_done.md`, prover task results, review reports, or any per-iter
narrative. Your value is a fresh view of the strategy with no sunk-cost
exposure.

## Project goal (verbatim from the challenge)
Formalize Christian Merten's Jacobian challenge: nine protected Lean
declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C/k`, with no `C(k) ≠ ∅` hypothesis and no
`CharZero` (only `[Field k]`). The witness `J` is constructed
unconditionally; only `isAlbaneseFor` is quantified over the pointing.

## Blueprint chapter index (title per chapter)
- AbelJacobi: The Abel–Jacobi map
- AbelianVarietyRigidity: morphisms from a genus-0 curve into an AV are constant
- Albanese_AlbaneseUP: Albanese universal property of Pic⁰_{C/k}
- Albanese_AuslanderBuchsbaum: Auslander–Buchsbaum
- Albanese_CodimOneExtension: codim-1 indeterminacy extension (A.4.a)
- Albanese_CoheightBridge: coheight–Krull-dim bridge
- Albanese_Thm32RationalMapExtension: Milne Thm 3.2 rational maps into AVs
- AlgebraicJacobian_Cotangent_GrpObj: cotangent space at the identity (A.3.0)
- Cohomology_* (MayerVietoris, SheafCompose, StructureSheafAb, StructureSheafModuleK): sheaf-cohomology substrate
- Differentials: relative cotangent presheaf
- Genus: genus of a smooth proper curve
- Genus0BaseObjects_Cross01Substrate: Cross01 substrate
- Jacobian: the Jacobian as an abelian variety
- Picard_FGAPicRepresentability: FGA representability of the Picard scheme (A.2.c)
- Picard_FlatteningStratification: flattening stratification
- Picard_IdentityComponent / Picard_Pic0AbelianVariety: identity component Pic⁰
- Picard_LineBundlePullback: line-bundle pullback on a relative curve
- Picard_QuotScheme: the Quot scheme
- Picard_RelPicFunctor: relative Picard functor + étale sheafification (A.1.c)
- Picard_RelativeSpec: relative Spec
- Picard_TensorObjSubstrate: line-bundle tensor group-law substrate (A.1.c.SubT)
- RiemannRoch_* (WeilDivisor, RRFormula, OCofP, OcOfD, RationalCurveIso, H1Vanishing): Riemann–Roch chain (PAUSED)
- Rigidity / RigidityKbar: rigidity for morphisms / over a base field

## references/summary.md (index)
(Read the file on disk for the full table; key sources: Kleiman "The Picard
scheme" §4 existence / §5 Pic⁰ / §6; Nitsure "Hilbert and Quot Schemes" §5;
Milne "Abelian Varieties" III §1/§4/§6; Mumford "Abelian Varieties"; Stacks
01CR Picard group; Mathlib `RingTheory.PicardGroup`.)

## Focus this iter
Two strategic changes landed this iter — assess both, plus the usual
soundness + canonical-skeleton + format audit:

1. **A.1.c.SubT flat/line-bundle pivot.** The relative Picard group law was
   re-scoped off a full `MonoidalCategory (Scheme.Modules X)` (which bottomed
   out in a verified-absent Mathlib `MonoidalClosed (PresheafOfModules R₀)`)
   onto the group of iso-classes of line bundles (four existence-of-iso
   lemmas + a flat-scoped restriction iso), mirroring Mathlib's
   `CommRing.Pic = Units (Skeleton …)` / `Module.Invertible`. Is this the
   right shape? Any risk the lighter route fails to deliver the full
   `AddCommGroup` the downstream RelPic functor needs?

2. **RR-free A.2.c.** A reference audit concluded bare `Pic_{C/k}`
   representability and the identity component `Pic^z` are RR-free (Kleiman
   §4–§5, Nitsure §5), narrowing the Route-C (Riemann–Roch, USER-paused)
   dependency to three downstream nodes only (genus formula `dim J = g`,
   autoduality `J ≅ J^∨`, `Sym^d` surjectivity if used). The STRATEGY's TOP
   open question is now whether to define `Pic⁰ := degComp` (RR-dependent,
   no identity-component infra) or `Pic⁰ := Pic^z` (RR-free, needs ~350 LOC
   identity-component / clopen-descent infra). Is the strategy's handling of
   this trade-off sound? Is leaving it as an open question (rather than
   deciding now) defensible given it is downstream and gated?

Render SOUND / CHALLENGE / REJECT per the usual rubric, plus the
canonical-skeleton + ≤250-line/≤12KB format check.
