# strategy-critic sc252 — directive

Fresh-eyes audit of the global strategy. You have NO iteration history; judge the strategy as a
mathematician seeing it for the first time. The strategy-critic was last run at iter-239 (13 iters
ago); `STRATEGY.md` has materially evolved since (a critical-path obstacle was eliminated, a new
parallel sub-lane was added). Re-verify the route is still the right one.

## What to read (verbatim)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` — the strategy (read in full).
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` — the reference index.
- Open and quote the actual reference source files under `references/` as needed (Kleiman, Nitsure,
  Milne, Mumford, Stacks) — do not rely on the summary alone for any claim you challenge.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine protected
declarations headed by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an
Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k` (`[Field k]` only; no `C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}` is built
unconditionally; `isAlbaneseFor` is quantified over the pointing. End-state: zero inline `sorry` in
the dependency cone of each protected decl, 0 project axioms, kernel-only axioms.

## Blueprint chapters (title / one-line topic)
- Picard_TensorObjSubstrate — the relative Picard sheaf `Scheme.Modules.tensorObj`; the ⊗-group law +
  the pullback–tensor comparison iso on line bundles (the ACTIVE critical path).
- Picard_RelPicFunctor — the relative Picard functor + étale sheafification (group on loc-triv classes).
- Picard_FGAPicRepresentability — FGA representability of the Picard scheme.
- Picard_RelativeSpec / Picard_QuotScheme / Picard_FlatteningStratification — A.2.c engine pieces.
- Picard_IdentityComponent / Picard_Pic0AbelianVariety — Pic⁰ as the identity component / AV structure.
- Picard_LineBundlePullback — line-bundle pullback on a relative curve.
- Cohomology_{FlatBaseChange, HigherDirectImage, MayerVietoris, SheafCompose, StructureSheafAb,
  StructureSheafModuleK} — cohomology/`Rⁱf_*` substrate for the engine.
- Albanese_{AlbaneseUP, AuslanderBuchsbaum, CodimOneExtension, Thm32RationalMapExtension, CoheightBridge} —
  the Albanese UP (Route 1 RR-free primary; Route 2 autoduality contingent).
- AbelianVarietyRigidity / Rigidity / RigidityKbar / RigidityLemma — rigidity (Milne 3.2/3.10).
- RiemannRoch_{WeilDivisor, OcOfD, OCofP, RRFormula, RationalCurveIso, H1Vanishing} — RR chain (USER-PAUSED).
- Genus / Genus0BaseObjects_Cross01Substrate / Differentials / AbelJacobi / Jacobian — genus, base objects, goal.

## Specific questions for you
1. Is `J := Pic⁰_{C/k}` (Route A, RR-free) still the right spine, given the RR chain is permanently
   USER-paused? The strategy accepts a ~3400–5500-LOC RR-free Quot/Cartier engine specifically to avoid RR.
2. Is the A.1.c.sub critical path — building the locally-trivial pullback–tensor comparison iso BY HAND
   through sheafification (carry `Pic X` on `IsInvertible M := ∃N, M⊗N≅𝒪`) — the right granularity, or is
   there a Mathlib-aligned shortcut you'd expect a fresh mathematician to reach for?
3. Is the A.4 Albanese plan (Route 1 = Weil's φ via divisor-sum + Milne rigidity, RR-free PRIMARY;
   Route 2 = autoduality, contingent on an unverified RR-freeness check) sound, or is one route dominant?
4. Any hallucinated dependency, unnecessary case split, or missing prerequisite in the phase table?

Report SOUND / CHALLENGE / REJECT per strategic claim, citing the reference you read.
