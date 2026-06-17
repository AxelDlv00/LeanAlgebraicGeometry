# Blueprint Review Report

## Slug
iter010

## Iteration
010

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine`: no `\definition` block for a "standard affine cover" Lean type. The strategy decision to narrow `CechAcyclic.affine` from `X.OpenCover` to a standard-cover argument requires this type to be named in the blueprint (a `def:standard_affine_cover` with `\lean{}` hint); without it the prover has no target to change the signature to. Confirmed from Lean: `CechAcyclic.affine` is `theorem CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀]` — the `X.OpenCover` must be replaced, but the replacement type is nowhere named.

- `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf`: lemma statement omits the `[HasInjectiveResolutions X.Modules]` instance hypothesis. Since `higherDirectImage` requires this instance (per the NOTE in `def:higher_direct_image`), the lemma asserting `R^k f_* G` is the sheafification of `V ↦ H^k(f⁻¹(V), G)` is formally under-stated. The proof sketch also does not describe the from-scratch requirement: Mathlib's `rightDerived ↔ sheafified-presheaf` comparison exists only for `Sheaf J AddCommGrpCat`, not `X.Modules`; a prover reading only the blueprint would not know this is a from-scratch build.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: the proof is **circular**. The rewritten (iter-009) proof uses the acyclic-resolution route: form the augmented Čech complex (resolution by `lem:cech_augmented_resolution`), claim each term `C^p` is acyclic for `Γ(B, -)`, apply `lem:acyclic_resolution_computes_derived`. Term acyclicity requires `H^k(B, (j_σ)_*(F|_{U_σ})) = 0` for `k ≥ 1`. The proof asserts this follows from "standard-cover Čech vanishing only / no appeal to sheaf cohomology," but in fact it requires either (a) `R^k(j_σ)_* = 0` (which uses Serre vanishing) followed by `H^k(U_σ, F|_{U_σ}) = 0` (which IS Serre vanishing), or (b) the very lemma being proved applied to `U_σ`. Either path is circular: `lem:affine_serre_vanishing` depends on `lem:cech_to_cohomology_on_basis`, and the term-acyclicity step in the proof of `lem:cech_to_cohomology_on_basis` depends on `lem:affine_serre_vanishing`. The `\uses{}` declaration of the proof block (`lem:cech_acyclic_affine, lem:cech_augmented_resolution, lem:acyclic_resolution_computes_derived`) hides this: `lem:affine_serre_vanishing` is missing, and adding it would make the DAG cyclic (currently `leandag` shows no cycle only because the implicit dependency is absent from `\uses{}`).

  **Fix direction**: revert to the original Stacks proof strategy for `lemma-cech-vanish-basis` (Tag 01EO in `references/stacks-cohomology.tex`). That proof uses hypotheses (1)(2)(3) and an abstract filtered-colimit / comparison argument that does NOT need Serre vanishing for term acyclicity — the basis criterion is proved for the ringed-space case first, then `lem:affine_serre_vanishing` follows by supplying conditions (1)(2)(3) for affines. This is the correct dependency order; the acyclic-resolution route inverted it and created the cycle.

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: in addition to the circularity, the statement is the **general** Stacks 01EO basis criterion (arbitrary ringed space `X`, arbitrary basis `ℬ`, arbitrary admissible-cover set `Cov`) while the proof immediately specialises to `X` = scheme with affine basis and standard affine covers. The general claim is not established: the acyclic-resolution proof is valid only when the opens are affine (Serre vanishing) and the covers are standard (contracting homotopy). Statement should either be kept general with a correct non-circular general proof (original Stacks strategy), or narrowed to the affine/standard-cover instance while still fixing the circularity.

### Lean target quality

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` / `\lean{AlgebraicGeometry.CechAcyclic.affine}`: the named Lean declaration exists but with the **wrong signature** (takes `X.OpenCover`, not a standard-cover type). The strategy has decided to narrow the signature; the blueprint defines no Lean type for "standard affine cover," so the prover has no target type to replace `X.OpenCover` with. The `\lean{}` hint is misleading as-is — a prover finding the existing declaration would see the wrong signature and no guidance on what to change it to.

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` proof block: **missing `\uses{}`** — the proof implicitly depends on `lem:affine_serre_vanishing` (for term acyclicity), but `lem:affine_serre_vanishing` is absent from the `\uses{}` of the proof block. Adding it would expose the DAG cycle. Disposition: **fix-the-cycle** — the dependency should not be added; instead the proof must be rewritten so that `lem:affine_serre_vanishing` is NOT needed (see "Proofs lacking detail" above). The missing edge is a symptom of the circular proof, not an independent finding.

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` **statement** block `\uses{}`: includes `lem:acyclic_resolution_computes_derived` which is a proof tool, not a statement dependency. Disposition: **soon** — move to proof block only.

### Citation discipline

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: the `% SOURCE QUOTE PROOF:` block (lines 657–672 of the chapter file) is embedded **inside** the `\begin{lemma}…\end{lemma}` environment, not immediately before `\begin{proof}`. The citation discipline rule requires it to appear immediately before the proof environment. Must be moved.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: partial
- **correct**: partial
- **notes**:

  **P3 — `lem:cech_acyclic_affine`**
  - The proof sketch is mathematically complete: the prime-local contracting homotopy `h(s)_{i₀…iₚ} = s_{i_fix i₀…iₚ}` is explicitly spelled out with the computation `(dh + hd)(s) = s`, the localise-at-prime criterion is named, and the module structure of the Čech complex on `Spec(A)` is described. This sketch is adequate to guide the contracting-homotopy half of P3.
  - **Missing definition** (incomplete): the blueprint has no `\definition` block for a "standard affine cover" Lean type. The strategy decision (DECIDED in directive) requires narrowing `CechAcyclic.affine` from `X.OpenCover` to a standard-cover argument. Without a named, `\lean{}`-hinted definition for the standard-cover structure, the prover cannot determine what type to use in the new signature.
  - **Wrong `\lean{}` target** (must-fix): `\lean{AlgebraicGeometry.CechAcyclic.affine}` names a declaration with the wrong signature (`X.OpenCover`). The hint should note that the signature must be updated and what the expected new type is (once `def:standard_affine_cover` is added).

  **P5a — `lem:cech_to_cohomology_on_basis`**
  - **Statement↔proof mismatch** (must-fix): statement is the general Stacks 01EO ringed-space basis criterion; proof handles only the affine/standard-cover special case.
  - **Circular proof** (correctness hard-fail): the term-acyclicity step in the proof requires `H^k(B, (j_σ)_*(F|_{U_σ})) = 0`, which needs `lem:affine_serre_vanishing`; but `lem:affine_serre_vanishing` depends on this lemma. The proof claim "no appeal to sheaf cohomology" is false. Fix: restore the original Stacks proof strategy (abstract filtered-colimit comparison, no Serre vanishing needed).
  - **Missing `\uses{}` edge**: `lem:affine_serre_vanishing` implicit in the proof body but absent from `\uses{}`; cannot be added without creating a DAG cycle — the cycle must be broken by rewriting the proof.
  - **Citation structure violation**: `% SOURCE QUOTE PROOF:` block is inside `\begin{lemma}` instead of immediately before `\begin{proof}`.

  **P5a — `lem:higher_direct_image_presheaf`**
  - **Missing hypothesis** (must-fix): statement does not include `[HasInjectiveResolutions X.Modules]`. Since `higherDirectImage` requires this instance (`def:higher_direct_image` carries an explicit NOTE about it), the lemma is formally under-stated. A prover will need this hypothesis in the Lean signature.
  - **Lean obstacle unaddressed** (must-fix for prover guidance): the proof sketch describes a standard injective-resolution argument as if the relevant Mathlib infrastructure exists. It does not: the `rightDerived ↔ sheafified-presheaf-cohomology` comparison is available in Mathlib only for `Sheaf J AddCommGrpCat`, not for `X.Modules`. The proof sketch must warn that this is a **from-scratch build** for the `Scheme.Modules` category and describe the adapted strategy (inject into `AddCommGrpCat`-level Mathlib result via a suitable functor comparison, or build a parallel argument directly using `X.Modules` injective resolutions).

  **P5a — `lem:cech_augmented_resolution`**
  - Proof sketch is correct and adequate: localise to affine, the general cover restricts to a standard cover (all affine opens of `Spec(A)` are `D(f)`'s so the cover is standard), apply `lem:cech_acyclic_affine`. The `\uses{}` (`def:cech_nerve`, `lem:cech_acyclic_affine`) is accurate. Minor implicit step ("general affine cover → standard cover" on `Spec(A)") is standard and within prover scope.

  **P5a — `lem:affine_serre_vanishing`**
  - Proof (applying `lem:cech_to_cohomology_on_basis` with the affine basis + standard covers) is logically correct once `lem:cech_to_cohomology_on_basis` is fixed. The `\uses{}` (`lem:cech_acyclic_affine`, `lem:cech_to_cohomology_on_basis`) will be correct after the circular dependency is resolved.

  **P5a/P5b — `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology`**
  - All three proofs are logically correct and well-structured (Route A: acyclic-resolution route applied cleanly). `\uses{}` edges are accurate. No findings beyond the `lem:acyclic_resolution_computes_derived` in the statement `\uses{}` of `lem:open_immersion_pushforward_comp` noted under "Dependency & isolation findings."

  **File-split observation (informational)**
  - P3 acyclicity (`CechAcyclic.affine` + standard-cover type), P5a presheaf description (`higherDirectImage_isSheafify_presheafCohomology`), and the remaining P5a/P5b content are **mutually independent** at the Lean level. Splitting into `CechAcyclic.lean` (P3), `HigherDirectImagePresheaf.lean` (P5a leaf), and a trimmed `CechHigherDirectImage.lean` (P5a Čech-resolution + P5b assembly) would enable parallel prover work on P3 and the presheaf description. This would require updating `archon:covers` to three separate chapters. Flagged for plan-agent consideration; not a blueprint defect.

---

## Severity summary

### Must-fix-this-iter

1. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` — **circular proof** (term-acyclicity step requires `lem:affine_serre_vanishing`; that lemma depends on this one; adding the missing `\uses{}` edge would create a DAG cycle). Fix: rewrite proof using original Stacks `lemma-cech-vanish-basis` strategy (references/stacks-cohomology.tex, Tag 01EO) which requires only hypotheses (1)(2)(3) with no Serre vanishing for term acyclicity.

2. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` — **statement↔proof mismatch**: statement is general ringed-space basis criterion; proof handles only affine/standard-cover instance. Statement should be kept general (with a correct non-circular proof), or narrowed with the circularity simultaneously fixed.

3. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` — **missing `def:standard_affine_cover`** with `\lean{}` hint. P3 is ACTIVE; the prover cannot re-sign `CechAcyclic.affine` without knowing the standard-cover Lean type. Dispatch blueprint-writer to add this definition block.

4. `Cohomology_CechHigherDirectImage.tex` / `lem:higher_direct_image_presheaf` — **missing `[HasInjectiveResolutions X.Modules]`** hypothesis in statement; proof sketch must also explicitly note that the `rightDerived ↔ sheafification` comparison for `Scheme.Modules` is a from-scratch build (Mathlib's version is for `Sheaf J AddCommGrpCat` only).

5. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` — **citation discipline**: `% SOURCE QUOTE PROOF:` block embedded inside `\begin{lemma}` instead of immediately before `\begin{proof}`. Must be relocated.

All five findings land on the single chapter `Cohomology_CechHigherDirectImage.tex`. No prover may be dispatched to `CechHigherDirectImage.lean` this iter. Dispatch one blueprint-writer for `Cohomology_CechHigherDirectImage.tex` with directive covering items 1–5.

### Soon

6. `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` statement `\uses{}`: `lem:acyclic_resolution_computes_derived` is a proof dependency, not a statement dependency; move to proof block.

7. File-split for parallelism: once the blueprint is fixed and P3 work begins, splitting into `CechAcyclic.lean` + `HigherDirectImagePresheaf.lean` + trimmed `CechHigherDirectImage.lean` enables parallel prover work on P3 and the presheaf description. Plan agent should evaluate this split before the next prover dispatch.

---

**Overall verdict**: `Cohomology_CechHigherDirectImage.tex` fails the HARD GATE (`correct: partial` due to a circular proof in `lem:cech_to_cohomology_on_basis`, statement↔proof mismatch, missing standard-cover definition for P3, and missing hypothesis in `lem:higher_direct_image_presheaf`); 3 chapters audited, 5 must-fix findings, 0 unstarted-phase proposals, no broken `\uses{}` labels, no isolated blueprint nodes. Dispatch a blueprint-writer for `Cohomology_CechHigherDirectImage.tex` before any prover work on `CechHigherDirectImage.lean`.
