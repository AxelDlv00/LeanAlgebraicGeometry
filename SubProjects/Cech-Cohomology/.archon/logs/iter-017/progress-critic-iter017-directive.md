# Progress-critic directive — iter-017 convergence audit

Assess whether each active route is converging or churning. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE if not converging.

## Route P3 — `CechAcyclic.lean`, target sorry `CechAcyclic.affine` (`lem:cech_acyclic_affine`)
- Phase P3 entered ACTIVE ~iter-011 (file split). Strategy estimate: ~3–5 iters left.
- Signals (sorry count for `CechAcyclic.affine` / helpers added / status / blocker phrase):
  - iter-015: sorry 1→1; +9 axiom-clean helpers (`CombinatorialCech.*`, constant-coefficient L3:
    contracting homotopy `dh+hd=id`, `d²=0`, `combDifferential_exact : Function.Exact`); PARTIAL;
    blocker "L1 categorical→module bridge".
  - iter-016: sorry 1→1; +9 axiom-clean helpers (`CombinatorialCech.Dependent.*`, dependent-coefficient
    L3 port ending in `depDiff_exact : Function.Exact`); PARTIAL; blocker "L1 bridge (missing
    sheaf-section infrastructure)".
- Proposed iter-017: switch this lane to **mathlib-build** to construct the L1 bridge infrastructure
  bottom-up (section identification `Γ(D(s_σ), pushPullObj F) ≅ Away-localisation M_{s_σ}`;
  differential = localisation coboundary; `IsZero homology ↔ Function.Exact`). This is a DIFFERENT
  task from iters 015/016 (which built the L3 combinatorial cores, now both DONE); it is NOT a
  re-run of a prove-mode body fill on the same sorry.

## Route P3b-free — `FreePresheafComplex.lean`, target `cechFreeComplex_quasiIso`
- New file iter-016. Strategy estimate (P3b): ~6–9 iters left.
- Signals:
  - iter-016: sorry 0→0; +8 axiom-clean decls incl. the deliverable `cechFreePresheafComplex`
    (`def:cech_free_presheaf_complex`) via the simplicial route; PARTIAL; blocker "O_𝒰 augmentation
    object not yet defined (separate definitional construction)". Route VALIDATED (evaluation
    preserves homology ⇒ objectwise homotopy route feasible).
- Proposed iter-017: **mathlib-build** `cechFreeComplex_quasiIso` (define `O_𝒰` + augmentation map +
  prepend-`i_fix` contracting homotopy ⇒ `HomotopyEquiv.toQuasiIso`). First data point on this node.

## Route P3b-bridge — `CechBridge.lean` (NEW iter-017), target `cechComplex_hom_identification`
- New file scaffolded iter-017 (downstream of section + free complexes).
- Signals:
  - iter-016 (attempted in `PresheafCech.lean`): sorry 0→0; NOT added; blocker "cross-file dependency
    `cechFreePresheafComplex` not importable from PresheafCech" — a STRUCTURAL file-placement issue,
    now resolved by moving the decl to the new downstream file. Recipe is ready
    (`freeYonedaHomAddEquiv` per-degree + biproduct-hom + `isoOfComponents`).
- Proposed iter-017: **mathlib-build** `cechComplex_hom_identification` in the new file.

## This iter's proposed `## Current Objectives` (3 files, one prover each)
1. `AlgebraicJacobian/Cohomology/CechAcyclic.lean` — L1 bridge [mathlib-build]
2. `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` — `cechFreeComplex_quasiIso` [mathlib-build]
3. `AlgebraicJacobian/Cohomology/CechBridge.lean` (new) — `cechComplex_hom_identification` [mathlib-build]

## Question for you
For each route: is it converging, or churning (helpers accumulate but the residual never shrinks)?
In particular for P3: the sorry has been 1→1 for two iters while 18 helpers were added — is this
churn, or legitimate bottom-up infrastructure building toward a sharply-isolated final assembly?
Name the corrective TYPE for any non-CONVERGING verdict.
