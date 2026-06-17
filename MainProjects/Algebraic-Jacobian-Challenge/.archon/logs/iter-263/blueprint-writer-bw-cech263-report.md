# Blueprint Writer Report

## Slug
bw-cech263

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Revised** `def:cech_nerve` — corrected the terminology error: the module-valued
  nerve is an augmented **cosimplicial** object of `QCoh(X)` (was wrongly called
  "simplicial"), with **cofaces**/**codegeneracies** (was faces/degeneracies). Added
  an explicit variance paragraph: the geometric nerve is a *simplicial* object in
  *schemes*, the covariant direct image turns it into a *cosimplicial* object in
  modules, hence the associated alternating-coface complex is a **cochain** (not
  chain) complex. Forward-references the new `sec:cech_three_part`.
- **Added subsection** `\subsection`/`\label{sec:cech_three_part}` "The three-part
  construction of the relative Čech complex" (placed after `def:cech_complex`, before
  the affine-acyclicity section). Three `\paragraph`s at textbook level, using math
  prose only (no Lean identifiers):
  1. **Geometric backbone** — package the cover as a single arrow
     `∐ᵢ Uᵢ ⟶ X` and take its augmented Čech nerve (augmented simplicial *scheme*
     over `X`, the iterated fibre powers = the intersections); unconditional, uses
     only coproducts + finite limits.
  2. **Push–pull functor** `G : (X/Sch)ᵒᵖ ⥤ QCoh(X)`, `(Y,p) ↦ p_* p^* F` — the
     lone non-formal step; stated explicitly that its functoriality (respect for
     identities/composition over `X`) is exactly the `(p∘q)_* ≅ p_* q_*` /
     `(p∘q)^* ≅ q^* p^*` pushforward/pullback coherence, a **consumer** of the same
     coherence developed for the tensor–pullback substrate.
  3. **Coherence-free plumbing** — forget the augmentation, push forward along `f`
     degreewise, take the alternating-coface cochain complex; uses only
     preadditivity of `QCoh(S)`. States that `CechComplex` is genuinely *defined*
     from the nerve.
- **Revised** `lem:cech_computes_cohomology` (statement) — documented the two
  weakenings the Lean statement carries: (a) the comparison holds only when
  `QCoh(X)` has enough injectives (the derived-functor target side), and (b) the
  comparison is asserted as the *existence* of an isomorphism (`Nonempty (≅)`), not
  a chosen natural iso, with the justification that downstream
  representability/loc-triv consumers need only object-level agreement.
- **Revised** `lem:cech_acyclic_affine` (proof) — appended a one-sentence
  absent-Mathlib-infrastructure note: explicit localisation description of the
  standard-cover Čech complex + the prime-local module-level contracting homotopy.
- **Revised** `lem:cech_computes_cohomology` (proof) — appended absent-infrastructure
  note: the Čech-to-derived-functor and Leray spectral sequences for sheaves of
  modules on a scheme.
- **Revised** `lem:cech_flat_base_change` (proof) — appended absent-infrastructure
  note: term-wise affine base change of the Čech complex and exactness of `- ⊗_A B`.

## Cross-references introduced
- `def:cech_nerve` now references `sec:cech_three_part` (forward ref to the new
  subsection in the same chapter — valid).
- No new `\uses{...}` were needed; existing dependency edges unchanged.

## References consulted
- None newly opened this session. All edits are prose clarifications of the existing
  construction strategy (sourced from the Lean file
  `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`) and Archon-original
  documentation of weakenings/gaps. No new `% SOURCE`/`% SOURCE QUOTE` blocks were
  added, so the existing citation blocks (backed by `references/stacks-coherent.tex`)
  were left fully intact.

## Macros needed (if any)
- None. Used only standard commands (`\coprod`, `\times_X`, `\mathbf{Sch}`,
  `\mathrm{op}`, `\paragraph`, `\subsection`).

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The chapter's `\leanok` markers are placed on lines *separate from* the
  `\begin{...}` line (e.g. `\begin{definition}` newline `\leanok` newline `[name]`).
  This is unusual formatting but pre-existing — I did not touch any `\leanok`.
- The new `\paragraph` `G : (X/Sch)ᵒᵖ ⥤ QCoh(X)` describes the push-pull functor at
  the math level; the Lean file's actual functor lands in `X.Modules` rather than the
  full `QCoh(X)` subcategory, but the chapter consistently writes `QCoh(X)` for the
  ambient module category throughout, so I matched that convention. If the plan agent
  wants the prose to say `O_X`-modules instead of `QCoh(X)`, that is a chapter-wide
  rename beyond this directive's scope.
- Environment balance verified: 3 `proof`, 6 statement environments, all matched.

## Strategy-modifying findings
None. The prose changes document the construction strategy and its known
Mathlib gaps faithfully; nothing surfaced that contradicts STRATEGY.md.
