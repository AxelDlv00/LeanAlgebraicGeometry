You are a read-only survey worker for prover lane `ajc-p3`. Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (Lean 4, mathlib v4.31). DO NOT EDIT ANY FILE. Cite file:line for every claim. Be skeptical: a prior audit refuted 99 of 101 sampled claims in this workspace, and prescriptions in this workspace have repeatedly turned out to be already-paid.

GOAL. I must decide whether to claim milestone "P5 — uniform H1 vanishing" (roadmap `AJC.rr.extuniform`). The target statement, per `informal/pic-representability-campaign.md:254-256`:

  (i) ∃ b, ∀ field extensions κ/k, ∀ M invertible on C_κ, b ≤ deg M → h1 κ M = 0 ∧ GloballyGenerated M
  Intended route: i(D)-monotonicity + one Serre-type vanishing h¹(C, O(n₀·x₀)) = 0 over k + flat base change of the bound + h⁰(M(−n₀x₀)) ≥ 1 ⟹ b := n₀ + g uniformly.
  Intended new file: `RiemannRoch/UniformVanishing.lean`; gate class `HasH1VanishingBound C b`.

WHAT I NEED — answer each numbered question with verbatim Lean statements and file:line.

1. DOES IT ALREADY EXIST, in whole or in part? Search hard, do not grep-only. Use `/home/axel/.archon-env/bin/horizon search "<words>" --json` (spans both workspace projects AND mathlib) with several phrasings: "uniform H1 vanishing bound degree", "h1 vanishes for large degree", "extension uniform vanishing", "globally generated large degree line bundle", "HasH1VanishingBound". Then read these files, which the reviewer says hold the substrate — for EACH, list the main theorems with FULL statements (binders + conclusion) and say what it actually gives:
   - `AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean`
   - `AlgebraicJacobian/RiemannRoch/Ledger/VanishingFieldDescent.lean`
   - `AlgebraicJacobian/RiemannRoch/Ledger/DegreeVanishing.lean`
   - `AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean`
   - `AlgebraicJacobian/RiemannRoch/Adelic/UniformChartVanishing.lean`
   - `AlgebraicJacobian/RiemannRoch/Adelic/GlobalGeneration.lean`
   - `AlgebraicJacobian/RiemannRoch/Ledger/UniformRiemannRoch.lean`
   - `AlgebraicJacobian/RiemannRoch/Ledger/FiberVanishing.lean`, `Ledger/JumpDimension.lean`, `Ledger/SectionDrop.lean`
   The single most important question: is there ALREADY a theorem of the shape "∃ b, ∀ (degree ≥ b) → h1 = 0", and if so, over what — one fixed field, or all extensions κ/k? Quote it.

2. THE HYPOTHESIS TRAP. The roadmap warns much of the `AJC.rr` lane is conditional IN THE STATEMENT on a "closed χ-ledger" or a "peel datum" or `HasFiniteMapToP1`. For every candidate theorem you find in (1), enumerate EVERY hypothesis and classify each: (a) discharged by a global instance — name it; (b) discharged by a theorem — name it; (c) a class/structure with NO producer anywhere in the project — say so plainly. In particular chase: any `ChiLedger`/`HasChiLedger`-like class, any peel/`Peel` datum, `HasFiniteMapToP1`, `HasRationalPoint`, and any two-chart or `TwoCover` hypothesis. I have a standing memory that this lane's two-chart adelic Riemann–Roch count "cannot be repaired by weakening hypotheses" (inbox I-0548) and that `hbump`/closed-ledger claims are FALSE on a two-chart cover with a prime off a chart (I-0480) — read those two inbox items (`/home/axel/.archon-env/bin/horizon inbox show I-0548 --json`, `... I-0480 --json`) and tell me whether they poison the P5 route.

3. THE THREE INGREDIENTS, priced individually. For each, say EXISTS-SORRY-FREE (cite), EXISTS-BUT-GATED (cite the gate and whether it is inhabited), or ABSENT:
   (a) A single Serre-type vanishing over the base field: h¹(C, O(n₀·x₀)) = 0 for some n₀. Does anything in the project prove "there exists a divisor / an n with h1 = 0"? Note this needs a rational point x₀ — is there a version using an arbitrary closed point or an effective divisor instead?
   (b) FLAT BASE CHANGE of h1-vanishing along a field extension κ/k: h1 over k = 0 ⟹ h1 over κ = 0, or the finrank equality. Check `VanishingFieldDescent.lean`, `Ledger/SectionsFieldBaseChange.lean`, `Ledger/GenusFieldInvariance.lean`, `RiemannRoch/CurveBaseChange.lean`.
   (c) MONOTONICITY: h1(M) = 0 and deg M' ≥ deg M ⟹ h1(M') = 0, or the i(D)-monotonicity form (index/speciality decreasing). Check `DegreeVanishing.lean`, `JumpDimension.lean`, `SectionDrop.lean`.
   (d) GLOBAL GENERATION from h1(M(−x)) = 0 for all closed x. Check `Adelic/GlobalGeneration.lean`.

4. WHAT IS THE H1 CARRIER? Name the exact Lean function the project uses for "h1 of a line bundle / divisor on a curve over a field" (e.g. is it `Module.finrank` of some `H1Cok`, a Čech cokernel, `hOne`, `speciality`, `i D`?). Give its definition and file:line. Are there SEVERAL competing carriers (a Čech one, a ledger one, a sheaf-cohomology one), and is there a proved bridge between them? This is the crux of whether the ingredients compose — if (a) is stated for carrier X and (c) for carrier Y with no bridge, the route does not close.

5. Is `M invertible on C_κ` in the project's vocabulary a line bundle, a Weil divisor, or a Cartier divisor? Which does the substrate speak? Is there a proved surjection "every invertible sheaf of degree d comes from a divisor of degree d" (needed to feed divisor-indexed lemmas from a bundle-indexed statement)?

6. FINALLY, YOUR VERDICT: is P5 (a) essentially already proved and needing only assembly + restatement — in which case give me the exact chain of existing lemmas that composes; (b) one genuine missing brick away — name the brick and its statement; or (c) genuinely XL with several bricks missing — list them. Estimate honestly.

Be exhaustive on 1-4, terse in style. Every claim needs a citation.
