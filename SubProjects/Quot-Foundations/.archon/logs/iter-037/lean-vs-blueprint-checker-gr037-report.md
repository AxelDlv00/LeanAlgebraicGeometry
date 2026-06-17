# Lean ↔ Blueprint Check Report

## Slug
gr037

## Iteration
037

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration (this-iter additions only)

### `det_one_updateCol` (private helper, line 1645)
- **Blueprint target**: none — private helper
- **Lean target exists**: yes (`private lemma det_one_updateCol`, line 1645)
- **Signature matches**: N/A (private; not blueprinted)
- **Proof follows sketch**: N/A — proof uses `Matrix.cramer_apply` / `Matrix.mulVec_cramer` / `Matrix.det_one`. No sorry. Legitimate.
- **notes**: Private helper only. Blueprint proof of `lem:gr_existence_factor_through_valuation_ring` alludes to "expanding the determinant of a column-substituted identity matrix"; this is the formalization of exactly that step. Acceptable as unlisted helper.

---

### `exists_minorDet_eq_free_entry` (new public theorem, line 1661)
- **Blueprint target**: **NONE** — no `\lean{AlgebraicGeometry.Grassmannian.exists_minorDet_eq_free_entry}` block exists anywhere in the chapter
- **Lean target exists**: yes (line 1661)
- **Signature matches**: N/A — there is no blueprint block to compare against
- **Proof follows sketch**: The proof is a full, sorry-free formalization (100+ lines); no axioms, no placeholders. Correct.
- **notes**: The blueprint proof text of `lem:gr_existence_factor_through_valuation_ring` describes the sub-step inline: *"cofactor expansion expresses each free entry x^J_{p,q} (q ∉ J) as, up to sign, the minor P^J_{K'} with K' = (J \ {j_p}) ∪ {q}…"* and explicitly flags it as *"the one sub-step with no pre-existing matrix-algebra scaffold."* However, the theorem is public (not private) and there is **no dedicated `\lean{...}` block** pointing to it. The prover's suggested label `lem:gr_free_entry_eq_signed_minor` is appropriate. See Blueprint Adequacy below.

---

### `\lean{AlgebraicGeometry.Grassmannian.existence_factor_through_valuationRing}` (chapter: `lem:gr_existence_factor_through_valuation_ring`, lines 2317–2377)
- **Lean target exists**: yes (`theorem existence_factor_through_valuationRing`, line 1775)
- **Signature matches**: **partial** — see below
- **Proof follows sketch**: yes — the proof correctly applies `existence_lift_transitionPreMap_minorDet_mul` for the minor-ratio step and `exists_minorDet_eq_free_entry` for the cofactor sub-step, then closes by `MvPolynomial.induction_on`. Matches the blueprint proof structure.
- **notes**:
  - The blueprint statement asserts two things: (1) "every value g(P^J_{K'}) lies in R, and consequently g factors uniquely as g = (R ↪ K) ∘ g' for a ring hom g' : R^J → R" and (2) "g defines the same K-point as f." The Lean theorem proves only (1) in the form `∀ x, g x ∈ (algebraMap R K).range`. Membership in range is logically equivalent to factoring (the factoring follows from `RingHom.codRestrict`), so the mathematical content is captured. Claim (2) ("same K-point") is not in this Lean declaration and appears to be deferred to E4 (`existence_lift`, not yet formalized). The `\leanok` marker on both the statement and proof blocks is appropriate given the formalized content.
  - No sorry, no axioms, no excuse-comments. Proof is complete.

---

## Red flags

No red flags found on the three new declarations.

### Placeholder / suspect bodies
*(none)*

### Excuse-comments
*(none)*

### Axioms / Classical.choice on non-trivial claims
*(none)*

---

## Unreferenced declarations (informational)

The following Lean declarations in this file have no corresponding `\lean{...}` block in the blueprint and are not private:

| Declaration | Line | Status |
|---|---|---|
| `exists_minorDet_eq_free_entry` | 1661 | **Public theorem, no blueprint block** — see below |

All other unreferenced declarations are either private (`private lemma`/`private def`) or are private helpers documented only via section-header comments.

The following declarations are in the blueprint but **not yet in the Lean file** (intentionally deferred, no `\leanok` in blueprint):
- `existence_lift` (`lem:gr_existence_lift`)
- `valuativeExistence_toSpecZ` (`lem:gr_valuativeExistence_toSpecZ`)
- `isProper` (`lem:gr_proper`)

These are correctly left without `\leanok` in the blueprint; no action required this iter.

---

## Blueprint adequacy for this file

- **Coverage**: All previously-formalized declarations have correct `\lean{...}` blocks and `\leanok` markers. The **new** declaration `exists_minorDet_eq_free_entry` is the sole gap: it has no dedicated blueprint block, only an inline mention in the proof of `lem:gr_existence_factor_through_valuation_ring`.

- **Proof-sketch depth**: **adequate for the covered declarations**. The proof sketch for `lem:gr_existence_factor_through_valuation_ring` describes the cofactor sub-step in enough mathematical detail to guide formalization. However, the sketch explicitly acknowledges a "matrix-algebra scaffold gap" and does not provide a sub-lemma name, leaving the prover to discover the `det_one_updateCol` + `exists_minorDet_eq_free_entry` decomposition independently.

- **Hint precision**: **loose** for the new E3-cofactor content. The blueprint does not provide a `\lean{...}` tag for the cofactor sub-step, so the prover had to invent the lemma name and signature without blueprint guidance.

- **Generality**: matches need for all covered declarations.

- **Recommended chapter-side actions**:
  1. **Add a dedicated lemma block** for the cofactor sub-step (suggested label `lem:gr_free_entry_eq_signed_minor`), pinning `\lean{AlgebraicGeometry.Grassmannian.exists_minorDet_eq_free_entry}`. The block content is already described in the proof text of `lem:gr_existence_factor_through_valuation_ring`; it just needs to be extracted as a standalone lemma with its own `\lean{...}` tag, `\uses{def:gr_minor_det, def:gr_universal_matrix}`, and a concise statement: "for `q ∉ J` and row index `p`, there exists `K' : Finset (Fin r)` with `K'.card = d` and `minorDet d r J K' = ±MvPolynomial.X (p, ⟨q, hq⟩)`."
  2. The inline reference in the proof of `lem:gr_existence_factor_through_valuation_ring` should be updated to `\cref{lem:gr_free_entry_eq_signed_minor}` once the block is added.

---

## Severity summary

| Finding | Severity |
|---|---|
| `exists_minorDet_eq_free_entry` (public theorem) has no `\lean{...}` blueprint block | **major** |
| `existence_factor_through_valuationRing` Lean statement proves only range-membership, not the full "factors as g = (R↪K)∘g'" claim of the blueprint (equivalent content, different phrasing) | **minor** |
| Blueprint adequacy: no dedicated block for the cofactor sub-step (only inline mention) | **major** |

**Overall verdict**: The three new E3-full declarations (`det_one_updateCol`, `exists_minorDet_eq_free_entry`, `existence_factor_through_valuationRing`) are all sorry-free and correctly proved — no must-fix-this-iter issues on the Lean side. The dominant gap is on the **blueprint side**: the public theorem `exists_minorDet_eq_free_entry` needs a dedicated `\lean{...}` block (label `lem:gr_free_entry_eq_signed_minor`) so that the prover/review chain can track it bidirectionally. — 3 declarations checked, 0 red flags, 2 major blueprint-coverage findings.
