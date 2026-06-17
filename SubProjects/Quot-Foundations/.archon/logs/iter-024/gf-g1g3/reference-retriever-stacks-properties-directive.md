# Reference Retriever Directive

## Slug
stacks-properties

## Topic
Algebraic geometry — quasi-coherent modules of **finite type** on schemes, and
specifically the affine-local characterization: on an affine scheme
`X = Spec(R)`, the quasi-coherent module `M̃` (associated to an `R`-module `M`)
is of finite type **if and only if** `M` is a finite (finitely generated)
`R`-module. Source: Stacks Project chapter **"Properties of Schemes"**
(`properties.tex`), the "Quasi-coherent sheaves" / "Modules of finite type"
sections.

## What the dispatcher will use this for
A blueprint lemma (`lem:gf_qcoh_fintype_finite_sections`) in
`Picard_FlatteningStratification.tex` asserts that for a quasi-coherent,
finite-type sheaf of modules `F` on a scheme `X` and an affine open `W ⊆ X`,
the section module `Γ(F, W)` is a finite module over `Γ(X, W)`. The exact
Stacks tag + verbatim statement is needed as the `% SOURCE:` / `% SOURCE QUOTE:`
citation backing this lemma (the keystone G1 bridge of geometric generic
flatness). I need the precise tag number and the exact wording of the lemma
that identifies finite-type quasi-coherent modules on an affine `Spec(R)` with
finite `R`-modules.

## Seeds
- Stacks Project chapter "Properties of Schemes":
  https://raw.githubusercontent.com/stacks/stacks-project/master/properties.tex
- Likely tags (confirm against the fetched `.tex`, do not assume):
  the definition of finite-type module (Properties, "finite type" — around tag
  01PB/01PG region) and the affine characterization lemma
  ("Let `X = Spec(R)`. ... `M̃` is of finite type if and only if `M` is a
  finite `R`-module", in the "Quasi-coherent sheaves" section of properties.tex).
- Stacks search: https://stacks.math.columbia.edu/ — search "finite type module
  affine finite R-module".

## Out of scope
- No need to map the whole Properties chapter; focus on the "Quasi-coherent
  sheaves" and "Modules of finite type" sections.
- Skip cohomology, ample line bundles, dimension theory sections.

## Contents-map depth expected
deep — locate and flag the EXACT tag + line numbers in the fetched
`properties.tex` for: (1) the definition of a finite-type `O_X`-module, and
(2) the lemma characterizing finite-type quasi-coherent modules on an affine
`Spec(R)` as the `M̃` of finite `R`-modules. Give section + line numbers so the
dispatcher can open the file and quote verbatim. NO paraphrase of the statements.
