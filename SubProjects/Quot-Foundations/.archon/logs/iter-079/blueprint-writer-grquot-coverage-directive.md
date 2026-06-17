# blueprint-writer — grquot-coverage

Target: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (write-domain also `references/**` for a
child reference-retriever if the Nitsure quote is needed).

Action 1 — MUST-FIX route mismatch. Rewrite the PROOF block of `lem:chartLocus_isOpenCover` to the
affine projective-splitting route actually formalized (the prose currently describes a
stalkwise-Nakayama route the Lean does NOT take; a `% NOTE:` flags it). The real route, from
`.archon/task_results/AlgebraicJacobian_Picard_GrassmannianQuot.lean.md` ("chartLocus_isOpenCover —
RESOLVED"): epis between free sheaves on `Spec R` split (conjugate through `tildeFinsupp`, `tilde`
reflects epi to `ModuleCat R`, `Module.projective_lifting_property`) → matrix right inverse over
`Spec R` → affine transport via `S.isoSpec` → pointwise (Nitsure §1): trivialise on an affine `W ∋ t`,
present by a matrix, evaluate at the residue field, `exists_isUnit_submatrix` gives a size-`d` minor
with unit residue determinant `f0`, on `W.basicOpen f0` the minor is invertible so the chart composite
pulls back to an iso ⟹ `t ∈ isoLocus`. Cite Nitsure §1/§5 (read `references/nitsure-hilbert-quot-src/`
or `.pdf` for the verbatim quote; retrieve only if absent). Remove the stale stalkwise prose + the `% NOTE:`.

Action 2 — coverage debt. Author 1-to-1 blocks for the ~15 new decls under "## Needs blueprint entry"
in that task result (exact `\lean` names + `Uses:` there): the Nitsure overlap-matrix chain
(`presentedMatrix`, `presentedMatrix_changeOfBasis` = Nitsure's `M^I = M^I_J·M^J`,
`isUnit_of_isIso_matrixEndRect`, `matrixEndRect_*`), the affine epi-splitting lemmas, etc.

Constraints: math-only prose, NO Lean tactics; NO `\leanok`. The grquot checker's "3 broken `\lean` pins"
were FALSE POSITIVES (decls exist at L386/L878/L271) — do NOT touch them. Do not edit other chapters.
