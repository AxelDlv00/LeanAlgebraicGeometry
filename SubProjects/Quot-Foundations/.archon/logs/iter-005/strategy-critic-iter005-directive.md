# Strategy Critic Directive

## Slug
iter005

## Project goal

Formalize, in Lean 4 + Mathlib, the **Čech-independent leg** of the parent project's
`thm:fga_pic_representability` cone (Kleiman, FGA "The Picard scheme", §4). Concretely, close the
seven `sorry`-bearing nodes with zero project `sorry` in the closure and kernel-only axioms:
**FBC** — the i=0 flat-base-change isomorphism `g^* f_* F ⟶ f'_* g'^* F`
(`lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`); **GF** — generic flatness
`thm:generic_flatness` with algebraic core `thm:generic_flatness_algebraic`; **QUOT** — the Quot-scheme
foundations `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
`thm:grassmannian_representable`. Declarations keep the parent's names/labels so the finished work
merges back into its A.2.c engine. No protected declarations (`archon-protected.yaml` is empty).

## Strategy under review

<paste below is the verbatim current STRATEGY.md>

# Strategy

## Goal

Close the seven `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4), then merge back:

- **FBC** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`
  (the i=0 base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **GF** — `thm:generic_flatness` with algebraic core `thm:generic_flatness_algebraic`.
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.

End-state: zero project `sorry` in the 29-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's so finished work merges back into its A.2.c engine.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries (`pushforward/pullback_spec_tilde_iso`); `cancelBaseChange` | section-level identification of `pushforwardBaseChangeMap` with the canonical tensor iso may still carry coherence content |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq`; finite affine cover + sheaf condition for `SheafOfModules` | H⁰-as-equalizer infra for `SheafOfModules` may need building; qsep Mayer–Vietoris induction |
| GF-alg — algebraic core | ACTIVE | 3–5 | ~120–400 | `exists_free_localizedModule_powers`, `induction_on_isQuotientEquivQuotientPrime`, `exists_finite_inj_algHom_of_fg` | decomposed iter-003 into a 5-lemma chain; only `lem:gf_polynomial_core` (poly-ring core) is the genuine hand-built residue |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | needs `genericFlatness` re-signed with `[IsQuasicoherent]`+`[IsFiniteType]`; relating Γ(F,W) to a finite module over a finite-type algebra is real plumbing |
| QUOT-defs — Quot functor, Grassmannian defs + predicates | ACTIVE | 4–7 | ~250–600 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `IsProper` | re-sign needs two project-side predicates absent at the pin (schematic-support/proper-support; rank-`r` local-freeness) built first; universe pin |
| SNAP — graded Hilbert function → Hilbert polynomial | BLOCKED | 2–4 | ~180–400 | `Polynomial.existsUnique_hilbertPoly` (extraction half only, verified); project-side graded Hilbert–Serre rationality `gradedModule_hilbertSeries_rational`; Serre `⊕ₘΓ(F⊗Lᵐ)` f.g.-graded-module correspondence (H⁰ only) | Čech-independent; the rationality bridge is Mathlib-ABSENT (the Mathlib lemma is only extraction) — real work is rationality + the graded-module correspondence, not coherent cohomology; gates `def:hilbert_polynomial` |
| QUOT-repr — `thm:grassmannian_representable` (4 sub-phases, see Routes) | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme (absent); `RelativeSpec` strengthened to `RepresentableBy` | deepest target; decomposed into GR-cells/GR-glue/GR-quot/GR-repr in Routes |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream.
Sequencing is bottom-up: FBC-A and GF-alg are the live frontier; QUOT is authorable in parallel
(all four files import only Mathlib). FBC-B follows FBC-A; GF-geo follows GF-alg; QUOT-repr follows
QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** Drop the parent's abstract adjoint-mate ↔ `cancelBaseChange` decomposition and the
deferred Mathlib `#37189` dependency. Prove the affine lemma **directly on global sections**:
rewrite both sides through the proved tilde dictionaries (`pullback_spec_tilde_iso`,
`pushforward_spec_tilde_iso`), reducing the affine base-change iso to the canonical
`(R'⊗_R A)⊗_A M ≅ R'⊗_R M` (Mathlib `cancelBaseChange`). Globalize the i=0 statement
**Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (sheaf condition,
Čech degree 0/1 — NOT Čech cohomology), and a flat `−⊗B` preserves that finite equalizer via
`Module.Flat.{ker,eqLocus}_lTensor_eq`. The affine-local reduction
`lem:base_change_map_affine_local` is now derived (naturality of the adjunction transpose +
pushforward-commutes-with-restriction), not asserted.

**GF route.** Algebraic core `genericFlatnessAlgebraic`: A noetherian domain, B finite-type
A-algebra, M finite B-module ⟹ ∃ f≠0, `M_f` free over `A_f`. Primary case (M finite over A) is a
thin wrapper over `exists_free_localizedModule_powers` at the generic point — already landed
axiom-clean in the `GenericFreeness` namespace. The surviving residue is the polynomial-ring
dévissage (M finite over a finite-type, not module-finite, A-algebra): Nitsure §4 prime-filtration
+ Noether normalisation, reducing to the primary case at the bottom; hand-built. Geometric form
`genericFlatness` (re-signed with coherence hyps) wraps the algebraic form by restricting to a
non-empty affine open Spec A ⊆ S and patching the basic opens D(f) over a finite affine cover of
X above Spec A.

**QUOT route.** Decisions taken to resolve the foundational dependencies:

- *Hilbert-polynomial encoding = graded Hilbert function* (PIVOT iter-003, addressing the
  strategy-critic CHALLENGE). `def:hilbert_polynomial` is the polynomial `Φ_s` agreeing for `m≫0`
  with the graded Hilbert function `m ↦ dim_{κ(s)} Γ(X_s, F_s ⊗ L_s^m)` of the section module
  `⊕_m Γ(X_s, F_s ⊗ L_s^m)`, taken as a finitely generated graded module over the homogeneous
  coordinate ring (Hartshorne I.7.5; Nitsure §1's Snapper-via-Hilbert-function presentation).
  Polynomiality routes through TWO pieces, NOT a single Mathlib citation (writer verified
  against `Mathlib.RingTheory.Polynomial.HilbertPoly`): (i) `Polynomial.existsUnique_hilbertPoly`
  is only the EXTRACTION half — given a rational series `p·(1-X)^{-d}` its eventual coefficients
  are a unique polynomial (`[CharZero]` on the coeff field, fine for `Polynomial ℚ`); (ii) the
  genuine graded Hilbert–Serre RATIONALITY step — that `n ↦ dim_κ M_n` of a f.g. graded module
  over a Noetherian graded ring equals such a rational series — is ABSENT from Mathlib and is a
  project-side lemma `lem:gradedHilbertSerre_rational`
  (`\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}`, NOT `\mathlibok`; classical,
  inductive on degree-1 generators). This still yields the SAME polynomial as the cohomological χ
  (they agree for `m≫0` by Serre vanishing) WITHOUT higher coherent cohomology, keeping QUOT inside
  the Čech-independent leg. SNAP sub-steps: (S1) Serre's correspondence `F ↦ ⊕_m Γ(F⊗L^m)` as a
  f.g. graded module over the section ring (H⁰ only, `lem:sectionGradedModule_fg`); (S2) the
  rationality bridge `lem:gradedHilbertSerre_rational`; (S3) apply `existsUnique_hilbertPoly` to
  extract `Φ_s`. *Rejected:* the cohomological-χ encoding — it needs all `Hⁱ` (i>0), breaking the
  leg's "Čech-independent" identity, and its from-scratch-coherent-cohomology SNAP estimate was not
  credible. The QUOT chapter `Picard_QuotScheme.tex` was rewritten to the graded encoding (iter-003)
  with the SNAP blocks embedded; GR-cells/GR-glue are blueprinted in `Picard_GrassmannianCells.tex`.
- *QUOT-defs predicate sub-builds* (encoding-independent, do first): (P1) schematic-support closed
  subscheme of a coherent sheaf + `IsProper` ("proper support over S"); (P2) rank-`r`
  local-freeness predicate for `SheafOfModules` (`IsLocallyFree` is upstream-only / rank-agnostic
  at the pin). Both gate faithful re-signs of the four stubs. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`.
- *QUOT-repr decomposed* (replaces the 1000-LOC monolith): **GR-cells** — affine big cells
  `U^I ≅ A^{d(r-d)}_S` for each size-`d` index set `I` (~80–200 LOC); **GR-glue** — Plücker
  cocycle gluing of the cells into a scheme `Gr_S(V,d)` + separatedness via the diagonal
  (~150–350 LOC); **GR-quot** — tautological rank-`d` quotient `π*V ↠ U` + its universal property
  (~100–250 LOC); **GR-repr** — functor-of-points identification `Grass(V,d) ≅ Hom_S(−,Gr)` giving
  `RepresentableBy` (~100–250 LOC). GR-repr needs either `thm:relative_spec_univ` strengthened to a
  `RepresentableBy` witness or a transpose-free gluing argument (Open question).

## Open strategic questions

- RelativeSpec strengthening: `thm:relative_spec_univ` is proved only as `IsAffineHom`, not the
  `RepresentableBy` Yoneda form; `thm:relative_spec_affine_base` only as `IsAffine`, not the
  canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. GR-repr needs the stronger forms. Decide: strengthen
  RelativeSpec (re-opens proved work) vs. a RepresentableBy-free GR-repr argument. Deferred —
  QUOT-repr is many iters out.
- Does FBC-A's direct-on-sections route fully dissolve the coherence wall, or does identifying
  `Γ(pushforwardBaseChangeMap)` with the canonical tensor iso still need a mate computation?
  Validate empirically once the affine lemma is attempted.

## Mathlib gaps & new material

Gaps to fill:
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-alg: polynomial-ring generic-freeness residue not covered by `exists_free_localizedModule_powers`.
- SNAP: (a) Serre `⊕ₘΓ(F⊗Lᵐ)` finitely-generated-graded-module correspondence (H⁰ only); (b) graded
  Hilbert–Serre rationality `gradedModule_hilbertSeries_rational` (`dim_κ Mₙ` → `p·(1-X)^{-d}`) —
  Mathlib-ABSENT, project build; (c) extraction via the verified `Polynomial.existsUnique_hilbertPoly`.
  All Čech-independent — no higher cohomology. (Mathlib provides only (c).)
- QUOT predicates: schematic-support/proper-support; rank-`r` local-freeness for `SheafOfModules`.
- QUOT-repr: Grassmannian-of-quotients as a scheme (Nitsure §1/§5 big-cell patching), per GR-* above.

New project material:
- `genericFlatnessAlgebraic` (new decl), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base
  (no single `IsCoherent` predicate at the pin), used uniformly across GF and QUOT re-signs.
- QUOT defs with tightened signatures (coherence on F/E, locally-free + rank on V, universe pin);
  `Grassmannian` via `QuotFunctor`; representability stated as `IsRepresentable`.

## References index

| File | Description |
| ---- | ----------- |
| `nitsure-hilbert-quot.md` → pdf / -src/*.tex | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). PRIMARY source. §1 Hilbert polynomial (Snapper), §2 Quot functor, §4 generic flatness (full induction, src L1711–1772 backs `thm:generic_flatness_algebraic`), §5 Grassmannian + Quot construction. |
| `stacks-coherent.md` → .tex | Stacks ch.30, tag 02KH (flat base change of `R^i f_*`; part (2) H⁰-with-base-change). Backs `thm:flat_base_change_pushforward`/`lem:affine_base_change_pushforward`. |
| `stacks-schemes.md` → .tex | tag 01I9: `ψ* M̃ = (S⊗_R M)~`, `ψ_* Ñ = (N_R)~` for affine ψ. Backs the tilde dictionaries. |
| `stacks-constructions.md` → .tex | ch.27 relative-spectrum tags 01LL/01LO/01LQ/01LR/01LS + 01LM/01LP/01LT. Backs `Picard_RelativeSpec.tex`. |
| `hartshorne-algebraic-geometry.md` → pdf | Hartshorne GTM 52. II.§5/§7, III.§9. Companion for Quot/Grassmannian + Hilbert polynomials. |

## Blueprint summary

- `Cohomology_FlatBaseChange.tex` — Flat base change for the pushforward of a quasi-coherent sheaf
  (i=0): tilde dictionaries, affine base-change lemma via `cancelBaseChange`, H⁰-equalizer
  globalization. (FBC phase.)
- `Picard_FlatteningStratification.tex` — Generic flatness / flattening stratification: algebraic
  core `genericFlatnessAlgebraic` (5-lemma dévissage chain in `GenericFreeness`) + geometric wrapper.
  (GF phase.)
- `Picard_QuotScheme.tex` — Quot-scheme foundations: per-fiber Hilbert polynomial (graded encoding +
  SNAP chain), Quot functor of T-flat coherent quotients, Grassmannian defs + representability.
  (QUOT-defs / SNAP phases.)
- `Picard_GrassmannianCells.tex` — Grassmannian over ℤ: affine big cells, Plücker cocycle gluing,
  separatedness/properness (GR-cells, GR-glue sub-phases of QUOT-repr). No `% archon:covers` — forward
  blueprint for a future `GrassmannianCells.lean`.
- `Picard_RelativeSpec.tex` — Relative Spec functor `Spec_X(𝒜)`: universal property (proved as
  `IsAffineHom`), affine base case. Foundational; consumed by GR-repr.

## Prior critique status

- iter-003: QUOT χ-vs-graded Hilbert-polynomial encoding CHALLENGE — addressed (STRATEGY.md QUOT route
  now adopts the graded Hilbert-function encoding, routes polynomiality through project-side
  `lem:gradedHilbertSerre_rational` + Mathlib `existsUnique_hilbertPoly`, and re-scopes the SNAP row
  as the Mathlib-ABSENT rationality bridge rather than from-scratch coherent cohomology).
- iter-003: SNAP effort under-counted CHALLENGE — addressed (SNAP re-scoped to the graded-module
  rationality + Serre H⁰ correspondence, not full higher coherent cohomology).
