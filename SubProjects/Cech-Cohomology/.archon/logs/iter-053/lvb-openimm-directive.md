# Lean ↔ blueprint check — OpenImmersionPushforward.lean

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (this consolidated chapter carries `% archon:covers .../OpenImmersionPushforward.lean`; the relevant
  blocks are `lem:open_immersion_pushforward_comp` and its acyclicity sub-lemma, whose Lean targets are
  `AlgebraicGeometry.higherDirectImage_openImmersion_comp` and
  `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic`).

Report:
(a) **Lean → blueprint** — do the two theorem signatures match the blueprint statements and the
    `\lean{...}` hints? Both bodies are partial (real reduction steps then a `sorry`). Are the
    reductions consistent with the blueprint proof sketch, or has the Lean diverged? Is the new private
    helper `isAffineHom_of_affine_separated` a faithful rendering of the "j is an affine morphism" clause
    the chapter prose describes? Flag any placeholder/fake statement or signature mismatch.
(b) **blueprint → Lean** — is the chapter detailed enough to guide closing these theorems? The prover
    reports both theorems bottom out on THREE unbuilt bridges (cohomology-presheaf identification
    [upstream-deferred in HigherDirectImagePresheaf.lean], Serre-vanishing transport to a general affine
    open, and a `PresheafOfModules.sheafification` locally-zero site lemma). Does the chapter name/sketch
    these bridges, or is it too thin — i.e. does the blueprint understate the remaining work?

Flag any must-fix-this-iter findings. Absolute paths above; read them directly.
