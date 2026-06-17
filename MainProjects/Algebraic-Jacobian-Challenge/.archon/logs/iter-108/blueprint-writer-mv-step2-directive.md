# Blueprint Writer Directive

## Slug
mv-step2

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context

`Cohomology/BasicOpenCech.lean`'s active substantive theorem is
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (the Stacks-01ED-style
local-to-global Čech-acyclicity claim for the basic-open cover of an
affine open). Its proof body has 6 transient sorries (L1120, L1212, L1536,
L1564, L1754, L1846); the iter-110-narrative active site is the trailing
`sorry` at **L1846 inside `h_loc_exact`**, which encodes the per-coord
finite-product-localization step "Step 2 (localized identification)" of
the chapter's existing four-step proof sketch.

Two consecutive prover iterations (iter-108, iter-109 narrative) made
**partial progress** on Steps 1a–1c of an iter-106 mathlib-analogist Q1
recipe (~50 LOC of inline `have` declarations: `h_V_le_U`, `h_slice_eq`,
`h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`), but Steps 2–4 hit a structural
blocker: `letI ... in <goal-type>` does not propagate to body binders
for the per-x algebra threading needed by the
`instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
adapter. The plan-agent's iter-108 (Archon) decision (informed by the
**strategy-critic-iter108 CHALLENGE**) is to **defer L1846 with a
budget-deferral annotation**, NOT a Mathlib-gap annotation: Mathlib
b80f227 *has* `IsLocalizedModule.Away` (in
`Mathlib.Algebra.Module.LocalizedModule.Away`) and `IsLocalizedModule.pi`
(in `Mathlib.RingTheory.TensorProduct.IsBaseChangePi`), so L1846 is
mechanizable from existing Mathlib pieces — just expensive in proof-engineering
LOC due to per-x typeclass plumbing friction.

Your job is to expand Step 2 of the chapter's proof sketch for
`\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` to:

1. Name the four Mathlib API pieces the prover needed at the L1846 site.
2. Add a **labelled "Implementation status (iter-108 escape-valve)"
   sub-block** marking this step as a budget-deferral (NOT a Mathlib
   gap), and citing the in-scope inline scaffolding committed at
   L1786–L1834 that survives as inert infrastructure.
3. Add the missing one-line status acknowledgement in
   § "Use in the project" that the substantive theorem currently rests
   on the budget-deferred sorry at L1846 (plus the PAUSED L1120 +
   the deferred substep sorries L1212/L1536/L1564/L1754).

## Required content

### (1) Step 2 expansion

The chapter at lines 1162–1166 currently reads (paraphrased): "Step 2.
Identification of the localized complex. Localizing at `f` identifies
the factor at `(f₀,…,fₙ)` with `O_X(U)[1/(f·f₀⋯fₙ)]` and rebuilds the
slice-cover Čech complex." This is mathematically correct but does not
preview the Mathlib API the prover needs to formalize it.

**Add a sub-block (e.g., a `\begin{remark}[Mathlib API for Step 2]`
or `\begin{proof}` enumeration of substeps)** previewing the four
Mathlib pieces:

- (i) **Image-Finset bridge**: `∏ᶜ_{a : Fin (n+1)} basicOpenCover s₀ (x a)
      = (Finset.image x univ).inf' _ (basicOpenCover s₀)` — via
  `Finset.inf_univ_eq_iInf`, `Finset.inf'_eq_inf`, `Finset.inf'_image`,
  + a `le_antisymm` step using `Pi.π`/`Pi.lift` (because
  `CompleteLattice.finite_product_eq_finset_inf` requires same-universe
  `α, ι` which `Fin (n+1) : Type 0` vs `Opens : Type u` violate).
- (ii) **Restriction-of-section identity**: `V_x ⊓ D(f.1) =
       D(f.1|V_x)` via `Scheme.basicOpen_res`.
- (iii) **Per-coord `IsLocalization.Away`**: for each
  `x : Fin (n+1) → ↑s₀`, the affine open `V_x` (per (i) + iter-057
  helper `basicOpenCover_finset_inf'_isAffineOpen`) carries
  `IsLocalization.Away (presheafMap.hom f.1) Γ(V_x ⊓ D(f.1))`
  via `IsAffineOpen.isLocalization_of_eq_basicOpen` + `h_slice_eq`.
- (iv) **Finite-product localization lift**: `IsLocalizedModule.pi`
  (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`) packages the
  per-coord localizations into a single `IsLocalizedModule (powers f.1)`
  on the product of restrictions, via the algebra adapter
  `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
  (`Mathlib.Algebra.Module.LocalizedModule.IsLocalization`).

Then close Step 2 by transporting the K₀-exactness `h_a₀_fun f` (already
in scope from earlier substeps) along the `Function.Exact.iff_of_ladder_linearEquiv`
ladder built from `IsLocalizedModule.iso` on each `LocalizedModule
(powers f.1) scK₀.X_i ≃ₗ[R] M_i' (slice_cover.X_i)`.

Cite `\uses{...}`-style references to the project's existing helpers:
`thm:Scheme_basicOpenCover_finset_inf_isAffineOpen`,
`thm:Scheme_basicOpenCover_finset_inf_isLocalization`,
`thm:Scheme_splitEpi_pi_lift_of_injective` (where applicable). The
referenced Mathlib lemmas don't get blueprint labels (they're upstream)
but should be named in the prose.

### (2) Implementation status sub-block

Add a `\begin{remark}[Implementation status (iter-108)]` block (or
similarly-labelled environment your chapter conventions already use
for Lean-state notes) under Step 2, body roughly:

> The Lean implementation of Step 2 currently lands inline at
> `BasicOpenCech.lean:L1781–L1846` within the body of `h_loc_exact`.
> Steps 1a + 1b ($V_x \le U$, $V_x \cap D(f) = D(f|V_x)$) and Step 1c
> (per-coord `IsLocalization.Away` via the image-Finset bridge +
> `IsAffineOpen.isLocalization_of_eq_basicOpen`) are committed as
> inline `have` declarations at L1786–L1834 (~50 LOC, iter-108 +
> iter-109 partial scaffolding). The trailing transport (Steps 2–4 of
> the recipe: per-x algebra + `IsScalarTower` synthesis,
> `IsLocalizedModule.pi` lift, ladder-LinearEquiv transport of
> $h_{a_0\text{\_fun}}\,f$) is **deferred at iter-108 (Archon canonical)
> as a budget deferral, NOT a Mathlib gap.** Mathlib b80f227 contains
> `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, and
> `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
> — the lemma is mechanizable; mechanization was deferred due to
> `letI ... in <goal-type>` propagation friction (Lean elaborates
> `letI`-in-type eagerly, leaving no body binders for the per-x
> algebra setup). The L1846 sorry is annotated `-- DEFERRED (budget):
> ...` (not a `-- MATHLIB GAP:` marker). Re-attempt is parked behind
> the C1 promotion (refined `LineBundle`) and Phase B priorities.

The point of this sub-block is to make the Lean-state reader
distinguish a budget-deferral from a structural Mathlib-gap. The
project's end-state advertises **3 named Mathlib gaps** (`instIsMonoidal_W`,
`h_exact`, `nonempty_jacobianWitness`); L1846 is NOT a fourth gap, it's
a deferred-budget item.

### (3) Status acknowledgement in § "Use in the project"

The chapter's § "Use in the project" subsection (around L1182) should
gain a one-paragraph status note:

> **Status (iter-108 / Archon canonical iter-108):** the substantive
> theorem `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
> currently rests on five labelled transient `sorry`s in the Lean
> proof body (L1120 PAUSED `cechCofaceMap_pi_smul`; L1212 substep (a)
> augmented Čech; L1536 outer `K → K_0` transport; L1564 substep (a)
> for $s_0$; L1846 deferred-budget per Step 2 above; L1754 gated on
> L1120 closure). The chain into `IsAffineHModuleVanishing` and the
> downstream Phase A step 6 consumer flows against these labelled
> sorries; the file compiles end-to-end.

## Out of scope

- **Do NOT** add `\leanok` or `\mathlibok` markers anywhere — handled
  by the `sync_leanok` phase + review agent.
- **Do NOT** edit other chapters or `content.tex`. The
  `Cohomology_MayerVietoris.tex` ↔ `Modules_Monoidal.tex` cross-reference
  (re Differentials.h_exact / W.IsMonoidal parallel) is a soft finding
  the blueprint-reviewer-iter108 noted but is NOT part of this directive.
- **Do NOT** restructure the existing four-step proof sketch — only
  expand Step 2 and add the labelled sub-block + status acknowledgement.
- **Do NOT** edit Step 1, Step 3, Step 4 of the proof sketch.
- **Do NOT** add a "Mathlib gap" label anywhere — the strategy-critic-iter108
  finding explicitly rules this out for L1846.

## References

- `references/challenge.lean`: original challenge file. The protected
  signatures it carries are the deliverables; Step 2 of
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is internal scaffolding
  for those deliverables, not itself a protected signature.
- `analogies/finite-product-localisation-and-cech-r-linearity.md`: the
  iter-106 mathlib-analogist Q1 recipe persistent file. The Mathlib API
  pieces named in the chapter expansion are documented here in full,
  and the chapter sub-block can cite this analogy file directly.

## Expected outcome

After your edits, `Cohomology_MayerVietoris.tex` Step 2 of
`\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` previews the
four Mathlib API pieces by name, cleanly distinguishes the budget-deferred
sorry at L1846 from a structural Mathlib gap, and the § "Use in the project"
subsection reflects the current Lean-state status. The chapter remains
under the `complete: partial` classification (the deferred sorries don't
shift; the prose just becomes operationally precise about *what* is
deferred and *why*). The next blueprint-reviewer pass should see this
finding resolved.
