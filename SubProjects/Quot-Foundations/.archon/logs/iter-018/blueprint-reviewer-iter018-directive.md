# Blueprint Reviewer Directive

## Slug
iter018

## Strategy snapshot

Goal: close the seven `sorry`-bearing nodes of the Čech-independent leg of Kleiman's
`thm:fga_pic_representability` cone (FBC affine + flat base change; GF generic flatness; QUOT Hilbert
polynomial / Quot functor / Grassmannian + representability), zero project axioms, kernel-only axioms.

### Phases & estimations
| Phase | Status | Iters left | LOC |
|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 2–3 | ~80–200 |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 |
| GF-alg — algebraic core | ACTIVE | 1–3 | ~100–300 |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 |
| QUOT-defs — Quot functor, Grassmannian defs + predicates | ACTIVE | 4–7 | ~220–560 |
| SNAP-S2 — graded Hilbert–Serre rationality | ACTIVE | 2–3 | ~150–280 |
| SNAP-S1/S3 — `def:sectionGradedRing` bridge + `Φ_s` extraction | NEXT | 3–6 | ~150–400 |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ |

## Routes
Single route per target (a fan of independent leaves merging back upstream). FBC proves the affine
lemma directly on global sections (Stacks 02KH); SNAP-S2 uses Route 2 (ambient subquotient induction
over pairs `N'≤N` of a fixed graded κ-module, NEVER forming graded quotient rings/modules — the
Route-1 isDefEq dead-end).

## Focus areas (this iter — bias for thoroughness; do NOT skip other chapters)

THREE chapters received writer edits this iter and gate THREE prover lanes about to be dispatched.
Confirm each is `complete + correct` with no must-fix-this-iter finding:

1. **`Cohomology_FlatBaseChange.tex`** — five NEW Seam-2 blocks added (`lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom`, `lem:base_change_mate_codomain_read_legs`, `lem:base_change_mate_fstar_reindex_legs`). **The prover lane this iter targets the step-(iii) mate-unwinding crux inside `lem:base_change_mate_fstar_reindex_legs`.** Verify the chapter's description of that step-(iii) sequence (rewrite the surviving unit factor by `lem:pullbackPushforward_unit_comp`; absorb the `e`-iso unit; identify the `Spec ιA`-unit via Seam-1 `lem:base_change_mate_unit_value`; land `lem:base_change_mate_inner_value`) is detailed enough to formalize. This is the specific gate for the FBC prove pass.

2. **`Picard_QuotScheme.tex`** — new "Ambient homogeneity calculus" subsubsection (~10 project-bespoke blocks) + `Algebra.adjoinCommRingOfComm` Mathlib anchor + enriched finiteness-encoding recipe in `lem:graded_subquotient_finite_transfer`/`lem:graded_subquotient_isRatHilb`. **The prover lane (mathlib-build) targets the finiteness encoding + the `P(r)` induction + the `(⊤,⊥)` bridge.** Verify the `adjoinCommRingOfComm → aeval → Module.compHom → eval(last=0) surjection transfer` recipe is mathematically sound and detailed enough; verify the `\mathlibok` anchor for `Algebra.adjoinCommRingOfComm` is faithful (or flag if you cannot confirm).

3. **`Picard_FlatteningStratification.tex`** (NOT edited this iter, but gates the GF prove lane) — confirm `lem:gf_noether_clear_denominators` (L4) is `complete + correct`: the Step-1 Noether-over-K + Step-2 Finset-fold-of-`gf_clear_one_denominator` decomposition adequate for a prove pass on `exists_localizationAway_finite_mvPolynomial`.

## References
- `references/nitsure-hilbert-quot.md` → `-src/*.tex` §4 (GF generic flatness, Noether normalisation step).
- `references/hilbert-serre.md` → `hilbert-serre-algebra.tex` (Stacks 00K1, SNAP-S2 ambient subquotient induction).
- `references/stacks-coherent.md` (02KH, FBC flat base change).

## Known issues
- The private Lean helper `AlgebraicGeometry.GradedModule.finrank_comap_subtype` is intentionally unblueprinted (private; a `\lean{}` pin would not resolve) — it is the single expected isolated `lean_aux` node. Do NOT report it as a must-fix; confirm it's the only one.
- FBC-B / GF-geo / SNAP-S1 / QUOT-repr are gated/far-out (not dispatched this iter) — their incompleteness is expected, not a must-fix-this-iter.
