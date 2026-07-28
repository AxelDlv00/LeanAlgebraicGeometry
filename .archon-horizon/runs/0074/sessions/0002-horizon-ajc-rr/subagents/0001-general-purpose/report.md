No builds pending — the work finished before your message arrived. Nothing was abandoned, and no project file was modified (all staging was under `/tmp`, cleaned up).

## (a) VERIFIED by reading code and by compiling

**1. The carrier question — RECONCILABLE, no ULift, and AJC already owns the bridge.** This is the decisive finding.

The two carriers are `Abelian.Ext` of the same pair at the same site, differing only in the universe parameter:
- AJCR: `Cohomology/ModuleKSheaf.lean:74`, `Type u`
- AJC: `Cohomology/StructureSheafModuleK/Carriers.lean:51`, `Type (u+1)`

The bridge is **`Abelian.Ext.chgUnivLinearEquiv`** at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:102` — AJC's own mathlib gap-fill, a **`k`-linear** equivalence `Ext.{w} X Y n ≃ₗ[R] Ext.{w'} X Y n`. Mathlib ships only the bare `Equiv` (`chgUniv`, `Ext/Basic.lean:542`); AJC upgraded it with `chgUniv_add` and `chgUniv_smul`. Verified by compilation:

- Both carriers coexist at the shared site with no conflict.
- `Module.finrank k` **agrees** across the bridge, so `h0`/`h1`/`chi` are literally the same numbers.
- The load-bearing direction works: AJC's own H⁰ instance (`module_finite_HModule_zero_of_isHModuleHomFinite_curve`) discharges the ported `Type u` ledger's H⁰ binder through it, with universes pinned as `chgUnivLinearEquiv.{u+1, u}`.
- `HasExt.{u}` fires by `inferInstance` (consistent with AJC's own `hasExt_moduleKSheaf`, `Adelic/CechComparisonGate.lean:130`).
- The 680 existing `HModule` use-sites need **no** rewiring — nothing is restated.

Also definitional, not merely isomorphic: `C.left.moduleKSheaf k = Scheme.toModuleKSheaf C` closes by `rfl`. AJCR's `overAlgebraMap` and AJC's `kToSection` are the same composite, and the two `Module` instances are `rfl`-equal.

**2. Verdict — (a) near-mechanical port.** I found zero places where adaptation bites, established by construction: I staged all 22 cone files under a scratch root, rewrote only `import` lines with `sed`, left every body **byte-identical**, and compiled against AJC's dependency set. **22/22 compiled, zero edits.** The ledger then closes on AJC's own binders:

```
chi_ledger_AJC_unconditional … [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] (D : C.left.WeilDivisor) :
  Sheaf.chi (divisorSheaf k …) = Sheaf.chi (moduleKSheaf k) + CurveDivisor.deg k …
#print axioms → [propext, Classical.choice, Quot.sound]
```

No finiteness hypothesis. There are no top-three obstacles to report — the three candidates all dissolved. The index-set bridge is 12 lines with both directions already in AJC (`WeilDivisor.lean:130` + `Adelic/FiniteMapToP1.lean:275`), and it is **not** an import inversion: `FiniteMapToP1`'s cone is 4 files / 1155 lines and excludes `WeilDivisor`. Degree weights differ as expected (AJCR weights by `residueDeg`, `Divisor.lean:61`; AJC sums bare coefficients, `WeilDivisor.lean:1026`), agreeing when every residue degree is 1, which AJC has over `k̄`.

**3. The 22-file cone is genuinely self-contained.** All four roots — `Algebra/DedekindColength`, `Cohomology/AffineCech`, `Cohomology/ModuleKSheaf`, `Curve/DedekindSections` — import only `Mathlib`. No `Challenge.lean`, no AJCR instance packs. `OverOpen`/`AffineCech` drag in nothing wider: `OverOpen` imports only `ModuleKSheaf`, and `AffineCech` only `Mathlib`. The dévissage core consumes only mathlib's `skyscraperSheaf` / `ShortComplex.ShortExact` plus the sealed local-instance discipline that travels with the files.

**Other verified facts:** AJCR builds green (`lake build …ChiLedger` → 8579 jobs, exit 0). Zero sorries in the cone by grep, kernel-confirmed for `chi_divisorSheaf`, `deg_divOf`, `chi_step`.

**The finding worth more than the ledger:** AJC's H¹ finiteness is *gated* on affine Serre vanishing (`Carriers.lean:181`, `i ≥ 2` open) plus gate-4 `HasCechToHModuleIso`. AJCR's `moduleFinite_hModule_one` (`Cohomology/Finiteness.lean:388`) is **unconditional** on exactly AJC's binders, axiom-clean, routing around Čech-to-derived entirely. That layer is +12 files / 3368 lines and also ports clean (12/12). Total 34 files / ~8859 lines.

## (b) Inferred but not verified

- **In-tree name collisions.** I compiled against a scratch root, not into AJC's tree. `overAlgebraMap`, `overModule`, `moduleKSheaf`, `constModuleSheaf`, `Sheaf.h0/h1`, `Scheme.ord` each have **0** hits in AJC, so I expect none — but "expect" is not "verified in-tree."
- **Effort estimate of 1–2 sessions.** Extrapolated from the fact that transcription dominates and adaptation is zero; not measured against an actual landing.

## (c) Never got to

- Landing the port in AJC's tree, or wiring it to close `principal_degree_zero` (`WeilDivisor.lean:1325`). The degree-weight reconciliation there needs AJC's `residueDeg_eq_one_of_isAlgClosed_curve`, which I read but did not compile into the bridge.
- The `i ≥ 2` clauses of AJC's affine-vanishing gate.
- Whether AJCR's `AffineVanishing.lean` could *replace* AJC's gate rather than sit beside it.

## Recommendation

**Port.** Do not rederive, do not state as a hypothesis-free interface. AJC's `ClassInvariance.lean:44` and `SectionBounds.lean:74` chose "reuse the argument, not the code" — right for the adelic forms, wrong here now that the substrate compiles unchanged. Note the alternative is not merely slower: AJC's adelic bump route is refuted in-tree (`ChiUnconditional.not_bump_of_notMem_left`).

One gotcha for whoever lands it: bare `lean` grabs the wrong toolchain, and without `-DmaxSynthPendingDepth=3` (both lakefiles set it) `Curve/P1.lean:166` fails with a bogus `IsScalarTower` mismatch. That cost me a false alarm; it is a flag artifact, not a port obstacle.

Findings are posted to cross-project thread I-0495.
