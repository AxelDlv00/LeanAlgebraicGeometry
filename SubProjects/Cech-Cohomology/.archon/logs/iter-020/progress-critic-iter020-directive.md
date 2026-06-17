# Progress-critic directive — iter-020

Assess convergence per active route. Signals are extracted below; do not read PROGRESS.md/STRATEGY.md.

## Route 1 — P3 L1 section-form vanishing — `CechAcyclic.lean`
Strategy: phase entered ~iter-015; STRATEGY `Iters left` ~4–6.
- iter-015: +9 helpers (L3 contracting homotopy); target sorry 1→1; status COMPLETE(infra).
- iter-016: +9 helpers (dependent-coeff L3 port, `depDiff_exact`); sorry 1→1; COMPLETE(infra).
- iter-018: +22 helpers (away-localisation comparison algebra + localised Čech maps, `cechLocalized_exact`); sorry 1→1; named target NOT landed; COMPLETE(infra).
- iter-019: +24 helpers; **LANDED named sub-target `dDiff_exact`** (step (a): positive-degree exactness of un-localised section module complex `D•`, incl. keystone `comparison_isLocalizedModule`); sorry 1→1; COMPLETE.
- Recurring phrase: "hardest L1 sub-task"; iter-019 closed the localisation-transitivity keystone the prior 2 iters flagged as highest-risk. Remaining: steps (b)–(d) sheaf-section bookkeeping.

## Route 2 — P3b free-complex resolution — `FreePresheafComplex.lean`
Strategy: phase entered ~iter-016; STRATEGY `Iters left` ~4–7.
- iter-016: +8 (`cechFreePresheafComplex` built); named target `cechFreeComplex_quasiIso` NOT landed; COMPLETE(infra).
- iter-018: +3 (augmentation chain map `cechFreeComplexAug`); target rephrased to `QuasiIso (cechFreeComplexAug)`; NOT landed; COMPLETE(infra).
- iter-019: +3 (`quasiIso_of_evaluation` — objectwise reduction, step 1 of 3); target NOT landed; reduces target to a single per-`V` obligation; COMPLETE(infra).
- Recurring phrase: "per-`V` sectionwise contracting homotopy is the project's largest single combinatorial build (~20 decls)". Each iter built genuinely distinct, necessary infra (complex → augmentation → objectwise reduction), not repeated helper churn on the same goal.

## Route 3 — P3b bridge — `CechBridge.lean`
Strategy: phase entered ~iter-018; STRATEGY `Iters left` shared with Route 2.
- iter-018: +5 (cosimplicial `Hom(K_•,F)` core, per-degree iso, naturality); named target held operationally; COMPLETE(infra).
- iter-019: +2; **LANDED named target `cechComplex_hom_identification`**; sorry 0→0; COMPLETE. `injective_cech_acyclic` correctly held (needs Route-2 `cechFreeComplex_quasiIso`).

## This iter's proposed objectives (3 files)
1. `CechAcyclic.lean` — P3 L1 steps (b)–(d): `qcohSectionsAwayLocalized`, `sectionCech_homology_exact`, `sectionCech_affine_vanishing` (mathlib-build).
2. `FreePresheafComplex.lean` — `cechFreeComplex_quasiIso`, dispatched on effort-broken sub-lemmas (this plan phase decomposes it; blueprint Lean-pathway expansion + effort-break before dispatch).
3. `CechBridge.lean` — build the injective-acyclicity bridging infrastructure (contravariant additive `Hom(-,I)` on injective `I` sends the resolution quasi-iso to Hom-exactness), independent of `cechFreeComplex_quasiIso` existing; do NOT attempt `injective_cech_acyclic` itself yet.

## Question
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). In particular: is Route 2 CHURNING (named target unlanded 3 iters) or CONVERGING (distinct necessary infra each iter, now reduced to one per-`V` obligation)? Name the corrective TYPE for any CHURNING/STUCK.
