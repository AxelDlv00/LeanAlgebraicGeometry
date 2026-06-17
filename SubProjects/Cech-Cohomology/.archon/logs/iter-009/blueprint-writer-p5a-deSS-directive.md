# Blueprint Writer — de-spectral-sequence three proof blocks in Cohomology_CechHigherDirectImage.tex

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Strategy context (the slice that matters)
The project proves `lem:cech_computes_cohomology`
(`AlgebraicGeometry.cech_computes_higherDirectImage`) via **Route A** — the
acyclic-resolution / Cartan–Leray route, which uses the abstract theorem
`lem:acyclic_resolution_computes_derived` ("a `G`-acyclic resolution computes
`G.rightDerived`", now formalized in `AcyclicResolution.lean`) and contains **NO spectral
sequences**. Three proof blocks in this chapter currently still argue via spectral
sequences that are ABSENT from Mathlib, contradicting Route A. Your job is to rewrite
those three **proofs** (and only their `\uses{}` and prose) to Route-A arguments. The
Route-A rewrite for each is mathematically settled (traced independently by this iter's
strategy-critic and blueprint-reviewer); you are transcribing a known argument, not
inventing one.

## HARD constraints
- **Do NOT change any `\begin{lemma}…\end{lemma}` / `\begin{theorem}` STATEMENT.** Only
  rewrite the `\begin{proof}…\end{proof}` body, its `\uses{}`, and the in-statement
  `\uses{}` where a dependency changes. Statements and `\lean{}` pins are frozen.
- **Do NOT add or remove `\leanok` or `\mathlibok`** anywhere. Those markers are managed
  by other phases.
- **Do NOT touch** the Route-A-clean blocks (listed at the end as out-of-scope), the P4
  chapter, or any other file.
- **Citation discipline**: every rewritten proof that leans on a Stacks result must carry
  a `% SOURCE QUOTE PROOF:` (or `% SOURCE:` + `% SOURCE QUOTE:`) comment with the
  **verbatim** text copied from the local reference file, plus the `(read from
  references/<file>)` parenthetical. The reference files you will quote from are
  `references/stacks-cohomology.tex` and `references/stacks-coherent.tex` — open and read
  the cited line ranges before quoting. If you need a Stacks tag NOT present in those
  files, you are authorized to spawn a `reference-retriever` (your `--write-domain`
  includes `references/**`); wait for it, read the fetched file, then quote.

## The three rewrites

### (1) `lem:cech_to_cohomology_on_basis` — replace the Čech-to-derived spectral sequence
**Current proof** invokes "the Čech-to-derived-functor spectral sequence … collapses … edge
map is an isomorphism" and self-flags as a to-build dependency. Replace with the
**reduced-scope direct argument** (the project only ever applies this lemma to affine opens
`B = Spec A` with STANDARD covers — do NOT formalize the general Stacks-01EO bootstrap):

For an affine `B` and a standard (admissible, cofinal) affine cover `𝒰` of `B`:
1. The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` of `𝒰` is exact (a resolution of `F`),
   by `lem:cech_augmented_resolution` (same prime-local contracting-homotopy argument as
   `lem:cech_acyclic_affine`).
2. Each Čech term `Cᵖ = ∏_σ (j_σ)_* (F|_{U_σ})` over `(p+1)`-fold intersections is acyclic
   for the global-sections functor `G = Γ(B,-)`: the higher cohomology of each
   `(j_σ)_*(F|_{U_σ})` on the affine `B` vanishes because the relevant module-level Čech
   complex is exact in positive degrees by the SAME contracting homotopy
   (`lem:cech_acyclic_affine` for a standard cover of the affine `U_σ`); there is NO
   sheaf-cohomology / spectral-sequence input.
3. Apply the acyclic-resolution comparison `lem:acyclic_resolution_computes_derived` with
   `G = Γ(B,-)`: `Hᵏ(B, F) ≅ Hᵏ(G(C⁰→C¹→⋯)) = Čech-Hᵏ(𝒰, F) = 0` for `k ≥ 1`.

So the spectral sequence is replaced by ONE application of the P4 theorem to the augmented
Čech complex. Set the proof's `\uses{}` to
`\uses{lem:cech_acyclic_affine, lem:cech_augmented_resolution, lem:acyclic_resolution_computes_derived}`
(keep any genuinely-still-used existing refs; drop the spectral-sequence-only ones).
**Source**: Stacks Project, Cohomology, Tag 01EO (`lemma-cech-vanish-basis`), statement at
`references/stacks-cohomology.tex` line 1696; if you want a verbatim proof quote, the
SS-free embed-into-injective + dimension-shift form is at
`references/stacks-cohomology.tex:1716–1776` — but make the project's prose the
contracting-homotopy reduction above (lighter; avoids the H¹ comparison sub-theory). Be
explicit in the prose that this is the affine/standard-cover special case actually consumed
downstream, and that it consumes narrowed-P3 standard-cover Čech vanishing (non-circular:
P3 produces standard-cover Čech vanishing; this lemma lifts it to affine sheaf vanishing).

### (2) `lem:open_immersion_pushforward_comp` part (2) — replace the relative Leray SS
**Part (1)** (`R^q j_* H = 0` for `q ≥ 1`) is already Route-A-clean — leave it. **Part (2)**
(`R^k f_*(j_* H) ≅ R^k g_* H` where `g = f ∘ j`) currently invokes the relative Leray
spectral sequence. Replace with the injective-resolution / `f_*`-acyclicity argument:
1. Choose an injective resolution `H → I•` of `H` in `U.Modules`.
2. Apply `j_*` degreewise to get `j_* H → j_* I•`.
3. Each `j_* Iⁿ` is `f_*`-acyclic: `R^k f_*(j_* Iⁿ)` is the sheafification of
   `V ↦ H^k(f⁻¹(V), (j_* Iⁿ)|_{f⁻¹(V)}) = H^k(U ∩ f⁻¹(V), Iⁿ|_{U ∩ f⁻¹(V)})`; for affine
   `V ⊆ S`, `U ∩ f⁻¹(V)` is affine (`j` affine, `X` separated, `f⁻¹(V)` quasi-compact), so
   by `lem:affine_serre_vanishing` (quasi-coherent `H^k(affine,-) = 0`, `k ≥ 1`) the term
   vanishes. Hence `R^{>0} f_*(j_* Iⁿ) = 0`.
4. Apply `lem:acyclic_resolution_computes_derived` with `G = f_*`:
   `R^k f_*(j_* H) ≅ H^k(f_*(j_* I•)) = H^k((f ∘ j)_* I•) = R^k g_* H`.
Set part (2)'s `\uses{}` to include
`lem:affine_serre_vanishing, lem:acyclic_resolution_computes_derived` (and
`lem:higher_direct_image_presheaf` for the presheaf description used in step 3 if you cite
it). Drop the relative-Leray-SS reference. **Source**: relative affine vanishing —
`references/stacks-coherent.tex` (`lemma-relative-affine-vanishing`). If you cite
flat-pushforward-preserves-injectives instead, that is Stacks
`lemma-pushforward-injective-flat`, `references/stacks-cohomology.tex:1820` — but the
`f_*`-acyclicity-via-affine-vanishing argument above is preferred and self-contained.

### (3) `lem:cech_term_pushforward_acyclic` — fix the contaminated prose sentence only
The `\uses{}` already lists `lem:open_immersion_pushforward_comp`. Replace the sentence
"consequently the Grothendieck composition spectral sequence for `f ∘ j_s` degenerates and
`R^k f_*((j_s)_* F|_{U_s}) = R^k (g_s)_* F|_{U_s}`" with:
"By `lem:open_immersion_pushforward_comp` part (2),
`R^k f_*((j_s)_* F|_{U_s}) ≅ R^k (g_s)_* F|_{U_s}`." No other change to this block.

## Out of scope (do NOT touch)
- Any STATEMENT, `\lean{}`, `\leanok`, `\mathlibok`.
- The Route-A-clean blocks: `def:cech_nerve`, `def:cech_complex`, `def:cover_arrow`,
  `def:cover_cech_nerve`, `def:push_pull_obj`, `def:push_pull_map`, `def:push_pull_functor`,
  `def:cech_nerve_cosimplicial`, `def:relative_cech_complex_of_nerve`, `lem:push_pull_id`,
  `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`,
  `lem:cech_acyclic_affine`, `lem:cech_augmented_resolution`,
  `lem:higher_direct_image_presheaf`, `lem:affine_serre_vanishing` (statement),
  `lem:cech_computes_cohomology`.
- `Cohomology_AcyclicResolution.tex`, `Cohomology_HigherDirectImage.tex`, any `.lean` file.

## Report
List each block rewritten, the new `\uses{}` set, the source quote you inserted (with the
line range you read), and any `reference-retriever` you spawned. Flag under
"Strategy-modifying findings" anything you discover that contradicts the Route-A rewrite
recipe above (e.g. a step that secretly still needs a spectral sequence).
