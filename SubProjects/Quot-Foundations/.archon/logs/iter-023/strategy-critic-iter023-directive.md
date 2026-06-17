# Strategy-critic directive — iter-023

Review the strategy below with a fresh mathematician's eye. You see ONLY: STRATEGY.md (verbatim), the references index, blueprint chapter topics, and the project goal. No iter history, no prover narrative.

## Project goal

Formalize (in Lean 4 / Mathlib) the **Čech-independent leg** of Kleiman's FGA Picard-scheme representability cone: (FBC) flat base change for the i=0 pushforward of a quasi-coherent sheaf; (GF) generic flatness (Nitsure §4); (QUOT) the Quot-functor / Hilbert-polynomial / Grassmannian foundations. End-state: zero project `sorry` in the 29-node closure, zero project axioms. Names/labels match the parent project so finished work merges back.

## References index

(see below — verbatim from references/summary.md)

| nitsure-hilbert-quot | Nitsure "Construction of Hilbert and Quot Schemes" — §1 Hilbert poly, §2 Quot functor, §4 generic flatness, §5 Grassmannian+Quot construction. PRIMARY source. |
| stacks-coherent | Stacks ch.30 tag 02KH — flat base change of R^i f_*, part(2) H^0-with-base-change. Backs FBC. |
| stacks-schemes | Stacks tag 01I9 — widetilde pullback/pushforward for affine ψ. Backs FBC tilde dictionaries. |
| stacks-constructions | Stacks ch.27 — relative Spec (01LL/01LO/01LQ/01LR/01LS). Backs RelativeSpec. |
| hartshorne | Hartshorne AG — background for Quot/Grassmannian (II.5, II.7, III.9). |
| hilbert-serre | Stacks Algebra tag 00K1 — graded Hilbert–Serre rationality. Backs lem:gradedHilbertSerre_rational. |

## Blueprint chapter topics

- Cohomology_FlatBaseChange — flat base change for pushforward of QC sheaf (i=0).
- Cohomology_RegroupHelper — regrouping iso for the affine base-change tensor tower.
- Picard_FlatteningStratification — flattening stratification / generic flatness.
- Picard_GrassmannianCells — the Grassmannian over ℤ: affine charts and gluing.
- Picard_QuotScheme (covers QuotScheme.lean + GradedHilbertSerre.lean) — the Quot scheme + graded Hilbert–Serre.
- Picard_RelativeSpec — relative Spec.

## STRATEGY.md (verbatim)

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
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 2–3 (post-swap baseline) | ~80–250 | proved tilde dictionaries; `cancelBaseChange`; `Adjunction.homEquiv_counit`; mate seams (unit-value + domain-read closed; gstar-transpose is the live crux) | iter-020 ROUTE-SWAP made the 6-iter-stuck `fstar_reindex` crux DEAD CODE (domain-read route); iters-left is the post-swap count, not a continuation. Live: prove `gstar_transpose` (Seam 3, counit factorization) → affine reduction → FBC-B. Dead-code removal owed in a no-prover slot |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer` (`Module.Flat.ker_lTensor_eq`, `tensorEqLocusEquiv` — VERIFIED present, iter-007 strategy-critic); finite affine cover + sheaf condition for `SheafOfModules` | LESS risky than prior est: the flat-equalizer half is Mathlib-backed; residual is the H⁰-as-equalizer packaging for `SheafOfModules` |
| GF-alg — algebraic core | ACTIVE | 1 | ~60–180 | `IsIntegral.exists_multiple_integral_of_isLocalization` (denominator-clearing, NEW); `Algebra.finite_adjoin_of_finite_of_isIntegral`; `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` (VERIFIED) | reindex + L5 + injectivity crux + dévissage 2/3 obligations closed; ONLY L4 finiteness leaf @754 remains (witness `g0·g1`, single-call clearing) — closing it cascades to the `genericFlatnessAlgebraic` B/𝔭 obligation. STUCK was a budget-deferral metric artifact, not attempt-failure |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | needs `genericFlatness` re-signed with `[IsQuasicoherent]`+`[IsFiniteType]`; relating Γ(F,W) to a finite module over a finite-type algebra is real plumbing |
| QUOT-defs — Quot functor, Grassmannian defs + predicates | ACTIVE | 4–7 | ~250–600 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `IsProper` | scaffolding STARTED iter-007 (`affineChart` file wired; 3 predicate defs `annihilator`/`IsLocallyFreeOfRank`/`sectionGradedRing` under build); re-sign of the 4 stubs follows the predicate builds; universe pin |
| SNAP — graded Hilbert function → Hilbert polynomial | BLOCKED (S2 DONE) | 2–3 | ~120–300 | S3: `Polynomial.existsUnique_hilbertPoly` (extraction, verified); S1: Serre `⊕ₘΓ(F⊗Lᵐ)` f.g.-graded-module correspondence (H⁰ only) | **S2 rationality bridge `gradedModule_hilbertSeries_rational` LANDED axiom-clean iter-020** (the Mathlib-ABSENT core — Stacks 00K1 graded Hilbert–Serre — now in `GradedHilbertSerre.lean`). Remaining: S1 (graded-module correspondence) → S3 extraction → `def:hilbert_polynomial`. Still Čech-independent |
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
axiom-clean. The surviving residue is the polynomial-ring core `lem:gf_polynomial_core` (L5), the
Nitsure §4 induction on the variable count `d`. Decomposed iter-007 (api-alignment + blueprint) into:
`gf_generic_rank_ses` (the SES `0→P_d^{⊕m}→N→T→0`, generic rank `m := finrank (FractionRing P_d)
(LocalizedModule (nonZeroDivisors P_d) N)`, built over `P_d` directly — NO `g`-inversion), and
`gf_torsion_reindex` (re-present the torsion cokernel `T` over `MvPolynomial (Fin (d-1)) A_g` via
single-variable Nagata elimination + denominator clearing — `m'=d-1`, no Krull-dim theory). **Load-
bearing structural finding (iter-007): the `Nat.strong_induction_on d` must generalize the BASE
DOMAIN `A` (revert `A`+instances into the motive), not just `N` — the reindex changes the base ring
to `A_g`, so `IH m' _ (Localization.Away g) T_g` only typechecks at base `A_g`. This was the real
cause of the iter-006 stall, not the rank API.** L4 `lem:gf_noether_clear_denominators` decomposed
into `gf_clear_one_denominator` + Finset-fold; its denominator-clearing primitive is the SAME engine
`gf_torsion_reindex` needs — build once. Geometric form `genericFlatness` (re-signed with coherence
hyps) wraps the algebraic form by restricting to a non-empty affine open Spec A ⊆ S and patching the
basic opens D(f) over a finite affine cover of X above Spec A.

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
- FBC target shape — RESOLVED. The seed `affineBaseChange_pushforward_iso` is
  `IsIso (pushforwardBaseChangeMap …)` (the canonical map, not `∃ iso`), and that signature is the
  merge-back signature. So the mate computation is unavoidable: the 3-seam decomposition is the path
  (Seam 1 closed; Seams 2–3 proceed). The `∃-iso` escape is rejected — it would require re-signing the
  frozen seed.
- QUOT Hilbert-polynomial encoding — the `hilbertPolynomial` Lean stub docstring still documents the
  cohomological χ (`Σ_i (-1)^i dim H^i`) with a stale parent-project "iter-177+" comment. STRATEGY's
  graded-Hilbert-function route fills the SAME `S → Polynomial ℚ` stub (the graded function and χ
  agree for m≫0 by Serre vanishing — a non-load-bearing remark; NO closure sorry uses that equality).
  Action when the QUOT-defs lane fills/re-signs the stub: update its docstring + `def:hilbert_polynomial`
  prose to the graded encoding, and confirm the parent consumes Φ as the `Polynomial ℚ` invariant
  (signature unchanged ⟹ merge-back safe).
- Merge-back signature check (strategy-critic iter-007 housekeeping): confirm the re-signed
  `genericFlatness`/QUOT decls (`[IsQuasicoherent]`+`[IsFiniteType]`) match the parent cone's
  expected signatures, so finished work merges back into the A.2.c engine without re-typing.

## Mathlib gaps & new material

Gaps to fill:
- FBC-A: the 3 adjoint-mate sub-lemmas (`base_change_mate_unit_value` / `…_fstar_reindex` /
  `…_gstar_transpose`) + the `map_smul'` transparent-`Module R'` reduction (`restrictScalars.smul_def`
  → `ExtendScalars.smul_tmul` → `tmul_mul_tmul`, route (a) `TensorProduct.ext` at the full carrier) —
  Mathlib-absent plumbing, blueprinted iter-007.
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`. (The
  flat-equalizer half IS Mathlib: `Mathlib.RingTheory.Flat.Equalizer` — `Module.Flat.ker_lTensor_eq`,
  `tensorEqLocusEquiv`, VERIFIED iter-007.)
- GF-alg: the variable-drop / single-variable-Nagata-elimination + denominator-clearing engine (shared
  by `gf_torsion_reindex` and L4 `gf_clear_one_denominator`); the generic-rank SES assembly
  (`gf_generic_rank_ses`) from verified atoms (`Module.finBasis`, `IsLocalizedModule.surj`,
  `LinearIndependent.restrict_scalars`, `Fintype.linearCombination`). Recipe: `analogies/gf-generic-rank-ses.md`.
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

---

Specific question for this iter: GF-alg has just completed (genericFlatnessAlgebraic axiom-clean), so I am moving it to ## Completed and the live frontier becomes FBC (gstar crux), GF-geo, and the QUOT lanes. Is the sequencing sound? In particular: (a) is continuing the FBC 3-seam adjoint-mate route still the right call vs. any alternative, given it has been the live crux for several iters; (b) is opening GF-geo (geometric generic flatness via finite-affine-cover) reasonable now that GF-alg is done; (c) are the QUOT sub-phases (QUOT-defs predicates, SNAP-S1 Serre correspondence, def:sectionGradedRing) correctly scoped and independent. Challenge anything that looks like sunk-cost continuation.
