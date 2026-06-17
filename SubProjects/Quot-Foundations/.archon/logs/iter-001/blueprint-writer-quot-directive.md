# Blueprint-writer directive — Picard_QuotScheme.tex (QUOT)

Edit ONLY `blueprint/src/chapters/Picard_QuotScheme.tex`. The second write-domain
`references/**` authorizes a child reference-retriever if needed; the Nitsure §1/§2/§5
source is already in `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` and
`references/nitsure-hilbert-quot.pdf`; Hartshorne in `references/hartshorne-algebraic-geometry.pdf`.

## Strategy context

Four stub nodes: `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
`thm:grassmannian_representable`. They are DEFINITIONS the parent's `thm:quot_representable`
consumes on merge-back, so signature quality matters more than speed. All four `.lean` bodies
are `sorry` (expected). This pass fixes the must-fix blueprint issues so a later prover gets
faithful targets — do NOT attempt to design the full representability proof body here.

## Required changes

### 1. Fix the broken cross-reference

`\cref{chap:Picard_FGAPicRepresentability}` (in the "Out of scope" region) points at a label
that exists only in the parent project — it renders broken. Replace it with a prose description
of the downstream out-of-scope chapter (the FGA Pic-representability assembly that lives in the
parent), with no `\cref`/`\ref` to a non-existent label.

### 2. Tighten the stub signatures in prose (specify faithful intended Lean types)

Mathlib has no single `IsCoherent` predicate at the pin; "coherent over a locally noetherian
base" = `[IsQuasicoherent]` + `[IsFiniteType]` (`SheafOfModules.IsQuasicoherent` /
`SheafOfModules.IsFiniteType` exist). For each stub, specify in the prose the corrected intended
signature (keep the existing `\lean{}` pins; the `.lean` re-sign is a later refactor):
- `hilbertPolynomial`: add coherence on `F` (`[F.IsQuasicoherent]`+`[F.IsFiniteType]`) and a
  proper-support-over-`S` hypothesis (state how it is encoded; if no clean Mathlib predicate
  exists, say so and propose the minimal honest encoding).
- `QuotFunctor`: add coherence on `E`.
- `Grassmannian`: add that `V` is locally free of some rank `r` and the rank constraint
  `1 ≤ d ≤ r` (state the Mathlib encoding of "locally free of rank r" you intend, e.g. a
  `Module.Free`/finite-rank condition on the appropriate local model, or flag it as a gap).

### 3. Representability statement — align with Mathlib `Functor.IsRepresentable`

The current return type `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)` is
exactly the content of `CategoryTheory.Functor.IsRepresentable`
(`IsRepresentable.has_representation : ∃ Y, Nonempty (F.RepresentableBy Y)`). State in the
chapter that the faithful target is `(Grassmannian V d).IsRepresentable` (Mathlib spelling), so
the parent can call `Functor.representableBy`/`reprX` at merge-back without re-bridging an
ad-hoc existential. Add a `\mathlibok` Mathlib dependency anchor block for
`CategoryTheory.Functor.IsRepresentable` (statement in project notation, `\lean{}` naming the
real Mathlib decl, marked `\mathlibok`). Also note the **universe constraint**: `RepresentableBy
F Y` needs `F : Cᵒᵖ ⥤ Type v` with the representing object in the same `C` at matching hom-universe
`v` — record that the Quot/Grassmannian functor's target universe must be pinned to the schemes
category's hom-universe, or representability will not typecheck.

### 4. Honor the `def:grassmannian_scheme` `\uses{def:quot_functor}` edge

State explicitly that `Grassmannian V d` should be DEFINED via `QuotFunctor` (Grass =
`Quot^{d,O_S}_{V/S/S}`, the case `X=S`, `E=V`, constant Hilbert polynomial `d`), so the
structural identity is preserved when the stubs are filled, rather than two independent defs.

### 5. Note (do NOT resolve) the RelativeSpec dependency gap

`thm:grassmannian_representable`'s sketch invokes the `RepresentableBy` Yoneda form "as in the
RelativeSpec chapter", but `thm:relative_spec_univ` is proved only as `IsAffineHom` (strictly
weaker). Add a `% NOTE:` recording that the representability PROOF is blocked on either
strengthening RelativeSpec to `RepresentableBy` or finding a `RepresentableBy`-free Grassmannian
argument — this is a deferred open question, NOT to be resolved in this pass. Do not edit the
RelativeSpec chapter.

## Out of scope

- Do NOT add or remove `\leanok`.
- Do NOT design the full §5 big-cell representability proof body. Do NOT edit other chapters.

## Citation discipline

Keep `% SOURCE:` + verbatim `% SOURCE QUOTE:` and visible `\textit{Source: Nitsure …}` lines on
externally-sourced blocks. Read verbatim quotes from
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — do not write from memory.

Report any "Strategy-modifying findings" in that section.
