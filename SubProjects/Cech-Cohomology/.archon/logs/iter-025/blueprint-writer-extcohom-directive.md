# Blueprint-writer directive — realize absolute sheaf cohomology H^p(U,F) as Ext (Mathlib-aligned)

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Background (decision already made by the planner)
A mathlib-analogist consult (`analogies/absolute-cohomology.md`) settled how the project will
realize the **absolute sheaf cohomology** `H^p(U, F)` that the Stacks 01EO comparison
(`lem:cech_to_cohomology_on_basis`) and the Serre-vanishing lemma (`lem:affine_serre_vanishing`)
require. The decision:

> **`H^p(U, F) := Ext^p_{Mod(O_U)}(𝒪_U, F|_U)`** (sheaf cohomology = Ext of the structure
> sheaf), realized with Mathlib's `CategoryTheory.Abelian.Ext`.

This was chosen because **Ext is the only route where Mathlib ships the load-bearing long exact
sequence off the shelf**. The previously-suspected route (`CategoryTheory.Sheaf.H` +
forget) was **refuted — it does not exist in Mathlib**. The plain `Functor.rightDerived` route
has the injective vanishing but **no LES** in Mathlib.

Read `analogies/absolute-cohomology.md` in full before writing — it has the exact Mathlib decls.

## Task

### 1. Add a new definition/anchor block `def:absolute_cohomology`
Place it in the chapter just BEFORE `lem:affine_serre_vanishing` (label `lem:affine_serre_vanishing`,
~L2756) so the two consuming lemmas can `\uses{def:absolute_cohomology}`. The block:

- States `H^p(U, F) := Ext^p(𝒪_U, F|_U)` for `F` an `O_X`-module and `U ⊆ X` open, in the
  module-sheaf category (the project's `X.Modules` / `SheafOfModules`, which is `Abelian`).
- Records that the three facts the downstream proofs need are supplied by Mathlib:
  - **degree-0 / global sections**: `H^0(U,F) ≅ Γ(U,F)` via `Ext.homEquiv₀` / `Ext.addEquiv₀`
    (degree-0 Ext is `Hom`, and `Hom(𝒪_U, F|_U) = Γ(U,F)`);
  - **injective vanishing**: `H^{n+1}(U, I) = 0` for an injective `O_X`-module `I` via
    `Ext.eq_zero_of_injective` (keep `I` as the **second** Ext argument so no
    "restriction-preserves-injectives" lemma is forced);
  - **long exact sequence**: for a SES `0→F→I→Q→0` at fixed first argument `𝒪_U`, the covariant
    Ext LES `Ext.covariant_sequence_exact₁/₂/₃` / `Ext.covariantSequence_exact`.
  - **`HasExt` availability**: unconditional via `HasExt.standard`.

### 2. Author Mathlib dependency anchors (`\mathlibok`)
For each genuine Mathlib decl the realization rests on, add a short anchor block (statement in the
project's notation, `\lean{<real Mathlib name>}`, marked `\mathlibok`). Anchor these names
(verify each exists via the analogy file / LSP `lean_local_search` before pinning):
- `CategoryTheory.Abelian.Ext` — the Ext bifunctor object.
- `CategoryTheory.Abelian.Ext.covariant_sequence_exact` (the covariant LES; the ₁/₂/₃ pieces may
  be bundled into this one anchor's `\lean{}` list).
- `CategoryTheory.Abelian.Ext.eq_zero_of_injective` — injective vanishing.
- `CategoryTheory.Abelian.Ext.homEquiv₀` (bundle `Ext.addEquiv₀` into the same `\lean{}` list).
- `CategoryTheory.HasExt.standard` — unconditional `HasExt`.
- `AlgebraicGeometry.Scheme.Modules.restrictFunctor` — sections-over-`U` / restriction functor.
You MAY mark `\mathlibok` ONLY on these genuine Mathlib anchors. Do NOT mark `\mathlibok` (or
`\leanok`) on any project-to-be-proved declaration.

### 3. Lightly refresh the two consuming proofs to name the Ext realization
- In `lem:affine_serre_vanishing` and `lem:cech_to_cohomology_on_basis`: add
  `def:absolute_cohomology` to their `\uses{}` (statement AND proof blocks), and adjust the proof
  prose so that "the sheaf-cohomology long exact sequence" and "`H^n(U,I)=0` for injective `I`"
  explicitly cite the Ext LES (`Ext.covariant_sequence_exact`) and `Ext.eq_zero_of_injective`
  respectively. Keep the `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks verbatim and unchanged
  — you are only refining the project-notation restatement, not the cited source text. Do NOT
  change the lemma STATEMENTS (the `H^p(U,F)=0` conclusions) — only make explicit that `H^p` is
  the Ext realization.

## Constraints
- Do NOT edit any `.lean` file. Do NOT add `\leanok` anywhere. `\mathlibok` ONLY on the genuine
  Mathlib anchors named in §2.
- Use only existing blueprint labels in `\uses{}` plus the new `def:absolute_cohomology`.
- Keep all existing prose / source quotes / statements of the other blocks intact.
- If you need to confirm a Mathlib decl's exact name/signature, use LSP search; if a name in §2
  turns out not to exist as written, report it (do not invent) — the analogy file's citations are
  your primary source.

## Report
List the new block + anchors added, the `\uses{}` edges added, and confirm no `\leanok` and no
broken `\uses{}` were introduced.
