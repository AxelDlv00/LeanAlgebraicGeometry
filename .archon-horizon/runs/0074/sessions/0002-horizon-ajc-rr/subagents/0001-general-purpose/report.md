Posted. Here is the audit.

## Verdict: (a) near-mechanical port

Not (b). I did not find a single place where adaptation bites. I verified this by construction rather than by reading: I staged all 22 cone files under a scratch root `Ported.*`, rewrote only the `import` lines with `sed`, left every body **byte-identical**, and compiled them against AJC's dependency set. **22/22 compiled, zero edits.** Then the ported ledger connects to AJC's own objects:

```
chi_ledger_AJC_unconditional (C : Over (Spec (CommRingCat.of k)))
  [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] …
  (D : C.left.WeilDivisor) :
  Sheaf.chi (divisorSheaf k (toCurveDivisor C D))
    = Sheaf.chi (moduleKSheaf k) + CurveDivisor.deg k (toCurveDivisor C D)
#print axioms → [propext, Classical.choice, Quot.sound]
```

No finiteness hypothesis, on AJC's headline curve binders. Both projects are on toolchain v4.31.0, mathlib v4.31.0, and share `.lake-packages`, which is why this works.

## The three claimed obstacles, checked

**1. Carriers — same object, and AJC already owns the bridge.** AJCR's `Sheaf.HModule` is `Type u`, AJC's `Scheme.HModule` is `Type (u+1)`, and they are `Abelian.Ext` of the same pair (the constant sheaf objects are the same). The bridge is not `ULift` and not a restatement: `Abelian.Ext.chgUnivLinearEquiv` at `/home/axel/…/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCore.lean:102` is a **`k`-linear** equivalence `Ext.{w} X Y n ≃ₗ[R] Ext.{w'} X Y n`. Mathlib ships only the bare `Equiv` (`chgUniv`, `Ext/Basic.lean:542`); AJC upgraded it itself. Machine-checked consequences: both carriers coexist with no conflict, and `Module.finrank k` **agrees** across the bridge, so `h0`/`h1`/`chi` are literally the same numbers. Load-bearing test that passed: AJC's own H⁰ instance discharges the ported `Type u` ledger's H⁰ binder through it. `HasExt.{u}` fires by `inferInstance`. The 680 `HModule` use-sites need no rewiring.

**2. Structure sheaves are definitionally equal**, not merely isomorphic: `C.left.moduleKSheaf k = Scheme.toModuleKSheaf C` closes by `rfl`. AJCR's `overAlgebraMap` and AJC's `kToSection` are the same composite, and the two `Module` instances are `rfl`-equal. Nothing to build.

**3. Index sets — 12 lines, both directions already present.** `PrimeDivisor ≃ {x // x ≠ genericPoint}`: forward is `PrimeDivisor.point_ne_genericPoint` (`WeilDivisor.lean:130`), backward is `le_antisymm` of `Adelic.coheight_le_one_of_curve` (`Adelic/FiniteMapToP1.lean:275`, needing only `[SmoothOfRelativeDimension 1]`) and `one_le_coheight_of_ne_genericPoint` (`WeilDivisor.lean:149`). Import order is fine: `FiniteMapToP1`'s cone is 4 files / 1155 lines and does **not** contain `WeilDivisor`, so this is not the import inversion the file's own comment feared for the adelic endpoint.

**Degree weights** are as described: AJCR's `deg` weights by `residueDeg` (`Divisor.lean:61`), AJC's `degree` sums bare coefficients (`WeilDivisor.lean:1026`). They agree exactly when every residue degree is 1 — which AJC already has over `k̄`.

## Cost driver: there isn't one

All 22 files are self-contained. All four roots (`DedekindColength`, `AffineCech`, `ModuleKSheaf`, `DedekindSections`) import only `Mathlib` — no `Challenge.lean`, no AJCR instance packs. `OverOpen`/`AffineCech` pull in no wider framework; the dévissage core (`Devissage`/`DevissageExact`/`Skyscraper`/`JumpDimension`/`ChiFiniteness`) consumes only `mathlib`'s `skyscraperSheaf`, `ShortComplex.ShortExact`, and the sealed local-instance discipline (`overModule`, `functionFieldOverModule`) that travels with the files.

Beyond the 22: the layer making H¹ finiteness **unconditional** is +12 files / 3368 lines, and it also ports clean (12/12). Total 34 files / ~8859 lines, transcription-dominated. **1–2 sessions.**

## The finding worth more than the ledger

AJC's H¹ finiteness is **gated** — on affine Serre vanishing (`IsAffineHModuleVanishing`, `Carriers.lean:181`, whose `i ≥ 2` clauses are open) plus gate 4 `HasCechToHModuleIso`; `Adelic/CechAcyclicInstance.lean:174` is explicit that it becomes unconditional only when both discharge. AJCR's `moduleFinite_hModule_one` (`Cohomology/Finiteness.lean:388`) is **unconditional** on precisely `[IsProper] [SmoothOfRelativeDimension 1] [GeometricallyIrreducible]`, axiom-clean, and routes around the Čech-to-derived comparison entirely (finite map to ℙ¹ + a two-chart `h1Cok` equivalence). Porting this cone hands AJC a gate-4-free H¹.

## Recommendation: port. Do not rederive, do not state as an interface

AJC's `ClassInvariance.lean:44` and `SectionBounds.lean:74` each record "no code was ported; what is reused is the argument." That was right for the adelic incarnations, and it is wrong here — the substrate now compiles unchanged. Rederiving would reproduce ~8.9k lines of working, kernel-verified mathematics, and an interface would leave AJC's `principal_degree_zero` sorry (`WeilDivisor.lean:1325`) open while the theorem exists next door. Note the alternative is not merely slower: AJC's own adelic bump route is **refuted in-tree** (`ChiUnconditional.not_bump_of_notMem_left`).

## Verification and caveats

- AJCR builds: `lake build AlgebraicJacobian.RiemannRoch.ChiLedger` → "Build completed successfully (8579 jobs)", exit 0.
- Zero sorries across the 22-file cone by grep (the two grep hits are the words "admits"/"admit more" in docstrings), and kernel-confirmed: `chi_divisorSheaf`, `deg_divOf`, `chi_step` all report `[propext, Classical.choice, Quot.sound]`.
- **I was read-only**: no file in either project was created or modified; all staging was under `/tmp`, now cleaned up.
- Honest limits: I compiled against a scratch root, not into AJC's tree, so in-tree name collisions are unverified — though `overAlgebraMap`, `overModule`, `moduleKSheaf`, `constModuleSheaf`, `Sheaf.h0/h1`, `Scheme.ord` have **0** hits in AJC, so I expect none.
- Harness gotcha for whoever lands this: bare `lean` picks up the wrong toolchain, and without `-DmaxSynthPendingDepth=3` (both lakefiles set it) `Curve/P1.lean:166` fails with a bogus `IsScalarTower` mismatch. That cost me a false alarm; it is a flag artifact, not a port obstacle.
