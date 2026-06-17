# Blueprint-writer — SNAP section-graded-ring infrastructure (NEW chapter)

## Target
Create `blueprint/src/chapters/Picard_SectionGradedRing.tex` (new chapter, new Lean file
`AlgebraicJacobian/Picard/SectionGradedRing.lean` to be scaffolded a later iter). It supplies the
Mathlib-absent INFRASTRUCTURE that `def:sectionGradedRing` / `def:sectionGradedModule` (which live in
`Picard_QuotScheme.tex` — do NOT redefine or move them) will `\uses{}`.

## Scope — decompose into sub-phases (this is the whole point; do NOT write one monolithic block)
The graded ring `R(X_s,L_s) = ⊕_{m≥0} Γ(X_s, L_s^{⊗m})` and graded module
`M(X_s,F_s,L_s) = ⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^{⊗m})` need three separable infra layers — give each its own
sub-lemmas/defs with `\label`, proposed `\lean{AlgebraicGeometry.…}` pins, `\uses`, and informal proofs:

1. **Tensor powers of a sheaf of modules** `L^{⊗m}` and `F ⊗ L^{⊗m}` on a scheme: the monoidal/iterated
   tensor product on `X.Modules` (`SheafOfModules`). State whether Mathlib's `SheafOfModules` carries a
   `MonoidalCategory` / `tensorObj` instance — if it does, record it as a `\mathlibok` Mathlib dependency
   anchor (statement in project notation + the real Mathlib `\lean{}`); if it does NOT, state the iterated
   tensor power as project-new infra to build, decomposed (base `L^{⊗0}=O_X`, step `L^{⊗(m+1)}=L^{⊗m}⊗L`).
2. **Lax-monoidal global sections** `Γ`: the natural multiplication `Γ(F)⊗_{Γ(O)}Γ(G) → Γ(F⊗G)` making
   `⊕_m Γ(L^{⊗m})` a graded ring and `⊕_m Γ(F⊗L^{⊗m})` a graded module over it. State the lax-monoidal
   structure map and the associativity/unit coherence needed for the graded-ring axioms. Mathlib anchor if
   `SheafOfModules`/section functor is already (lax-)monoidal; else project-new, decomposed.
3. **Graded-ring / graded-module assembly**: from layers 1–2, the `GradedRing`/`GradedAlgebra` and
   `GradedModule` (or `DirectSum`-graded) structures on the section objects. Name the Mathlib graded-algebra
   API used (`DirectSum.GAlgebra` / `GradedRing` etc.) as anchors.

## References
- Reads may need Serre's theorem on f.g. of section rings (Q1: the `m≫0` agreement). If you need a source not
  in `references/`, spawn a reference-retriever (you are authorized `references/**`). The "Hartshorne II.5.17"
  attribution in prior notes is UNVERIFIED — do not cite it from memory; retrieve and read before quoting.
- Hartshorne II.5/II.7 (`references/hartshorne-algebraic-geometry.pdf`) backs tensor-of-sheaves + section
  rings; Stacks if cleaner. Keep `% SOURCE` / `% SOURCE QUOTE` discipline; quote verbatim from a file you read.

## Re-estimation
Calibrate effort against comparable completed net-new builds (GradedHilbertSerre ~9 iters/~1290 LOC). State a
realistic sub-phase-level estimate in the chapter intro prose (NOT optimistic).

## Constraints
- Edit ONLY `blueprint/src/chapters/Picard_SectionGradedRing.tex` (+ `references/**` via a spawned retriever).
- Do NOT touch `Picard_QuotScheme.tex` or redefine `def:sectionGradedRing`/`def:sectionGradedModule`.
- Do NOT add `\leanok` (sync_leanok's job). `\mathlibok` ONLY on genuine Mathlib dependency anchors.
- No Lean tactic syntax in proofs — mathematical prose only.
