# Recommendations — next plan iter (post iter-027)

## HIGH / must-fix

### 1. Add the `CechToCohomology` root import (planner-owned, mechanical)
`AlgebraicJacobian/Cohomology/CechToCohomology.lean` compiles standalone (`lake build … EXIT 0`) but is
**NOT imported into the build root** — `AlgebraicJacobian.lean` imports `AbsoluteCohomology` (line 9) but
not `CechToCohomology`. The umbrella build does not see L1/L2 until this is wired in. Same pattern as the
iter-026 `AbsoluteCohomology` orphan. Add `import AlgebraicJacobian.Cohomology.CechToCohomology` via a
`refactor` dispatch (review cannot edit the root).

### 2. Blueprint prose rewrite of L1/L2 to the cover-local form — HARD-GATE prerequisite
lvb `cechtocohom` raised **2 blueprint-side must-fix** (full detail:
`.archon/task_results/lean-vs-blueprint-checker-cechtocohom.md`). The landed Lean is COVER-LOCAL /
PRESHEAF-level; the chapter prose still describes cover-global `(B,Cov)` / sheaf-of-modules. I added
`% NOTE:` flags to both blocks, but the **prose itself** is the planner's blueprint-writer job:
- **`lem:cech_ses_of_basis` (L1)**: rewrite to `U : ι → Opens X`, `P : ShortComplex X.PresheafOfModules`,
  hypothesis `hface : ∀ p σ, (faceShortComplex U P σ).ShortExact ⊢ (sectionCechComplexShortComplex U P).ShortExact`.
  Add a remark that the `(B,Cov)` instantiation supplies `hface` via `ses_cech_h1`.
- **`lem:quotient_vanishing_cech` (L2)**: rewrite to take `hSES` (L1 output) + explicit `hI`/`hF` vanishing
  hyps in `cechCohomology` terms; note `hI` follows from `injective_cech_acyclic` at instantiation.
Because `Cohomology_CechHigherDirectImage.tex` is the consolidated chapter gating L3/L4, this must clear the
blueprint HARD GATE (writer → scoped blueprint-reviewer re-clear) **before** any L3/L4 prover lane.

### 3. Add blueprint blocks for two substantive helper theorems (major, same chapter)
- `shortExact_piMap` (public, AB4* content): add a `\begin{lemma}` "a product of short exact sequences in
  Ab is short exact", `\lean{AlgebraicGeometry.shortExact_piMap}`, with a proof note that `Epi (Pi.map φ)`
  is not a typeclass instance.
- `cechHomology_quotient_vanishing` (abstract homological L2 vehicle): add a `\begin{lemma}`,
  `\lean{AlgebraicGeometry.cechHomology_quotient_vanishing}`.

## MEDIUM

### 4. 1-to-1 coverage debt — 14 unmatched `lean_aux` helpers
`archon dag-query unmatched` = 14 (all this iter's helpers). Bundle into `\lean{}` lists or give thin
blocks. By file:
- **AbsoluteCohomology.lean** (4 private, bundle into `lem:absolute_cohomology_zero_natural` or a sub-block):
  `homEquiv₀_comp_mk₀`, `freeYonedaHomEquiv_naturality`, `sheafificationHomAddEquiv_naturality`,
  `jShriekOU_homEquiv_naturality`.
- **CechToCohomology.lean** (10): `sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`,
  `sectionCechComplexFunctor`, `sectionCechComplexMap`, `cechCohomology` (worth a `\begin{definition}`),
  `shortExact_piMap` (see #3), `faceShortComplex`, `sectionCechComplexShortComplex` (worth a definition),
  `cechHomology_quotient_vanishing` (see #3), `pi_π_map_apply` (private — bundle).

## Ready frontier (next prover lanes, once #1–#2 clear)

### 5. Per-face SES derivation — feeds L1's `hface` at instantiation
For a sheaf SES `S : ShortComplex X.Modules` with `S.ShortExact`, prove
`faceShortComplex (coverOpen 𝒰) (S.map toPresheafOfModules) σ` is `ShortExact`: mono + middle-exactness
from **left-exactness of sections** (`toPresheafOfModules` is a right adjoint ⇒ `PreservesFiniteLimits`;
eval-at-`op V` preserves limits), `Epi`/surjectivity from `ses_cech_h1`. The one remaining geometric input
for L1; independent of L3/L4.

### 6. L3 `absoluteCohomology_one_eq_zero_of_basis` — NOW UNBLOCKED
The Lane-1 naturality landing (`absoluteCohomologyZeroAddEquiv_naturality`) supplies the surjectivity
transfer L3 needs: since the iso is an `AddEquiv` with bottom arrow `g_U`, surjectivity of `g_U` ⇒
surjectivity of `H⁰(U,g)`. L3 then uses `absoluteCohomology_covariant_exact₁/₃`. Blueprint block
`lem:absolute_cohomology_one_vanishing` (line ~3296) is ready.

### 7. L4 + top — induction over `HasVanishingHigherCech`
After L3: induction using L2 (`quotient_cech_vanishing_of_basis`) for closure-under-quotient and L3 for the
base case. Keep the inductive predicate ABSTRACT (Q = I/F is not quasi-coherent — specializing to QCoh is
unsound, per the iter-027 plan D1). Heaviest remaining piece (effort ~1718); effort-break further if the
prover stalls on the `BasisCovSystem` closure step.

## Notes (LOW)
- lean-auditor minors (no action forced): `erw` at AbsoluteCohomology:47; aspirational forward-reference
  comment at AbsoluteCohomology:160; implicit `Mono` `inferInstance` in `shortExact_piMap`. Leave unless a
  prover reopens the file.
- The external-LLM informal helper still has no API key in env (provers use LSP search only). Optional;
  loop proceeds without it.

## Do NOT
- Do NOT send a prover at L1/L2 again — both are CLOSED axiom-clean. The remaining work is the per-face SES
  derivation (#5), L3 (#6), L4 (#7), plus the blueprint/import bookkeeping (#1–#4).
- Do NOT specialize the inductive vanishing predicate to QCoh.
