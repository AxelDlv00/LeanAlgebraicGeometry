# Strategy-critic directive — iter-246

Fresh-context critique of the project strategy. You have NO iter history and no prover narrative — that
is the point. Challenge the strategy as a fresh mathematician would.

## What to read
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — the
  full current strategy).
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (the reference
  index — what source material backs the project).

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine protected Lean
declarations headed by `AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — construct
the Jacobian `J := Pic⁰_{C/k}` of a smooth proper geometrically irreducible curve `C/k` (`[Field k]`
only; no rational point assumed, no `CharZero`) and prove it satisfies the Albanese universal property
(`isAlbaneseFor`, quantified over the `k`-rational pointing). End-state: zero inline `sorry` in the
dependency cone of each protected decl, 0 project axioms.

## Blueprint chapter map (title — one-line topic)
- Picard_TensorObjSubstrate — relative Picard ⊗-substrate: `Scheme.Modules.tensorObj`, the Pic group law, the pullback–tensor comparison iso (CURRENT critical-path frontier)
- Picard_RelPicFunctor — the relative Picard functor + étale sheafification
- Picard_LineBundlePullback — line-bundle pullback on a relative curve
- Picard_RelativeSpec / Picard_QuotScheme / Picard_FlatteningStratification / Picard_FGAPicRepresentability / Picard_IdentityComponent / Picard_Pic0AbelianVariety — the FGA representability engine (held behind the substrate)
- Cohomology_FlatBaseChange / Cohomology_HigherDirectImage / Cohomology_MayerVietoris / Cohomology_Sheaf* — cohomology engine foundations
- Albanese_AlbaneseUP / Albanese_Thm32RationalMapExtension / Albanese_CodimOneExtension / Albanese_AuslanderBuchsbaum / Albanese_CoheightBridge — Albanese UP (Route 2 preferred / Route 1 RR-free fallback)
- AbelianVarietyRigidity / Rigidity / RigidityKbar — rigidity (`Mor(ℙ¹,A)` constant)
- RiemannRoch_* (WeilDivisor, OcOfD, OCofP, RRFormula, RationalCurveIso, H1Vanishing) — Riemann–Roch chain (PAUSED by a permanent user directive)
- Genus / Genus0BaseObjects_* / Differentials / AlgebraicJacobian_Cotangent_GrpObj / Jacobian / AbelJacobi — genus, base objects, tangent space, final assembly

## Focus questions for this critique
1. **The iter-245 loc-triv pivot.** STRATEGY.md records that the *general* strong-monoidal inverse-image
   pullback build (≈20–38 iters) was abandoned in favor of a locally-trivial-restricted comparison-iso
   chart-chase (≈8–16 iters), on the ground that the sole consumer (the relative Picard functor) needs
   the pullback–tensor comparison iso only on **line bundles**, never general modules. Is this reduction
   sound? Is there any downstream node in the arc (A.1.c.fun → A.2.c → A.3 → A.4) that secretly needs the
   comparison iso on **general** modules and would force reviving the abandoned general build?
2. **The IsInvertible vs IsLocallyTrivial carrier split.** The group law `picCommGroup` is carried on
   `IsInvertible` (`∃N, M⊗N≅𝒪`); the relative functor `OnProduct` is carried on `IsLocallyTrivial`. The
   bridge `IsInvertible ⟹ IsLocallyTrivial` (= locally-free-rank-1) is claimed Mathlib-scale but
   off-path. Is carrying two different invertibility notions across the A.1.c boundary a latent hazard —
   does any node need both directions of the bridge?
3. **Overall arc soundness.** Is `J := Pic⁰_{C/k}` via the FGA representability engine the right spine
   given the permanent Route-C (Riemann–Roch) pause? Is the A.2.c-engine (~3400–5500 LOC, Mathlib-absent)
   estimate realistic, or is there a cheaper RR-free route the strategy has missed?
4. **Albanese autoduality risk.** Route 2 (preferred) lands on `J` via autoduality `J^∨≅J`, flagged
   UNVERIFIED for RR-freeness, with Route 1 (Weil/rigidity, RR-free) as the named in-tree fallback. Is
   relying on an unverified autoduality as the *preferred* route a strategic error, or is the named
   fallback sufficient insurance?

Give a per-question verdict (SOUND / CHALLENGE / REJECT) with reasoning grounded in the references.
