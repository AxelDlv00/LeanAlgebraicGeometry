# Strategy-critic directive — iter-232

Give a fresh-mathematician critique of the project strategy. You have NO access to
iter-by-iter narrative — judge the strategy on its merits.

## Read these (and only these)
- `.archon/STRATEGY.md` (verbatim — the current strategy; just revised this iter).
- `references/summary.md` (the available informal sources).

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine
protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only). `J := Pic⁰_{C/k}` is built unconditionally; end-state is zero inline
`sorry` in the dependency cone of each protected decl, 0 project axioms.

## Blueprint chapters (title per file)
[paste from the chapter list — titles only]
AbelJacobi; AbelianVarietyRigidity; Albanese_{AlbaneseUP, AuslanderBuchsbaum,
CodimOneExtension, CoheightBridge, Thm32RationalMapExtension}; Cotangent_GrpObj;
Cohomology_{FlatBaseChange, MayerVietoris, SheafCompose, StructureSheafAb,
StructureSheafModuleK}; Differentials; Genus; Genus0BaseObjects_Cross01Substrate;
Jacobian; Picard_{FGAPicRepresentability, FlatteningStratification, IdentityComponent,
LineBundlePullback, Pic0AbelianVariety, QuotScheme, RelPicFunctor, RelativeSpec,
TensorObjSubstrate}; RiemannRoch_{H1Vanishing, OCofP, OcOfD, RRFormula,
RationalCurveIso, WeilDivisor}; Rigidity; RigidityKbar.

## Focus questions
1. The sole active lane (A.1.c.SubT ⊗-inverse) has been flat for 14 iters. The strategy
   now restructures it: file-split the leaf + incremental sub-build of `dual_restrict_iso`
   (one axiom-clean sub-lemma per iter) instead of an all-or-nothing gate. Is this the
   right structural response, or does the 14-iter stall signal a deeper route problem
   (e.g. the whole dual-based inverse is the wrong construction and route-II cocycle
   gluing should be primary now)?
2. The A.1.c.SubT substrate unblocks only the PARKED A.2.c engine (~3400–5500 LOC,
   Mathlib-absent). Is finishing the substrate the right near-term investment given the
   PRIMARY GOAL is Pic representability (A.2.c)? Should engine blueprint coverage
   (now seeding `Cohomology_FlatBaseChange`) be accelerated relative to the substrate?
3. Any hallucinated route, unnecessary case-split, or missing prerequisite in the
   RR-free critical path A.1.c.SubT → A.1.c → A.2.c?

Verdict: SOUND / CHALLENGE / REJECT, with the specific strategic claim you challenge.
