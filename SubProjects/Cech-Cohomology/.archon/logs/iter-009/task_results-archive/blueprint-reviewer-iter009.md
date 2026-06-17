# Blueprint Review Report

## Slug
iter009

## Iteration
009

## Top-level summaries

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: proof invokes a "Čech-to-derived-functor spectral sequence" (absent from Mathlib) to collapse the comparison; the Route-A rewrite strategy is identified in the findings section and is feasible from Stacks 01EO, but the current sketch cannot be handed to a prover.
- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp` part (2): proof invokes the "relative Leray spectral sequence" (absent from Mathlib) for the degeneration; a Route-A proof via the P4 acyclic-resolution theorem exists and is described below.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_term_pushforward_acyclic` proof prose: the sentence "consequently the Grothendieck composition spectral sequence for `f ∘ j_s` degenerates" contradicts Route A; the `\uses{lem:open_immersion_pushforward_comp}` edge is already in place, but the prose must be rewritten to cite that lemma instead.

### Multi-route coverage

- **Route A (acyclic-resolution / Cartan–Leray) — PARTIAL.** The `AcyclicResolution.tex` P4 backbone is complete + correct. In `CechHigherDirectImage.tex`: definitions, push-pull functor laws, `lem:cech_acyclic_affine`, `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`, and `lem:cech_computes_cohomology` are Route-A-clean. Three blocks are contaminated (see "Proofs lacking detail" above).
- **Route B (spectral sequences) — correctly absent.** STRATEGY.md marks Route B rejected; no blueprint coverage required.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE CLEARS for the two remaining P4 frontier leaves. Both `lem:acyclic_one_iso_coker` and `lem:acyclic_resolution_computes_derived` carry complete, sourced proof sketches adequate for direct formalization — see detailed verdict below.
  - 9 blueprint nodes have matching Lean declarations but lack `\leanok` (leandag "needs_leanok: 9"). These include `lem:horseshoe_twist`, `lem:horseshoe_chainMap`, `lem:horseshoe_resolvesMiddle`, `def:push_pull_functor`-group and related CechHigherDirectImage nodes. This is a `sync_leanok` artefact, not a blueprint defect; the deterministic sync phase will resolve it.
  - All 6 `\mathlibok` anchors were verified in iter-007 gate review and remain correct. Zero `unknown_uses` (broken `\uses{}` edges). Zero isolated blueprint nodes.

#### HARD GATE detail — `lem:acyclic_one_iso_coker`

The statement `(R¹G)(A) ≅ coker(G(J)→G(Z))` for the short exact sequence `0→A→J→Z→0` with `J` right-`G`-acyclic is precisely and completely stated. The proof sketch reads off the low-degree segment `G(J)→G(Z)→(R¹G)(A)→(R¹G)(J)=0` of the long exact sequence produced by the horseshoe lift (`lem:injective_resolution_of_ses`) applied to the given SES, using `lem:homology_long_exact_sequence` to get the LES, `lem:right_derived_injective_resolution` to identify cohomology with derived functors, and acyclicity of `J` (`def:right_acyclic`) to kill the `(R¹G)(J)` term. The argument concludes that `δ⁰` factors through an isomorphism onto `coker`. This is a 5-line algebraic argument with every step named; a prover can formalize it directly. `\uses{}` is complete: `def:right_acyclic, lem:right_derived_zero_iso_self, lem:right_derived_injective_resolution, lem:homology_long_exact_sequence, lem:injective_resolution_of_ses`. Source: Stacks 015D — `% SOURCE:` with `(read from references/homological-acyclic-derived.tex)` ✓, `% SOURCE QUOTE:` ✓, `% SOURCE QUOTE PROOF:` ✓, visible `\textit{Source:...}` ✓.

#### HARD GATE detail — `lem:acyclic_resolution_computes_derived` (TARGET 3)

The statement `(RⁿG)(A) ≅ Hⁿ(G(J•))` for all `n ∈ ℕ` under a `G`-acyclic resolution is complete and unambiguous. The proof sketch is fully decomposed:

- Degree 0: `H⁰(G(J•)) ≅ G(A)` via `lem:cohomology_of_applied_resolution`, transported to `(R⁰G)(A)` via `lem:right_derived_zero_iso_self`.
- Positive degrees: iterate `lem:acyclic_dimension_shift` down the cosyzygy staircase `(RⁿG)(A) ≅ (R^{n-1}G)(Z¹) ≅ … ≅ (R¹G)(Z^{n-1})`, apply `lem:acyclic_one_iso_coker` to `(S_{n-1})`, then `lem:cohomology_of_applied_resolution` to identify the resulting cokernel with `Hⁿ(G(J•))`.
- The final reconciliation with injective resolutions is noted (injectives are acyclic by `lem:right_derived_vanishes_injective`).

Every lemma reference in the proof is a named, already-proved declaration. The staircase direction and terminus are stated precisely; a prover faces no guesswork. `\uses{}` complete: `def:right_acyclic, lem:cosyzygy_ses, lem:cohomology_of_applied_resolution, lem:acyclic_dimension_shift, lem:acyclic_one_iso_coker, lem:right_derived_zero_iso_self, lem:right_derived_vanishes_injective`. Two source quotes and one proof quote from Stacks 015E + 05TA are present verbatim ✓.

---

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: partial
- **notes**:

#### Route-A contamination — per-lemma verdict

**`lem:cech_to_cohomology_on_basis` — CONTAMINATED.**
The proof states: "the Čech-to-derived-functor spectral sequence for a cover `𝒰` of `B ∈ ℬ` has its higher rows killed by hypothesis (3) … so it collapses and the edge map … is an isomorphism." This invokes the Čech-to-derived spectral sequence, which is absent from Mathlib. The proof also contains the self-aware remark "The general basis-comparison criterion for sheaves of modules on a scheme is not yet available in Mathlib and is recorded here as a to-build dependency," confirming the present sketch is not prover-ready.

**Route-A rewrite feasibility**: Feasible via the acyclic-resolution / Mayer-Vietoris approach. The application of this lemma is always in the special case `ℬ` = affine opens of `U = Spec A`, `Cov` = standard covers of affine opens. In that case the Route-A argument is:

1. For an admissible standard cover `𝒰` of an affine `B ∈ ℬ`, the augmented Čech complex `0→F→C•` is exact by `lem:cech_augmented_resolution` (the same contracting-homotopy argument).
2. Each Čech term `Cᵖ = ∏ (jₛ)_*F|_{Uₛ}` (with `Uₛ` affine open) is acyclic for `Γ(B, -)`: for each affine `Uₛ`, the sheaf `(jₛ)_*F|_{Uₛ}` on `B` has `Hᵏ(B, (jₛ)_*F|_{Uₛ}) = Hᵏ(Uₛ, F|_{Uₛ}) = 0` for `k ≥ 1` — the first equality by the Leray/presheaf description (or, directly from the fact that `jₛ` is an open immersion and global sections factor), and the second by `lem:cech_acyclic_affine` applied to a standard cover of `Uₛ` (or directly by the same contracting homotopy at the module level). (Note: the second equality requires an inductive or alternative argument to avoid circularity — see below.)
3. By `lem:acyclic_resolution_computes_derived` applied with `G = Γ(B, -)`, `Hᵏ(B, F) ≅ Hᵏ(G(C•)) = Čech H^k = 0`.

The circularity concern (step 2 uses Serre vanishing on affines, which is what we want to prove) is resolved as follows: `lem:cech_acyclic_affine` gives `Čech-H^k = 0` for standard covers — this is purely an algebraic statement about complexes of localisations proved by a contracting homotopy. The transfer from Čech vanishing to sheaf-cohomology vanishing is exactly what `lem:cech_to_cohomology_on_basis` establishes. The argument becomes non-circular when written as: for `B = Spec A` with a STANDARD cover, apply `lem:acyclic_resolution_computes_derived` with `G = Γ(B, -)` directly to the augmented Čech complex of that standard cover, where acyclicity of each term is established by the SAME contracting homotopy argument (the prime-local homotopy of `lem:cech_acyclic_affine` proves `Γ(B, Cᵖ) → Γ(B, Cᵖ⁺¹)` is exact without any sheaf cohomology input). This bypasses the spectral sequence and uses only `lem:cech_acyclic_affine` + `lem:acyclic_resolution_computes_derived`. References needed: `references/stacks-cohomology.tex` (01EO, line 1696) for the statement, `references/stacks-coherent.tex` for the application context.

**`lem:open_immersion_pushforward_comp` — CONTAMINATED in part (2).**
Part (1) — `R^q j_*H = 0` for `q ≥ 1` — is Route-A-clean: uses `lem:higher_direct_image_presheaf` + `lem:affine_serre_vanishing` applied to affine `j^{-1}(V)`.
Part (2) — `R^k f_*(j_*H) ≅ R^k g_*H` — invokes the relative Leray spectral sequence (absent from Mathlib).

**Route-A rewrite feasibility**: Feasible using the P4 acyclic-resolution theorem:

1. Choose an injective resolution `H → I•` of `H` in `U.Modules`.
2. Apply `j_*` degreewise: `j_*H → j_*I•`.
3. Claim: each `j_*Iⁿ` is `f_*`-acyclic. Proof of claim: `R^k f_*(j_*Iⁿ)` is the sheafification of `V ↦ H^k(f⁻¹(V), j_*Iⁿ|_{f⁻¹(V)}) = H^k(U ∩ f⁻¹(V), Iⁿ|_{U∩f⁻¹(V)})`. For affine `V ⊆ S`, `U ∩ f⁻¹(V)` is affine (since `j` is affine over `X` separated and `f⁻¹(V)` is quasi-compact). By `lem:affine_serre_vanishing`, `H^k(affine, quasi-coherent) = 0` for `k ≥ 1`; since `Iⁿ|_{U∩f⁻¹(V)}` is quasi-coherent, the claim holds.
4. By `lem:acyclic_resolution_computes_derived` applied with `G = f_*`, `R^k f_*(j_*H) ≅ H^k(f_*(j_*I•)) = H^k((f ∘ j)_*I•) = R^k g_*(H)`.

`\uses` for rewritten part (2): `lem:affine_serre_vanishing, lem:acyclic_resolution_computes_derived`. References: `references/stacks-coherent.tex` (`lemma-relative-affine-vanishing`, affine morphisms → `R^q = 0`).

**`lem:cech_term_pushforward_acyclic` — CONTAMINATED in proof prose only.**
The `\uses{}` already lists `lem:open_immersion_pushforward_comp` and the argument is otherwise sound. The offending sentence is: "consequently the Grothendieck composition spectral sequence for `f ∘ j_s` degenerates and `R^k f_*((j_s)_*F|_{U_s}) = R^k(g_s)_*F|_{U_s}`." Once `lem:open_immersion_pushforward_comp` is rewritten, this sentence should be replaced with: "By `lem:open_immersion_pushforward_comp` part (2), `R^k f_*((j_s)_*F|_{U_s}) ≅ R^k(g_s)_*F|_{U_s}`." No other changes are needed.

#### Route-A-clean blocks (confirmed)

All of the following are Route-A-clean and require no changes:
- `def:cech_nerve`, `def:cech_complex`, `def:cover_arrow`, `def:cover_cech_nerve`, `def:push_pull_obj`, `def:push_pull_map`, `def:push_pull_functor`, `def:cech_nerve_cosimplicial`, `def:relative_cech_complex_of_nerve`
- `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`
- `lem:cech_acyclic_affine` (contracting homotopy, no spectral sequences)
- `lem:cech_augmented_resolution` (local exactness from `lem:cech_acyclic_affine`, no spectral sequences)
- `lem:higher_direct_image_presheaf` (presheaf description via injective resolution, no spectral sequences)
- `lem:cech_computes_cohomology` (Route-A proof explicitly assembled: cites `lem:cech_augmented_resolution` + `lem:cech_term_pushforward_acyclic` + `lem:acyclic_resolution_computes_derived`, no spectral sequences in the main proof)

#### Citation discipline

All blocks: `% SOURCE:` with `(read from references/<file>)` present and the named files exist on disk; `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:` present where required; visible `\textit{Source:...}` present. Push-pull functor lemmas (`lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`) carry no `% SOURCE:` annotation, which is correct — these are Archon-original coherence calculations with no external source. The `lem:open_immersion_pushforward_comp` `% SOURCE:` cites both `references/stacks-coherent.tex` and `references/stacks-cohomology.tex`; both exist. No citation-discipline findings.

#### Dependency graph

`unknown_uses: []` — zero broken `\uses{}` edges across the chapter. All inter-chapter references (`def:higher_direct_image` from `HigherDirectImage.tex`, `lem:acyclic_resolution_computes_derived` from `AcyclicResolution.tex`) resolve correctly.

---

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

**Status: live thin pointer.** The sole declaration `def:higher_direct_image` (`\leanok`, sourced from Stacks Cohomology of Schemes) is the target that `lem:cech_computes_cohomology` (the project goal) compares against. It is used in the cone by `lem:higher_direct_image_presheaf` and `lem:cech_computes_cohomology` via `\uses{def:higher_direct_image}`. Not orphaned. The `% NOTE` annotation on the `[HasInjectiveResolutions X.Modules]` instance hypothesis is informative and correct. **keep.**

---

## Severity summary

### must-fix-this-iter

1. **`Cohomology_CechHigherDirectImage.tex` — `correct: partial`** — three Route-A-contaminated proof blocks block the entire P5a/P5b prover cone:
   - `lem:cech_to_cohomology_on_basis` proof (Čech-to-derived SS) — must be rewritten to the direct acyclic-resolution argument (Stacks 01EO basis + contracting homotopy, using `lem:cech_acyclic_affine` + `lem:acyclic_resolution_computes_derived`).
   - `lem:open_immersion_pushforward_comp` proof part (2) (relative Leray SS) — must be rewritten to the injective-resolution / `f_*`-acyclicity argument using `lem:affine_serre_vanishing` + `lem:acyclic_resolution_computes_derived`.
   - `lem:cech_term_pushforward_acyclic` proof prose (Grothendieck composition SS sentence) — must replace the spectral-sequence sentence with a citation of the corrected `lem:open_immersion_pushforward_comp`.

   **Action**: dispatch blueprint-writer for `Cohomology_CechHigherDirectImage.tex` with directive targeting these three proof sketches, using `references/stacks-cohomology.tex` (01EO, line 1696) and `references/stacks-coherent.tex` (`lemma-relative-affine-vanishing`). Route-A rewrites for all three are feasible from existing references (see detailed analysis above).

### informational

- 9 blueprint nodes have matching Lean declarations but lack `\leanok` ("needs_leanok: 9" in leandag). The deterministic `sync_leanok` phase handles this; no writer action required.
- 2 blueprint nodes have sorry in their Lean declarations ("with_sorry: 2"). These correspond to the 2 frontier leaves in P4 (`lem:acyclic_one_iso_coker`, `lem:acyclic_resolution_computes_derived`), which are the active prover objective this iter — expected.

---

Overall verdict: **`Cohomology_AcyclicResolution.tex` HARD GATE CLEARS** for both remaining P4 frontier leaves — adequate, sourced, directly formalizable proof sketches confirmed; `Cohomology_CechHigherDirectImage.tex` is `partial/partial` — 3 spectral-sequence-contaminated proof blocks require blueprint-writer dispatch with Route-A rewrites before any P5a/P5b prover lane opens; `Cohomology_HigherDirectImage.tex` complete + correct; 0 unstarted-phase proposals (all phases have existing blueprint coverage); 3 chapters audited, 3 must-fix findings (all on the same chapter), 0 unstarted-phase proposals.
