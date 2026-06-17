# Blueprint Reviewer Directive

## Slug
iter005

## Strategy snapshot

**Goal.** Close the seven `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4), then merge back:
- **FBC** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward` (the i=0
  base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **GF** — `thm:generic_flatness` with algebraic core `thm:generic_flatness_algebraic`.
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.
End-state: zero project `sorry` in the closure, zero project axioms, kernel-only axioms. Names/labels
are the parent's so finished work merges back into its A.2.c engine.

### Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries; `cancelBaseChange` | section-level identification coherence |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq`; finite affine cover + sheaf condition for `SheafOfModules` | H⁰-as-equalizer infra |
| GF-alg — algebraic core | ACTIVE | 3–5 | ~120–400 | `exists_free_localizedModule_powers`, `induction_on_isQuotientEquivQuotientPrime`, `exists_finite_inj_algHom_of_fg` | poly-ring dévissage residue |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | Γ(F,W)→finite-module plumbing |
| QUOT-defs — Quot functor, Grassmannian defs + predicates | ACTIVE | 4–7 | ~250–600 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `IsProper` | two project predicates built first; universe pin |
| SNAP — graded Hilbert function → Hilbert polynomial | BLOCKED | 2–4 | ~180–400 | `Polynomial.existsUnique_hilbertPoly` (extraction only); project-side `gradedModule_hilbertSeries_rational`; Serre H⁰ correspondence | rationality bridge Mathlib-ABSENT |
| QUOT-repr — `thm:grassmannian_representable` (GR-cells/glue/quot/repr) | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; `RelativeSpec` strengthened to `RepresentableBy` | deepest target |

## Routes
Single route per target; the leg is a fan of independent leaves merging back upstream. FBC (drop the
parent's adjoint-mate↔cancelBaseChange decomposition; prove the affine lemma directly on global
sections via the proved tilde dictionaries → `cancelBaseChange`; globalize Čech-free via the H⁰
sheaf-condition equalizer preserved by flat `−⊗B`). GF (algebraic core = generic freeness of a finite
module over a finite-type algebra over a noetherian domain via Nitsure §4 prime-filtration + Noether
normalisation, bottoming at the landed primary case; geometric form wraps it). QUOT (Hilbert polynomial
= **graded Hilbert function** of the section module `⊕_m Γ(X_s, F_s⊗L_s^m)` as an f.g. graded module —
PIVOT iter-003 adopting the graded encoding; polynomiality via project-side graded Hilbert–Serre
rationality `lem:gradedHilbertSerre_rational` (Mathlib-ABSENT) + Mathlib `existsUnique_hilbertPoly`
extraction; Grassmannian via big-cell patching GR-cells/glue/quot/repr).

## References
- `references/nitsure-hilbert-quot.md` → pdf / -src/*.tex: primary source. §1 Hilbert polynomial
  (Snapper), §2 Quot functor, §4 generic flatness (induction proof, src L1711–1772 backs
  `thm:generic_flatness_algebraic`), §5 Grassmannian + Quot construction (backs GR-* /
  `def:grassmannian_scheme` / `thm:grassmannian_representable`). Backs QUOT, GF, GR chapters.
- `references/stacks-coherent.md` → .tex: Stacks ch.30, tag 02KH (flat base change of `R^i f_*`,
  part (2) H⁰-with-base-change). Backs `Cohomology_FlatBaseChange.tex`.
- `references/stacks-schemes.md` → .tex: tag 01I9 (`ψ* M̃`, `ψ_* Ñ` for affine ψ). Backs the proved
  tilde dictionaries in `Cohomology_FlatBaseChange.tex`.
- `references/stacks-constructions.md` → .tex: ch.27 tags 01LL/01LO/01LQ/01LR/01LS + adjacent
  01LM/01LP/01LT (relative-spectrum). Backs `Picard_RelativeSpec.tex`. (See pointer caveats.)
- `references/hartshorne-algebraic-geometry.md` → pdf: GTM 52. II.§5/§7, III.§9 (Hilbert polynomials,
  Grassmannians, flat families). Companion for QUOT/GR chapters. Offset +17.

## Focus areas
Pay extra attention to the QUOT/GR/SNAP chapters (`Picard_QuotScheme.tex`,
`Picard_GrassmannianCells.tex`) — these blueprint the future BLOCKED phases (Hilbert-polynomial graded
encoding, Quot functor + predicates, Grassmannian big-cell construction). They contain the
Mathlib-absent project lemmas (`lem:gradedHilbertSerre_rational`, GR gluing) whose statements gate all
downstream prover work, so correctness of these statements matters most. Confirm:
- the graded-encoding `def:hilbert_polynomial` / SNAP chain (S1 Serre f.g. correspondence, S2
  rationality bridge, S3 extraction) is mathematically faithful to Nitsure §1 / Hartshorne I.7.5 and
  the `\uses{}` chain is honest;
- the GR-cells/glue declarations (`def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`,
  `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`) have sound statements + proof sketches
  against Nitsure §5;
- the `\mathlibok` anchors are faithful to real Mathlib declarations.
The FBC and GF chapters cleared the HARD GATE in iter-003 (`complete:true`+`correct:true`); re-confirm
they still hold after this iter's edits, but the QUOT/GR/SNAP chapters are the priority.

## Known issues
- The GR chapter (`Picard_GrassmannianCells.tex`) intentionally has NO `% archon:covers` line: its
  declarations are destined for a future `AlgebraicJacobian/Picard/GrassmannianCells.lean` (not yet
  scaffolded), so its `\lean{}` annotations are forward-placeholders pointing at a non-existent file.
  This is by design (tex precedes Lean) — do NOT flag the unmatched `\lean{}` as a coverage defect.
- Similarly the SNAP/QUOT-future declarations carry `\lean{}` placeholders for decls not yet in the
  Lean source — expected, not a defect.
- leandag currently reports: 0 ∞-sources, 0 broken `\uses{}`, 0 isolated blueprint nodes, 0 unmatched
  lean_aux. The DAG agent is about to declare the roadmap COMPLETE; your review is the correctness
  gate on that decision, so focus on whether any STATEMENT is mathematically wrong or any PROOF SKETCH
  too thin to formalize — not on graph-wiring (which is clean).
