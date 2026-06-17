# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
015

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (blocks relevant to `CechAcyclic.lean`: `lem:cech_acyclic_affine` and dependencies)

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)

- **Lean target exists**: yes (line 74)
- **Signature matches**: yes — LSP-verified signature is:
  ```
  CechAcyclic.affine.{u} {R : CommRingCat} {S : Scheme} (f : Spec R ⟶ S)
    [IsAffineHom f] {ι : Type u} [Finite ι] (s : ι → ↑R)
    (hs : Ideal.span (Set.range s) = ⊤) (F : (Spec R).Modules)
    (hF : SheafOfModules.IsQuasicoherent F) (p : ℕ) (hp : 1 ≤ p) :
    IsZero (HomologicalComplex.homology
      (CechComplex f (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover F) p)
  ```
  The blueprint states: affine `U = Spec(A)`, spanning family `(s : ι → A, hs)`, quasi-coherent `F`, conclusion `Ȟᵖ(𝒰, F) = 0` for `p > 0`. The relative formulation (extra `f : Spec R ⟶ S` with `[IsAffineHom f]`) is consistent with the overall chapter's relative Čech complex setup (`def:cech_complex`) and is a legitimate generalization rather than a mismatch.
- **Proof follows sketch**: no — body is `sorry` (LSP warning confirmed: "declaration uses `sorry`"). **PRE-KNOWN OPEN SORRY** (listed explicitly in directive). The L3 combinatorial infrastructure (`CombinatorialCech.*`) is axiom-clean and present; the remaining gap is the L1 categorical→module bridge.
- **Notes**: The planner strategy comment (lines 36–59) documents the three-step route (L1 identification, L2 `exact_of_isLocalized_span`, L3 homotopy). L3 is closed. No excuse-comment is attached to the `sorry` itself; the `sorry` is a legitimate open hole, not a disguised wrong proof.

---

## Red flags

### Placeholder / suspect bodies

- `CechAcyclic.affine` (line 74): body is `sorry`. Blueprint (`lem:cech_acyclic_affine`) claims a substantive proof. **PRE-ACKNOWLEDGED** as known open sorry in directive — not a new finding. Recorded for completeness; the gate on this file should not re-fire on this item.

### Excuse-comments

None. The inline comment block (lines 79–92) is a planner strategy note documenting the proof route and the known gap; it does not excuse wrong code — it accurately describes the state of the proof (L3 done, L1 still missing).

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations appear. The `CombinatorialCech` namespace is confirmed axiom-clean per the inline module docstring (line 84: "NOW PROVED axiom-clean").

---

## Unreferenced declarations (informational)

The following 9 private declarations in `namespace AlgebraicGeometry.CombinatorialCech` have no `\lean{...}` reference in any blueprint block. Per directive, their absence is **known coverage debt** slated for the planner; they are NOT a Lean error.

| Name | Line | Kind | Blueprint home recommendation |
|------|------|------|-------------------------------|
| `combDifferential` | 127 | private def | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combHomotopy` | 133 | private def | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combHomotopy_zero` | 136 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `cons_comp_succAbove_succ` | 142 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combHomotopy_spec` | 155 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combDifferential_eq_of_cocycle` | 172 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combSign_flip` | 180 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combDifferential_comp` | 200 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |
| `combDifferential_exact` | 231 | private lemma | Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list |

**Recommendation**: These should be listed in a `\lean{...}` bundle attached to `lem:cech_acyclic_affine` in the blueprint, since the Lean file's own module docstring (line 115–117) states: *"The intended blueprint home is the `\lean{...}` bundle of `lem:cech_acyclic_affine`."* They are purely internal helpers and do not need separate blueprint blocks. One addition to the blueprint's `\lean{...}` list suffices, e.g.:

```latex
\lean{AlgebraicGeometry.CechAcyclic.affine,
  AlgebraicGeometry.CombinatorialCech.combDifferential,
  AlgebraicGeometry.CombinatorialCech.combHomotopy,
  AlgebraicGeometry.CombinatorialCech.combHomotopy_spec,
  AlgebraicGeometry.CombinatorialCech.combDifferential_comp,
  AlgebraicGeometry.CombinatorialCech.combDifferential_exact}
```
(auxiliary helpers `combHomotopy_zero`, `cons_comp_succAbove_succ`, `combDifferential_eq_of_cocycle`, `combSign_flip` can be omitted or included at the blueprint author's discretion.)

---

## Blueprint adequacy for this file

- **Coverage**: 1/1 public Lean declarations have a corresponding `\lean{...}` block in the chapter. 9 private helpers have no blueprint coverage (known debt, not counted as a deficiency here).
- **Proof-sketch depth**: **under-specified on L1**. The blueprint proof of `lem:cech_acyclic_affine` (lines 576–610) gives two descriptions of the proof:
  - The prime-localization route (Stacks-style): well described and mathematically complete.
  - The "concrete" node-by-node route (lines 601–609): describes L2 (`exact_of_isLocalized_span` — the reduction to localised complexes) and L3 (the contracting homotopy `h(s) = s_{r i₀…iₚ}` in the away-localisation) adequately.
  - **Silent on L1**: the blueprint never explains how to identify the abstract `CechComplex f 𝒰 F` (a categorical object in `QCoh(Spec R)`) with the concrete away-localisation module complex `∏_σ M_{s_σ}`. This identification — specifically that the `i`-th sections of `CechComplex` equal `IsLocalizedModule.Away (s i) M` — is the key bridge a Lean prover needs for L1 and it is not present in the blueprint prose. A prover relying solely on the blueprint cannot begin L1; this gap is currently bridged only by the planner's strategy comment inside the Lean file itself (lines 36–59).
- **Hint precision**: precise — `\lean{AlgebraicGeometry.CechAcyclic.affine}` names the correct declaration with the correct generality.
- **Generality**: matches need. The relative formulation (`f : Spec R ⟶ S`) is appropriate.
- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. **Add a `\lean{...}` bundle** to `lem:cech_acyclic_affine` listing the 9 `CombinatorialCech` helpers (see above). This closes the coverage-debt item.
  2. **Expand the proof sketch** to include an explicit L1 paragraph: describe how `affineOpenCoverOfSpanRangeEqTop_f i = Spec.map (algebraMap R (Localization.Away (s i)))` implies that sections over the `i`-th piece of the Čech complex are exactly `IsLocalizedModule.Away (s i) M`, and that this identification is compatible with the Čech differential. This is the missing bridge that a prover needs to connect the abstract `CechComplex` to the module complex fed into `exact_of_isLocalized_span`.

---

## Severity summary

| Finding | Severity | Notes |
|---------|----------|-------|
| `CechAcyclic.affine` body is `sorry` | *(pre-known)* | Explicitly listed in directive as a known open sorry; does not trigger this-iter gate |
| 9 `CombinatorialCech` helpers unreferenced in blueprint | **major** | Coverage debt; blueprint needs a `\lean{...}` bundle addition to `lem:cech_acyclic_affine` |
| Blueprint proof sketch silent on L1 (categorical→module bridge) | **major** | Under-specified; a prover cannot formalize L1 from blueprint prose alone; the Lean file's planner comment currently compensates |
| `combDifferential_comp` / `combSign_flip` details not previewed in blueprint | **minor** | Sub-steps of the homotopy computation; standard enough to omit, but a brief mention of d²=0 as a separate verified sub-goal would help future provers |

**Overall verdict**: The Lean file is mathematically faithful to the blueprint for all checked declarations; the main theorem's signature is correct and the `CombinatorialCech` namespace is axiom-clean and consistent with the blueprint's L3 proof sketch; the two actionable issues are blueprint-side — a missing `\lean{...}` bundle for the 9 private helpers (major coverage debt) and a missing L1 prose paragraph that would guide formalization of the categorical→module identification (major proof-sketch gap).
