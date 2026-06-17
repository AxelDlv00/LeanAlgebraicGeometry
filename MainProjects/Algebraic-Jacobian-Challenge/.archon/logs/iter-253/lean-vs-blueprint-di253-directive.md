# lean-vs-blueprint-checker di253 — directive

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (this chapter `archon:covers` the DualInverse file; the relevant labels are `lem:sheafofmodules_hom_of_local_compat`, `lem:dual_restrict_iso`, `lem:scheme_modules_hom_local_section`).

Specific question to resolve (Lean → blueprint AND blueprint → Lean):
- The Lean proof of `homOfLocalCompat` is blocked at sub-step (a) (the `IsCompatible`/cocycle condition). The file reports that the hypothesis `hf` — phrased as an `HEq` between `Scheme.Modules.pullback`-images of `f i` and `f j` — cannot be consumed, because the two source/target objects are only *isomorphic* (each is a sheafification of a pullback presheaf), not propositionally equal, so `eq_of_heq` / `HEq.elim` / `conj_eqToHom_iff_heq` / `subst` are all inapplicable.
  1. Does the blueprint proof of `lem:sheafofmodules_hom_of_local_compat` prescribe a bridge for this step that the current Lean `hf` signature actually supports? Or does the blueprint assume a form of the compatibility hypothesis (sectionwise, or via `restrictFunctor`/`eqToHom` transport into the common object `M.restrict (U i ⊓ U j).ι`) different from the `HEq`-of-pullback-images the Lean uses?
  2. Is the chapter detailed enough to guide the formalization of step (a), or is it too thin / does it gloss the exact obstacle the Lean hit?
- Also check sub-steps (b) (now closed via `topSectionToHom`) and (c) (linearity, still open) against the blueprint.

Report must-fix-this-iter findings explicitly (blueprint too thin / signature mismatch / Lean diverges from sketch).
