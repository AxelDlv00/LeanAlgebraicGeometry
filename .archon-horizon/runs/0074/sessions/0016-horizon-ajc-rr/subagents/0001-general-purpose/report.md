You are auditing for a Lean 4 formalization task. READ-ONLY: do not edit any file.

Two Lean projects in /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/:
- AJC  = Algebraic-Jacobian-Challenge
- AJCR = Algebraic-Jacobian-Challenge-Rebuild

GOAL. AJC has `AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean` defining:

```
def UniformBaseDivisor (d : ℤ) : Prop :=
  ∀ (κ : Type u) [Field κ] [Algebra k κ], ... ∃ D₀ : (Scheme.baseChangeField C κ).left.CurveDivisor,
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D₀) 1)
        ∧ CurveDivisor.deg κ D₀ ≤ d
```

This is the single remaining open input ("input (2)") for extension-uniform H1 vanishing. The
plausible route is: take a divisor D₀ at the base field k with vanishing H1, PULL IT BACK to
C_κ, and show (a) its degree is unchanged, (b) its H1 still vanishes.

I need PRECISE MEASUREMENTS, with file:line for every claim. Report absence as clearly as presence.

QUESTION 1 — divisor pullback / base change of divisors.
In AJCR, find every declaration that transports a `CurveDivisor` (or Weil divisor) along a
base-field extension or along a scheme morphism, and every degree-invariance statement.
Start from these AJCR files under AlgebraicJacobian/RiemannRoch/:
  DegreeBaseChange.lean, DegreeBaseFieldInvariance.lean, DegreeIsoTransport.lean,
  DegreePullback.lean, DegreePullbackDictionary.lean, DegreePullbackFiber.lean
For each relevant declaration give: exact name, exact statement (full signature), file:line, and
whether it is sorry-free. CRITICALLY: say precisely which carrier the divisor lives on and what
the transport map is. Does AJCR have something of the form
  `deg K (pullback of D along C_K → C) = deg k D`?
If yes give it verbatim. If what exists is instead only about *classes* (picClass/classDeg)
rather than divisors, say so explicitly — that distinction matters.

QUESTION 2 — H1 base change for a NON-UNIT (divisor / twisted) sheaf.
AJC has `Ledger/GenusFieldInvariance.lean` proving `h1CokₗBaseChangeField`, a comparison
`κ ⊗[k] Ȟ¹(S, 𝒪) ≃ₗ[κ] Ȟ¹(S_κ, 𝒪_{C_κ})`, but ONLY for the unit module (`SheafOfModules.unit`).
In AJCR, find whether the analogous H1 base-change comparison exists for a general module /
divisor sheaf rather than just the structure sheaf. Look at
AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean and neighbours, and any
BasicOpenCocycleDatum base-change results (e.g. `datum_subsingleton_h1_baseChange`).
Report the exact generality: what is the module argument, is it arbitrary?

QUESTION 3 — is AJCR's engine importable into AJC at all?
AJC has ZERO occurrences of: thetaChartDatum, BasicOpenCocycleDatum, presentationDivisor,
relCurve, AffineTwoCover. Confirm this is right, and report roughly how large the AJCR
dependency cone of `WindowFieldTransport.deg_windowN` and of `datum_subsingleton_h1_baseChange`
is (how many AJCR files would have to come along). A rough but honest file count and the names
of the major missing abstractions is what I need — I am deciding port vs rederive.

QUESTION 4 — AJC's own n₀.
In AJC, trace `subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` (used by
`Ledger/FiberBound.exists_base_subsingleton_of_isFinite_toP1`). Where does its bound come from
(file:line), and is the natural number it produces an explicit formula or a
Classical.choose/Nat.find on a Noetherian stabilization? Quote the relevant code. I need to know
whether AJC's own n₀ could be given a κ-independent explicit value.

Be concise but exact. Structure your answer by question. Every claim needs file:line. If you
cannot determine something, say "UNMEASURED" rather than guessing. Do not speculate about what
"should" exist — report what IS there.
