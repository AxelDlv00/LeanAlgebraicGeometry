# Blueprint Reviewer Directive

## Slug
iter108

## Strategy snapshot

This project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge file (`references/challenge.lean`).

The plan agent (this iter) is deciding the **Phase A escape-valve menu** following two consecutive PARTIAL prover iterations on `BasicOpenCech.lean h_loc_exact` at L1846 (Steps 1c–4 of an `IsLocalizedModule.Away f.1`-on-finite-product recipe). The two viable Phase A escape-valves are:

- (i) **Defer L1846 as the fourth named Mathlib gap** alongside `instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`. Mark with `-- MATHLIB GAP: IsLocalizedModule.Away f.1 on finite products of restricted basic-opens`. Single named sorry, no scope expansion.
- (ii) **Fire C1 promotion** (refactor `Picard/LineBundle.lean` body from `CommRing.Pic Γ(X, ⊤)` to `MonoidalCategory.Invertible (X.Modules)` — independently mandated by user iter-107 hint "no approximation accepted" + lean-auditor critical carryover).

The plan agent is leaning toward Option (i) (cheapest; Option (ii) lands eventually anyway on standard schedule). Either choice may dispatch a blueprint-writer if the chapter coverage is inadequate to the chosen path.

The remaining strategic phases (in expected order):
- **Phase A**: close out `BasicOpenCech.lean` (currently 6 sorries, of which L1120 is PAUSED-stuck and L1846 has just hit the escape-valve trigger).
- **Phase B**: `Differentials.lean` (5 sorries; non-`h_exact` sorries; `serre_duality_genus` flagged as variance-risk).
- **Phase C0–C2**: `Modules/Monoidal.lean` (deferred — Mathlib gap on stalk-of-tensor varying ring); **C1 LineBundle refactor**; C2 `PicardFunctor` re-derivation.
- **Phase C3 — DEFERRED**: `nonempty_jacobianWitness` exit policy (single named sorry; protected `Jacobian C` / `ofCurve` / instances compile against `Nonempty (JacobianWitness C)`).

The end-state is: **9 protected declarations** carry intended mathematical content modulo **4 named Mathlib-gap sorries** (`instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`, `PicardFunctor.representable`), plus possibly L1846 if Option (i) is chosen.

## Routes

Single route per phase (no multi-route forking this iter). The decision under audit is between two **escape-valves** for the L1846 stall, not between two routes.

## References

- `references/challenge.lean`: original challenge file by Christian Merten; the formal statement of missing definitions and theorems for the Jacobian. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file. Signatures are authoritative.

## Focus areas

- `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (the chapter pinning `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`): iter-107 lean-vs-blueprint-checker flagged a **soon → should-fix-soon** finding (minor severity) about Step 2 expansion of the chapter previewing the four Mathlib pieces (`Finset.inf'` image-bridge, `Scheme.basicOpen_res`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `IsLocalizedModule.pi`). The chapter currently sketches the strategic route but does not preview the Mathlib-API plumbing the prover needed at the `h_loc_exact` site. Confirm whether this is now must-fix (the prover did demonstrably progress despite the gap, but Steps 2–4 hit a structural blocker; if Option (i) defer-as-gap wins, Step 2 of the chapter prose should become a **labelled named-Mathlib-gap sub-block** explaining why L1846 is deferred to a future Mathlib upstream fix).
- `blueprint/src/chapters/Picard_LineBundle.tex`: lean-auditor-iter104/106/107 flagged the `LineBundle X := CommRing.Pic Γ(X, ⊤)` definition as **critical** (admitted-wrong on non-affine schemes per its own docstring; `ℙⁿ_k` Pic is `ℤ` but the approximation gives a strict subgroup). The chapter prose may need a pre-C1-promotion forward-compatibility note acknowledging the planned refactor (Picard_Functor.tex § "Forward-compatibility note" already has one; Modules_Monoidal.tex acknowledges; Picard_LineBundle.tex itself was flagged at iter-105 as missing this acknowledgement — confirm current state).

## Known issues (carryover; do not re-flag at must-fix severity)

- `Picard/LineBundle.lean` weakened-wrong definition (carried; resolution scheduled via C1 promotion either iter-109 escape-valve OR standard slot iter-111+).
- `Modules/Monoidal.lean instIsMonoidal_W` Mathlib upstream gap (off-limits, deferred indefinitely).
- `Differentials.lean cotangentExactSeq_structure.h_exact` Mathlib upstream gap (deferred parallel to `instIsMonoidal_W`).
- `Picard/Functor.lean PicardFunctor.representable` (gated on C3 / LineBundle C1).
- `Jacobian.lean nonempty_jacobianWitness` (Phase C3 exit policy — JacobianWitness pattern).
- `BasicOpenCech.lean L1120 cechCofaceMap_pi_smul` (PAUSED per progress-critic-iter106/107 STUCK).
- `Differentials.lean` header status block stale-by-50-iters (carried lean-auditor-iter107 major).
