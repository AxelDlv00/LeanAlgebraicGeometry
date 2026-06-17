# Blueprint Review Report

## Slug
fbc-fastpath

## Iteration
017

## Scope
Same-iter fast-path scoped re-review: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
against `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`.

---

## Directive checks (three gaps flagged by iter-016)

### Gap 1 — `lem:pullbackPushforward_unit_comp` coverage debt

**RESOLVED. Verdict: CLEAR.**

The lemma block now appears at blueprint lines 1443–1482 with:

- `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` — correctly pinned.
- Statement: the pseudofunctoriality identity
  `η^b_N ∘ b_*(η^a_{b^*N}) ∘ pushforwardComp^hom = η^{a∘b}_N ∘ (a∘b)_*(pullbackComp^inv)` — accurate against the Lean signature at Lean file line 1140.
- `\uses{lem:unit_conjugateEquiv_mathlib, lem:comp_unit_app_mathlib, lem:conjugateEquiv_pullbackComp_inv_mathlib}` — three new Mathlib anchors, each marked `\mathlibok`.
- Proof sketch: three-sentence derivation applying each Mathlib anchor in sequence; sufficient for a prover.
- `lem:pullbackPushforward_unit_comp` IS listed in the `\uses{}` of `lem:base_change_mate_fstar_reindex` (blueprint line 1491). Wire-up complete.

**Mathlib anchor faithfulness audit** (all three `\mathlibok` nodes appear in `leandag` `unmatched_lean`, expected for Mathlib-only declarations):

| Anchor | `\lean{}` | Status |
|--------|-----------|--------|
| `lem:unit_conjugateEquiv_mathlib` | `CategoryTheory.unit_conjugateEquiv` | Used at Lean file line 1039 and 1150 in the compiled axiom-clean proof — declaration exists in Mathlib ✓ |
| `lem:comp_unit_app_mathlib` | `CategoryTheory.Adjunction.comp_unit_app` | Used at Lean file lines 1024, 1031, 1155 — exists ✓ |
| `lem:conjugateEquiv_pullbackComp_inv_mathlib` | `AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv` | Used at Lean file line 1155 — exists ✓ |

`lean_verify` on `AlgebraicGeometry.pullbackPushforward_unit_comp` returns axioms `{propext, Classical.choice, Quot.sound}` — axiom-clean, standard kernel axioms only. No fabrication risk.

---

### Gap 2 — Seam-2 (`lem:base_change_mate_fstar_reindex`) proof sketch under-specified

**RESOLVED. Verdict: CLEAR.**

The proof block (blueprint lines 1570–1658) now gives three explicitly named sub-steps:

**(i) Abstract variable-legs restatement** (lines 1608–1618):
> Restate the codomain read — and the whole four-factor chain — for *generic* morphisms `g'`, `f'` carrying the cone-leg equalities as explicit hypotheses, in place of the literal pullback projections. In this abstract form each leg is a free variable, so substituting its defining equation now acts on a well-typed motive because the equality proof `w`, the adjunction index, and the `Θ_tgt` arguments move along the substitution uniformly.

This directly resolves the DEAD END (documented in the `% RECIPE:` comment at lines 1529–1555): "naive `rw`/`simp` with the leg equalities `hfst`/`hsnd` on the Γ-split goal fails ('motive is not type correct') — the reindex MUST go through the abstract conjugate calculus, never by `rw` on the bare legs."

**(ii) Γ-collapse of the transparent coherences** (lines 1619–1634):
Names the three factors that collapse: `pushforwardComp^hom` and `pushforwardComp^inv` evaluate to the identity on the top open; `pushforwardCongr^hom` is a presheaf-restriction along an equality of opens (an `eqToHom` repackaging). After collapse the only surviving non-trivial factor is `f_*(η^{g'})` on global sections.

**(iii) Reduction to Seam 1 via the leg-reindex engine** (lines 1636–1657):
Instantiates `lem:pullbackPushforward_unit_comp` at `a = e` (the pullbackSpecIso, an isomorphism), `b = Spec(ιA)`, `N = tilde M`. The `e`-unit is invertible (since `e` is an isomorphism, by `lem:pullback_isEquivalence_of_iso`), hence absorbed into `Θ_tgt`. The surviving `Spec(ιA)`-unit's section value is Seam 1 (`lem:base_change_mate_unit_value`). Composing with `Θ_tgt` and reading over `Spec R` by restriction of scalars along `ψ` lands on `ρ = base_change_mate_inner_value`.

Each of (i)–(iii) is characterized as "extracts as a named lemma". A prover has an unambiguous formalization route with no undocumented leaps.

---

### Gap 3 — Seam-3 (`lem:base_change_mate_gstar_transpose`) proof sketch under-specified

**RESOLVED. Verdict: CLEAR.**

The proof block (blueprint lines 1715–1776) now gives three named steps plus a `% RECIPE:` comment at lines 1690–1702:

**Counit split**: "By the counit form of the hom-set adjunction (`homEquiv`-counit identity for the transpose), [the base-change map] factors as `g^*(θ_in)` followed by the counit `ε_g`, with no opaque adjunction transpose remaining." The Lean spelling — `Adjunction.homEquiv_counit` — is named in both the comment (line 1677) and the Lean file (line 1334, already applied).

**The concrete counit coherence** (lines 1753–1768): The proof explains why the counit cannot be simplified by reflexivity or definitional unfolding (the dictionary `Π_ψ` is built abstractly via `conjIso`), and names the resolution: "the counit-triangle (zig-zag) coherence for the *composed* adjunction `(tilde_{R'} ⊣ Γ_{R'}) . (g^* ⊣ g_*)`" — explicitly called "the dual companion of the unit-across-conjugate coherence (`lem:unit_conjugateEquiv_mathlib`)." Applying it collapses the geometric counit to the module-level adjunction counit, leaving `extendScalars ψ ∘ ρ`.

**Identification on generators** (lines 1770–1775): `r' ⊗ m ↦ (1 ⊗ r') ⊗ m` is exactly `(base_change_mate_regroupEquiv).inv` on generators, both `R'`-linear.

The `% LEAN SIGNATURE` block gives the complete Lean type of the goal, confirmed by the actual declaration at Lean file line 1258–1277. The `% RECIPE:` block names the three Lean steps: (1) `homEquiv_counit` split, (2) conjugation by `Θ_src`/`Θ_tgt` using the composed-adjunction counit-triangle identity, (3) `R'`-linear identification with `regroupEquiv.inv` on generators. A prover can follow this directly.

---

## Dependency graph audit (leandag)

`leandag build --json` results for the full blueprint:

- **unknown_uses (broken `\uses{}`)**: 0
- **conflicts**: 0
- **isolated nodes**: 0 (0 blueprint nodes)
- **nodes needing `\lean{}`**: 0
- **`unmatched_lean`**: 43 entries — all are `\mathlibok` Mathlib anchors (expected; leandag scans project files only, not Mathlib) plus a small number in unrelated chapters. The six FBC-chapter Mathlib anchors (`lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:isPushout_cancelBaseChange_mathlib`, `lem:unit_conjugateEquiv_mathlib`, `lem:comp_unit_app_mathlib`, `lem:conjugateEquiv_pullbackComp_inv_mathlib`, `lem:flat_preserves_equalizer_mathlib`) are all used in compiled project proofs, confirming they exist in Mathlib.

No DAG finding requires a writer action on the FBC chapter.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pullbackPushforward_unit_comp` has no `\leanok` marker. The Lean proof is axiom-clean (iter-016 prover confirmed). `\leanok` is sync-managed; the marker will be added by `sync_leanok` after the current iter's prover work. Not a blueprint deficiency.
  - `lem:base_change_mate_gstar_transpose` and `lem:base_change_mate_fstar_reindex` both have `sorry` bodies in the Lean file — these are the two open obligations the iter-017 prover is to close. Both proof sketches are now adequate (see directive checks above).

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

---

## Overall verdict

All three iter-016 gaps are closed: `lem:pullbackPushforward_unit_comp` is pinned with `\lean{}`, `\uses`, proof, and wired as a dependency of Seam 2; the Seam-2 proof sketch gives the abstract variable-legs / Γ-collapse / Seam-1-reduction decomposition needed to bypass the dependent-type wall; the Seam-3 proof sketch names `homEquiv_counit` and the composed-adjunction counit-triangle coherence concretely. The FBC chapter is **complete + correct with no must-fix findings** and satisfies the HARD GATE for an iter-017 prover targeting `lem:base_change_mate_fstar_reindex` and `lem:base_change_mate_gstar_transpose`.
