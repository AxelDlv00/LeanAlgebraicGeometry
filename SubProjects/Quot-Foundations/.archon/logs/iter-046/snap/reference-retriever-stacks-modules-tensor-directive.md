# Reference Retriever Directive

## Slug
stacks-modules-tensor

## Topic
The Stacks Project "Sheaves of Modules" chapter (modules.tex), specifically:
1. **Tensor product of sheaves of O_X-modules** — the section defining F ⊗_{O_X} G as the
   sheafification of the presheaf U ↦ F(U) ⊗_{O_X(U)} G(U) (Stacks tag around 01CC/01CD).
2. **Invertible sheaves / invertible modules and their tensor powers** — the definition of an
   invertible O_X-module and the tensor power L^{⊗n} (Stacks tag around 01CR–01CV; the
   "Invertible modules" section).
3. If present in the same or an adjacent chapter, the **graded ring / algebra of global sections
   ⊕_{n≥0} Γ(X, L^{⊗n})** of an invertible sheaf (the section ring / homogeneous coordinate ring;
   may live in "Constructions of Schemes" or "Properties of Schemes" — e.g. the Γ_*(L) construction).

## What the dispatcher will use this for
Grounding a NEW blueprint chapter `Picard_SectionGradedRing.tex` that builds the Mathlib-absent
infrastructure for the section graded ring R(X_s,L_s)=⊕_m Γ(X_s,L_s^{⊗m}) and section graded module
M=⊕_m Γ(X_s, F_s⊗L_s^{⊗m}). I need VERBATIM source text (original notation, every word) for two
conceptual definition blocks: (a) the tensor product of two sheaves of modules as sheafification of
the pointwise tensor presheaf, and (b) the tensor power of an invertible sheaf. These back the
project-new Lean constructions that sheafify Mathlib's PresheafOfModules monoidal product.

## Seeds
- URL (chapter TeX): https://raw.githubusercontent.com/stacks/stacks-project/master/modules.tex
- Stacks tag (tensor product of modules): 01CD
- Stacks tag (invertible modules section): 01CR
- Stacks Project online: https://stacks.math.columbia.edu

## Out of scope
- No cohomology computations, no derived tensor products.
- No paraphrase: I need exact tag statements from the fetched .tex so the verbatim quotes are faithful.

## Contents-map depth expected
deep: map the exact tensor-product definition tag and the invertible-module/tensor-power tag, with
their precise location (line numbers in the fetched .tex) so I can copy the verbatim statements.
