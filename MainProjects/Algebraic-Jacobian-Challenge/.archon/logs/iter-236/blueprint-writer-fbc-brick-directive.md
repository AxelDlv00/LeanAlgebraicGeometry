# blueprint-writer — Cohomology_FlatBaseChange.tex, the brick lemma

## Scope (edit ONLY this chapter)
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, the block
`\begin{lemma}\label{lem:pushforward_spec_tilde_iso}` (the single Mathlib-absent brick the
iter-235 reframe reduced the affine lane to).

## Problem to fix (blueprint-reviewer ts236 must-fix/soon #4)
The brick block currently has NO `\lean{...}` hint and NO `\begin{proof}` body — only a
remark stating what it discharges. The next prover (mathlib-build) has no target name and
no proof strategy. Supply both.

## Required additions

### 1. `\lean{...}` hint
Add `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` to the lemma block.
(Tag the name as the expected target; the prover may adjust the exact namespace, but this
is the intended declaration.)

### 2. Statement (restate cleanly if needed, project notation)
For a ring map `φ : R → R'` (`CommRingCat`), with `M` an `R'`-module (so `tilde M` is the
associated quasi-coherent module on `Spec R'`), there is a canonical isomorphism of
`(Spec R).Modules`
\[
  (\mathrm{pushforward}\,(\mathrm{Spec.map}\,\varphi))\,(\widetilde{M})
    \;\cong\; \widetilde{\,\mathrm{restrictScalars}\,\varphi\;M\,}.
\]

### 3. `\begin{proof}` sketch (mathematical prose; NO Lean tactic strings)
This is a project-bespoke Mathlib-gradient lemma (no external source line needed). Convey
the following construction as textbook prose:

- **Sections agree on `⊤` with no transport.** `Spec.map φ` pulls back the top open to the
  top open (`(Spec.map φ)⁻¹ ⊤ = ⊤` holds definitionally), and the pushforward of a module
  evaluated on `⊤` is the module evaluated on the preimage of `⊤`. Hence the global
  sections of the left side are `M` (as the global sections of `tilde M`), and the global
  sections of the right side are `restrictScalars φ M` — the SAME underlying abelian group,
  now viewed as an `R`-module.

- **The comparison ring map is `φ` itself.** The structure-sheaf comparison map at `⊤`
  underlying `Spec.map φ` is the global-sections map `Γ(Spec R, ⊤) ⟶ Γ(Spec R', ⊤)`, which
  is canonically conjugate to `φ` by the naturality of the `Γ ⊣ Spec` adjunction unit/counit
  iso (`Scheme.ΓSpecIso` naturality). So the `R`-action on the pushforward sections is
  exactly restriction of scalars along `φ`.

- **Assemble the iso via `tilde` full-faithfulness / the `Γ`–`tilde` adjunction.** `tilde`
  is fully faithful with essential image the quasi-coherent modules, and the counit
  `fromTildeΓ` is an isomorphism on quasi-coherent objects. Applying `tilde` to the
  global-sections identification (`M` over `R'` ↦ `restrictScalars φ M` over `R`) and
  composing with the counit isomorphisms on both sides yields the asserted object iso.

- **The one residual scalar-compatibility check** (if it surfaces at the `ModuleCat` level)
  is the standard restriction-of-scalars compatibility: materialise the intermediate action
  with the composite-homomorphism module structure and the scalar-tower compatibility along
  `algebraMap`, exactly the idiom Mathlib's own `Tilde` construction uses to discharge the
  same `map_smul`-shaped goal. (Name the mathematical fact — restriction of scalars commutes
  with the `tilde` functor on global sections via the `algebraMap` scalar tower — not a Lean
  tactic block.)

### 4. Add a one-line corollary remark
Note that this single object iso also discharges, as immediate corollaries: (a) the
quasi-coherence of `pushforward (Spec.map φ)(tilde M)` (the QC class is closed under
isomorphism and `tilde N` is quasi-coherent), and (b) the Γ-fragment iso needed by
`affineBaseChange_pushforward_iso` (apply global sections to the object iso). So it is the
sole remaining gap for the whole affine lane.

## Constraints
- Mathematical prose only; no Lean tactic strings as content (Lean identifier names may be
  mentioned in passing as the name of the cited Mathlib fact).
- Do NOT add/remove `\leanok`/`\mathlibok` markers.
- Keep the existing tilde-full-faithfulness reframe and the `[IsQuasicoherent F]`-based
  statements of the two theorems intact; you are only filling the brick block.

## Out of scope
Do not touch the locality lemmas, the two main theorems' statements, or any other chapter.
